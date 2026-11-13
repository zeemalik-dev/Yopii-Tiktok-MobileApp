import 'dart:convert';

import 'parts/creator_model.dart';
import 'parts/music_model.dart';
import 'parts/pagination_model.dart';
import 'parts/product_model.dart';

FeedResponse feedResponseFromJson(String str) =>
    FeedResponse.fromJson(json.decode(str));

String feedResponseToJson(FeedResponse data) => json.encode(data.toJson());

class FeedResponse {
  final String? status;
  final String? message;
  final FeedData? data;

  FeedResponse({
    this.status,
    this.message,
    this.data,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) => FeedResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : FeedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class FeedData {
  final List<FeedItem> feed;
  final Pagination? pagination;

  FeedData({
    required this.feed,
    this.pagination,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
        feed: json["feed"] == null
            ? []
            : List<FeedItem>.from(
                json["feed"].map((x) => FeedItem.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "feed": List<dynamic>.from(feed.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class FeedItem {
  final String id;
  final String description;
  final List<String> tags;
  final String thumbnailUrl;
  final bool isYourContent;
  final bool isLikedByYou;
  final bool isSavedByYou;
  final int totalLikes;
  final int totalComments;
  final int totalSaves;
  final int totalViews;
  final Creator? creatorId;
  final String videoUrl;
  final bool isProduct;
  final Music? musicId;
  final Product? productId;
  final DateTime? createdAt;

  FeedItem({
    required this.id,
    required this.description,
    required this.tags,
    required this.thumbnailUrl,
    required this.isYourContent,
    required this.isLikedByYou,
    required this.isSavedByYou,
    required this.totalLikes,
    required this.totalComments,
    required this.totalSaves,
    required this.totalViews,
    this.creatorId,
    required this.videoUrl,
    required this.isProduct,
    this.musicId,
    this.productId,
    this.createdAt,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) => FeedItem(
        id: json["_id"] ?? "",
        description: json["description"] ?? "",
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"].map((x) => x.toString())),
        thumbnailUrl: json["thumbnailUrl"] ?? "",
        isYourContent: json["isYourContent"] ?? false,
        isLikedByYou: json["isLikedByYou"] ?? false,
        isSavedByYou: json["isSavedByYou"] ?? false,
        totalLikes: json["totalLikes"] ?? 0,
        totalComments: json["totalComments"] ?? 0,
        totalSaves: json["totalSaves"] ?? 0,
        totalViews: json["totalViews"] ?? 0,
        creatorId: json["creatorId"] == null
            ? null
            : Creator.fromJson(json["creatorId"]),
        videoUrl: json["videoUrl"] ?? "",
        isProduct: json["isProduct"] ?? false,
        musicId:
            json["musicId"] == null ? null : Music.fromJson(json["musicId"]),
        productId: json["productId"] == null
            ? null
            : Product.fromJson(json["productId"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "thumbnailUrl": thumbnailUrl,
        "isYourContent": isYourContent,
        "isLikedByYou": isLikedByYou,
        "isSavedByYou": isSavedByYou,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "totalSaves": totalSaves,
        "totalViews": totalViews,
        "creatorId": creatorId?.toJson(),
        "videoUrl": videoUrl,
        "isProduct": isProduct,
        "musicId": musicId?.toJson(),
        "productId": productId?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
      };
}
