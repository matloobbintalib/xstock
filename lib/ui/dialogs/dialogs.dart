import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'confirmation_dialog.dart';

sealed class Dialogs {
  Dialogs_();

  static Future<bool> showLogOutConfirmationDialog(
    BuildContext context,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to Sing Out?',
    );
    if (confirmed && context.mounted) {
      return true;
    }else{
      return false;
    }
  }

  static Future<bool> showDeleteAccountConfirmationDialog(
    BuildContext context,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Delete Account',
      message: 'Are you sure you want to Delete your account?',
    );

    if (confirmed && context.mounted) {
      return true;
    }else{
      return false;
    }
  }

  static Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    bool? res = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
      ),
    );
    return res ?? false;
  }
}
