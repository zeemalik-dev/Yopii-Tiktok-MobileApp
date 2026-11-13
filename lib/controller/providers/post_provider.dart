import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_manager.dart';
import '../services/app_toast.dart';

class PostProvider extends ChangeNotifier {
  bool _isUploading = false;
  bool _isPosting = false;
  String? _uploadedVideoUrl;
  String? _uploadedThumbnailUrl;
  String? _errorMessage;

  bool get isUploading => _isUploading;
  bool get isPosting => _isPosting;
  String? get uploadedVideoUrl => _uploadedVideoUrl;
  String? get uploadedThumbnailUrl => _uploadedThumbnailUrl;
  String? get errorMessage => _errorMessage;

  /// 🟢 Upload a video file
  Future<void> uploadVideo(BuildContext context, File videoFile) async {
    if (_isUploading) return;

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiManager.uploadVideo(context, videoFile);
      if (result != null && result.isNotEmpty) {
        _uploadedVideoUrl = result[0];
        _uploadedThumbnailUrl = result[1];
        AppToast.success(context, 'Video uploaded successfully 🎥');
      } else {
        _errorMessage = 'Failed to upload video.';
        AppToast.error(context, _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error uploading video: $e';
      AppToast.error(context, _errorMessage!);
    }

    _isUploading = false;
    notifyListeners();
  }

  /// 🟣 Upload an image file (thumbnail)
  Future<void> uploadThumbnail(BuildContext context, File imageFile) async {
    if (_isUploading) return;
    log("Thumbnail upload started ... path: ${imageFile.path}");
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiManager.uploadImage(context, imageFile);
      if (result != null && result.isNotEmpty) {
        _uploadedThumbnailUrl = result;
        // AppToast.success(context, 'Thumbnail uploaded successfully 🖼️');
      } else {
        _errorMessage = 'Failed to upload thumbnail.';
        // AppToast.error(context, _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error uploading thumbnail: $e';
      AppToast.error(context, _errorMessage!);
    }

    _isUploading = false;
    notifyListeners();
  }

  /// 🟠 Create a post after uploads
  /// 🟠 Create a post (handles upload + post creation)
  Future<void> createPost(
    BuildContext context, {
    required String description,
    required List<String> tags,
    required bool isProduct,
    bool isVideo = false, // 🔸 NEW PARAMETER to control upload behavior
    required File file,
    String? productId,
    String? musicId,
  }) async {
    if (_isPosting) return;
    _isPosting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ Step 1: Handle uploads if it's a video post
      if (isVideo) {
        // Upload Video
        await uploadVideo(context, file);
        // Upload Thumbnail
      } else {
        await uploadThumbnail(context, file);
      }

      // ✅ Step 2: Validate upload results (if isVideo)
      // debugger();
      if (_errorMessage != null) {
        throw Exception(_errorMessage);
      } else {
        final success = await ApiManager.createContent(
          context,
          description: description,
          tags: tags,
          videoUrl: isVideo
              ? _uploadedVideoUrl!
              : "https://res.cloudinary.com/dhjgywp9k/video/upload/sp_auto/v1760379224/yoopii_app/yoopiivideos/k7jgnhxh8xbumve9wwa1.m3u8",
          thumbnailUrl: _uploadedThumbnailUrl!,
          isProduct: isProduct,
          productId: productId,
          musicId: musicId,
        );

        if (success) {
          AppToast.success(context, 'Post created successfully 🚀');
          clearUploads();
        } else {
          throw Exception('Failed to create post.');
        }
      }
      // ✅ Step 3: Create the post
    } catch (e) {
      _errorMessage = 'Error creating post: $e';
      AppToast.error(context, _errorMessage!);
    }

    _isPosting = false;
    notifyListeners();
  }

  /// 🧹 Reset uploaded data
  void clearUploads() {
    _uploadedVideoUrl = null;
    _uploadedThumbnailUrl = null;
    _errorMessage = null;
    notifyListeners();
  }
}
