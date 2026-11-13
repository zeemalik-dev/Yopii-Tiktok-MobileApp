import 'package:flutter/material.dart';
import '../services/api_manager.dart';

class ForgotProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Request password reset OTP
  Future<bool> requestForgotPassword(
    BuildContext context,
    String email,
  ) async {
    _setLoading(true);
    final success = await ApiManager.forgotPassword(context, email);
    _setLoading(false);
    return success;
  }

  /// Reset password using OTP
  Future<bool> resetPassword(
    BuildContext context, {
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    final success = await ApiManager.resetPassword(context,
        otp: otp, newPassword: newPassword);
    _setLoading(false);
    return success;
  }

  /// Verify OTP for email verification
  Future<bool> verifyOtp(BuildContext context, String otp) async {
    _setLoading(true);
    final success = await ApiManager.verifyOtp(context, otp);
    _setLoading(false);
    return success;
  }

  /// Resend OTP to user
  Future<bool> resendOtp(BuildContext context, String email) async {
    _setLoading(true);
    final success = await ApiManager.resendOtp(context, email);
    _setLoading(false);
    return success;
  }
}
