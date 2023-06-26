part of 'order_bloc.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderDataAdding extends OrderState {}

class OrderDataAdded extends OrderState {
  final Response data;

  OrderDataAdded(this.data);
}

class OrderFailed extends OrderState {}

class OrderHistoryInitial extends OrderState {}

class OrderHistoryDataAdding extends OrderState {}

class OrderHistoryDataAdded extends OrderState {
  final OrderHistory data;

  OrderHistoryDataAdded(this.data);
}

class OrderHistoryFailed extends OrderState {}
