import 'dart:convert';

ExpandedCategory expandedCategoryFromJson(String str) => ExpandedCategory.fromJson(json.decode(str));

String expandedCategoryToJson(ExpandedCategory data) => json.encode(data.toJson());

class ExpandedCategory {
  ExpandedCategory({
    required this.code,
    required this.message,
    required this.productList,
  });

  int code;
  String message;
  List<ProductList>? productList;

  factory ExpandedCategory.fromJson(Map<String, dynamic> json) => ExpandedCategory(
    code: json["code"],
    message: json["message"],
    productList: json["productList"] == null ? [] : List<ProductList>.from(json["productList"].map((x) => ProductList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "productList": List<dynamic>.from(productList!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ExpandedCategory{code: $code, message: $message, productList: $productList}';
  }
}

class ProductList {
  ProductList({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.availableQty,
    required this.description,
    required this.rate,
    required this.img,
  });

  int id;
  String name;
  num price;
  int discount;
  int availableQty;
  String description;
  double rate;
  List<Img> img;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    discount: json["discount"],
    availableQty: json["available_qty"],
    description: json["description"],
    rate: json["rate"].toDouble(),
    img: List<Img>.from(json["img"].map((x) => Img.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
    return 'ProductList{id: $id, name: $name, price: $price, discount: $discount, availableQty: $availableQty, description: $description, rate: $rate, img: $img}';
  }
}

class Img {
  Img({
    required this.id,
    required this.imgPath,
  });

  int id;
  String imgPath;

  factory Img.fromJson(Map<String, dynamic> json) => Img(
    id: json["id"],
    imgPath: json["img_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "img_path": imgPath,
  };

  @override
  String toString() {
    return 'Img{id: $id, imgPath: $imgPath}';
  }
}
