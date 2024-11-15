// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

OrderHistory orderHistoryFromJson(String str) =>
    OrderHistory.fromJson(json.decode(str));

String orderHistoryToJson(OrderHistory data) => json.encode(data.toJson());

class OrderHistory {
  OrderHistory({
    required this.code,
    required this.message,
    required this.orders,
  });

  final int code;
  final String message;
  final List<Order> orders;

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        code: json["code"],
        message: json["message"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.shipName,
    required this.shipAddress,
    required this.deliveryType,
    required this.country,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.phone,
    required this.shippingCharge,
    required this.tax,
    required this.shipDate,
    required this.orderStatus,
    required this.trackingNumber,
    required this.status,
    required this.orderDate,
    required this.productlist,
  });

  final int orderId;
  final int userId;
  final String userName;
  final num amount;
  final String shipName;
  final String shipAddress;
  final String deliveryType;

  final String country;
  final String state;
  final String city;
  final String zipcode;
  final String phone;
  final double shippingCharge;
  final double tax;
  final String shipDate;
  final String orderStatus;
  final String trackingNumber;
  final bool status;
  final String orderDate;
  final List<Productlist> productlist;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        userId: json["userId"],
        userName: json["userName"],
        amount: json["amount"],
        shipName: json["shipName"],
        shipAddress: json["shipAddress"],
        deliveryType: json["deliveryType"] ?? "",
        country: json["country"],
        state: json["state"],
        city: json["city"],
        zipcode: json["zipcode"],
        phone: json["phone"],
        shippingCharge: json["shippingCharge"].toDouble(),
        tax: json["tax"].toDouble(),
        shipDate: json["shipDate"],
        orderStatus: json["orderStatus"],
        trackingNumber: json["trackingNumber"],
        status: json["status"],
        orderDate: json["orderDate"],
        productlist: List<Productlist>.from(
            json["productlist"].map((x) => Productlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "userName": userName,
        "amount": amount,
        "shipName": shipName,
        "shipAddress": shipAddress,
        "deliveryType": deliveryType,
        "country": country,
        "state": state,
        "city": city,
        "zipcode": zipcode,
        "phone": phone,
        "shippingCharge": shippingCharge,
        "tax": tax,
        "shipDate": shipDate,
        "orderStatus": orderStatus,
        "trackingNumber": trackingNumber,
        "status": status,
        "orderDate": orderDate,
        "productlist": List<dynamic>.from(productlist.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Order{orderId: $orderId, userId: $userId, userName: $userName, amount: $amount, shipName: $shipName, shipAddress: $shipAddress, deliveryType: $deliveryType, country: $country, state: $state, city: $city, zipcode: $zipcode, phone: $phone, shippingCharge: $shippingCharge, tax: $tax, shipDate: $shipDate, orderStatus: $orderStatus, trackingNumber: $trackingNumber, status: $status, orderDate: $orderDate, productlist: $productlist}';
  }
}

class Productlist {
  Productlist({
    required this.ordId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.sku,
    required this.quantity,
  });

  final int ordId;
  final int productId;
  final String productName;
  final num price;
  final String sku;
  final int quantity;

  factory Productlist.fromJson(Map<String, dynamic> json) => Productlist(
        ordId: json["ordId"],
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"],
        sku: json["sku"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "ordId": ordId,
        "productId": productId,
        "productName": productName,
        "price": price,
        "sku": sku,
        "quantity": quantity,
      };

  @override
  String toString() {
    return 'Productlist{ordId: $ordId, productId: $productId, productName: $productName, price: $price, sku: $sku, quantity: $quantity}';
  }
}
