import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/stock_investment_transaction.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/stockInvestmentTransaction/stock_investment_transaction_bloc.dart';
import '../../core/api/api_consts.dart';
import '../../core/preferences.dart';
import '../../models/dashboard.dart';
import '../../models/stock_investment_model.dart';
import '../../models/stock_investment_transaction_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'my_stocks.dart';

class StocksInvestment extends StatefulWidget {
  static const route = '/Stocks-Investment';
  const StocksInvestment({Key? key}) : super(key: key);

  @override
  State<StocksInvestment> createState() => _StocksInvestmentState();
}

class _StocksInvestmentState extends State<StocksInvestment> {
  String selectedType = 'KA Group';
  String selectedUser = '';
  List<Memberlist> members = [];
  String mobileNo = '';
  bool isCalculateInvestments = false;
  int totalQty = 0;

  List<String> types = [
    'KA Group',
    'Others',
  ];

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    members.add(Memberlist(
        id: int.parse(ApiUser.userId),
        name: ApiUser.userName,
        mobileno: mobileNo,
        relation: 'You',
        familyid: ApiUser.membersList.isNotEmpty
            ? ApiUser.membersList.first.familyid
            : 0,
        relativeUserId: 0));
    setState(() {});
    for (int i = 0; i < ApiUser.membersList.length; i++) {
      members.add(ApiUser.membersList[i]);
    }
  }

  @override
  void initState() {
    setState(() {
      selectedUser = ApiUser.userName;
    });
    getMobNo();
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
                title: Text('Stock Investments',
                    style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {
                        Navigator.of(context)
                            .pushNamed(NotificationScreen.route);
                }),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is StockInvestmentErrorState) {
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
            if (state is StockInvestmentInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            }
            if (state is StockInvestmentLoadedState) {
              if (!isCalculateInvestments) {
                for (int i = 0;
                    i < state.stockInvestmentPortfolio.stocks.length;
                    i++) {
                  totalQty +=
                      state.stockInvestmentPortfolio.stocks[i].balanceQty;
                }
              }
              isCalculateInvestments = true;

              return Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100.w,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                      colors: [
                                    colorRed,
                                    colorBoxGradiant3333
                                  ])),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                          child: Column(
                            children: [
                              Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            constraints: BoxConstraints(
                                                minWidth: 5.5.h,
                                                minHeight: 5.5.h),
                                            padding: EdgeInsets.zero,
                                            splashRadius: 5.5.w,
                                            splashColor: colorWhite,
                                            onPressed: () {
                                                    CommonFunction()
                                                        .selectFormDialog(
                                                  context,
                                                  'Select Member',
                                                      print(
                                                          '-----val---=---$val');
                                                print('-----val---=---$val');
                                                setState(() {
                                                  selectedUser = val.name
                                                      .substring(0, 1)
                                                      .toUpperCase();
                                                  isCalculateInvestments =
                                                      false;
                                                  totalQty = 0;
                                                });
                                                      Navigator.of(context)
                                                          .pop();
                                                      BlocProvider.of<FetchingDataBloc>(context).add(
                                                        LoadStockInvestmentEvent(
                                                            userId: val
                                                                        .relation ==
                                                              userId: val.relation ==
                                                                    .toString()
                                                                : val
                                                                    .relativeUserId
                                                                    .toString(),
                                                            investmentPortfolio:
                                                                StockInvestmentModel(
                                                              code: 0,
                                                              message: '',
                                                              portfolio: 0,
                                                              investment: 0,
                                                              gain: 0,
                                                                balanceAmount:
                                                                    0,
                                                              stocks: [],
                                                            )));
                                              });
                                            },
                                            icon: Container(
                                                height: 5.5.h,
                                                width: 5.5.h,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle),
                                                      alignment:
                                                          Alignment.center,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    selectedUser
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                          style:
                                                              textStyle20Bold(
                                                        colorRed)))),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                                  Text( '₹0',
                                                      // '₹${CommonFunction().splitString(state.stockInvestmentPortfolio.balanceAmount.toStringAsFixed(0))}',
                                                      style: textStyle22(
                                                              colorWhite)
                                                          .copyWith(
                                                              height: 1.2)),
                                            Text('STOCK PORTFOLIO',
                                                      style:
                                                          textStyle10(colorE5E5)
                                                              .copyWith(
                                                                  height: 1.2)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              if (members.length == 1)
                                Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: popupButton(
                                        false,
                                        selectedType,
                                        List.generate(
                                            types.length,
                                            (i) => menuItem(types[i], () {
                                                  setState(() {
                                                    selectedType = types[i];
                                                  });
                                                }))),
                                  ),
                                ),
                              if (members.length != 1)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 2.w, right: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 2.5.w),
                                        height: 4.h,
                                        width: 50.w,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: members.length,
                                            itemBuilder: (context, index) {
                                              return index == 0
                                                  ? Container()
                                                  : InkWell(
                                                      onTap: () {
                                                        isCalculateInvestments =
                                                            false;
                                                        totalQty = 0;
                                                        BlocProvider.of<FetchingDataBloc>(context).add(
                                                            LoadStockInvestmentEvent(
                                                                userId: members[
                                                                        index]
                                                                    .relativeUserId
                                                                    .toString(),
                                                                investmentPortfolio:
                                                                    StockInvestmentModel(
                                                                  balanceAmount:
                                                                      0,
                                                                  code: 0,
                                                                  message: '',
                                                                  portfolio: 0,
                                                                  investment: 0,
                                                                  gain: 0,
                                                                  stocks: [],
                                                                )));
                                                      },
                                                      child: Container(
                                                          height: 5.5.h,
                                                          width: 5.0.h,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color:
                                                                      colorF3F3,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              members[index]
                                                                  .name
                                                                  .substring(
                                                                      0, 1)
                                                                  .toUpperCase(),
                                                              style:
                                                                  textStyle13Bold(
                                                                      colorRed))),
                                                    );
                                            }),
                                      ),
                                      popupButton(
                                          false,
                                          selectedType,
                                          List.generate(
                                              types.length,
                                              (i) => menuItem(types[i], () {
                                                    setState(() {
                                                      selectedType = types[i];
                                                    });
                                                  }))),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(StocksReview.route);
                          },
                          child: Container(
                            height: 6.5.h,
                            width: 90.w,
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
                            child: Text('Connect Your Brokers',
                                style: textStyle12Bold(colorWhite)),
                          )),
                      SizedBox(height: 2.5.h)
                    ],
                  ),
                  Positioned(
                      top: 20.5.h,
                      child: Container(
                        height: state.stockInvestmentPortfolio.stocks.isNotEmpty
                            ? 52.5.h
                            : 0,
                        width: 90.w,
                        decoration: decoration(),
                        child: Column(children: [
                          Expanded(
                            flex: 6,
                            child: ListView.builder(
                                itemCount: state
                                    .stockInvestmentPortfolio.stocks.length,
                                itemBuilder: (context, index) {
                                  return state.stockInvestmentPortfolio
                                              .stocks[index].balanceQty !=
                                          0
                                      ? Column(
                                          children: [
                                            reviews(
                                                state.stockInvestmentPortfolio
                                                    .stocks[index].stockName
                                                    .toString(),
                                                state.stockInvestmentPortfolio
                                                    .stocks[index].balanceQty
                                                    .toString(),
                                                color47D1,
                                                state.stockInvestmentPortfolio
                                                    .stocks[index].balanceAmount
                                                    .toStringAsFixed(2),
                                                () => {
                                                      BlocProvider.of<
                                                                  StockTransactionBloc>(
                                                              context)
                                                          .add(LoadStockTransactionEvent(
                                                              userId: ApiUser
                                                                  .userId,
                                                              stockName: state
                                                                  .stockInvestmentPortfolio
                                                                  .stocks[index]
                                                                  .stockName
                                                                  .toString(),
                                                              stockTransaction:
                                                                  StockInvestmentTransactionModel(
                                                                      code: 0,
                                                                      message:
                                                                          '',
                                                                      stockTransactions: []))),
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              StockInvestmentTransaction
                                                                  .route)
                                                    }),
                                            if (index !=
                                                state.stockInvestmentPortfolio
                                                        .stocks.length -
                                                    1)
                                              Container(
                                                  height: 1,
                                                  color: colorTextBCBC
                                                      .withOpacity(0.36))
                                          ],
                                        )
                                      : const SizedBox();
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 1,
                                    color: colorTextBCBC.withOpacity(0.36)),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Qty Total',
                                              style: textStyle10Bold(
                                                  colorText7070)),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                            '${CommonFunction().splitString(totalQty.toString())}',
                                            style: textStyle11Bold(colorBlack),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Investment',
                                              style: textStyle10Bold(
                                                  colorText7070)),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text(
                                            '₹${CommonFunction().splitString(state.stockInvestmentPortfolio.balanceAmount.toStringAsFixed(0))}',
                                            style: textStyle11Bold(colorBlack),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                      ))
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        height: 4.5.h,
        padding: EdgeInsets.zero,
        onTap: onClick,
        child: Container(
            width: 25.w,
            color: colorTransparent,
            padding: const EdgeInsets.only(left: 10),
            child: Text(title, style: textStyle10(colorText3D3D))));
  }

  popupButton(bool isMemberField, String selectedItem,
      List<PopupMenuItem> menuItemList) {
    return Container(
      height: 4.h,
      width: 30.w,
      decoration: BoxDecoration(
          border: Border.all(color: colorWhite, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: PopupMenuButton(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedItem, style: textStyle10(colorWhite)),
            Image.asset(icDropdown, color: colorWhite, width: 5.w)
          ],
        ),
        offset: Offset(0, 4.h),
        elevation: 3,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: colorRed, width: 1),
            borderRadius: BorderRadius.circular(7)),
        itemBuilder: (context) => menuItemList,
      ),
    );
  }

  showValue(String icon, Color bgColor, String title, String val) {
    return Container(
      width: 43.w,
      decoration: BoxDecoration(
          color: colorWhite, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: Row(
        children: [
          Container(
            height: 4.3.h,
            width: 4.3.h,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(icon, color: colorWhite, height: 2.3.h),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyle9Bold(colorText7070)),
                SizedBox(height: 0.5.h),
                Text(
                  '₹ $val',
                  style: textStyle11Bold(colorBlack),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  reviews(String title, String value, Color textColor, String percentageVal,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 3.w),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          color: colorWhite,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 60.w,
                      child: Text(title, style: textStyle10Bold(colorBlack))),
                  SizedBox(height: 0.7.h),
                  Row(
                    children: [
                      Text('Qty: ', style: textStyle9Bold(colorText7070)),
                      Text(value, style: textStyle9Bold(colorText7070)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(CommonFunction().splitString(percentageVal),
                      style: textStyle9Bold(colorText7070)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
