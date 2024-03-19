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

class MGainLedgerScreenData {
  String? mGainId;
  MGainLedgerScreenData({this.mGainId});
}

class MGainLedgerScreen extends StatefulWidget {
  static const route = '/mGain-Ledger';
  final MGainLedgerScreenData mGainLedgerScreenData;

  const MGainLedgerScreen(this.mGainLedgerScreenData, {Key? key})
      : super(key: key);

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
            child: Padding(
              padding: EdgeInsets.only(
                  top: 2.5.h, left: 5.w, right: 5.w, bottom: 2.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: Text(
                          'MGain Id: ${widget.mGainLedgerScreenData.mGainId}',
                          style: textStyle13Bold(colorRed)),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Container(
                      width: 100.w,
                      decoration: decoration(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              cLeftTextContainer('Particulars'),
                              cRightTextContainer('Debit', colorBlack),
                              cRightTextContainer('Credit', colorBlack),
                            ],
                          ),
                          Container(
                              height: 2,
                              color: colorTextBCBC.withOpacity(0.36)),
                          BlocConsumer<FetchingDataBloc, FetchingDataState>(
                            listener: (context, state) {
                              if (state is MGainLedgerLoadedState) {
                                for (int i = 0;
                                    i < state.mGainLedger.ledgerEntries.length;
                                    i++) {
                                  totalDebit = totalDebit +
                                      state.mGainLedger.ledgerEntries[i].debit
                                          .toInt();
                                  totalCredit = totalCredit +
                                      state.mGainLedger.ledgerEntries[i].credit
                                          .toInt();
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
                                            color: colorRed,
                                            strokeWidth: 0.7.w)),
                                  ),
                                );
                              }
                              if (state is MGainLedgerLoadedState) {
                                for (int i = 0;
                                    i < state.mGainLedger.ledgerEntries.length;
                                    i++) {
                                  totalDebit = totalDebit +
                                      state.mGainLedger.ledgerEntries[i].debit
                                          .toInt();
                                  totalCredit = totalCredit +
                                      state.mGainLedger.ledgerEntries[i].credit
                                          .toInt();
                                }
                                return state.mGainLedger.ledgerEntries.isEmpty
                                    ? Expanded(
                                        child: Center(
                                            child: Text('No Data Available',
                                                style: textStyle13Medium(
                                                    colorBlack))),
                                      )
                                    : Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                  state.mGainLedger
                                                      .ledgerEntries.length,
                                                  (index) => Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      3.w,
                                                                  vertical:
                                                                      1.5.h,
                                                                ),
                                                                width: 45.w,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        state
                                                                            .mGainLedger
                                                                            .ledgerEntries[
                                                                                index]
                                                                            .name,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: textStyle9Bold(colorBlack).copyWith(
                                                                            height:
                                                                                1.2,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                    SizedBox(
                                                                        height:
                                                                            0.5.h),
                                                                    Row(
                                                                      children: [
                                                                        Image.asset(
                                                                            icCalender,
                                                                            color:
                                                                                colorText3D3D,
                                                                            width:
                                                                                3.w),
                                                                        SizedBox(
                                                                            width:
                                                                                1.w),
                                                                        Text(
                                                                            DateFormat('dd MMM yyyy').format(state.mGainLedger.ledgerEntries[index].investmentDate),
                                                                            style: textStyle9(colorText7070)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        3.w,
                                                                    vertical:
                                                                        1.5.h,
                                                                  ),
                                                                  child: Text(
                                                                      '${CommonFunction().splitString(state.mGainLedger.ledgerEntries[index].debit.toInt().toString())}',
                                                                      style: textStyle9Bold(colorBlack).copyWith(
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        3.w,
                                                                    vertical:
                                                                        1.5.h,
                                                                  ),
                                                                  child: Text(
                                                                      '${CommonFunction().splitString(state.mGainLedger.ledgerEntries[index].credit.toInt().toString())}',
                                                                      style: textStyle9Bold(colorBlack).copyWith(
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                              height: 1,
                                                              color: colorTextBCBC
                                                                  .withOpacity(
                                                                      0.36)),
                                                        ],
                                                      )),
                                            ],
                                          ),
                                        ),
                                      );
                              }
                              return Container();
                            },
                          ),
                          Container(
                              height: 2,
                              color: colorTextBCBC.withOpacity(0.36)),
                          Row(
                            children: [
                              cLeftTextContainer('Total'),
                              cRightTextContainer(
                                  '${CommonFunction().splitString('$totalDebit')}',
                                  colorRed),
                              cRightTextContainer(
                                  '${CommonFunction().splitString('$totalCredit')}',
                                  colorRed)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorE5E5, width: 1),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }

  Widget cLeftTextContainer(String text) {
    return Container(
        height: 6.h,
        width: 45.w,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(text,
              textAlign: TextAlign.center, style: textStyle11Bold(colorBlack)),
        ));
  }

  Widget cRightTextContainer(String text, Color color) {
    return Expanded(
      child: Container(
          height: 6.h,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Text(text,
                textAlign: TextAlign.center, style: textStyle11Bold(color)),
          )),
    );
  }
}
