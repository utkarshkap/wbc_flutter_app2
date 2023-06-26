import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/blocs/order/order_bloc.dart';

import '../../common_functions.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'cart_screen.dart';

class OrderHistoryData {
  final bool isOrdered;

  OrderHistoryData({this.isOrdered = false});
}

class OrderHistory extends StatefulWidget {
  final OrderHistoryData data;

  const OrderHistory({super.key, required this.data});

  static const route = '/Order-History';

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.data.isOrdered) {
        CommonFunction().successPopup(context, 'Thank You',
            'Your order has been successfully placed.', jsonOrderSuccess);
      }
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
                },
                icon: Image.asset(icBack, color: colorRed, width: 6.w)),
            titleSpacing: 0,
            title: Text('Order History', style: textStyle14Bold(colorBlack)),
            actions: [
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icNotification,
                  iconColor: colorText7070,
                  onClick: () {}),
              SizedBox(width: 2.w),
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icAddToCart,
                  iconColor: colorText7070,
                  onClick: () {
                    Navigator.of(context).pushNamed(CartScreen.route);
                  }),
              SizedBox(width: 2.w),
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icProfile,
                  iconColor: colorText7070,
                  onClick: () {}),
              SizedBox(width: 5.w)
            ],
          ),
          body: BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderHistoryFailed) {
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
              }
            },
            builder: (context, state) {
              if (state is OrderHistoryInitial) {
                return Center(
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                          color: colorRed, strokeWidth: 0.7.w)),
                );
              }
              if (state is OrderHistoryDataAdded) {
                return state.data.orders.isEmpty
                    ? Center(
                        child: Text('You haven\'t placed an any order yet.',
                            style: textStyle13Medium(colorBlack)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 2.h),
                            child: Text('ALL ORDERS',
                                style: textStyle10Bold(colorBlack)),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    state.data.orders.length,
                                    (index) => Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 1.5),
                                          decoration: BoxDecoration(
                                              color: colorWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: colorTextBCBC.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 6))
                                              ]),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5.h,
                                                horizontal: 4.w),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: state
                                                                  .data
                                                                  .orders[index]
                                                                  .status
                                                              ? color47D1
                                                              : colorTextFFC1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 0.7.h,
                                                                horizontal:
                                                                    2.5.w),
                                                        child: Text(
                                                            state.data.orders[index].status
                                                                ? 'Delivered'
                                                                : 'Pending',
                                                            style:
                                                                textStyle10Bold(
                                                                    colorWhite)),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(icClock,
                                                            width: 3.w),
                                                        SizedBox(width: 1.w),
                                                        Text(
                                                            state
                                                                .data
                                                                .orders[index]
                                                                .orderDate
                                                                .split(' ')[0],
                                                            style: textStyle9(
                                                                colorText7070))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 2.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(child: Text('Transaction.ID', style: textStyle11(colorText7070))),
                                                    Text('Delivered to', style: textStyle11(colorText7070)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(child:
                                                    Text(
                                                        '#${state.data.orders[index].trackingNumber}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: textStyle10Bold(colorBlack))),
                                                    Text(
                                                        state.data.orders[index].deliveryType,
                                                        style: textStyle10Bold(colorBlack)),                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                          )
                        ],
                      );
              }
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            },
          ),
        ));
  }
}
