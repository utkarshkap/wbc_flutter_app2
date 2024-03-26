import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/presentations/emisip_cal_result.dart';
import '../../resources/resource.dart';
import '../../thousandsSeparatorInputFormatter.dart';
import '../../widgets/appbarButton.dart';
import '../../blocs/emisipcalculator/emisip_calculator_bloc.dart';

class EMISIPCalculator extends StatefulWidget {
  static const route = '/EMISIP-Calculator';

  const EMISIPCalculator({super.key});

  @override
  State<EMISIPCalculator> createState() => _EMISIPCalculatorState();
}

class _EMISIPCalculatorState extends State<EMISIPCalculator> {
  final TextEditingController loanAmount =
      TextEditingController(text: "5000000");

  int noOfYear = 30;
  int loanInterestRate = 9;
  int interestRateOnInvestment = 15;

  String principalAmount = "";
  String interestAmount = "";
  String emiAmount = "";
  String sipAmount = "";
  String totalPayableAmount = "";

  String loanAmountValidation = '';

  bool isSubmit = false;
  var formatter = NumberFormat('#,##,000');

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
          title: Text('EMI SIP Calculator', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<EMISIPCalculatorBloc, EMISIPCalculatorState>(
          listener: (context, state) {
            print('EMISIPCalculatorState-------$state');
            if (state is EMISIPCalculatorFailed) {
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
            } else if (state is EMISIPCalculatorAdded) {
              setState(() {
                isSubmit = false;
              });
              Navigator.of(context).pushNamed(EMISIPCalculatorResult.route);
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
                                        'Get your home\nloan interest paid with your investments',
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
                                      child: Text("Loan Amount",
                                          style: textStyle10Bold(colorBlack)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 1.4.w),
                                      child: TextFormField(
                                        controller: loanAmount,
                                        style: textStyle11(colorText3D3D)
                                            .copyWith(height: 1.3),
                                        maxLines: 1,
                                        inputFormatters: [
                                          ThousandsSeparatorInputFormatter(),
                                        ],
                                        decoration: InputDecoration(
                                            hintText: "Enter a loan amount",
                                            hintStyle:
                                                textStyle11(colorText3D3D),
                                            fillColor: colorWhite,
                                            filled: true,
                                            border: InputBorder.none),
                                        onChanged: (val) {
                                          if (loanAmount.text != "") {
                                            setState(() {
                                              loanAmountValidation = "";
                                            });
                                          }
                                        },
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                      ),
                                    ),
                                    if (loanAmountValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: loanAmountValidation ==
                                                'Empty Loan Amount'
                                            ? errorText(
                                                'Please Enter Loan Amount.')
                                            : Container(),
                                      ),
                                    ),
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
                                        min: 0,
                                        max: 40,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${noOfYear.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            noOfYear = newValue.round();
                                          });
                                        },
                                        onChangeEnd: (double newValue) {},
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
                                          left: 5.w, right: 5.w, top: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Loan Interest Rate (%)",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$loanInterestRate%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: loanInterestRate.toDouble(),
                                        min: 6,
                                        max: 18,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${loanInterestRate.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            loanInterestRate = newValue.round();
                                          });
                                        },
                                        onChangeEnd: (double newValue) {},
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
                                          left: 5.w, right: 5.w, top: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Return on SIP",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$interestRateOnInvestment%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value:
                                            interestRateOnInvestment.toDouble(),
                                        min: 0,
                                        max: 20,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label:
                                            '${interestRateOnInvestment.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            interestRateOnInvestment =
                                                newValue.round();
                                          });
                                          print(
                                              "expectedReturn-->$interestRateOnInvestment");
                                        },
                                        onChangeEnd: (double newValue) {},
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${newValue.round()}';
                                        }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 3.5.h, bottom: 2.5.h),
                                child: InkWell(
                                    onTap: () {
                                      if (loanAmount.text.isEmpty) {
                                        setState(() {
                                          loanAmountValidation =
                                              'Empty Loan Amount';
                                        });
                                      } else {
                                        setState(() {
                                          isSubmit = true;
                                        });
                                        BlocProvider.of<EMISIPCalculatorBloc>(
                                                context)
                                            .add(EMISIPData(
                                          name: "",
                                          loanAmount: int.parse(loanAmount.text
                                              .replaceAll(',', '')),
                                          noOfYear: noOfYear,
                                          loanInterestRate: loanInterestRate,
                                          interestRateOnInvestment:
                                              interestRateOnInvestment,
                                        ));
                                      }
                                    },
                                    child: Container(
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                          color: colorRed,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 3),
                                                blurRadius: 6,
                                                color:
                                                    colorRed.withOpacity(0.35))
                                          ]),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.h),
                                        child: isSubmit
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: colorWhite,
                                                        strokeWidth: 0.6.w))
                                            : Text('CALCULATE',
                                                style: textStyle13Bold(
                                                    colorWhite)),
                                      ),
                                    )),
                              ),
                              /*SizedBox(
                                height: 4.h,
                              ),
                              Table(
                                border: TableBorder.all(color: colorBG),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(color: colorE5E5),
                                    children: [
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('Principal Amount',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('EMI Amount',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('SIP Amount',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              isSubmit ? Container() : Table(
                                border: TableBorder.all(color: colorE5E5),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                },
                                children: List<TableRow>.generate(
                                  1, (index) {
                                  return TableRow(
                                    decoration: const BoxDecoration(
                                        color: Colors.white
                                    ),
                                    children: [
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            formatter.format(double.parse(principalAmount)),
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            emiAmount.toString(),
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            sipAmount.toString(),
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                    ],
                                  );
                                },
                                  growable: false,
                                ),
                              ),
                              Table(
                                border: TableBorder.all(color: colorBG),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(color: colorE5E5),
                                    children: [
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('Interest Amount',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('Total Payable Amount',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              isSubmit ? Container() : Table(
                                border: TableBorder.all(color: colorE5E5),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                },
                                children: List<TableRow>.generate(
                                  1, (index) {
                                  return TableRow(
                                    decoration: const BoxDecoration(
                                        color: Colors.white
                                    ),
                                    children: [
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            formatter.format(double.parse(interestAmount)),
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            formatter.format(double.parse(totalPayableAmount)),
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                      Container(
                                        height: 43,
                                        alignment: Alignment.center,
                                        child: Text(
                                            "",
                                            textAlign: TextAlign.left,
                                            style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                                      ),
                                    ],
                                  );
                                },
                                  growable: false,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              isSubmit ? Text("Calculating...", style: textStyle10Medium(colorText4D4D)) : Container(),
                              SizedBox(
                                height: 2.h,
                              )*/
                            ],
                          )
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

  errorText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: colorRed, size: 13),
        const SizedBox(width: 4),
        Container(
          height: 2.h,
          alignment: Alignment.center,
          child: Text(text, style: textStyle9(colorErrorRed)),
        ),
      ],
    );
  }
}
