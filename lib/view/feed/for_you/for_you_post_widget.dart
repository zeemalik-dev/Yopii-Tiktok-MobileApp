import 'package:createex_task_application/model/feed/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../cors/theme/app_colors.dart';

class ForYouPostWidget extends StatelessWidget {
  final FeedItem feedItem;

  const ForYouPostWidget({super.key, required this.feedItem});

  @override
  Widget build(BuildContext context) {
    // final creator = feedItem.id;
    // final videoUrl = feedItem.videoUrl;
    final thumbnailUrl = feedItem.thumbnailUrl;
    final description = feedItem.description;
    final creatorName = feedItem.creatorId!.fullName;
    final creatorImage = feedItem.creatorId!.profileImageUrl;

    return Stack(
      children: [
        // Background video or thumbnail
        Positioned.fill(
          child: Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[900]),
          ),
        ),

        // Gradient overlay for readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back_ios,
                      color: AppColors.primaryWhite, size: 24),
                  Row(
                    children: [
                      Text("Following",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                      SizedBox(width: 16),
                      Text("For You",
                          style: TextStyle(
                              color: AppColors.primaryWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.search, color: AppColors.primaryWhite, size: 24),
                ],
              ),
            ),
          ),
        ),

        // Action buttons (right side)
        Positioned(
          right: 16,
          bottom: 240,
          child: Column(
            children: [
              _icon(Iconsax.heart, feedItem.totalLikes),
              const SizedBox(height: 18),
              _icon(Iconsax.message, feedItem.totalComments),
              const SizedBox(height: 18),
              _icon(Iconsax.export, feedItem.totalSaves),
              const SizedBox(height: 18),
              _icon(Iconsax.save_2, feedItem.totalViews),
            ],
          ),
        ),

        // Bottom user info & caption
        Positioned(
          left: 16,
          bottom: 132,
          right: 100,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(creatorImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creatorName,
                        style: const TextStyle(
                            color: AppColors.primaryWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _icon(IconData icon, int? count) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryWhite, size: 28),
        if (count != null)
          Text(
            '$count',
            style: const TextStyle(color: AppColors.primaryWhite, fontSize: 12),
          ),
      ],
    );
  }
}
