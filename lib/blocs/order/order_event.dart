part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class CreateOrder extends OrderEvent {
  final int userId;
  final int orderId;
  final int amount;
  final String shipName;
  final String shipAddress;
  final String deliverytype;
  final String country;
  final String state;
  final String city;
  final String zipcode;
  final String phone;
  final String orderDate;
  final List<Item> items;

  CreateOrder({
    required this.userId,
    required this.orderId,
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
}

class GetOrderHistory extends OrderEvent {
  final String userId;

  GetOrderHistory({required this.userId});
}
