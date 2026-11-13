import 'package:flutter/material.dart';
import '../services/api_manager.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  final _storage = LocalStorageService();

  /// Initialize auth state on app start
  Future<void> initAuth() async {
    _token = await _storage.getToken();
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final success =
        await ApiManager.loginUser(context, email: email, password: password);

    _isLoading = false;
    if (success) {
      _token = await _storage.getToken();
      _isLoggedIn = true;

      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<bool> signUp(
    BuildContext context, {
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await ApiManager.signUpUser(
      context,
      fullName: fullName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    _isLoading = false;

    if (success) {
      // AppToast.success(context, "Account created successfully 🎉");

      _token = await _storage.getToken();
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    await ApiManager.logoutUser(context);
    await _storage.clearAll();

    _token = null;
    _isLoggedIn = false;

    notifyListeners();
  }

  /// Refresh token logic (optional)
  Future<bool> verifyOtp(BuildContext context, String otp) async {
    _isLoading = true;
    notifyListeners();
    final success = await ApiManager.verifyOtp(context, otp);
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> resendOtp(BuildContext context, String email) async {
    _isLoading = true;
    notifyListeners();
    final success = await ApiManager.resendOtp(context, email);
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
