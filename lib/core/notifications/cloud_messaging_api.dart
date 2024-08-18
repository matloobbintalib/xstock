import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../di/service_locator.dart';
import 'local_notification_api.dart';

class CloudMessagingApi {
  final FirebaseMessaging _firebaseMessaging;

  CloudMessagingApi({FirebaseMessaging? firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token : ${fcmToken}');
    if (Platform.isIOS) {
      await _setForegroundNotificationsPresentationOptionsIOS();
      await _requestNotificationPermissionForIOS();
    }

    // Foreground
    _handleOnMessageWhenAppInForeground();

    // Background
    _handleOnMessageOpenedAppFromBackground();
  }

  /// When the app is in foreground [onMessage]
  void _handleOnMessageWhenAppInForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification}');
      AndroidNotification? android = message.notification?.android;
      sl<LocalNotificationsApi>().showNotification(message, android);
      if (message.notification != null) {
        print('Message Notification Body: ${message.notification!.body}');
        AndroidNotification? android = message.notification?.android;
        sl<LocalNotificationsApi>().showNotification(message, android);
      }
    });
  }

  /// When user click from the background state [onMessageOpenedApp]
  void _handleOnMessageOpenedAppFromBackground() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// When notification is clicked from background state...
  void _handleMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('CLICKED FROM WHEN APP WAS CLOSED');
      print('Message data ${message.data}');
      // PayloadModel payloadModel = PayloadModel.fromJson(message.data);
      // if (payloadModel.page == 'chat') {
      //    NavRouter.push(NavRouter.navigationKey.currentContext!, ChatPage(receiverName: receiverName, receiverImage: receiverImage, userId: userId, receiverId: receiverId));
      // }
    }
  }

  Future<RemoteMessage?> getInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    return initialMessage;
  }

  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> deleteFcmToken() async {
    _firebaseMessaging.deleteToken();
  }

  Future<void> _setForegroundNotificationsPresentationOptionsIOS() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> _requestNotificationPermissionForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
