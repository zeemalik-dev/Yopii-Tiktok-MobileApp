class ChatUser {
  final String? id;
  final String? fullName;
  final String? username;
  final String? profileImageUrl;
  final bool? isOnline;

  ChatUser({
    this.id,
    this.fullName,
    this.username,
    this.profileImageUrl,
    this.isOnline,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'],
      fullName: json['fullName'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "username": username,
        "profileImageUrl": profileImageUrl,
        "isOnline": isOnline,
      };
}
