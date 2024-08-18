import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Urls {
  Urls._();

  static const _termsOfService = 'https://google.com/';
  static const _privacyPolicy = 'https://www.freeprivacypolicy.com/live/2f9d374c-7b69-4ba9-8e04-fc80c540cd8e';

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
