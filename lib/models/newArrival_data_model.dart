import 'dart:convert';

import 'popular_data_model.dart';

NewArrival newArrivalFromJson(String str) => NewArrival.fromJson(json.decode(str));

String newArrivalToJson(NewArrival data) => json.encode(data.toJson());

class NewArrival {
  NewArrival({
    required this.code,
    required this.message,
    required this.products,
  });

  int code;
  String message;
  List<Product> products;

  factory NewArrival.fromJson(Map<String, dynamic> json) => NewArrival(
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
    return 'NewArrival{code: $code, message: $message, products: $products}';
  }
}

