import 'parts/chat_message_model.dart';
import 'parts/chat_user_model.dart';

class ChatConversation {
  final String? id;
  final ChatUser? otherUser;
  final ChatMessage? lastMessage;
  final String? lastMessageAt;
  final bool? isOnline;

  ChatConversation({
    this.id,
    this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
    this.isOnline,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['_id'],
      otherUser: json['otherUser'] != null
          ? ChatUser.fromJson(json['otherUser'])
          : null,
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      lastMessageAt: json['lastMessageAt'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "otherUser": otherUser?.toJson(),
        "lastMessage": lastMessage?.toJson(),
        "lastMessageAt": lastMessageAt,
        "isOnline": isOnline,
      };
}

/// 📜 Optional: Pagination model for conversations/messages listing
class Pagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
    );
  }

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
      };
}
