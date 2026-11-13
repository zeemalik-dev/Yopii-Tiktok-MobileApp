import 'dart:io';

import 'package:createex_task_application/controller/services/app_toast.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:createex_task_application/view/content/preview/media_preview_sheet.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '../../../controller/providers/post_provider.dart';
import '../../../cors/routes/app_routes.dart';
import '../../../cors/utils/bottom_sheet_service.dart';

class PostScreen extends StatefulWidget {
  final File file;
  const PostScreen({super.key, required this.file});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<String> tags = [];

  // ✅ Function to add tags
  void _addTag() {
    String text = _tagController.text.trim();
    if (text.isEmpty) return;

    // Only allow letters, numbers, and underscores
    final validTag = RegExp(r'^[a-zA-Z0-9_ ]+$');
    if (!validTag.hasMatch(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Only letters, numbers, and underscores allowed"),
        ),
      );
      return;
    }

    // Split by spaces to make multiple tags
    final words = text.split(' ');
    for (var word in words) {
      if (word.isNotEmpty) {
        String formatted = "#${word.replaceAll('#', '')}";
        if (!tags.contains(formatted)) {
          tags.add(formatted);
        }
      }
    }
    _tagController.clear();
    setState(() {});
  }

  // ✅ Back alert dialog
  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard Post?"),
        content: const Text(
            "Are you sure you want to discard this post and go back?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Discard",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  bool _isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.mkv');
  }

  Future<String?> _generateVideoThumbnail(File file) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 75,
    );
    return thumbnailPath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PostProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () async {
                  bool discard = await _onWillPop();
                  if (discard && mounted) {
                    Get.offAllNamed(AppRoutes.home);
                  }
                },
              ),
              const Text(
                "Post",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        body: Builder(builder: (context) {
          var pro = context.watch<PostProvider>();
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description + Image Thumbnail
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            controller: _descController,
                            maxLength: 610,
                            maxLines: 6,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFAFAFA),
                              hintText: "Write your post description...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              counterText: '',
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        BottomSheetService.instance.show(
                            context: context,
                            child: MediaPreviewSheet(
                              file: widget.file,
                              isNext: false,
                              isVideo: _isVideo(widget.file.path),
                              onNextTap: () {},
                            ));
                      },
                      child: Container(
                        height: 165,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: FutureBuilder(
                          future: _isVideo(widget.file.path)
                              ? _generateVideoThumbnail(widget.file)
                              : Future.value(widget.file.path),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2));
                            }
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey);
                            }

                            final imagePath = snapshot.data!;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(imagePath.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (_isVideo(widget.file.path))
                                  const Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white70,
                                      size: 35,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tags
                const Text(
                  "Tags",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => tags.remove(tag));
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          hintText: "Add tag (letters, numbers, _)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.primaryOrange, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addTag,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7446),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(color: AppColors.primaryWhite),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Buttons
                pro.isPosting
                    ? CustomButton(
                        text: "",
                        callback: () {},
                        flag: true,
                        isLoading: true,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final shouldDiscard = await _onWillPop();
                                if (shouldDiscard && mounted) {
                                  Get.offAllNamed(AppRoutes.home);
                                }
                              },
                              icon: const Icon(
                                Iconsax.trash,
                                size: 18,
                                color: AppColors.darkOrage,
                              ),
                              label: const Text(
                                "Deny",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkOrage),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xfaFFE2D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_descController.text.trim().isEmpty) {
                                  AppToast.error(
                                      context, "Description can't be empty");
                                  return;
                                } else if (tags.isEmpty) {
                                  AppToast.error(
                                      context, "Please add at least one tag");
                                  return;
                                } else {
                                  await pro.createPost(
                                    context,
                                    description: _descController.text.trim(),
                                    tags: tags,
                                    isProduct: false,
                                    file: widget.file,
                                    isVideo: _isVideo(widget.file.path),
                                    productId: "",
                                    musicId: "",
                                  );
                                }
                              },
                              icon: const Icon(
                                Iconsax.send_2,
                                size: 18,
                                color: AppColors.primaryWhite,
                              ),
                              label: const Text(
                                "Post",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryWhite),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
