// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:createex_task_application/const/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/chat/chat_model.dart';
import '../../model/chat/parts/chat_message_model.dart';
import '../../model/feed/feed_model.dart';
import '../../model/user_model.dart';
import 'local_storage_service.dart';
import 'app_toast.dart';
import 'package:mime/mime.dart'; // 👈 add this package
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ApiManager {
  ApiManager._();
  static const String ApiBaseUrl =
      "https://yoopiiapp-bde2h9fdhwc9f3bj.canadacentral-01.azurewebsites.net/api";

  static Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final token = await LocalStorageService().getToken();
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      if (withAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ---------------------------------------------------------------------------
  // 🔹 Auth API
  // ---------------------------------------------------------------------------
  static Future<bool> loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    log("Email: $email, Password: $password");

    final url = Uri.parse(ApiBaseUrl + Endpoints.login);

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: false),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // debugger();
        User user = User.fromJson(body['data']['user']);
        await LocalStorageService().saveUserId(user.id);
        final token = body['data']['token'];

        if (token != null) {
          await LocalStorageService().saveToken(token);
          AppToast.success(context, 'Login Successful 🎉');

          log(response.body);
          return true;
        } else {
          AppToast.error(context, 'Invalid token response.');
        }
      } else if (response.statusCode == 401) {
        final body = jsonDecode(response.body);
        AppToast.error(context, body['message'] ?? 'Unauthorized access.');
      } else if (response.statusCode == 500) {
        AppToast.error(context, 'Internal Server Error.');
      } else {
        AppToast.error(context, 'Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Login failed: $e');
    }
    return false;
  }

  static Future<bool> signUpUser(
    BuildContext context, {
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    log("FullName: $fullName, Username: $username, Email: $email, Phone: $phoneNumber, Password: $password");

    final url = Uri.parse(
      ApiBaseUrl +
          Endpoints.signUp, // 🔗 e.g., "https://yoopiiapp.../api/user/signUp"
    );

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: false),
        body: jsonEncode({
          "fullName": fullName,
          "username": username,
          "email": email,
          "phoneNumber": phoneNumber,
          "password": password,
        }),
      );

      log("SignUp Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body);
        User user = User.fromJson(body['data']['user']);
        await LocalStorageService().saveUserId(user.id);
        // ✅ Optionally save token or user info if returned
        if (body['data']['token'] != null) {
          await LocalStorageService().saveToken(body['data']['token']);
        }

        AppToast.success(context, 'Account created successfully 🎉');
        return true;
      } else if (response.statusCode == 400) {
        final body = jsonDecode(response.body);
        AppToast.error(context, body['message'] ?? 'Invalid request data.');
      } else if (response.statusCode == 409) {
        AppToast.error(context, 'User already exists.');
      } else if (response.statusCode == 500) {
        AppToast.error(context, 'Internal Server Error.');
      } else {
        AppToast.error(context, 'Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Signup failed: $e');
    }

    return false;
  }

