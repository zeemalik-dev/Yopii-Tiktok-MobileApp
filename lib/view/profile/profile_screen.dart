import 'package:createex_task_application/controller/providers/auth_provider.dart';
import 'package:createex_task_application/controller/providers/user_provider.dart';
import 'package:createex_task_application/cors/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../cors/theme/app_colors.dart';
import 'widgets/stats_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> posts = [
    {"image": "https://picsum.photos/200/300", "views": "1.5K Views"},
    {"image": "https://picsum.photos/200/301", "views": "1.2K Views"},
    {"image": "https://picsum.photos/200/302", "views": "900 Views"},
    {"image": "https://picsum.photos/200/303", "views": "2.1K Views"},
    {"image": "https://picsum.photos/200/304", "views": "1.8K Views"},
    {"image": "https://picsum.photos/200/305", "views": "700 Views"},
  ];

  String selectedTab = "Live";

  final tabs = ["Live", "Music", "Save", "Vibes", "My Order"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var pro = context.read<UserProvider>();
    if (pro.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pro.userProfileShowMe(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Builder(builder: (context) {
            var provider = context.watch<UserProvider>();

            return provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),

                      /// --- App Bar ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: AppColors.darkBlack),
                            PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onSelected: (value) async {
                                if (value == 'Logout') {
                                  // handle logout
                                  Get.offAllNamed(AppRoutes.onboarding);
                                  await context
                                      .read<AuthProvider>()
                                      .logout(context);
                                } else if (value == 'Help') {
                                  // handle help
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Help',
                                  child: Text('Help'),
                                ),
                                const PopupMenuItem(
                                  value: 'Logout',
                                  child: Text('Logout'),
                                ),
                              ],
                              child: const Icon(Icons.more_vert,
                                  color: AppColors.darkBlack),
                            ),
                          ],
                        ),
                      ),

                      /// --- Profile Picture ---
                      CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.darkOrage,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Container(
                                decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(provider
                                        .user!.profileImageUrl!.isEmpty
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStltpfa69E9JTQOf5ZcyLGR8meBbxMFJxM0w&s"
                                    : provider.user!.profileImageUrl!),
                                fit: BoxFit.cover,
                              ),
                            )),
                          )),
                      const SizedBox(height: 10),

                      /// --- Name and Bio ---
                      Text(
                        provider.user!.fullName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlack),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.user!.description ??
                            "Sun-kissed vibes\nCape Town, South Africa",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkBlack,
                            fontWeight: FontWeight.w400),
                      ),

                      const SizedBox(height: 16),

                      /// --- Stats Row ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsWidget(
                                title: "Followers",
                                value:
                                    provider.user?.totalFollowers.toString() ??
                                        "1.1M"),
                            StatsWidget(
                                title: "Following",
                                value:
                                    provider.user?.totalFollowing.toString() ??
                                        "200"),
                            // StatsWidget(
                            //     title: "Boosts Received", value: "32.2K"),
                            StatsWidget(
                                title: "Items Sold",
                                value:
                                    provider.user?.itemSold.toString() ?? "32"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// --- Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7043),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoutes.editProfile,
                                  arguments: provider.user);
                            },
                            child: const Text("Edit Profile",
                                style: TextStyle(
                                    color: AppColors.primaryWhite,
                                    fontSize: 15)),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFF7043)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 10),
                            ),
                            onPressed: () {},
                            child: const Text("Share",
                                style: TextStyle(
                                    color: Color(0xFFFF7043), fontSize: 15)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// --- Tabs ---
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: tabs.map((tab) {
                            final isSelected = tab == selectedTab;
                            return GestureDetector(
                              onTap: () => setState(() => selectedTab = tab),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFF7043)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: const Color(0xFFFF7043)),
                                ),
                                child: Text(
                                  tab,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primaryWhite
                                        : const Color(0xFFFF7043),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// --- Posts Grid ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(post["image"]!,
                                      fit: BoxFit.cover),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      post["views"]!,
                                      style: const TextStyle(
                                        color: AppColors.primaryWhite,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
