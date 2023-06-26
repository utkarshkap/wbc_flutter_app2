import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.shipName,
    required this.shipAddress,
    required this.deliverytype,
    required this.country,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.phone,
    required this.orderDate,
    required this.items,
  });

  int orderId;
  int userId;
  int amount;
  String shipName;
  String shipAddress;
  String deliverytype;
  String country;
  String state;
  String city;
  String zipcode;
  String phone;
  String orderDate;
  List<Item> items;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["orderId"],
    userId: json["userId"],
    amount: json["amount"],
    shipName: json["shipName"],
    shipAddress: json["shipAddress"],
    deliverytype: json["deliverytype"],
    country: json["Country"],
    state: json["State"],
    city: json["City"],
    zipcode: json["zipcode"],
    phone: json["phone"],
    orderDate: json["OrderDate"],
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "userId": userId,
    "amount": amount,
    "shipName": shipName,
    "shipAddress": shipAddress,
    "deliverytype": deliverytype,
    "Country": country,
    "State": state,
    "City": city,
    "zipcode": zipcode,
    "phone": phone,
    "OrderDate": orderDate,
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'Order{orderId: $orderId, userId: $userId, amount: $amount, shipName: $shipName, shipAddress: $shipAddress, deliverytype: $deliverytype, country: $country, state: $state, city: $city, zipcode: $zipcode, phone: $phone, orderDate: $orderDate, items: $items}';
  }
}

class Item {
  Item({
    required this.productId,
    required this.productName,
    required this.price,
    required this.sku,
    required this.quantity,
  });

  int productId;
  String productName;
  int price;
  String sku;
  int quantity;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["productId"],
    productName: json["productName"],
    price: json["price"],
    sku: json["sku"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "price": price,
    "sku": sku,
    "quantity": quantity,
  };
}
