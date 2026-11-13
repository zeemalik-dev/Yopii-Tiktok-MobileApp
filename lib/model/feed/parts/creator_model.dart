class Creator {
  final String id;
  final String fullName;
  final String username;
  final String profileImageUrl;

  Creator({
    required this.id,
    required this.fullName,
    required this.username,
    required this.profileImageUrl,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["_id"] ?? "",
        fullName: json["fullName"] ?? "",
        username: json["username"] ?? "",
        profileImageUrl: json["profileImageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "username": username,
        "profileImageUrl": profileImageUrl,
      };
}
