import 'dart:convert';

ProductCategory productCategoryFromJson(String str) => ProductCategory.fromJson(json.decode(str));

String productCategoryToJson(ProductCategory data) => json.encode(data.toJson());

class ProductCategory {
  ProductCategory({
    required this.code,
    required this.message,
    required this.categories,
  });

  int code;
  String message;
  List<Category> categories;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    code: json["code"],
    message: json["message"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.imgPath,
  });

  int id;
  String name;
  String imgPath;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    imgPath: json["img_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img_path": imgPath,
  };
}
