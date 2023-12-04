import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../common_functions.dart';
import '../../core/api/api_consts.dart';
import '../../models/mGain_investment_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'M_Gain_Investment.dart';

class MGainLedgerScreen extends StatefulWidget {
  static const route = '/mGain-Ledger';

  const MGainLedgerScreen({Key? key}) : super(key: key);

  @override
  State<MGainLedgerScreen> createState() => _MGainLedgerScreenState();
}

class _MGainLedgerScreenState extends State<MGainLedgerScreen> {
  int totalDebit = 0;
  int totalCredit = 0;

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
                    BlocProvider.of<FetchingDataBloc>(context).add(
                        LoadMGainInvestmentEvent(
                            userId: ApiUser.userId,
                            mGainInvestment: MGainInvestment(
                                code: 0,
                                message: '',
                                mGainTotalInvestment: 0,
                                totalIntrestReceived: 0,
                                mGains: [])));
                    Navigator.of(context)
                        .pushReplacementNamed(MGainInvestmentScreen.route);
                  },
                  icon: Image.asset(icBack, color: colorRed, width: 6.w)),
              titleSpacing: 0,
              title: Text('M Gain Ledger', style: textStyle14Bold(colorBlack)),
              actions: [
                AppBarButton(
                    splashColor: colorWhite,
                    bgColor: colorF3F3,
                    icon: icMGainFilter,
                    iconColor: colorText7070,
                    onClick: () {}),
                SizedBox(width: 2.w),
                AppBarButton(
                    splashColor: colorWhite,
                    bgColor: colorF3F3,
                    icon: icNotification,
                    iconColor: colorText7070,
                    onClick: () {}),
                SizedBox(width: 5.w)
              ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                BlocProvider.of<FetchingDataBloc>(context).add(
                    LoadMGainInvestmentEvent(
                        userId: ApiUser.userId,
                        mGainInvestment: MGainInvestment(
                            code: 0,
                            message: '',
                            mGainTotalInvestment: 0,
                            totalIntrestReceived: 0,
                            mGains: [])));
                Navigator.of(context)
                    .pushReplacementNamed(MGainInvestmentScreen.route);
                return false;
              },
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(color: colorBG),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE5E5),
                        children: [
                          Container(
                            height: 6.h,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text('Particulars',
                                  textAlign: TextAlign.center,
                                  style: textStyle10Bold(colorBlack)),
                            ),
                          ),
                          Container(
                              height: 6.h,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 3.w),
                                child: Text('Debit',
                                    textAlign: TextAlign.center,
                                    style: textStyle10Bold(colorBlack)),
                              )),
                          Container(
                              height: 6.h,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 3.w),
                                child: Text('Credit',
                                    textAlign: TextAlign.center,
                                    style: textStyle10Bold(colorBlack)),
                              )),
                        ],
                      )
                    ],
                  ),
                  BlocConsumer<FetchingDataBloc, FetchingDataState>(
                    listener: (context, state) {
                      if (state is MGainLedgerLoadedState) {
                        for (int i = 0;
                            i < state.mGainLedger.ledgerEntries.length;
                            i++) {
                          totalDebit = totalDebit +
                              state.mGainLedger.ledgerEntries[i].debit.toInt();
                          totalCredit = totalCredit +
                              state.mGainLedger.ledgerEntries[i].credit.toInt();
                          setState(() {});
                        }
                      }
                      if (state is MGainLedgerErrorState) {
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
                      if (state is MGainLedgerInitial) {
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
                      if (state is MGainLedgerLoadedState) {
                        for (int i = 0;
                            i < state.mGainLedger.ledgerEntries.length;
                            i++) {
                          totalDebit = totalDebit +
                              state.mGainLedger.ledgerEntries[i].debit.toInt();
                          totalCredit = totalCredit +
                              state.mGainLedger.ledgerEntries[i].credit.toInt();
                        }
                        return state.mGainLedger.ledgerEntries.isEmpty
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
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                    },
                                    children: List<TableRow>.generate(
                                      state.mGainLedger.ledgerEntries.length,
                                      (index) {
                                        return TableRow(
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          children: [
                                            Container(
                                              height: 60,
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.w, right: 1.5.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        state
                                                            .mGainLedger
                                                            .ledgerEntries[
                                                                index]
                                                            .name,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: textStyle9Bold(
                                                                colorBlack)
                                                            .copyWith(
                                                                height: 1.2)),
                                                    SizedBox(height: 0.5.h),
                                                    Row(
                                                      children: [
                                                        Image.asset(icCalender,
                                                            color:
                                                                colorText3D3D,
                                                            width: 3.w),
                                                        SizedBox(width: 1.w),
                                                        Text(
                                                            DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(state
                                                                    .mGainLedger
                                                                    .ledgerEntries[
                                                                        index]
                                                                    .investmentDate),
                                                            style: textStyle9(
                                                                colorText7070)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                height: 60,
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3.w),
                                                  child: Text(
                                                      '${CommonFunction().splitString(state.mGainLedger.ledgerEntries[index].debit.toInt().toString())}/-',
                                                      style: textStyle9Bold(
                                                              colorBlack)
                                                          .copyWith(
                                                              height: 1.2)),
                                                )),
                                            Container(
                                                height: 60,
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3.w),
                                                  child: Text(
                                                      '${CommonFunction().splitString(state.mGainLedger.ledgerEntries[index].credit.toInt().toString())}/-',
                                                      style: textStyle9Bold(
                                                              colorBlack)
                                                          .copyWith(
                                                              height: 1.2)),
                                                )),
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
                ],
              ),
            ),
            bottomNavigationBar: Table(
              border: TableBorder.all(color: colorE5E5),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: colorBG),
                  children: [
                    Container(
                      height: 6.h,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text('Total',
                            textAlign: TextAlign.center,
                            style: textStyle11Bold(colorBlack)),
                      ),
                    ),
                    Container(
                        height: 6.h,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(
                              '${CommonFunction().splitString('$totalDebit')}/-',
                              textAlign: TextAlign.center,
                              style: textStyle11Bold(colorRed)),
                        )),
                    Container(
                        height: 6.h,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(
                              '${CommonFunction().splitString('$totalCredit')}/-',
                              textAlign: TextAlign.center,
                              style: textStyle11Bold(colorRed)),
                        )),
                  ],
                )
              ],
            )));
  }
}
