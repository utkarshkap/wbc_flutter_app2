import 'dart:convert';

import 'package:wbc_connect_app/models/popular_data_model.dart';

import 'expanded_category_model.dart';

Trending trendingFromJson(String str) => Trending.fromJson(json.decode(str));

String trendingToJson(Trending data) => json.encode(data.toJson());

class Trending {
  Trending({
    required this.code,
    required this.message,
    required this.products,
  });

  int code;
  String message;
  List<Product> products;

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
    code: json["code"],
    message: json["message"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'Trending{code: $code, message: $message, products: $products}';
  }
}

