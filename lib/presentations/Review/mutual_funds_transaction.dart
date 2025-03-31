import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../blocs/MFTransaction/mf_transaction_bloc.dart';
import '../../core/api/api_consts.dart';
import '../../models/investment_transaction_model.dart';
import '../../widgets/appbarButton.dart';

class MutualFundsTransaction extends StatefulWidget {
  static const route = '/Mutual-Funds-Transaction';
  const MutualFundsTransaction({Key? key}) : super(key: key);

  @override
  State<MutualFundsTransaction> createState() => _MutualFundsTransactionState();
}

class _MutualFundsTransactionState extends State<MutualFundsTransaction> {
  double totalPurUnit = 0.0;
  double totalSalesUnit = 0.0;
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
            title: Text('Mutual Funds Transaction',
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
              BlocConsumer<MFTransactionBloc, MFTransactionState>(
                listener: (context, state) {
                  if (state is MFTransactionErrorState) {
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
                  if (state is MFTransactionLoadedState) {
                    return state.investmentTransaction.mFStocks.isNotEmpty
                        ?
                        // GestureDetector(
                        //     onTap: () {
                        //       BlocProvider.of<MFTransactionBloc>(context).add(
                        //           LoadMFTransactionEvent(
                        //               userId: ApiUser.userId,
                        //               // folioNo: "",
                        //               schemeName: "",
                        //               investmentTransaction:
                        //                   InvestmentTransaction(
                        //                       code: 0,
                        //                       message: '',
                        //                       mFStocks: [])));
                        //     },
                        //     child:
                        Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    state.investmentTransaction.mFStocks[0]
                                        .mFStockName
                                        .toString(),
                                    style: textStyle13Bold(colorRed)),
                                SizedBox(
                                  height: 0.8.h,
                                ),
                                Text(
                                    "Folio number : ${state.investmentTransaction.mFStocks[0].folioNo}",
                                    textAlign: TextAlign.center,
                                    style: textStyle10Bold(colorTextBCBC)),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                              ],
                            ),
                            // ),
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
                        child: Text('PurUnit',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('SaleUnit',
                            textAlign: TextAlign.center,
                            style: textStyle10Bold(colorBlack)),
                      ),
                      Container(
                        height: 5.1.h,
                        alignment: Alignment.center,
                        child: Text('Nav',
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
              BlocConsumer<MFTransactionBloc, MFTransactionState>(
                listener: (context, state) {
                  if (state is MFTransactionErrorState) {
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
                  if (state is MFTransactionInitial) {
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
                  if (state is MFTransactionLoadedState) {
                    for (var i = 0;
                        i < state.investmentTransaction.mFStocks.length;
                        i++) {
                      if (state.investmentTransaction.mFStocks[i]
                                  .transactionType ==
                              "SWO" ||
                          state.investmentTransaction.mFStocks[i]
                                  .transactionType ==
                              "Sale"
                          // "SWI"
                          ||
                          state.investmentTransaction.mFStocks[i]
                                  .transactionType ==
                              "RED") {
                        totalSalesUnit +=
                            state.investmentTransaction.mFStocks[i].unit;
                        totalSalesAmount += state
                            .investmentTransaction.mFStocks[i].investmentAmount;
                      } else {
                        totalPurUnit +=
                            state.investmentTransaction.mFStocks[i].unit;
                        totalPurchaseAmount += state
                            .investmentTransaction.mFStocks[i].investmentAmount;
                      }
                    }

                    print("totalPurUnit-->$totalPurUnit");
                    print("totalSalesUnit-->$totalSalesUnit");

                    return state.investmentTransaction.mFStocks.isEmpty
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
                                  state.investmentTransaction.mFStocks.length,
                                  (index) {
                                    var strToDateTime = DateTime.parse(
                                        DateTime.parse(state
                                                .investmentTransaction
                                                .mFStocks[index]
                                                .date)
                                            .toUtc()
                                            .toString());

                                    String updatedDt = DateFormat("dd-MM-yyyy")
                                        .format(strToDateTime.toLocal());

                                    bool isPurchaseUnit;

                                    if (state
                                                .investmentTransaction
                                                .mFStocks[index]
                                                .transactionType ==
                                            "SWO" ||
                                        state
                                                .investmentTransaction
                                                .mFStocks[index]
                                                .transactionType ==
                                            "Sale" ||

                                        //  "SWI"
                                        state
                                                .investmentTransaction
                                                .mFStocks[index]
                                                .transactionType ==
                                            "RED") {
                                      isPurchaseUnit = false;
                                    } else {
                                      isPurchaseUnit = true;
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
                                              isPurchaseUnit
                                                  ? state.investmentTransaction
                                                      .mFStocks[index].unit
                                                      .toStringAsFixed(1)
                                                  : '-',
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              isPurchaseUnit
                                                  ? '-'
                                                  : state.investmentTransaction
                                                      .mFStocks[index].unit
                                                      .toStringAsFixed(1),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              state.investmentTransaction
                                                  .mFStocks[index].nav
                                                  .toStringAsFixed(2),
                                              textAlign: TextAlign.left,
                                              style: textStyle9Bold(colorBlack)
                                                  .copyWith(height: 1.2)),
                                        ),
                                        Container(
                                          height: 43,
                                          alignment: Alignment.center,
                                          child: Text(
                                              CommonFunction().splitString(
                                                state
                                                    .investmentTransaction
                                                    .mFStocks[index]
                                                    .investmentAmount
                                                    .toStringAsFixed(2),
                                              ),
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
              BlocConsumer<MFTransactionBloc, MFTransactionState>(
                listener: (context, state) {
                  if (state is MFTransactionErrorState) {
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
                  if (state is MFTransactionLoadedState) {
                    return state.investmentTransaction.mFStocks.isNotEmpty
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
                                                  'Total Purchase Unit: ${CommonFunction().splitString(totalPurUnit.toStringAsFixed(2))}',
                                                  textAlign: TextAlign.center,
                                                  style: textStyle9Bold(
                                                      colorBlack)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0.6.h, bottom: 0.6.h),
                                              child: Text(
                                                  'Total Sales Unit: ${CommonFunction().splitString(totalSalesUnit.toStringAsFixed(2))}',
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
