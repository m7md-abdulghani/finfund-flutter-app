class AuthService {
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  Future<bool> setPin(String pin) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> login(String phone, String pin) async {
    await Future.delayed(const Duration(seconds: 1));
    return pin == '1234';
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
