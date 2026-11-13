class Pagination {
  final int total;
  final String page;
  final String limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"] ?? 0,
        page: json["page"] ?? "",
        limit: json["limit"] ?? "",
        totalPages: json["totalPages"] ?? 0,
        hasNextPage: json["hasNextPage"] ?? false,
        hasPrevPage: json["hasPrevPage"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "hasNextPage": hasNextPage,
        "hasPrevPage": hasPrevPage,
      };
}
