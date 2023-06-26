part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartAddInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartAddLoadedState extends CartState {
  final List<CartItem> cartItem;

  const CartAddLoadedState(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartAddErrorState extends CartState {
  final String error;

  const CartAddErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CartRemoveInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartRemoveLoadedState extends CartState {
  final List<CartItem> cartItem;

  const CartRemoveLoadedState(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartRemoveErrorState extends CartState {
  final String error;

  const CartRemoveErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CartSingleRemoveInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartSingleRemoveLoadedState extends CartState {
  final List<CartItem> cartItem;

  const CartSingleRemoveLoadedState(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartSingleRemoveErrorState extends CartState {
  final String error;

  const CartSingleRemoveErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CartListInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartListLoadedState extends CartState {
  final List<CartItem> cartList;

  const CartListLoadedState(this.cartList);

  @override
  List<Object?> get props => [cartList];
}

class CartListErrorState extends CartState {
  final String error;

  const CartListErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
