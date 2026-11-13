import 'dart:io';

import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../services/api_manager.dart';
import '../services/local_storage_service.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;

  bool _isUpdating = false;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  User? get user => _user;

  final LocalStorageService _storage = LocalStorageService();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Get user details by ID
  Future<void> fetchUserById(BuildContext context, String userId) async {
    _setLoading(true);
    try {
      final fetchedUser = await ApiManager.getUserById(context, userId);
      _user = fetchedUser;
    } catch (e) {
      debugPrint("❌ Error fetching user: $e");
    }
    _setLoading(false);
  }

  Future<void> userProfileShowMe(BuildContext context) async {
    _setLoading(true);
    try {
      final fetchedUser = await ApiManager.getUserProfileShowMe(context);
      _user = fetchedUser;
    } catch (e) {
      debugPrint("❌ Error fetching user: $e");
    }
    _setLoading(false);
  }

  updateUserProfile(BuildContext context,
      {required String fullName,
      required String contentType,
      required String description,
      String? profileImageUrl,
      File? imageFile}) async {
    try {
      _isUpdating = true;

      notifyListeners();
      if (imageFile != null) {
        profileImageUrl = await ApiManager.uploadImage(context, imageFile);
      }

      final fetchedUser = await ApiManager.updateUserProfile(context,
          fullName: fullName,
          contentType: contentType,
          description: description,
          profileImageUrl: profileImageUrl!);
      _user = fetchedUser;
    } catch (e) {
      debugPrint("❌ Error fetching user: $e");
    }
    _isUpdating = false;

    notifyListeners();
  }

  /// Update user details
  Future<bool> updateUser(
    BuildContext context, {
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    _setLoading(true);
    final success = await ApiManager.updateUser(context,
        userId: userId, updateData: updatedData);
    if (success) {
      await fetchUserById(context, userId);
    }
    _setLoading(false);
    return success;
  }

  /// Delete user
  Future<bool> deleteUser(BuildContext context, String userId) async {
    _setLoading(true);
    final success = await ApiManager.deleteUser(context, userId);
    if (success) {
      _user = null;
      await _storage.clearAll();
    }
    _setLoading(false);
    return success;
  }

  /// Clear user data
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
