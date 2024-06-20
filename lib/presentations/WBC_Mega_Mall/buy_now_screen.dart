import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/expanded_category_model.dart';
import 'package:wbc_connect_app/models/order_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/order_history.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/dashboardbloc/dashboard_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/signingbloc/signing_bloc.dart';
import '../../common_functions.dart';
import '../../core/handler.dart';
import '../../core/preferences.dart';
import '../../models/address_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'add_new_address.dart';

class BuyNowData {
  final ProductList product;
  final int quantity;

  BuyNowData({required this.quantity, required this.product});
}

class BuyNowScreen extends StatefulWidget {
  static const route = '/BuyNow-Screen';
  final BuyNowData data;

  const BuyNowScreen({super.key, required this.data});

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  DatabaseHelper helper = DatabaseHelper();
  int productQuantity = 1;
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
    setState(() {});
  }

  @override
  void initState() {
    getAddressData();
    getUserData();
    setState(() {
      productQuantity = widget.data.quantity;
      cartValue = ((widget.data.product.price.toInt() -
                  ((widget.data.product.price.toInt() *
                              widget.data.product.discount) ~/
                          100)
                      .toInt()) *
              productQuantity)
          .toDouble();
    });
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
              title: Text('Order', style: textStyle14Bold(colorBlack)),
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
            body:
                BlocConsumer<OrderBloc, OrderState>(listener: (context, state) {
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
                BlocProvider.of<CartBloc>(context)
                    .add(LoadRemoveCartListEvent());
              }
            }, builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: decoration(),
                      margin: EdgeInsets.only(top: 2.5.h),
                      child: Stack(
                        children: [
                          Container(
                            decoration:
                                BoxDecoration(color: colorWhite, boxShadow: [
                              BoxShadow(
                                  color: colorTextBCBC.withOpacity(0.3),
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
                                            widget
                                                .data.product.img.first.imgPath,
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
                                        child: Text(widget.data.product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text('1 Packet',
                                          style: textStyle8(colorText7070)),
                                      SizedBox(height: 2.h),
                                      Row(
                                        children: [
                                          Image.asset(icGoldCoin, width: 3.w),
                                          SizedBox(width: 1.w),
                                          Text(
                                              '${widget.data.product.price.toInt() - ((widget.data.product.price.toInt() * widget.data.product.discount) ~/ 100).toInt()}GP',
                                              style: textStyle9Bold(
                                                  colorTextFFC1)),
                                          SizedBox(width: 2.w),
                                          Image.asset(icGoldCoin, width: 3.w),
                                          SizedBox(width: 1.w),
                                          Text(
                                              '${widget.data.product.price.toInt()}GP',
                                              style: textStyle8(colorText7070)
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                          SizedBox(width: 2.w),
                                          Text(
                                              '${widget.data.product.discount}% off',
                                              style: textStyle7(colorGreen)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 1.5.h,
                              right: 5.w,
                              child: addItemButton(productQuantity, () {
                                if (productQuantity != 1) {
                                  setState(() {
                                    productQuantity--;
                                    cartValue = ((widget.data.product.price
                                                    .toInt() -
                                                ((widget.data.product.price
                                                                .toInt() *
                                                            widget.data.product
                                                                .discount) ~/
                                                        100)
                                                    .toInt())
                                            .toDouble() *
                                        productQuantity);
                                  });
                                }
                              }, () {
                                setState(() {
                                  productQuantity++;
                                  cartValue = ((widget.data.product.price
                                                  .toInt() -
                                              ((widget.data.product.price
                                                              .toInt() *
                                                          widget.data.product
                                                              .discount) ~/
                                                      100)
                                                  .toInt())
                                          .toDouble() *
                                      productQuantity);
                                });
                              }))
                        ],
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
                                    style: textStyle10(colorText7070)),
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
                                    style: textStyle10(colorText7070)),
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
                                        style: textStyle9(colorText7070)),
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
                                          onTap: () {
                                            for (int i = 0;
                                                i < shippingAddressList.length;
                                                i++) {
                                              setState(() {
                                                if (i == index) {
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
                                                      street:
                                                          shippingAddressList[i]
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
                                                          shippingAddressList[i]
                                                              .country,
                                                      addressType:
                                                          shippingAddressList[i]
                                                              .addressType,
                                                      isSelected:
                                                          shippingAddressList[i]
                                                              .isSelected);
                                                } else {
                                                  shippingAddressList[i]
                                                      .isSelected = 0;
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: shippingAddressList[
                                                                    index]
                                                                .isSelected ==
                                                            1
                                                        ? colorRed
                                                        : colorTextBCBC
                                                            .withOpacity(
                                                                0.62))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.2.h,
                                                horizontal: 3.w),
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
                                                    color: shippingAddressList[
                                                                    index]
                                                                .isSelected ==
                                                            1
                                                        ? colorRed
                                                        : colorText7070,
                                                    width: 6.w),
                                                SizedBox(
                                                  width: 65.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                    height:
                                                                        1.2)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(icCheckMark,
                                                    color: shippingAddressList[
                                                                    index]
                                                                .isSelected ==
                                                            1
                                                        ? colorRed
                                                        : colorTextBCBC
                                                            .withOpacity(0.62),
                                                    width: 5.w),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                            if (shippingAddressList.isNotEmpty)
                              addEditAddressButton(icSqrEdit, 'EDIT ADDRESS',
                                  () {
                                Navigator.of(context).pushReplacementNamed(
                                    AddNewAddress.route,
                                    arguments: AddNewAddressData(
                                        product: widget.data.product,
                                        quantity: productQuantity,
                                        navigateType: 'BuyNow',
                                        actionType: 'Edit',
                                        id: shippingAddress.id));
                              }),
                            if (shippingAddressList.isNotEmpty)
                              const SizedBox(height: 15),
                            addEditAddressButton(icAdd, 'ADD NEW ADDRESS', () {
                              Navigator.of(context).pushReplacementNamed(
                                  AddNewAddress.route,
                                  arguments: AddNewAddressData(
                                      product: widget.data.product,
                                      quantity: productQuantity,
                                      navigateType: 'BuyNow',
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
                                      child: Text('1200 Coins',
                                          style: textStyle11Bold(colorRed)),
                                    ),
                                    Text('Use Coin You',
                                        style: textStyle8(colorText7070)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0.5.h),
                                      child: Text('Have 1000+ coins',
                                          style: textStyle8(colorText7070)),
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
                                  items: [
                                    Item(
                                        productId: widget.data.product.id,
                                        productName: widget.data.product.name,
                                        price:
                                            widget.data.product.price.toInt() -
                                                ((widget.data.product.price
                                                                .toInt() *
                                                            widget.data.product
                                                                .discount) ~/
                                                        100)
                                                    .toInt(),
                                        sku:
                                            '${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${widget.data.product.id}',
                                        quantity: productQuantity)
                                  ]));
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
                                  padding: EdgeInsets.only(
                                      left: 3.5.w, right: 2.5.w),
                                  child: Image.asset(icGoldCoin, width: 5.w),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('1 item',
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
                                                  .copyWith(
                                                      letterSpacing: 1.17)),
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
            })));
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
