class CartItem {
  CartItem({
    required this.id,
    required this.categoryId,
    required this.productId,
    required this.img,
    required this.name,
    required this.price,
    required this.discount,
    required this.quantity,
  });

  int id;
  int categoryId;
  int productId;
  String img;
  String name;
  num price;
  int discount;
  int quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    categoryId: json["categoryId"],
    productId: json["productId"],
    img: json["img"],
    name: json["name"],
    price: json["price"],
    discount: json["discount"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "productId": productId,
    "img": img,
    "name": name,
    "price": price,
    "discount": discount,
    "quantity": quantity,
  };

  @override
  String toString() {
    return 'CartItem{id: $id, categoryId: $categoryId, productId: $productId, img: $img, name: $name, price: $price, discount: $discount, quantity: $quantity}';
  }
}
