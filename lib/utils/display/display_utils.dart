import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../ui/widgets/loading_indicator.dart';

class DisplayUtils {
  static void showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(title)),
      );
  }

  static void showToast(BuildContext context, String title) {
    final snackBar = SnackBar(
      elevation: 2,
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message:
        title,
        color: Colors.green,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showErrorToast(BuildContext context, String title) {
    final snackBar = SnackBar(
      elevation: 2,
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message:
        title,
        color: Colors.red,
        contentType: ContentType.warning,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showLoader() {
    BotToast.showCustomLoading(
        toastBuilder: (_) => const CircularLoadingIndicator());
  }

  static void removeLoader() {
    BotToast.closeAllLoading();
  }
}