// ---------------- USER OPERATIONS ----------------

  /// 🧩 Get User by ID
  static Future<User?> getUserById(BuildContext context, String userId) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.user}/$userId");
    try {
      final response = await http.get(
        url,
        headers: await _headers(withAuth: true),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return User.fromJson(body['data']);
      } else {
        AppToast.error(context, 'Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Error fetching user: $e');
    }
    return null;
  }

  static Future<User?> getUserProfileShowMe(BuildContext context) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.profile_show_me}");
    try {
      final response = await http.get(
        url,
        headers: await _headers(withAuth: true),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return User.fromJson(body['data']);
      } else {
        AppToast.error(context, 'Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Error fetching user: $e');
    }
    return null;
  }

  static Future<User?> updateUserProfile(
    BuildContext context, {
    required String fullName,
    required String contentType,
    required String description,
    required String profileImageUrl,
  }) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.edit_profile}");
    try {
      final body = {
        "fullName": fullName,
        "contentType": contentType,
        "description": description,
        "profileImageUrl": profileImageUrl,
      };

      final response = await http.put(
        url,
        headers: await _headers(withAuth: true),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, "Profile updated successfully ✅");
        final body = jsonDecode(response.body);
        return User.fromJson(body['data']);
      } else {
        log("Profile update failed: ${response.statusCode} → ${response.body}");
        AppToast.error(
            context, "Failed to update profile: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("❌ Error updating profile: $e");
      AppToast.error(context, "Error updating profile: $e");
      return null;
    }
  }

  /// ✏️ Update User by ID
  static Future<bool> updateUser(
    BuildContext context, {
    required String userId,
    required Map<String, dynamic> updateData,
  }) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.user}/$userId");

    try {
      final response = await http.put(
        url,
        headers: await _headers(withAuth: true),
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, 'Profile updated successfully 🎉');
        return true;
      } else {
        AppToast.error(context, 'Update failed: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Update error: $e');
    }

    return false;
  }

  /// ❌ Delete User by ID
  static Future<bool> deleteUser(BuildContext context, String userId) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.user}/$userId");

    try {
      final response = await http.delete(
        url,
        headers: await _headers(withAuth: true),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, 'Account deleted successfully ❌');
        await LocalStorageService().clearAll();
        return true;
      } else {
        AppToast.error(context, 'Delete failed: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Error deleting user: $e');
    }

    return false;
  }

  /// 🔐 Verify OTP
  static Future<bool> verifyOtp(BuildContext context, String otp) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.verifyOtp}/$otp");

    try {
      final response =
          await http.get(url, headers: await _headers(withAuth: false));

      if (response.statusCode == 200) {
        AppToast.success(context, 'OTP verified successfully ✅');
        return true;
      } else {
        AppToast.error(context, 'Invalid OTP or expired.');
      }
    } catch (e) {
      AppToast.error(context, 'OTP verification failed: $e');
    }

    return false;
  }

  /// 📧 Forgot Password - Send OTP
  static Future<bool> forgotPassword(BuildContext context, String email) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.forgotPassword}");

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: false),
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, 'OTP sent to your email 📩');
        return true;
      } else {
        AppToast.error(context, 'Failed to send OTP.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return false;
  }

  /// 🔁 Reset Password
  static Future<bool> resetPassword(
    BuildContext context, {
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.resetPassword}/$otp");

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: false),
        body: jsonEncode({'password': newPassword}),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, 'Password reset successful 🎉');
        return true;
      } else {
        log(response.body);
        final responseBody = jsonDecode(response.body);
        AppToast.error(context, responseBody['message'] ?? 'Reset failed.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return false;
  }

  /// 🔄 Resend OTP
  static Future<bool> resendOtp(BuildContext context, String email) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.resendOtp}");

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: false),
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        AppToast.success(context, 'OTP resent successfully 🔁');
        return true;
      } else {
        log(response.body);
        final responseBody = jsonDecode(response.body);

        AppToast.error(
            context, responseBody["message"] ?? 'Failed to resend OTP.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return false;
  }

  /// 🚪 Logout User
  static Future<bool> logoutUser(BuildContext context) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.logout}");

    try {
      final response = await http.post(
        url,
        headers: await _headers(withAuth: true),
      );

      if (response.statusCode == 200) {
        await LocalStorageService().clearAll();
        AppToast.success(context, 'Logged out successfully 👋');
        return true;
      } else {
        AppToast.error(context, 'Logout failed.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  // 🔹 FOR YOU FEED API
  // ---------------------------------------------------------------------------
  static Future<FeedResponse?> getForYouFeed(
    BuildContext context, {
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
        '$ApiBaseUrl${Endpoints.getFeedsContentForYou}?page=$page&limit=$limit');

    try {
      final response = await http.get(url, headers: await _headers());

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // AppToast.success(context, jsonData['message']);

        return FeedResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        AppToast.error(context, 'You are not authorized. Please log in.');
      } else if (response.statusCode == 500) {
        AppToast.error(context, 'Internal Server Error.');
      } else {
        AppToast.warning(
            context, 'Unexpected response: ${response.statusCode}');
      }
    } catch (e) {
      AppToast.error(context, 'Error fetching feed: $e');
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // 🔹 Example Future Expansion — Refresh Token API
  // ---------------------------------------------------------------------------
  static Future<String?> refreshToken(BuildContext context) async {
    // Example endpoint (if your backend supports refresh)
    final url = Uri.parse(ApiBaseUrl + '/api/auth/refresh');
    try {
      final response = await http.post(url, headers: await _headers());
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newToken = body['token'];
        if (newToken != null) {
          await LocalStorageService().saveToken(newToken);
          AppToast.success(context, 'Token refreshed 🔄');
          return newToken;
        }
      } else {
        AppToast.warning(context, 'Token refresh failed.');
      }
    } catch (e) {
      AppToast.error(context, 'Error refreshing token: $e');
    }
    return null;
  }

  //Post And Uploads things

  static Future<String?> uploadImage(
      BuildContext context, File imageFile) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.uploadImage}");

    try {
      // ✅ Detect MIME type automatically
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/png';
      final fileName = path.basename(imageFile.path);

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(await _headers(withAuth: true));

      // ✅ Explicitly set contentType
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // debugger();
        // ✅ Assuming your API returns something like { "url": "..." }
        final imageUrl = responseData['data']['imageUrl'] as String;
        // AppToast.success(context, 'Image uploaded successfully 📸');
        return imageUrl; // return the uploaded URL
      } else {
        log(response.body);
        final responseBody = jsonDecode(response.body);
        AppToast.error(
            context, responseBody["message"] ?? 'Failed to upload image.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return null;
  }

  static Future<List<String?>?> uploadVideo(
      BuildContext context, File videoFile) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.uploadVideo}");

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(await _headers(withAuth: true));

      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          contentType: MediaType('video', 'mp4'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      // debugger();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // AppToast.success(context, '🎬 Video uploaded successfully');
        log("Video uploaded: ${response.body}");

        final responseData = jsonDecode(response.body);
        final videoUrl = responseData['data']['videoUrl'] as String;
        final thumbnailUrl = responseData['data']['thumbnailUrl'] as String;
        return [videoUrl, thumbnailUrl];
      } else {
        final responseBody = jsonDecode(response.body);
        AppToast.error(
          context,
          responseBody["message"] ?? 'Failed to upload video.',
        );
        log("Upload failed: ${response.body}");
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
      log("Upload error: $e");
    }

    return null;
  }

  static Future<bool> createContent(
    BuildContext context, {
    required String description,
    required List<String> tags,
    required String videoUrl,
    required String thumbnailUrl,
    required bool isProduct,
    String? productId,
    String? musicId,
  }) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.createContent}");

    try {
      final body = {
        "description": description,
        "tags": tags,
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
        "isProduct": isProduct,
        "productId": productId,
        "musicId": musicId,
      };
      // debugger();
      final response = await http.post(
        url,
        headers: await _headers(withAuth: true),
        body: jsonEncode(body),
      );
      // debugger();
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppToast.success(context, 'Content created successfully 🎉');
        return true;
      } else {
        log(response.body);
        final responseBody = jsonDecode(response.body);
        AppToast.error(
            context, responseBody["message"] ?? 'Failed to create content.');
      }
    } catch (e) {
      AppToast.error(context, 'Error: $e');
    }

    return false;
  }

  //Chat Apis:

  static Future<List<ChatConversation>> getConversations(
    BuildContext context, {
    int page = 1,
    int limit = 20,
  }) async {
    final url = Uri.parse(
        "${ApiBaseUrl}${Endpoints.chat_conversations}?page=$page&limit=$limit");
    try {
      final response = await http.get(
        url,
        headers: await _headers(withAuth: true),
      );
      // debugger();
      if (response.statusCode == 200) {
        log(response.body);
        final json = jsonDecode(response.body);
        final List data = json['data']['conversations'] ?? [];
        return data.map((e) => ChatConversation.fromJson(e)).toList();
      } else {
        log(response.body);
        AppToast.error(
            context, "Failed to load conversations: ${response.statusCode}");
      }
    } catch (e) {
      AppToast.error(context, "Error loading conversations: $e");
    }
    return [];
  }

  // ✅ Get messages for a conversation
  static Future<List<ChatMessage>> getMessagesByConversation(
    BuildContext context, {
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    final url = Uri.parse(
        "${ApiBaseUrl}${Endpoints.chat_messages}/$conversationId?page=$page&limit=$limit");

    try {
      final response = await http.get(
        url,
        headers: await _headers(withAuth: true),
      );
      // debugger();
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data']['messages'] ?? [];
        return data.map((e) => ChatMessage.fromJson(e)).toList();
      } else {
        AppToast.error(context,
            "Failed to load messages (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      AppToast.error(context, "Error loading messages: $e");
    }
    return [];
  }

  // ✅ Send message (previous function for reference)
  static Future<ChatMessage?> sendMessage(
    BuildContext context, {
    required String receiverId,
    required String message,
    required String messageType, // e.g. "text", "image", "video"
    String? fileUrl,
  }) async {
    final url = Uri.parse("${ApiBaseUrl}${Endpoints.chat_send_message}");
    try {
      final body = {
        "receiverId": receiverId,
        "message": message,
        "messageType": messageType,
        "fileUrl": fileUrl ?? "",
      };

      final response = await http.post(
        url,
        headers: await _headers(withAuth: true),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data']['message'];
        AppToast.success(
            context, json['message'] ?? 'Message sent successfully');
        return ChatMessage.fromJson(data);
      } else {
        AppToast.error(context,
            "Failed to send message (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      AppToast.error(context, "Error sending message: $e");
    }
    return null;
  }
}
