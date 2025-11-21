import 'dart:async';
import 'package:flutter/material.dart';

class SplashViewModel {
  void navigateToLogin(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}
