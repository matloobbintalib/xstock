import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Urls {
  Urls._();

  static const _termsOfService = 'https://google.com/';
  static const _privacyPolicy = 'https://google.com/';

  static void showTermsOfService() => _show(_termsOfService);

  static void showPrivacyPolicy() => _show(_privacyPolicy);

  static void _show(String url) {
    launchUrl(Uri.parse(url));
  }

  static openApp() {
    final appId = Platform.isAndroid ? 'com.whatsapp' : 'com.whatsapp';
    final uri = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
