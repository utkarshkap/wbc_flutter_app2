import 'dart:convert';

import 'expanded_category_model.dart';

Popular popularFromJson(String str) => Popular.fromJson(json.decode(str));

String popularToJson(Popular data) => json.encode(data.toJson());

class Popular {
  Popular({
    required this.code,
    required this.message,
    required this.products,
  });

  int code;
  String message;
  List<Product> products;

  factory Popular.fromJson(Map<String, dynamic> json) => Popular(
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
    return 'Popular{code: $code, message: $message, products: $products}';
  }
}

class Product {
  Product({
    required this.id,
    required this.catId,
    required this.name,
    required this.price,
    required this.discount,
    required this.availableQty,
    required this.description,
    required this.rate,
    required this.img,
  });

  int id;
  int catId;
  String name;
  num price;
  int discount;
  int availableQty;
  String description;
  double rate;
  List<Img> img;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    catId: json["cat_id"],
    name: json["name"]??'',
    price: json["price"]??0,
    discount: json["discount"]??0,
    availableQty: json["available_qty"]??0,
    description: json["description"]??'',
    rate: json["rate"].toDouble()??0,
    img: json["img"]==null?[]:List<Img>.from(json["img"].map((x) => Img.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cat_id": catId,
    "name": name,
    "price": price,
    "discount": discount,
    "available_qty": availableQty,
    "description": description,
    "rate": rate,
    "img": List<dynamic>.from(img.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'Product{id: $id, catId: $catId, name: $name, price: $price, discount: $discount, availableQty: $availableQty, description: $description, rate: $rate, img: $img}';
  }
}

