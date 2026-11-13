import 'chat_user_model.dart';

class ChatMessage {
  final String? id;
  final String? conversationId;
  final ChatUser? sender;
  final ChatUser? receiver;
  final String? message;
  final String? messageType; // e.g. "text", "image", "video"
  final bool? isRead;
  final String? createdAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.sender,
    this.receiver,
    this.message,
    this.messageType,
    this.isRead,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      conversationId: json['conversationId'],
      sender: json['sender'] != null ? ChatUser.fromJson(json['sender']) : null,
      receiver:
          json['receiver'] != null ? ChatUser.fromJson(json['receiver']) : null,
      message: json['message'],
      messageType: json['messageType'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "conversationId": conversationId,
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
        "message": message,
        "messageType": messageType,
        "isRead": isRead,
        "createdAt": createdAt,
      };
}
