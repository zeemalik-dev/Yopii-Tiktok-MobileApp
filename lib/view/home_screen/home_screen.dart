import 'package:createex_task_application/controller/providers/feed_provider.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/view/chat/chat_list_screen.dart';
import 'package:createex_task_application/view/content/media/media_picker_sheet.dart';
import 'package:createex_task_application/view/feed/for_you_screen.dart';
import 'package:createex_task_application/view/notification/notification_screen.dart';
import 'package:createex_task_application/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const ForYouScreen(),
    const ChatListScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  Future<void> _onRefresh() async {
    // Implement your refresh logic here
    // For example, you might want to refresh the feed data
    await Provider.of<FeedProvider>(context, listen: false)
        .fetchFeed(context, loadMore: false);
    // Simulating a network call delay
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          selectedIndex == 0 ? AppColors.primaryBlack : AppColors.primaryWhite,
      body: selectedIndex == 0
          ? RefreshIndicator(
              color: Colors.orange,
              backgroundColor: Colors.black,
              onRefresh: _onRefresh,
              child: Stack(
                children: [
                  /// Main Page (TikTok-style feed)
                  Positioned.fill(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: _screens,
                    ),
                  ),

                  /// Bottom Navigation Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomBottomNavBar(
                      selectedIndex: selectedIndex,
                      onItemTapped: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      onAddTap: () {
                        // Handle add button tap
                        BottomSheetService.instance
                            .show(context: context, child: MediaPickerSheet());
                      },
                      isGreyTransparent: true,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                /// Main Page (TikTok-style feed)
                Positioned.fill(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: _screens,
                  ),
                ),

                /// Bottom Navigation Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomBottomNavBar(
                    selectedIndex: selectedIndex,
                    onAddTap: () {
                      // Handle add button tap
                      BottomSheetService.instance
                          .show(context: context, child: MediaPickerSheet());
                    },
                    onItemTapped: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    isGreyTransparent: selectedIndex == 0 ? true : false,
                  ),
                ),
              ],
            ),
    );
  }
}
