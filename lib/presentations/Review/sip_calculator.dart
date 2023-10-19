import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/sipcalculator/sip_calculator_bloc.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';

class SIPCalculator extends StatefulWidget {
  static const route = '/SIP-Calculator';

  @override
  State<SIPCalculator> createState() => _SIPCalculatorState();
}

class _SIPCalculatorState extends State<SIPCalculator> {
  int sipAmount = 15000;
  int noOfYear = 20;
  int expectedReturn = 15;

  String maturityValue = "";
  String investedAmount = "";
  String returnValue = "";

  bool isSubmit = false;
  var formatter = NumberFormat('#,##,000');

  @override
  void initState() {
    endSliderChanges();
    setState(() {
      isSubmit = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          title: Text('SIP Calculator', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {}),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<SIPCalculatorBloc, SIPCalculatorState>(
          listener: (context, state) {
            print('SIPCalculatorState-------$state');
            if (state is SIPCalculatorFailed) {
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
            } else if (state is SIPCalculatorAdded) {
              setState(() {
                maturityValue = state.maturityValue;
                investedAmount = state.investedAmount;
                returnValue = state.returnValue;
                isSubmit = false;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 60.w,
                                    child: Text(
                                        'Check if\nyou have Enough\nInvestments',
                                        style: textStyle15Bold(colorBlack)
                                            .copyWith(height: 1.34))),
                                Image.asset(imgInsuranceCalculator, width: 20.w)
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 2.4.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: colorDFDF, width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w, top: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("SIP Amount",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(formatter.format(sipAmount),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: sipAmount.toDouble(),
                                        min: 500,
                                        max: 100000,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label:
                                            formatter.format(sipAmount.round()),
                                        autofocus: true,
                                        onChanged: (double newValue) {
                                          setState(() {
                                            sipAmount = newValue.round();
                                          });
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on SipAmount $newValue');
                                          endSliderChanges();
                                          setState(() {
                                            isSubmit = true;
                                          });
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${newValue.round()}';
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.3.h, bottom: 0.3.h),
                                      child: Container(
                                          height: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w, top: 3.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("No of year",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$noOfYear',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: noOfYear.toDouble(),
                                        min: 1,
                                        max: 70,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${noOfYear.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            noOfYear = newValue.round();
                                          });
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on NoOfYear $newValue');
                                          endSliderChanges();
                                          setState(() {
                                            isSubmit = true;
                                          });
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${newValue.round()}';
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.3.h, bottom: 0.3.h),
                                      child: Container(
                                          height: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w, top: 3.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Gain (%)",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$expectedReturn%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: expectedReturn.toDouble(),
                                        min: 1,
                                        max: 25,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${expectedReturn.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            expectedReturn = newValue.round();
                                          });
                                          print(
                                              "expectedReturn-->$expectedReturn");
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on ExpectedReturn $newValue');
                                          endSliderChanges();
                                          setState(() {
                                            isSubmit = true;
                                          });
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${newValue.round()}';
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              isSubmit
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Text("Calculating...",
                                          style:
                                              textStyle10Medium(colorText4D4D)),
                                    )
                                  : Column(
                                      children: [
                                        Table(
                                          border:
                                              TableBorder.all(color: colorBG),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: [
                                            TableRow(
                                              decoration: const BoxDecoration(
                                                  color: colorE5E5),
                                              children: [
                                                Container(
                                                  height: 5.3.h,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Investment Amount',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle10Bold(
                                                          colorBlack)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Table(
                                          border:
                                              TableBorder.all(color: colorE5E5),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: List<TableRow>.generate(
                                            1,
                                            (index) {
                                              return TableRow(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                children: [
                                                  Container(
                                                    height: 43,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "${formatter.format(double.parse(investedAmount))} ₹",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: textStyle11Bold(
                                                                colorRedFF6)
                                                            .copyWith(
                                                                height: 1.2)),
                                                  ),
                                                ],
                                              );
                                            },
                                            growable: false,
                                          ),
                                        ),
                                        Table(
                                          border:
                                              TableBorder.all(color: colorBG),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: [
                                            TableRow(
                                              decoration: const BoxDecoration(
                                                  color: colorE5E5),
                                              children: [
                                                Container(
                                                  height: 5.3.h,
                                                  alignment: Alignment.center,
                                                  child: Text('Maturity Value',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle10Bold(
                                                          colorBlack)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Table(
                                          border:
                                              TableBorder.all(color: colorE5E5),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: List<TableRow>.generate(
                                            1,
                                            (index) {
                                              return TableRow(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                children: [
                                                  Container(
                                                    height: 43,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "${formatter.format(double.parse(maturityValue))} ₹",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: textStyle11Bold(
                                                                colorRedFF6)
                                                            .copyWith(
                                                                height: 1.2)),
                                                  ),
                                                ],
                                              );
                                            },
                                            growable: false,
                                          ),
                                        ),
                                        Table(
                                          border:
                                              TableBorder.all(color: colorBG),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: [
                                            TableRow(
                                              decoration: const BoxDecoration(
                                                  color: colorE5E5),
                                              children: [
                                                Container(
                                                  height: 5.3.h,
                                                  alignment: Alignment.center,
                                                  child: Text('Returns',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyle10Bold(
                                                          colorBlack)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Table(
                                          border:
                                              TableBorder.all(color: colorE5E5),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          children: List<TableRow>.generate(
                                            1,
                                            (index) {
                                              return TableRow(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                children: [
                                                  Container(
                                                    height: 43,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "${formatter.format(double.parse(returnValue))} ₹",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: textStyle11Bold(
                                                                colorRedFF6)
                                                            .copyWith(
                                                                height: 1.2)),
                                                  ),
                                                ],
                                              );
                                            },
                                            growable: false,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void endSliderChanges() {
    BlocProvider.of<SIPCalculatorBloc>(context).add(SIPInsuranceData(
      sipAmount: sipAmount,
      noOfYear: noOfYear,
      expectedReturn: expectedReturn,
    ));
  }
}
