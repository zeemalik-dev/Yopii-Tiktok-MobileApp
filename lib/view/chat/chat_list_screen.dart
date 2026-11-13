import 'package:createex_task_application/cors/routes/app_routes.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controller/providers/chat_provider.dart';
import '../../model/chat/chat_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch conversations from provider

    var pro = context.read<ChatProvider>();
    if (pro.conversations.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pro.fetchConversations(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final conversations = chatProvider.conversations;

    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Chats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ✅ Conversations List
            Expanded(
              child: chatProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ))
                  : conversations.isEmpty
                      ? Center(
                          child: Text("No Chat Founds",
                              style: TextStyle(
                                  color: AppColors.primaryBlack,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)))
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final ChatConversation convo = conversations[index];
                            final user = convo.otherUser;
                            final lastMsg = convo.lastMessage?.message ?? '';

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.chat,
                                  arguments: {
                                    "conversationId": convo.id,
                                    "receiver": user,
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryWhite,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryBlack
                                          .withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: user?.profileImageUrl !=
                                              null
                                          ? NetworkImage(user!.profileImageUrl!)
                                          : null,
                                      child: user?.profileImageUrl == null
                                          ? const Icon(Icons.person,
                                              size: 28,
                                              color: AppColors.darkBlack)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.fullName ?? "Unknown User",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            lastMsg,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      convo.lastMessageAt != null
                                          ? convo.lastMessageAt!
                                              .substring(11, 16)
                                          : "",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkBlack,
                                      ),
                                    ),
                                  ],
                                ),
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
