import 'package:flutter/material.dart';
import '../../model/chat/chat_model.dart';
import '../../model/chat/parts/chat_message_model.dart';
import '../services/api_manager.dart';
import '../services/app_toast.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSending = false;
  bool _isFetchingMore = false;
  bool _hasMoreMessages = true;

  int _messagesPage = 1;
  final int _messagesLimit = 50;

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _messages = [];

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreMessages => _hasMoreMessages;

  List<ChatConversation> get conversations => List.unmodifiable(_conversations);
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // 🔹 Fetch all conversations
  Future<void> fetchConversations(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await ApiManager.getConversations(context);
    } catch (e) {
      AppToast.error(context, "Error fetching conversations: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔹 Fetch messages for a specific conversation (initial load)
  Future<void> fetchMessages(
      BuildContext context, String conversationId) async {
    _isLoading = true;
    _messagesPage = 1;
    _hasMoreMessages = true;
    notifyListeners();

    try {
      final fetched = await ApiManager.getMessagesByConversation(
        context,
        conversationId: conversationId,
        page: _messagesPage,
        limit: _messagesLimit,
      );

      // Assuming your API returns newest-first; if not, reverse it.
      _messages = fetched;
    } catch (e) {
      AppToast.error(context, "Error fetching messages: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔹 Fetch older messages (pagination) when scrolling up
  Future<void> fetchMoreMessages(
      BuildContext context, String conversationId) async {
    if (_isFetchingMore || !_hasMoreMessages) return;
    _isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = _messagesPage + 1;
      final fetched = await ApiManager.getMessagesByConversation(
        context,
        conversationId: conversationId,
        page: nextPage,
        limit: _messagesLimit,
      );

      if (fetched.isNotEmpty) {
        // append older messages at the end (UI uses reverse:true)
        _messages.addAll(fetched);
        _messagesPage = nextPage;
      } else {
        _hasMoreMessages = false;
      }
    } catch (e) {
      AppToast.error(context, "Error loading older messages: $e");
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  // 🔹 Send a new message
  Future<void> sendChatMessage(
    BuildContext context, {
    required String receiverId,
    required String message,
    required String messageType,
    String? fileUrl,
  }) async {
    if (_isSending) return;
    _isSending = true;
    notifyListeners();

    try {
      final sent = await ApiManager.sendMessage(
        context,
        receiverId: receiverId,
        message: message,
        messageType: messageType,
        fileUrl: fileUrl,
      );

      if (sent != null) {
        // insert new message at the top (because list is reversed in UI)

        _messages.insert(0, sent);
        notifyListeners();
      }
    } catch (e) {
      AppToast.error(context, "Error sending chat message: $e");
    }

    _isSending = false;
    notifyListeners();
  }

  // 🔹 Clear chat data
  void clearChatData() {
    _messages.clear();
    _conversations.clear();
    _isLoading = false;
    _isSending = false;
    _isFetchingMore = false;
    _hasMoreMessages = true;
    notifyListeners();
  }
}
