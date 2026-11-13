class Product {
  final String id;
  final String productName;
  final int price;
  final String description;
  final List<String> productImages;
  final String shopId;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.description,
    required this.productImages,
    required this.shopId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"] ?? "",
        productName: json["productName"] ?? "",
        price: json["price"] ?? 0,
        description: json["description"] ?? "",
        productImages: json["productImages"] == null
            ? []
            : List<String>.from(json["productImages"].map((x) => x.toString())),
        shopId: json["shopId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productName": productName,
        "price": price,
        "description": description,
        "productImages": List<dynamic>.from(productImages.map((x) => x)),
        "shopId": shopId,
      };
}
