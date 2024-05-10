import 'package:flutter/material.dart';

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
