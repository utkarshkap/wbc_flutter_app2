import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../blocs/stockInvestmentTransaction/stock_investment_transaction_bloc.dart';

class StockInvestmentTransaction extends StatefulWidget {
  static const route = '/Stock-Investment-Transaction';
  const StockInvestmentTransaction({Key? key}) : super(key: key);

  @override
  State<StockInvestmentTransaction> createState() =>
      _StockInvestmentTransactionState();
}

class _StockInvestmentTransactionState
    extends State<StockInvestmentTransaction> {
  int totalPurQty = 0;
  int totalSalesQty = 0;
  double totalPurchaseAmount = 0.0;
  double totalSalesAmount = 0.0;

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
                  Navigator.pop(context);
                },
                icon: Image.asset(icBack, color: colorRed, width: 6.w)),
            titleSpacing: 0,
            title: Text('Stock Investments Transaction',
                style: textStyle14Bold(colorBlack)),
            actions: [
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icNotification,
                  iconColor: colorText7070,
                  onClick: () {
                    Navigator.of(context).pushNamed(NotificationScreen.route);
                  }),
              SizedBox(width: 5.w)
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.5.h,
              ),
              BlocConsumer<StockTransactionBloc, StockTransactionState>(
                listener: (context, state) {
                  if (state is StockTransactionErrorState) {
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
                  if (state is StockTransactionLoadedState) {
                    return state.stockTransaction.stockTransactions.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    state.stockTransaction.stockTransactions[0]
                                        .stockName
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: textStyle13Bold(colorRed)),
                                SizedBox(
                                  height: 0.8.h,
                                ),
                                Text(
                                    "Balance Qty : ${state.stockTransaction.stockTransactions[0].balanceQty}",
                                    textAlign: TextAlign.center,
                                    style: textStyle10Bold(colorTextBCBC)),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                              ],
                            ),
                          )
                        : Container();
                  }
                  return Container();
                },
              ),
              Table(
                border: TableBorder.all(color: colorBG),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1.4),
                  1: FlexColumnWidth(0.9),
                  2: FlexColumnWidth(0.9),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1.2),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: colorE5E5),
                    children: [
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('Date',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('PurQty',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('SaleQty',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('Rate',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                          height: 5.1.h,
                          alignment: Alignment.center,
                          child: Text('Amount',
                              textAlign: TextAlign.center,
                              style: textStyle11Bold(colorBlack))),
                    ],
                  )
                ],
              ),
              BlocConsumer<StockTransactionBloc, StockTransactionState>(
                listener: (context, state) {
                  if (state is StockTransactionErrorState) {
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
                  if (state is StockTransactionInitial) {
                    return Expanded(
                      child: Center(
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                                color: colorRed, strokeWidth: 0.7.w)),
                      ),
                    );
                  }
                  if (state is StockTransactionLoadedState) {
                    for (var i = 0;
                        i < state.stockTransaction.stockTransactions.length;
                        i++) {
                      if (state.stockTransaction.stockTransactions[i]
                              .purchaseQty >
                          0) {
                        totalPurQty += state
                            .stockTransaction.stockTransactions[i].purchaseQty;
                        totalPurchaseAmount += state.stockTransaction
                            .stockTransactions[i].purchaseAmount;
                      } else {
                        totalSalesQty +=
                            state.stockTransaction.stockTransactions[i].saleQty;
                        totalSalesAmount += state
                            .stockTransaction.stockTransactions[i].saleAmount;
                      }
                    }

                    print("totalSalesQty-->$totalSalesQty");
                    print("totalPurQty-->$totalPurQty");

                    return state.stockTransaction.stockTransactions.isEmpty
                        ? Expanded(
                            child: Center(
                                child: Text('No Data Available',
                                    style: textStyle13Medium(colorBlack))),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder.all(color: colorE5E5),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1.4),
                                  1: FlexColumnWidth(0.9),
                                  2: FlexColumnWidth(0.9),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1.2),
                                },
                                children: List<TableRow>.generate(
                                  state.stockTransaction.stockTransactions
                                      .length,
                                  (index) {
                                    var strToDateTime = DateTime.parse(
                                        DateTime.parse(state.stockTransaction
                                                .stockTransactions[index].date)
                                            .toUtc()
                                            .toString());
                                    String updatedDt = DateFormat("dd-MM-yyyy")
                                        .format(strToDateTime.toLocal());

                                    bool isPurchaseQty;

                                    if (state
                                            .stockTransaction
                                            .stockTransactions[index]
                                            .purchaseQty >
                                        0) {
                                      isPurchaseQty = true;
                                    } else {
                                      isPurchaseQty = false;
                                    }

                                    return TableRow(
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      children: [
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(updatedDt.toString(),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              isPurchaseQty
                                                  ? state
                                                      .stockTransaction
                                                      .stockTransactions[index]
                                                      .purchaseQty
                                                      .toString()
                                                  : '-',
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              isPurchaseQty
                                                  ? '-'
                                                  : CommonFunction()
                                                      .splitString(state
                                                          .stockTransaction
                                                          .stockTransactions[
                                                              index]
                                                          .saleQty
                                                          .toString()),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              CommonFunction().splitString(state
                                                  .stockTransaction
                                                  .stockTransactions[index]
                                                  .rate
                                                  .toStringAsFixed(2)),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              isPurchaseQty
                                                  ? CommonFunction()
                                                      .splitString(state
                                                          .stockTransaction
                                                          .stockTransactions[
                                                              index]
                                                          .purchaseAmount
                                                          .toStringAsFixed(2))
                                                  : CommonFunction()
                                                      .splitString(state
                                                          .stockTransaction
                                                          .stockTransactions[
                                                              index]
                                                          .saleAmount
                                                          .toStringAsFixed(2)),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                      ],
                                    );
                                  },
                                  growable: false,
                                ),
                              ),
                            ),
                          );
                  }
                  return Container();
                },
              ),
              BlocConsumer<StockTransactionBloc, StockTransactionState>(
                listener: (context, state) {
                  if (state is StockTransactionErrorState) {
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
                  if (state is StockTransactionLoadedState) {
                    return state.stockTransaction.stockTransactions.isNotEmpty
                        ? Table(
                            border: TableBorder.all(color: colorBG),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    const BoxDecoration(color: colorE5E5),
                                children: [
                                  Container(
                                      height: 12.h,
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            4.w, 3.w, 4.w, 3.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'Total Purchase: ${CommonFunction().splitString(totalPurchaseAmount.toStringAsFixed(2))}',
                                                textAlign: TextAlign.center,
                                                style:
                                                    textStyle9Bold(colorBlack)),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 0.6.h),
                                              child: Text(
                                                  'Total Sale: ${CommonFunction().splitString(totalSalesAmount.toStringAsFixed(2))}',
                                                  textAlign: TextAlign.center,
                                                  style: textStyle9Bold(
                                                      colorBlack)),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 0.6.h),
                                              child: Text(
                                                  'Total Purchase Qty: ${CommonFunction().splitString(totalPurQty.toString())}',
                                                  textAlign: TextAlign.center,
                                                  style: textStyle9Bold(
                                                      colorBlack)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0.6.h, bottom: 0.6.h),
                                              child: Text(
                                                  'Total Sales Qty: ${CommonFunction().splitString(totalSalesQty.toString())}',
                                                  textAlign: TextAlign.center,
                                                  style: textStyle9Bold(
                                                      colorBlack)),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              )
                            ],
                          )
                        : Container();
                  }
                  return Container();
                },
              ),
            ],
          )),
    );
  }
}
