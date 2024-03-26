import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../core/handler.dart';
import '../../models/cart_model.dart';
import '../../resources/resource.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  DatabaseHelper helper = DatabaseHelper();
  CartBloc() : super(CartInitial()) {
    on<LoadAddCartEvent>((event, emit) async {
      emit(CartAddInitial());
      try {
        if (cartItemList.isNotEmpty) {
          bool isContain = false;
          int productIndex = 0;
          for (int i = 0; i < cartItemList.length; i++) {
            print(
                '--x=x--add--${cartItemList[i].id}-----${event.cartItem.id}----${cartItemList[i].id == event.cartItem.id}');
            if (cartItemList[i].id == event.cartItem.id) {
              print('-----is-contain-item');
              isContain = true;
              productIndex = i;
              break;
            } else {
              print('-----is-not-contain-item---=add=---${event.cartItem}');
              isContain = false;
            }
          }
          if (isContain) {
            await helper.updateCartData(CartItem(
                id: event.cartItem.id,
                categoryId: event.cartItem.categoryId,
                productId: event.cartItem.productId,
                img: event.cartItem.img,
                name: event.cartItem.name,
                price: event.cartItem.price,
                discount: event.cartItem.discount,
                quantity: event.cartItem.quantity + 1));
            print('-----single-add-index---$productIndex');
            print('-----is-Already-contain-item');
            cartItemList.removeAt(productIndex);
            cartItemList.insert(
                productIndex,
                CartItem(
                    id: event.cartItem.id,
                    categoryId: event.cartItem.categoryId,
                    productId: event.cartItem.productId,
                    img: event.cartItem.img,
                    name: event.cartItem.name,
                    price: event.cartItem.price,
                    discount: event.cartItem.discount,
                    quantity: event.cartItem.quantity + 1));
          } else {
            await helper.insertCartData(event.cartItem);
            cartItemList.add(event.cartItem);
          }
        } else {
          print('-----is-not-contain-item');
          await helper.insertCartData(event.cartItem);
          cartItemList.add(event.cartItem);
        }
        print('----cartList--add----$cartItemList');
        emit(CartAddLoadedState(cartItemList));
      } catch (e) {
        emit(CartAddErrorState(e.toString()));
      }
    });

    on<LoadRemoveCartEvent>((event, emit) async {
      emit(CartRemoveInitial());
      try {
        print('-=-------cart-remove---${event.id}');
        await helper.deleteCartData(event.id);
        cartItemList.remove(
            cartItemList.firstWhere((element) => element.id == event.id));
        print('----cartList--remove----$cartItemList');
        emit(CartRemoveLoadedState(cartItemList));
      } catch (e) {
        emit(CartRemoveErrorState(e.toString()));
      }
    });

    on<LoadSingleRemoveCartEvent>((event, emit) async {
      emit(CartSingleRemoveInitial());
      try {
        print('-=-------cart-single---${event.cartItem}');
        if (cartItemList.isNotEmpty) {
          bool isMoreThanOne = false;
          int productIndex = 0;
          for (int i = 0; i < cartItemList.length; i++) {
            print(
                '--x=x--remove--${cartItemList[i].id}-----${event.cartItem.id}----${cartItemList[i].id == event.cartItem.id}');
            if (cartItemList[i].id == event.cartItem.id) {
              print('-----is-contain-item');
              if (cartItemList[i].quantity > 1) {
                isMoreThanOne = true;
                productIndex = i;
              }
              break;
            } else {
              print('-----is-not-contain-item---=remove=---${event.cartItem}');
              isMoreThanOne = false;
            }
          }
          if (isMoreThanOne) {
            await helper.updateCartData(CartItem(
                id: event.cartItem.id,
                categoryId: event.cartItem.categoryId,
                productId: event.cartItem.productId,
                img: event.cartItem.img,
                name: event.cartItem.name,
                price: event.cartItem.price,
                discount: event.cartItem.discount,
                quantity: event.cartItem.quantity - 1));
            print('-----single-remove-index---$productIndex');
            cartItemList.removeAt(productIndex);
            cartItemList.insert(
                productIndex,
                CartItem(
                    id: event.cartItem.id,
                    categoryId: event.cartItem.categoryId,
                    productId: event.cartItem.productId,
                    img: event.cartItem.img,
                    name: event.cartItem.name,
                    price: event.cartItem.price,
                    discount: event.cartItem.discount,
                    quantity: event.cartItem.quantity - 1));
          } else {
            await helper.deleteCartData(event.cartItem.id);
            cartItemList.remove(cartItemList
                .firstWhere((element) => element.id == event.cartItem.id));
          }
        }
        print('----cartList--single--remove--$cartItemList');
        emit(CartSingleRemoveLoadedState(cartItemList));
      } catch (e) {
        emit(CartSingleRemoveErrorState(e.toString()));
      }
    });

    on<LoadCartListEvent>((event, emit) async {
      emit(CartListInitial());
      try {
        emit(CartListLoadedState(cartItemList));
        print('-=-------cartList---$cartItemList');
      } catch (e) {
        emit(CartListErrorState(e.toString()));
      }
    });

    on<LoadRemoveCartListEvent>((event, emit) async {
      emit(CartListInitial());
      try {
        await helper.cleanCart();
        cartItemList = [];
        emit(CartListLoadedState(cartItemList));
        print('-=-------cartList---$cartItemList');
      } catch (e) {
        emit(CartListErrorState(e.toString()));
      }
    });
  }
}
