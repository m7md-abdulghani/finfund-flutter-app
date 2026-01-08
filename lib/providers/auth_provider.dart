import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _token;
  String? _tempPhone;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  String? get tempPhone => _tempPhone;

  void setTempPhone(String phone) {
    _tempPhone = phone;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _tempPhone = phone;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();

    if (otp == '1234') {
      return {'success': true, 'isNewUser': true};
    }
    return {'success': false, 'message': 'رمز التحقق غير صحيح'};
  }

  Future<bool> setPin(String pin) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _user = User.mock();
    _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> loginWithPin(String phone, String pin) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (pin == '1234') {
      _user = User.mock();
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _tempPhone = null;
    notifyListeners();
  }

  void setMockUser({bool asAdmin = false}) {
    _user = User(
      id: 1,
      firstName: 'محمد',
      lastName: 'العبدالله',
      email: 'mohammed@example.com',
      phone: '0501234567',
      role: asAdmin ? 'Admin' : 'Customer',
      isVerified: true,
      createdAt: DateTime.now(),
    );
    _token = 'mock_token';
    notifyListeners();
  }
}
