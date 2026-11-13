import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../cors/routes/app_routes.dart';
import '../../../cors/theme/app_colors.dart';
import '../../../cors/utils/bottom_sheet_service.dart';

class MediaPreviewSheet extends StatefulWidget {
  final File file;
  final bool isVideo;
  final bool isNext;
  final Function onNextTap;

  const MediaPreviewSheet({
    super.key,
    required this.file,
    required this.isVideo,
    this.isNext = true,
    required this.onNextTap,
  });

  @override
  State<MediaPreviewSheet> createState() => _MediaPreviewSheetState();
}

class _MediaPreviewSheetState extends State<MediaPreviewSheet> {
  VideoPlayerController? _videoController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_videoController == null) return;
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      setState(() => isPlaying = false);
    } else {
      _videoController!.play();
      setState(() => isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppBar style top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () =>
                        BottomSheetService.instance.dismiss(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Preview",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  widget.isNext == false
                      ? SizedBox()
                      : TextButton(
                          onPressed: () {
                            // navigate to next screen with selected file
                            BottomSheetService.instance.dismiss(context);

                            Get.toNamed(AppRoutes.post, arguments: widget.file);
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            const Divider(height: 1),

            const SizedBox(height: 10),

            // Main preview area
            Expanded(
              child: Center(
                child: widget.isVideo
                    ? (_videoController != null &&
                            _videoController!.value.isInitialized)
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                              IconButton(
                                iconSize: 70,
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  color: Colors.white,
                                ),
                                onPressed: _togglePlay,
                              ),
                            ],
                          )
                        : const CircularProgressIndicator()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          widget.file,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
