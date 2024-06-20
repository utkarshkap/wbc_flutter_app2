import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/order_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/order_history.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/dashboardbloc/dashboard_bloc.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/signingbloc/signing_bloc.dart';
import '../../common_functions.dart';
import '../../core/handler.dart';
import '../../core/preferences.dart';
import '../../models/address_model.dart';
import '../../models/cart_model.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/product_category_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../profile_screen.dart';
import 'add_new_address.dart';

class CartScreen extends StatefulWidget {
  static const route = '/Cart-Screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DatabaseHelper helper = DatabaseHelper();
  double cartValue = 0;
  List<ShippingAddress> shippingAddressList = [];
  ShippingAddress shippingAddress = ShippingAddress(
      id: 0,
      name: '',
      num: '',
      pinCode: '',
      street: '',
      subLocality: '',
      city: '',
      state: '',
      country: '',
      addressType: '',
      isSelected: 0);
  String addressValidation = '';
  bool isOrdered = false;

  void getAddressData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ShippingAddress>?> addressList = helper.getAddressList();
      addressList.then((data) {
        if (data!.isNotEmpty) {
          setState(() {
            shippingAddressList = data;
          });
          for (int i = 0; i < shippingAddressList.length; i++) {
            print('--xxx--$i--==---${shippingAddressList[i]}');
            if (shippingAddressList[i].isSelected == 1) {
              setState(() {
                shippingAddress = ShippingAddress(
                    id: shippingAddressList[i].id,
                    name: shippingAddressList[i].name,
                    num: shippingAddressList[i].num,
                    pinCode: shippingAddressList[i].pinCode,
                    street: shippingAddressList[i].street,
                    subLocality: shippingAddressList[i].subLocality,
                    city: shippingAddressList[i].city,
                    state: shippingAddressList[i].state,
                    country: shippingAddressList[i].country,
                    addressType: shippingAddressList[i].addressType,
                    isSelected: shippingAddressList[i].isSelected);
              });
            }
          }
        }
        print('----shippingAddressList----$shippingAddressList');
      });
    });
  }

  getUserData() async {
    BlocProvider.of<SigningBloc>(context)
        .add(GetUserData(mobileNo: await Preference.getMobNo()));
  }

  @override
  void initState() {
    getAddressData();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBG,
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: colorWhite,
          elevation: 6,
          shadowColor: colorTextBCBC.withOpacity(0.3),
          leadingWidth: 15.w,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<CartBloc>(context).add(LoadCartListEvent());
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('Cart & Checkout', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {
                  Navigator.of(context).pushNamed(NotificationScreen.route);
                }),
            SizedBox(width: 2.w),
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icProfile,
                iconColor: colorText7070,
                onClick: () {
                  Navigator.of(context).pushNamed(ProfileScreen.route);
                }),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartListLoadedState) {
              return bodyView(state.cartList);
            }
            return bodyView(cartItemList);
          },
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(color: colorWhite, boxShadow: [
      BoxShadow(
          color: colorTextBCBC.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 6))
    ]);
  }

  BoxDecoration radiusDecoration(Color bgColor) {
    return BoxDecoration(
        color: colorRed,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 6,
              color: colorRed.withOpacity(0.35))
        ]);
  }

  bodyView(List<CartItem> cartList) {
    cartValue = 0;
    if (cartList.isNotEmpty) {
      for (int i = 0; i < cartList.length; i++) {
        cartValue = cartValue +
            ((cartList[i].price.toInt() -
                    ((cartList[i].price.toInt() * cartList[i].discount) ~/ 100)
                        .toInt()) *
                cartList[i].quantity);
      }
    }
    return cartList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(jsonEmptyCart,
                    height: 25.h,
                    fit: BoxFit.fill,
                    alignment: Alignment.bottomCenter),
                Text('Your Shopping Cart is empty.',
                    style: textStyle13Medium(colorBlack)),
                SizedBox(height: 2.h),
                InkWell(
                    onTap: () {
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadProductCategoryEvent(
                              productCategory: ProductCategory(
                                  code: 0, message: '', categories: [])));
                      BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                          popular: Popular(code: 0, message: '', products: []),
                          newArrival:
                              NewArrival(code: 0, message: '', products: []),
                          trending:
                              Trending(code: 0, message: '', products: [])));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          WbcMegaMall.route, (route) => false);
                    },
                    child: Container(
                      height: 6.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                          color: colorRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                                color: colorRed.withOpacity(0.35))
                          ]),
                      alignment: Alignment.center,
                      child:
                          Text('Shop Now', style: textStyle13Bold(colorWhite)),
                    )),
                SizedBox(height: 7.h),
              ],
            ),
          )
        : BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
            if (state is OrderFailed) {
              isOrdered = false;
              AwesomeDialog(
                btnCancelColor: colorRed,
                padding: EdgeInsets.zero,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                headerAnimationLoop: false,
                title: 'Something Went Wrong',
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            } else if (state is OrderDataAdded) {
              BlocProvider.of<DashboardBloc>(context)
                  .add(GetDashboardData(userId: ApiUser.userId));
              Navigator.of(context).pushNamed(OrderHistory.route,
                  arguments: OrderHistoryData(isOrdered: true));
              BlocProvider.of<CartBloc>(context).add(LoadRemoveCartListEvent());
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SHOPPING CART (${cartList.length} ITEMS)',
                            style: textStyle10Bold(colorBlack)),
                        GestureDetector(
                            onTap: () {
                              print('------clear--all--product');
                              CommonFunction().confirmationDialog(context,
                                  'Are you sure you want to clear all items from cart?',
                                  () {
                                Navigator.of(context).pop();
                                BlocProvider.of<CartBloc>(context)
                                    .add(LoadRemoveCartListEvent());
                              });
                            },
                            child: Text('CLEAR CART',
                                style: textStyle10Bold(Colors.red)))
                      ],
                    ),
                  ),
                  Container(
                    decoration: decoration(),
                    child: Column(
                      children: List.generate(
                          cartList.length,
                          (index) => Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            if (index != cartList.length - 1)
                                              BoxShadow(
                                                  color: colorTextBCBC
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 6))
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 2.h),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 7.h,
                                              width: 10.w,
                                              child: Image.network(
                                                  imgBaseUrl +
                                                      cartList[index].img,
                                                  fit: BoxFit.fill),
                                            ),
                                            SizedBox(width: 3.5.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 0.5.h),
                                                SizedBox(
                                                  width: 55.w,
                                                  child: Text(
                                                      cartList[index].name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textStyle10Bold(
                                                          colorBlack)),
                                                ),
                                                SizedBox(height: 0.5.h),
                                                Text('1 Packet',
                                                    style: textStyle8(
                                                        colorText4D4D)),
                                                SizedBox(height: 2.h),
                                                Row(
                                                  children: [
                                                    Image.asset(icGoldCoin,
                                                        width: 3.w),
                                                    SizedBox(width: 1.w),
                                                    Text(
                                                        '${cartList[index].price.toInt() - ((cartList[index].price.toInt() * cartList[index].discount) ~/ 100).toInt()}GP',
                                                        style: textStyle9Bold(
                                                            colorTextFFC1)),
                                                    SizedBox(width: 2.w),
                                                    Image.asset(icGoldCoin,
                                                        width: 3.w),
                                                    SizedBox(width: 1.w),
                                                    Text(
                                                        '${cartList[index].price.toInt()}GP',
                                                        style: textStyle8(
                                                                colorText7070)
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough)),
                                                    SizedBox(width: 2.w),
                                                    Text(
                                                        '${cartList[index].discount}% off',
                                                        style: textStyle7(
                                                            colorGreen)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 1.w,
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          splashRadius: 3.w,
                                          splashColor: colorWhite,
                                          onPressed: () {
                                            CommonFunction().confirmationDialog(
                                                context,
                                                'Are you sure you want to remove this item from cart?',
                                                () {
                                              Navigator.of(context).pop();
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(LoadRemoveCartEvent(
                                                      id: cartList[index].id));
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(LoadCartListEvent());
                                            });
                                          },
                                          icon: Image.asset(icDelete,
                                              width: 3.w)),
                                    ),
                                    Positioned(
                                        bottom: 1.5.h,
                                        right: 5.w,
                                        child: addItemButton(
                                            cartList[index].quantity, () {
                                          print(
                                              '-----cartItem--remove--${CartItem(
                                            id: cartList[index].id,
                                            categoryId:
                                                cartList[index].categoryId,
                                            productId:
                                                cartList[index].productId,
                                            img: cartList[index].img,
                                            name: cartList[index].name,
                                            price: cartList[index].price,
                                            discount: cartList[index].discount,
                                            quantity: cartList[index].quantity,
                                          )}');
                                          if (cartList[index].quantity == 1) {
                                            CommonFunction().confirmationDialog(
                                                context,
                                                'Are you sure you want to remove this item from cart?',
                                                () {
                                              Navigator.of(context).pop();
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(
                                                      LoadSingleRemoveCartEvent(
                                                          cartItem: CartItem(
                                                id: cartList[index].id,
                                                categoryId:
                                                    cartList[index].categoryId,
                                                productId:
                                                    cartList[index].productId,
                                                img: cartList[index].img,
                                                name: cartList[index].name,
                                                price: cartList[index].price,
                                                discount:
                                                    cartList[index].discount,
                                                quantity:
                                                    cartList[index].quantity,
                                              )));
                                              BlocProvider.of<CartBloc>(context)
                                                  .add(LoadCartListEvent());
                                            });
                                          } else {
                                            BlocProvider.of<CartBloc>(context)
                                                .add(LoadSingleRemoveCartEvent(
                                                    cartItem: CartItem(
                                              id: cartList[index].id,
                                              categoryId:
                                                  cartList[index].categoryId,
                                              productId:
                                                  cartList[index].productId,
                                              img: cartList[index].img,
                                              name: cartList[index].name,
                                              price: cartList[index].price,
                                              discount:
                                                  cartList[index].discount,
                                              quantity:
                                                  cartList[index].quantity,
                                            )));
                                            BlocProvider.of<CartBloc>(context)
                                                .add(LoadCartListEvent());
                                          }
                                        }, () {
                                          print('-----cartItem--add--${CartItem(
                                            id: cartList[index].id,
                                            categoryId:
                                                cartList[index].categoryId,
                                            productId:
                                                cartList[index].productId,
                                            img: cartList[index].img,
                                            name: cartList[index].name,
                                            price: cartList[index].price,
                                            discount: cartList[index].discount,
                                            quantity: cartList[index].quantity,
                                          )}');
                                          BlocProvider.of<CartBloc>(context)
                                              .add(LoadAddCartEvent(
                                                  cartItem: CartItem(
                                            id: cartList[index].id,
                                            categoryId:
                                                cartList[index].categoryId,
                                            productId:
                                                cartList[index].productId,
                                            img: cartList[index].img,
                                            name: cartList[index].name,
                                            price: cartList[index].price,
                                            discount: cartList[index].discount,
                                            quantity: cartList[index].quantity,
                                          )));
                                          BlocProvider.of<CartBloc>(context)
                                              .add(LoadCartListEvent());
                                        }))
                                  ],
                                ),
                              )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 2.h),
                    child: Text('PRICE SUMMARY',
                        style: textStyle10Bold(colorBlack)),
                  ),
                  Container(
                    decoration: decoration(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 2.3.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Product Charges',
                                  style: textStyle10(colorText4D4D)),
                              Row(
                                children: [
                                  Image.asset(icGoldCoin, width: 3.w),
                                  SizedBox(width: 1.w),
                                  Text('$cartValue',
                                      style: textStyle10(colorBlack)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping Charges',
                                  style: textStyle10(colorText4D4D)),
                              Text('FREE', style: textStyle9(colorRed)),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 1.w),
                            child: Container(
                                height: 1.5,
                                color: colorTextBCBC.withOpacity(0.36)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order Total',
                                      style: textStyle11Bold(colorBlack)),
                                  SizedBox(height: 0.7.h),
                                  Text('Inclusive of all taxes',
                                      style: textStyle9(colorText4D4D)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(icGoldCoin, width: 4.w),
                                  SizedBox(width: 1.w),
                                  Text('$cartValue',
                                      style: textStyle14Bold(colorRed)
                                          .copyWith(letterSpacing: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 2.h),
                    child: Text('SELECT DELIVERY ADDRESS',
                        style: textStyle10Bold(colorBlack)),
                  ),
                  Container(
                    decoration: BoxDecoration(color: colorWhite, boxShadow: [
                      BoxShadow(
                          color: colorTextBCBC.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 6))
                    ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 2.3.h),
                      child: Column(
                        children: [
                          Column(
                            children: List.generate(
                                shippingAddressList.length,
                                (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: GestureDetector(
                                        onTap: () async {
                                          for (int i = 0;
                                              i < shippingAddressList.length;
                                              i++) {
                                            if (i == index) {
                                              await helper.updateAddressData(ShippingAddress(
                                                  id: shippingAddressList[i].id,
                                                  name: shippingAddressList[i]
                                                      .name,
                                                  num: shippingAddressList[i]
                                                      .num,
                                                  pinCode:
                                                      shippingAddressList[i]
                                                          .pinCode,
                                                  street: shippingAddressList[i]
                                                      .street,
                                                  subLocality:
                                                      shippingAddressList[i]
                                                          .subLocality,
                                                  city: shippingAddressList[i]
                                                      .city,
                                                  state: shippingAddressList[i]
                                                      .state,
                                                  country:
                                                      shippingAddressList[i]
                                                          .country,
                                                  addressType:
                                                      shippingAddressList[i]
                                                          .addressType,
                                                  isSelected: 1));
                                              setState(() {
                                                shippingAddressList[i]
                                                    .isSelected = 1;
                                                shippingAddress = ShippingAddress(
                                                    id: shippingAddressList[i]
                                                        .id,
                                                    name: shippingAddressList[i]
                                                        .name,
                                                    num: shippingAddressList[i]
                                                        .num,
                                                    pinCode:
                                                        shippingAddressList[i]
                                                            .pinCode,
                                                    street: shippingAddressList[
                                                            i]
                                                        .street,
                                                    subLocality:
                                                        shippingAddressList[i]
                                                            .subLocality,
                                                    city: shippingAddressList[
                                                            i]
                                                        .city,
                                                    state: shippingAddressList[
                                                            i]
                                                        .state,
                                                    country:
                                                        shippingAddressList[
                                                                i]
                                                            .country,
                                                    addressType:
                                                        shippingAddressList[i]
                                                            .addressType,
                                                    isSelected: 1);
                                              });
                                            } else {
                                              await helper.updateAddressData(ShippingAddress(
                                                  id: shippingAddressList[i].id,
                                                  name: shippingAddressList[i]
                                                      .name,
                                                  num: shippingAddressList[i]
                                                      .num,
                                                  pinCode:
                                                      shippingAddressList[i]
                                                          .pinCode,
                                                  street: shippingAddressList[i]
                                                      .street,
                                                  subLocality:
                                                      shippingAddressList[i]
                                                          .subLocality,
                                                  city: shippingAddressList[i]
                                                      .city,
                                                  state: shippingAddressList[i]
                                                      .state,
                                                  country:
                                                      shippingAddressList[i]
                                                          .country,
                                                  addressType:
                                                      shippingAddressList[i]
                                                          .addressType,
                                                  isSelected: 0));
                                              setState(() {
                                                shippingAddressList[i]
                                                    .isSelected = 0;
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color:
                                                      shippingAddressList[index]
                                                                  .isSelected ==
                                                              1
                                                          ? colorRed
                                                          : colorTextBCBC
                                                              .withOpacity(
                                                                  0.62))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.2.h, horizontal: 3.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(
                                                  shippingAddressList[index]
                                                              .addressType ==
                                                          'Home'
                                                      ? icHome
                                                      : icOffice,
                                                  color:
                                                      shippingAddressList[index]
                                                                  .isSelected ==
                                                              1
                                                          ? colorRed
                                                          : colorText7070,
                                                  width: 6.w),
                                              SizedBox(
                                                width: 65.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        shippingAddressList[
                                                                index]
                                                            .addressType,
                                                        style: textStyle10Bold(
                                                            shippingAddressList[
                                                                            index]
                                                                        .isSelected ==
                                                                    1
                                                                ? colorRed
                                                                : colorText7070)),
                                                    const SizedBox(height: 4),
                                                    SizedBox(
                                                      child: Text(
                                                          '${shippingAddressList[index].street}, ${shippingAddressList[index].subLocality}, ${shippingAddressList[index].city}, ${shippingAddressList[index].state}, ${shippingAddressList[index].country}',
                                                          style: textStyle9(
                                                                  colorText7070)
                                                              .copyWith(
                                                                  height: 1.2)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Image.asset(icCheckMark,
                                                  color:
                                                      shippingAddressList[index]
                                                                  .isSelected ==
                                                              1
                                                          ? colorRed
                                                          : colorTextBCBC
                                                              .withOpacity(
                                                                  0.62),
                                                  width: 5.w),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                          if (shippingAddressList.isNotEmpty)
                            addEditAddressButton(icSqrEdit, 'EDIT ADDRESS', () {
                              Navigator.of(context).pushReplacementNamed(
                                  AddNewAddress.route,
                                  arguments: AddNewAddressData(
                                      navigateType: 'Cart',
                                      actionType: 'Edit',
                                      id: shippingAddress.id));
                            }),
                          if (shippingAddressList.isNotEmpty)
                            const SizedBox(height: 15),
                          addEditAddressButton(icAdd, 'ADD NEW ADDRESS', () {
                            Navigator.of(context).pushReplacementNamed(
                                AddNewAddress.route,
                                arguments: AddNewAddressData(
                                    navigateType: 'Cart',
                                    actionType: 'Add',
                                    id: shippingAddressList.isEmpty
                                        ? 1
                                        : shippingAddressList.last.id + 1));
                          }),
                        ],
                      ),
                    ),
                  ),
                  if (addressValidation.isNotEmpty)
                    SizedBox(
                      height: 0.5.h,
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: addressValidation == 'Add Address'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    color: colorRed, size: 13),
                                const SizedBox(width: 4),
                                Container(
                                  height: 2.h,
                                  alignment: Alignment.center,
                                  child: Text('Please Add Address',
                                      style: textStyle9(colorErrorRed)),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 2.h),
                    child: Text('SELECT PAYMENT METHOD',
                        style: textStyle10Bold(colorBlack)),
                  ),
                  Container(
                    width: 100.w,
                    decoration: decoration(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 2.3.h),
                      child: Row(
                        children: [
                          Container(
                            width: 45.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: cartValue > 1000
                                        ? colorRed
                                        : colorTextBCBC.withOpacity(0.62))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.5.w, vertical: 1.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(icGoldCoin, width: 6.w),
                                      Image.asset(icCheckMark, width: 4.w),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.5.h),
                                    child: Text(
                                        '${ApiUser.goldReferralPoint} Coins',
                                        style: textStyle11Bold(colorRed)),
                                  ),
                                  Text('Use Coin You',
                                      style: textStyle8(colorText4D4D)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.5.h),
                                    child: Text('Have 1000+ coins',
                                        style: textStyle8(colorText4D4D)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container())
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 2.5.h),
                    child: InkWell(
                      onTap: () {
                        if (shippingAddress.name.isEmpty ||
                            shippingAddress.num.isEmpty ||
                            shippingAddress.street.isEmpty ||
                            shippingAddress.subLocality.isEmpty ||
                            shippingAddress.pinCode.isEmpty ||
                            shippingAddress.country.isEmpty ||
                            shippingAddress.state.isEmpty ||
                            shippingAddress.city.isEmpty) {
                          setState(() {
                            addressValidation = 'Add Address';
                          });
                        } else {
                          setState(() {
                            addressValidation = '';
                          });
                          if (cartValue.toInt() > ApiUser.goldReferralPoint) {
                            CommonFunction().errorDialog(context,
                                'You don\'t have sufficient gold point for buying this cart products.');
                          } else {
                            setState(() {
                              isOrdered = true;
                            });
                            print(
                                '-----state---(${shippingAddress.state})----(${shippingAddress.state.trim()})');
                            BlocProvider.of<OrderBloc>(context).add(CreateOrder(
                                userId: int.parse(ApiUser.userId),
                                orderId: 1,
                                amount: cartValue.toInt(),
                                shipName: shippingAddress.name.trim(),
                                shipAddress:
                                    '${shippingAddress.street}, ${shippingAddress.subLocality}'
                                        .trim(),
                                deliverytype: shippingAddress.addressType,
                                country: shippingAddress.country.trim(),
                                state: shippingAddress.state.trim(),
                                city: shippingAddress.city.trim(),
                                zipcode: shippingAddress.pinCode.trim(),
                                phone: shippingAddress.num.trim(),
                                orderDate: DateTime.now().toString(),
                                items: List.generate(
                                    cartList.length,
                                    (index) => Item(
                                        productId: cartList[index].productId,
                                        productName: cartList[index].name,
                                        price: cartList[index].price.toInt() -
                                            ((cartList[index].price.toInt() *
                                                        cartList[index]
                                                            .discount) ~/
                                                    100)
                                                .toInt(),
                                        sku:
                                            '${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${cartList[index].id}',
                                        quantity: cartList[index].quantity))));
                          }
                        }
                      },
                      child: Container(
                        width: 90.w,
                        decoration: radiusDecoration(colorRed),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.5.w),
                                child: Image.asset(icBag,
                                    color: colorWhite, width: 6.w),
                              ),
                              Container(
                                  height: 4.h,
                                  width: 1,
                                  color: colorWhite.withOpacity(0.2)),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 3.5.w, right: 2.5.w),
                                child: Image.asset(icGoldCoin, width: 5.w),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${cartList.length} items',
                                      style: textStyle9(colorTextFFC1)),
                                  SizedBox(height: 0.5.h),
                                  Text('$cartValue',
                                      style: textStyle14Bold(colorWhite)
                                          .copyWith(letterSpacing: 1.5)),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: Row(
                                  children: [
                                    isOrdered
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.w),
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: colorWhite,
                                                        strokeWidth: 0.6.w)),
                                          )
                                        : Text('PLACE ORDER',
                                            style: textStyle11Bold(colorWhite)
                                                .copyWith(letterSpacing: 1.17)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.2.w),
                                      child: Image.asset(icNext,
                                          color: colorWhite, width: 1.2.w),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
  }

  addEditAddressButton(String icon, String title, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 6.5.h,
        width: 90.w,
        decoration: radiusDecoration(colorRed),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon,
                color: colorWhite, width: icon == icSqrEdit ? 4.w : 3.w),
            SizedBox(width: 2.w),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    textStyle13Bold(colorWhite).copyWith(letterSpacing: 1.17)),
          ],
        ),
      ),
    );
  }

  addItemButton(int count, Function() onMinus, Function() onAdd) {
    return Container(
        height: 4.h,
        width: 20.w,
        decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: colorRed, width: 1),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                  color: colorRed.withOpacity(0.35))
            ]),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 2.5.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 2.5.w,
                  onPressed: onMinus,
                  icon: Image.asset(icMinus, color: colorRed, width: 2.5.w)),
            ),
            Text('$count', style: textStyle9Bold(colorBlack)),
            SizedBox(
              width: 2.5.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 2.5.w,
                  onPressed: onAdd,
                  icon: Image.asset(icAdd, color: colorRed, width: 2.5.w)),
            ),
          ],
        ));
  }
}
