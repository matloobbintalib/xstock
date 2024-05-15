import 'package:flutter/material.dart';
import 'package:xstock/utils/display/display_utils.dart';

import 'email_validator.dart';

abstract class Validators {
  Validators._();

  static FormFieldValidator<String>? getValidator(TextInputType? keyboardType) {
    return switch (keyboardType) {
      TextInputType.emailAddress => Validators.email,
      TextInputType.number => Validators.number,
      _ => null,
    };
  }

  static String? required(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'Required';
    }

    return null;
  }

  static String? requiredTyped<T>(T? input) {
    if (input == null) {
      return 'Required';
    }

    return null;
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    if (!EmailValidator.validate(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // if (!password.contains(RegExp('[A-Z]'))) {
    //   return 'Password must contain at least one capital letter';
    // }

    return null;
  }

  static bool isValidPassword(BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      DisplayUtils.showErrorToast(context, 'Enter your password');
      return false;
    }else if (password.length < 8) {
      DisplayUtils.showErrorToast(
          context, 'Password must be at least 8 characters long');
      return false;
    }else{
      return true;
    }
  }

  static bool isValidEmail(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      DisplayUtils.showErrorToast(context, 'Enter your email address');
      return false;
    }else if (!EmailValidator.validate(email)) {
      DisplayUtils.showErrorToast(
          context, 'Enter a valid email');
      return false;
    }else{
      return true;
    }
  }

  static bool isNotEmpty(BuildContext context, String title, String? input) {
    if (input == null || input.isEmpty) {
      DisplayUtils.showErrorToast(context, 'Enter your ${title.toLowerCase()}');
      return false;
    }else if (input.length < 5) {
      DisplayUtils.showErrorToast(context, '${title} must be at least 5 characters long');
      return false;
    }else{
      return true;
    }
  }

  static String? number(String? input) {
    if (input == null) {
      return 'Required';
    }

    final number = num.tryParse(input);
    if (number == null) {
      return 'Enter a valid number';
    }

    return null;
  }

  static String? positiveInteger(String? input) {
    if (input == null) {
      return 'Required';
    }

    final integer = int.tryParse(input);
    if (integer == null || integer <= 0) {
      return 'Enter positive integer';
    }

    return null;
  }
}
