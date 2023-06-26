part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class LoadAddCartEvent extends CartEvent {
  final CartItem cartItem;
  LoadAddCartEvent({required this.cartItem});
}

class LoadRemoveCartEvent extends CartEvent {
  final int id;
  LoadRemoveCartEvent({required this.id});
}

class LoadSingleRemoveCartEvent extends CartEvent {
  final CartItem cartItem;
  LoadSingleRemoveCartEvent({required this.cartItem});
}

class LoadCartListEvent extends CartEvent {}

class LoadRemoveCartListEvent extends CartEvent {}
