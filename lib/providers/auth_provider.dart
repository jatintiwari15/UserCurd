import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Show loading indicator

    await Future.delayed(const Duration(seconds: 2)); // Simulating API call

    _isLoading = false;
    notifyListeners(); // Hide loading indicator

    return true; // Simulating a successful login
  }
}
