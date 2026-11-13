import 'package:flutter/material.dart';
import '../../cors/theme/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Bessie Cooper liked your post",
      "subtitle": "2 minutes ago",
      "icon": Icons.favorite,
      "color": Colors.pink[100],
    },
    {
      "title": "Jane Cooper started following you",
      "subtitle": "10 minutes ago",
      "icon": Icons.person_add_alt_1,
      "color": Colors.purple[100],
    },
    {
      "title": "Guy Hawkins mentioned you in a comment",
      "subtitle": "1 hour ago",
      "icon": Icons.comment,
      "color": Colors.blue[100],
    },
    {
      "title": "Theresa Webb shared your post",
      "subtitle": "3 hours ago",
      "icon": Icons.share,
      "color": Colors.green[100],
    },
    {
      "title": "Darrell Steward sent you a message",
      "subtitle": "Yesterday",
      "icon": Icons.message,
      "color": Colors.orange[100],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
            const SizedBox(height: 40),

            /// 🔔 Notification list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlack.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: notif["color"],
                          child: Icon(
                            notif["icon"],
                            size: 24,
                            color: AppColors.darkBlack,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif["title"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif["subtitle"],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert,
                            size: 20, color: Colors.black54),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
