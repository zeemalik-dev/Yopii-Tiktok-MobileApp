class User {
  // ✅ Common fields (required)
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final bool isSeller;
  final String role;
  final int totalFollowers;
  final int totalFollowing;

  // ✅ Optional / extra fields
  final bool? isEmailVerified;
  final int? itemSold;
  final bool? isDeleted;
  final String? onboardingStatus;
  final double? walletBalance;
  final DateTime? createdAt;
  final String? contentType;
  final String? description;
  final String? profileImageUrl;
  final Map<String, dynamic>? shopDetails;

  const User({
    // Required (common)
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.isSeller,
    required this.role,
    required this.totalFollowers,
    required this.totalFollowing,

    // Optional
    this.isEmailVerified,
    this.itemSold,
    this.isDeleted,
    this.onboardingStatus,
    this.walletBalance,
    this.createdAt,
    this.contentType,
    this.description,
    this.profileImageUrl,
    this.shopDetails,
  });

  /// ✅ Null-safe and type-safe JSON parsing
  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("User.fromJson: JSON data is null");
    }

    // Helper for safe parsing
    T parse<T>(dynamic value, T fallback) {
      if (value is T) return value;
      return fallback;
    }

    return User(
      // Common required fields
      id: parse(json['_id'], ''),
      fullName: parse(json['fullName'], ''),
      username: parse(json['username'], ''),
      email: parse(json['email'], ''),
      phoneNumber: parse(json['phoneNumber'], ''),
      isSeller: parse(json['isSeller'], false),
      role: parse(json['role'], 'user'),
      totalFollowers:
          int.tryParse(json['totalFollowers']?.toString() ?? '') ?? 0,
      totalFollowing:
          int.tryParse(json['totalFollowing']?.toString() ?? '') ?? 0,

      // Optional fields
      isEmailVerified: parse(json['isEmailVerified'], false),
      itemSold: int.tryParse(
              (json['itemSold'] ?? json['itemsSold'])?.toString() ?? '') ??
          0,
      isDeleted: parse(json['isDeleted'], false),
      onboardingStatus: parse(json['onboardingStatus'], 'pending'),
      walletBalance:
          double.tryParse(json['walletBalance']?.toString() ?? '') ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      contentType: parse(json['contentType'], ''),
      description: parse(json['description'], ''),
      profileImageUrl: parse(json['profileImageUrl'], ''),
      shopDetails: (json['shopDetails'] is Map)
          ? Map<String, dynamic>.from(json['shopDetails'])
          : null,
    );
  }

  /// ✅ Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'isSeller': isSeller,
      'role': role,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'isEmailVerified': isEmailVerified,
      'itemSold': itemSold,
      'isDeleted': isDeleted,
      'onboardingStatus': onboardingStatus,
      'walletBalance': walletBalance,
      'createdAt': createdAt?.toIso8601String(),
      'contentType': contentType,
      'description': description,
      'profileImageUrl': profileImageUrl,
      'shopDetails': shopDetails,
    };
  }

  /// ✅ Copy with method (to update values immutably)
  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    bool? isSeller,
    String? role,
    int? totalFollowers,
    int? totalFollowing,
    bool? isEmailVerified,
    int? itemSold,
    bool? isDeleted,
    String? onboardingStatus,
    double? walletBalance,
    DateTime? createdAt,
    String? contentType,
    String? description,
    String? profileImageUrl,
    Map<String, dynamic>? shopDetails,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSeller: isSeller ?? this.isSeller,
      role: role ?? this.role,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      itemSold: itemSold ?? this.itemSold,
      isDeleted: isDeleted ?? this.isDeleted,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      contentType: contentType ?? this.contentType,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      shopDetails: shopDetails ?? this.shopDetails,
    );
  }
}
