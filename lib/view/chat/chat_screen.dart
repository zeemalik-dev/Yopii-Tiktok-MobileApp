import 'dart:async';
import 'dart:developer';

import 'package:createex_task_application/controller/services/local_storage_service.dart';
import 'package:createex_task_application/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/providers/chat_provider.dart';
import '../../model/chat/parts/chat_user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String conversationId;
  late ChatUser receiver;
  String? currentUserID;
  bool _initialized = false;
  // Infinite scroll state
  bool _isLoadingMore = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // We'll initialize after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    // get route args
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    conversationId = args?['conversationId'] ?? '';
    receiver = args?['receiver'];

    // get user id
    currentUserID = await LocalStorageService().getUserId();

    // only proceed if everything is valid
    if (conversationId.isNotEmpty && mounted) {
      if (context.read<ChatProvider>().messages.isEmpty) {
        await context
            .read<ChatProvider>()
            .fetchMessages(context, conversationId);
      }
      context.read<ChatProvider>().addListener(_onProviderUpdate);
      // rebuild so currentUserID applies
      setState(() {});
    }
    setState(() => _initialized = true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    conversationId = args?['conversationId'] ?? '';
    receiver = args?['receiver'];

    // load current user id (async) then fetch messages
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    // remove provider listener
    try {
      context.read<ChatProvider>().removeListener(_onProviderUpdate);
    } catch (_) {}
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onProviderUpdate() {
    // Called whenever provider notifies.
    // We want to animate to newest message smoothly if a new message arrived or after sending.
    // Because ListView is reversed (newest at bottom), we animate to 0.0 (scrollController.position.minScrollExtent).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      // If user is near bottom (less than 200px away), auto-scroll.
      final distanceFromBottom = _scrollController.position.pixels -
          _scrollController.position.minScrollExtent;
      // for reversed list: minScrollExtent == 0.0, pixels will be small when at bottom
      if (distanceFromBottom.abs() < 200) {
        _scrollToBottomSmooth();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // For reversed ListView: scroll position 0.0 is the bottom (newest).
    // To detect "scrolled to top" (oldest), compare to maxScrollExtent.
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    // If user scrolled sufficiently close to the top (older messages)
    if (current >= (max - 100) && !_isLoadingMore) {
      // Debounce quick repeated triggers
      if (_debounceTimer?.isActive ?? false) return;
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        _loadMoreMessages();
      });
    }
  }

  Future<void> _loadMoreMessages() async {
    setState(() => _isLoadingMore = true);

    try {
      // tell provider to fetch next page of messages for this conversation
      await context
          .read<ChatProvider>()
          .fetchMoreMessages(context, conversationId);
      // After older messages are appended at the end of 'messages' list (because reversed),
      // we should preserve scroll offset to prevent jump.
      // A simple approach: keep the current scroll offset by jumping to same pixel after update.
      // But because provider and list rebuilding are async, a short delay helps smoothness.
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      // ignore errors here — provider shows toasts
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _scrollToBottomSmooth() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    await context.read<ChatProvider>().sendChatMessage(
          context,
          receiverId: receiver.id ?? "",
          message: text,
          messageType: "text",
        );

    Future.delayed(const Duration(milliseconds: 150), () {
      _scrollToBottomSmooth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final messages = chatProvider.messages;
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
        title: Text(
          receiver.fullName ?? 'Chat',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // loading older messages indicator (shown when fetching older pages)
            if (_isLoadingMore)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: AppColors.primaryOrange),
                ),
              ),

            // 💬 Messages List
            Expanded(
              child: chatProvider.isLoading && messages.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : NotificationListener<ScrollNotification>(
                      // optional: stop parent scroll behaviors
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true, // newest messages at the bottom
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.sender?.id == currentUserID;
                          log(currentUserID.toString());
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFFFFE5E1)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 16),
                                ),
                              ),
                              child: Text(
                                msg.message ?? '',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // ✏️ Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: AppColors.primaryWhite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your message",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: AppColors.primaryWhite,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: AppColors.darkOrage, width: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orangeAccent,
                      child: const Icon(Icons.send,
                          color: AppColors.primaryWhite, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
