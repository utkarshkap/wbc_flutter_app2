import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import '../../blocs/retirementcalculator/retirement_calculator_bloc.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';

class RetirementCalculatorData {
  final bool isRetirementCalculator;
  final int? currentAge;
  final int? retirementAge;
  final int? lifeExpectancy;
  final String? monthlyExpenses;
  final int? preRetirementReturn;
  final int? postRetirementReturn;
  final String? currentInvestment;
  final int? inflationRate;
  final double? corpusAfterRetirement;
  final double? investmentRequired;
  final double? inflationAdjustedExpense;

  RetirementCalculatorData({
    this.isRetirementCalculator = false,
    this.currentAge,
    this.retirementAge,
    this.lifeExpectancy,
    this.monthlyExpenses,
    this.preRetirementReturn,
    this.postRetirementReturn,
    this.currentInvestment,
    this.inflationRate,
    this.corpusAfterRetirement,
    this.investmentRequired,
    this.inflationAdjustedExpense,
  });
}

class RetirementCalculator extends StatefulWidget {
  static const route = '/Retirement-Calculator';
  final RetirementCalculatorData retirementCalculatorData;

  const RetirementCalculator(
      {super.key, required this.retirementCalculatorData});

  @override
  State<RetirementCalculator> createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends State<RetirementCalculator> {
  int currentAge = 18;
  int retirementAge = 50;
  int lifeExpectancy = 80;

  String corpusAfterRetirement = "";
  String investmentRequired = "";
  String inflationAdjustedExpense = "";

  final TextEditingController _currentAgeController =
      TextEditingController(text: "18");
  final TextEditingController _retirementAgeController =
      TextEditingController(text: "50");
  final TextEditingController _lifeExpectancyController =
      TextEditingController(text: "80");

  final TextEditingController _monthlyExpensesController =
      TextEditingController();
  final TextEditingController _preRetirementReturnController =
      TextEditingController();
  final TextEditingController _postRetirementReturnController =
      TextEditingController();
  final TextEditingController _currentInvestmentController =
      TextEditingController();
  final TextEditingController _inflationRateController =
      TextEditingController();

  bool isCurrentAgeFieldTap = false;
  bool isRetirementAgeFieldTap = false;
  bool isLifeExpectancyFieldTap = false;
  bool isMonthlyExpensesFieldTap = false;
  bool isPreRetirementReturnFieldTap = false;
  bool isPostRetirementReturnFieldTap = false;
  bool isCurrentInvestmentFieldTap = false;
  bool isInflationRateFieldTap = false;

  FocusNode currentAgeFocus = FocusNode();
  FocusNode retirementAgeFocus = FocusNode();
  FocusNode lifeExpectancyFocus = FocusNode();
  FocusNode monthlyExpensesFocus = FocusNode();
  FocusNode preRetirementReturnFocus = FocusNode();
  FocusNode postRetirementReturnFocus = FocusNode();
  FocusNode currentInvestmentFocus = FocusNode();
  FocusNode inflationRateFocus = FocusNode();

/*
  String currentAgeValidation = '';
  String retirementAgeValidation = '';
  String lifeExpectancyValidation = '';
  String monthlyExpensesValidation = '';
  String preRetirementReturnValidation = '';
  String postRetirementReturnValidation = '';
  String currentInvestmentValidation = '';
  String inflationRateValidation = '';*/

  int monthlyExpense = 30000;
  double preRetirementReturn = 15;
  double postRetirementReturn = 7;
  int currentInvestmentAmount = 10000;
  double inflactionRate = 6;
  var formatter = NumberFormat('#,##,000');

  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    /*if (widget.retirementCalculatorData.isRetirementCalculator) {
      setState(() {
        _currentAgeController.text = widget.retirementCalculatorData.currentAge.toString();
        _retirementAgeController.text = widget.retirementCalculatorData.retirementAge.toString();
        _lifeExpectancyController.text = widget.retirementCalculatorData.lifeExpectancy.toString();
        _monthlyExpensesController.text = widget.retirementCalculatorData.monthlyExpenses.toString();
        _preRetirementReturnController.text = widget.retirementCalculatorData.preRetirementReturn.toString();
        _postRetirementReturnController.text = widget.retirementCalculatorData.postRetirementReturn.toString();
        _currentInvestmentController.text = widget.retirementCalculatorData.currentInvestment.toString();
        _inflationRateController.text = widget.retirementCalculatorData.inflationRate.toString();
      });
    }*/
    setState(() {
      isSubmit = true;
    });
    BlocProvider.of<RetirementCalculatorBloc>(context).add(RetirementData(
      name: "",
      currentAge: currentAge,
      retirementAge: retirementAge,
      lifeExpectancy: lifeExpectancy,
      monthlyExpenses: monthlyExpense,
      preRetirementReturn: preRetirementReturn,
      postRetirementReturn: postRetirementReturn,
      currentInvestment: currentInvestmentAmount,
      inflationRate: inflactionRate,
    ));
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
          title:
              Text('Retirement Calculator', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<RetirementCalculatorBloc, RetirementCalculatorState>(
          listener: (context, state) {
            print('RetirementCalculatorState-------$state');
            if (state is RetirementCalculatorFailed) {
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
            } else if (state is RetirementCalculatorAdded) {
              setState(() {
                isSubmit = false;
                inflationAdjustedExpense = state.inflationAdjustedExpense;
                investmentRequired = state.investmentRequired;
                corpusAfterRetirement = state.corpusAfterRetirement;
              });
              /*Navigator.of(context).pushReplacementNamed(
                  RetirementCalculator.route,
                  arguments: RetirementCalculatorData(
                    isRetirementCalculator: true,
                    currentAge: int.parse(_currentAgeController.text),
                    retirementAge: int.parse(_retirementAgeController.text),
                    lifeExpectancy: int.parse(_lifeExpectancyController.text),
                    monthlyExpenses: _monthlyExpensesController.text.toString(),
                    preRetirementReturn: int.parse(_preRetirementReturnController.text),
                    postRetirementReturn: int.parse(_postRetirementReturnController.text),
                    currentInvestment: _currentInvestmentController.text.toString(),
                    inflationRate: int.parse(_inflationRateController.text),
                    corpusAfterRetirement: state.corpusAfterRetirement,
                    investmentRequired: state.investmentRequired,
                    inflationAdjustedExpense: state.inflationAdjustedExpense,
                  )
              );*/
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
                                        'Plan your dream\nretirement\nhere',
                                        style: textStyle15Bold(colorBlack)
                                            .copyWith(height: 1.34))),
                                Image.asset(imgInsuranceCalculator, width: 20.w)
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: colorDFDF, width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*textFormFieldContainer('Life Expectancy',
                                        'Enter Life Expectancy', isLifeExpectancyFieldTap, () {
                                          setState(() {
                                            isCurrentAgeFieldTap = false;
                                            isRetirementAgeFieldTap = true;
                                            isLifeExpectancyFieldTap = false;
                                            isMonthlyExpensesFieldTap = false;
                                            isPreRetirementReturnFieldTap = false;
                                            isPostRetirementReturnFieldTap = false;
                                            isCurrentInvestmentFieldTap = false;
                                            isInflationRateFieldTap = false;
                                          });
                                          lifeExpectancyFocus.requestFocus();
                                        }, _lifeExpectancyController, TextInputType.number),
                                    if (lifeExpectancyValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: lifeExpectancyValidation == 'Empty Life Expectancy'
                                            ? Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter Life Expectancy',
                                                  style: textStyle9(colorErrorRed)),
                                            ),
                                          ],
                                        ) : Container(),
                                      ),
                                    ),*/
                                    /*Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            textFormFieldContainer('Current Age',
                                                'Enter Current Age', isCurrentAgeFieldTap, () {
                                                  setState(() {
                                                    isCurrentAgeFieldTap = true;
                                                    isRetirementAgeFieldTap = false;
                                                    isLifeExpectancyFieldTap = false;
                                                    isMonthlyExpensesFieldTap = false;
                                                    isPreRetirementReturnFieldTap = false;
                                                    isPostRetirementReturnFieldTap = false;
                                                    isCurrentInvestmentFieldTap = false;
                                                    isInflationRateFieldTap = false;
                                                  });
                                                  currentAgeFocus.requestFocus();
                                                }, _currentAgeController, TextInputType.number),
                                            if (currentAgeValidation.isNotEmpty)
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 2.w),
                                                child: currentAgeValidation == 'Empty Current Age'
                                                    ? Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.error,
                                                        color: colorRed, size: 13),
                                                    const SizedBox(width: 4),
                                                    Container(
                                                      height: 2.h,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          'Enter Current Age',
                                                          style: textStyle9(colorErrorRed)),
                                                    ),
                                                  ],
                                                ) : Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            textFormFieldContainer('Retirement Age',
                                                'Enter Retirement Age', isRetirementAgeFieldTap, () {
                                                  setState(() {
                                                    isCurrentAgeFieldTap = false;
                                                    isRetirementAgeFieldTap = true;
                                                    isLifeExpectancyFieldTap = false;
                                                    isMonthlyExpensesFieldTap = false;
                                                    isPreRetirementReturnFieldTap = false;
                                                    isPostRetirementReturnFieldTap = false;
                                                    isCurrentInvestmentFieldTap = false;
                                                    isInflationRateFieldTap = false;
                                                  });
                                                  retirementAgeFocus.requestFocus();
                                                }, _retirementAgeController, TextInputType.number),
                                            if (retirementAgeValidation.isNotEmpty)
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 2.w),
                                                child: retirementAgeValidation == 'Empty Retirement Age'
                                                    ? Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.error, color: colorRed, size: 13),
                                                    const SizedBox(width: 4),
                                                    Container(
                                                      height: 2.h,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          'Enter Retirement Age',
                                                          style: textStyle9(colorErrorRed)),
                                                    ),
                                                  ],
                                                ) : Container(),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),*/
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w, top: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Current Age",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(currentAge.toString(),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: currentAge.toDouble(),
                                        min: 0,
                                        max: 100,
                                        divisions: 250,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${currentAge.round()}',
                                        onChanged: (newValue) {
                                          setState(() {
                                            currentAge = newValue.round();
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
                                          left: 5.w, right: 5.w, top: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Retirement Age",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(retirementAge.toString(),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: retirementAge.toDouble(),
                                        min: 0,
                                        max: 100,
                                        divisions: 250,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${retirementAge.round()}',
                                        onChanged: (newValue) {
                                          setState(() {
                                            retirementAge = newValue.round();
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
                                          left: 5.w, right: 5.w, top: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Life Expectancy",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(lifeExpectancy.toString(),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: lifeExpectancy.toDouble(),
                                        min: 0,
                                        max: 100,
                                        divisions: 250,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '${lifeExpectancy.round()}',
                                        onChanged: (newValue) {
                                          setState(() {
                                            lifeExpectancy = newValue.round();
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
                                          left: 5.w, right: 5.w, top: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Monthly Expenses",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(
                                              monthlyExpense.toString() == "0"
                                                  ? "0"
                                                  : formatter
                                                      .format(monthlyExpense),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: monthlyExpense.toDouble(),
                                        min: 0,
                                        max: 500000,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: formatter
                                            .format(monthlyExpense.round()),
                                        autofocus: true,
                                        onChanged: (double newValue) {
                                          setState(() {
                                            monthlyExpense = newValue.round();
                                          });
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on monthlyExpense $newValue');
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
                                          Text("Pre-retirement ROI",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$preRetirementReturn%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: preRetirementReturn,
                                        min: 0,
                                        max: 30,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '$preRetirementReturn',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            preRetirementReturn = double.parse(
                                                newValue.toStringAsFixed(1));
                                          });
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on preRetirementReturn $newValue');
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${double.parse(newValue.toStringAsFixed(1))}';
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
                                          Text("Post-retirement ROI",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$postRetirementReturn%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: postRetirementReturn,
                                        min: 0,
                                        max: 30,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '$postRetirementReturn',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            postRetirementReturn = double.parse(
                                                newValue.toStringAsFixed(1));
                                          });
                                          print(
                                              "postRetirementReturn-->$postRetirementReturn");
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on postRetirementReturn $newValue');
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${double.parse(newValue.toStringAsFixed(1))}';
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
                                          Text("Monthly Investment",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text(
                                              formatter.format(
                                                  currentInvestmentAmount),
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value:
                                            currentInvestmentAmount.toDouble(),
                                        min: 5000,
                                        max: 150000,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label:
                                            '${currentInvestmentAmount.round()}',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            currentInvestmentAmount =
                                                newValue.round();
                                          });
                                          print(
                                              "currentInvestmentAmount-->$currentInvestmentAmount");
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on currentInvestmentAmount $newValue');
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
                                          Text("Inflation (%)",
                                              style:
                                                  textStyle10Bold(colorBlack)),
                                          Text('$inflactionRate%',
                                              style:
                                                  textStyle10(colorText7070)),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: inflactionRate,
                                        min: 1,
                                        max: 15,
                                        divisions: 100,
                                        activeColor: colorRedFF6,
                                        inactiveColor: Colors.grey,
                                        label: '$inflactionRate',
                                        onChanged: (double newValue) {
                                          setState(() {
                                            inflactionRate = double.parse(
                                                newValue.toStringAsFixed(1));
                                          });
                                          print(
                                              "inflactionRate-->$inflactionRate");
                                        },
                                        onChangeEnd: (double newValue) {
                                          print(
                                              'Ended change on inflactionRate $newValue');
                                        },
                                        semanticFormatterCallback:
                                            (double newValue) {
                                          return '${double.parse(newValue.toStringAsFixed(1))}';
                                        }),
                                  ],
                                ),
                              ),

                              /*textFormFieldContainer('Monthly Expenses',
                                  'Enter Monthly Expenses', isMonthlyExpensesFieldTap, () {
                                    setState(() {
                                      isCurrentAgeFieldTap = false;
                                      isRetirementAgeFieldTap = false;
                                      isLifeExpectancyFieldTap = false;
                                      isMonthlyExpensesFieldTap = true;
                                      isPreRetirementReturnFieldTap = false;
                                      isPostRetirementReturnFieldTap = false;
                                      isCurrentInvestmentFieldTap = false;
                                      isInflationRateFieldTap = false;
                                    });
                                    monthlyExpensesFocus.requestFocus();
                                  }, _monthlyExpensesController, TextInputType.number),
                              if (monthlyExpensesValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: monthlyExpensesValidation == 'Empty Monthly Expenses'
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter Monthly Expenses',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  ) : Container(),
                                ),
                              ),

                              textFormFieldContainer('Pre-Retirement Return',
                                  'Enter Pre-Retirement Return', isPreRetirementReturnFieldTap, () {
                                    setState(() {
                                      isCurrentAgeFieldTap = false;
                                      isRetirementAgeFieldTap = false;
                                      isLifeExpectancyFieldTap = false;
                                      isMonthlyExpensesFieldTap = false;
                                      isPreRetirementReturnFieldTap = true;
                                      isPostRetirementReturnFieldTap = false;
                                      isCurrentInvestmentFieldTap = false;
                                      isInflationRateFieldTap = false;
                                    });
                                    preRetirementReturnFocus.requestFocus();
                                  }, _preRetirementReturnController, TextInputType.number),
                              if (preRetirementReturnValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: preRetirementReturnValidation == 'Empty Pre-Retirement Return'
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter Pre-Retirement Return',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  ) : Container(),
                                ),
                              ),

                              textFormFieldContainer('Post-Retirement Return',
                                  'Enter Post-Retirement Return', isPostRetirementReturnFieldTap, () {
                                    setState(() {
                                      isCurrentAgeFieldTap = false;
                                      isRetirementAgeFieldTap = false;
                                      isLifeExpectancyFieldTap = false;
                                      isMonthlyExpensesFieldTap = false;
                                      isPreRetirementReturnFieldTap = false;
                                      isPostRetirementReturnFieldTap = true;
                                      isCurrentInvestmentFieldTap = false;
                                      isInflationRateFieldTap = false;
                                    });
                                    postRetirementReturnFocus.requestFocus();
                                  }, _postRetirementReturnController, TextInputType.number),
                              if (postRetirementReturnValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: postRetirementReturnValidation == 'Empty Post-Retirement Return'
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter Post-Retirement Return',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  ) : Container(),
                                ),
                              ),

                              textFormFieldContainer('Current Investment',
                                  'Enter Current Investment', isCurrentInvestmentFieldTap, () {
                                    setState(() {
                                      isCurrentAgeFieldTap = false;
                                      isRetirementAgeFieldTap = false;
                                      isLifeExpectancyFieldTap = false;
                                      isMonthlyExpensesFieldTap = false;
                                      isPreRetirementReturnFieldTap = false;
                                      isPostRetirementReturnFieldTap = false;
                                      isCurrentInvestmentFieldTap = true;
                                      isInflationRateFieldTap = false;
                                    });
                                    currentInvestmentFocus.requestFocus();
                                  }, _currentInvestmentController, TextInputType.number),
                              if (currentInvestmentValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: currentInvestmentValidation == 'Empty Current Investment'
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter Current Investment',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  ) : Container(),
                                ),
                              ),

                              textFormFieldContainer('Inflation Rate',
                                  'Enter Inflation Rate', isInflationRateFieldTap, () {
                                    setState(() {
                                      isCurrentAgeFieldTap = false;
                                      isRetirementAgeFieldTap = false;
                                      isLifeExpectancyFieldTap = false;
                                      isMonthlyExpensesFieldTap = false;
                                      isPreRetirementReturnFieldTap = false;
                                      isPostRetirementReturnFieldTap = false;
                                      isCurrentInvestmentFieldTap = false;
                                      isInflationRateFieldTap = true;
                                    });
                                    inflationRateFocus.requestFocus();
                                  }, _inflationRateController, TextInputType.number),
                              if (inflationRateValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: inflationRateValidation == 'Empty Inflation Rate'
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter Inflation Rate',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  ) : Container(),
                                ),
                              ),

                              if (widget.retirementCalculatorData.isRetirementCalculator)
                                textFormFieldContainer(
                                    'Corpus After Retirement',
                                    widget.retirementCalculatorData.corpusAfterRetirement!.toStringAsFixed(2),
                                    false, () {}),
                              if (widget.retirementCalculatorData.isRetirementCalculator)
                                textFormFieldContainer(
                                    'Investment Required',
                                    widget.retirementCalculatorData.investmentRequired!.toStringAsFixed(2),
                                    false, () {}),
                              if (widget.retirementCalculatorData.isRetirementCalculator)
                                textFormFieldContainer(
                                    'Inflation Adjusted Expense',
                                    widget.retirementCalculatorData.inflationAdjustedExpense!.toStringAsFixed(2),
                                    false, () {}),

                              const SizedBox(
                                height: 10,
                              ),*/

                              if (!widget.retirementCalculatorData
                                  .isRetirementCalculator)
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 1.h, bottom: 2.5.h),
                                  child: InkWell(
                                      onTap: () {
                                        /* if (_currentAgeController.text.isEmpty) {
                                          setState(() {
                                            currentAgeValidation = 'Empty Current Age';
                                          });
                                        } else {
                                          setState(() {
                                            currentAgeValidation = '';
                                          });
                                        }
                                        if (_retirementAgeController.text.isEmpty) {
                                          setState(() {
                                            retirementAgeValidation = 'Empty Retirement Age';
                                          });
                                        } else {
                                          setState(() {
                                            retirementAgeValidation = '';
                                          });
                                        }
                                        if (_lifeExpectancyController.text.isEmpty) {
                                          setState(() {
                                            lifeExpectancyValidation = 'Empty Life Expectancy';
                                          });
                                        } else {
                                          setState(() {
                                            lifeExpectancyValidation = '';
                                          });
                                        }
                                        if (_monthlyExpensesController.text.isEmpty) {
                                          setState(() {
                                            monthlyExpensesValidation = 'Empty Monthly Expenses';
                                          });
                                        } else {
                                          setState(() {
                                            monthlyExpensesValidation = '';
                                          });
                                        }
                                        if (_preRetirementReturnController.text.isEmpty) {
                                          setState(() {
                                            preRetirementReturnValidation = 'Empty Pre-Retirement Return';
                                          });
                                        } else {
                                          setState(() {
                                            preRetirementReturnValidation = '';
                                          });
                                        }
                                        if (_postRetirementReturnController.text.isEmpty) {
                                          setState(() {
                                            postRetirementReturnValidation = 'Empty Post-Retirement Return';
                                          });
                                        } else {
                                          setState(() {
                                            postRetirementReturnValidation = '';
                                          });
                                        }
                                        if (_currentInvestmentController.text.isEmpty) {
                                          setState(() {
                                            currentInvestmentValidation = 'Empty Current Investment';
                                          });
                                        } else {
                                          setState(() {
                                            currentInvestmentValidation = '';
                                          });
                                        }
                                        if (_inflationRateController.text.isEmpty) {
                                          setState(() {
                                            inflationRateValidation = 'Empty Inflation Rate';
                                          });
                                        } else {
                                          setState(() {
                                            inflationRateValidation = '';
                                          });
                                        }*/
                                        /* if (_currentAgeController.text.isNotEmpty &&
                                            _retirementAgeController.text.isNotEmpty &&
                                            _lifeExpectancyController.text.isNotEmpty &&
                                            _monthlyExpensesController.text.isNotEmpty &&
                                            _preRetirementReturnController.text.isNotEmpty &&
                                            _postRetirementReturnController.text.isNotEmpty &&
                                            _currentInvestmentController.text.isNotEmpty &&
                                            _inflationRateController.text.isNotEmpty) {
                                        }*/

                                        setState(() {
                                          isSubmit = true;
                                        });
                                        BlocProvider.of<
                                                    RetirementCalculatorBloc>(
                                                context)
                                            .add(RetirementData(
                                          name: "",
                                          currentAge: currentAge,
                                          retirementAge: retirementAge,
                                          lifeExpectancy: lifeExpectancy,
                                          monthlyExpenses: monthlyExpense,
                                          preRetirementReturn:
                                              preRetirementReturn,
                                          postRetirementReturn:
                                              postRetirementReturn,
                                          currentInvestment:
                                              currentInvestmentAmount,
                                          inflationRate: inflactionRate,
                                        ));
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
                                                  color: colorRed
                                                      .withOpacity(0.35))
                                            ]),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          child: isSubmit
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: colorWhite,
                                                          strokeWidth: 0.6.w))
                                              : Column(
                                                  children: [
                                                    Text('CALCULATE',
                                                        style: textStyle13Bold(
                                                            colorWhite)),
                                                  ],
                                                ),
                                        ),
                                      )),
                                ),
                              SizedBox(
                                height: 3.w,
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
                                    decoration:
                                        const BoxDecoration(color: colorE5E5),
                                    children: [
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('Corpus After Retirement',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text('Investment Required',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                      Container(
                                        height: 5.3.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Inflation Adjusted Expense',
                                            textAlign: TextAlign.center,
                                            style: textStyle10Bold(colorBlack)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              isSubmit
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Text("Calculating...",
                                          style:
                                              textStyle10Medium(colorText4D4D)),
                                    )
                                  : Table(
                                      border: TableBorder.all(color: colorE5E5),
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: FlexColumnWidth(1),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1),
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
                                                    formatter.format(double.parse(
                                                        corpusAfterRetirement)),
                                                    textAlign: TextAlign.left,
                                                    style: textStyle11Bold(
                                                            colorRedFF6)
                                                        .copyWith(height: 1.2)),
                                              ),
                                              Container(
                                                height: 43,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    formatter.format(
                                                        double.parse(
                                                            investmentRequired)),
                                                    textAlign: TextAlign.left,
                                                    style: textStyle11Bold(
                                                            colorRedFF6)
                                                        .copyWith(height: 1.2)),
                                              ),
                                              Container(
                                                height: 43,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    formatter.format(double.parse(
                                                        inflationAdjustedExpense)),
                                                    textAlign: TextAlign.left,
                                                    style: textStyle11Bold(
                                                            colorRedFF6)
                                                        .copyWith(height: 1.2)),
                                              ),
                                            ],
                                          );
                                        },
                                        growable: false,
                                      ),
                                    ),
                              SizedBox(
                                height: 3.w,
                              )
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

  textFormFieldContainer(
      String labelText, String hintText, bool isSelected, Function() onClick,
      [TextEditingController? controller, TextInputType? keyboardType]) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        onTap: widget.retirementCalculatorData.isRetirementCalculator
            ? null
            : onClick,
        child: Container(
          width: labelText == 'Current Age' || labelText == 'Retirement Age'
              ? 44.w
              : 90.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(labelText, style: textStyle10Bold(colorBlack)),
                ),
                SizedBox(
                  width: 10.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                    child: SizedBox(
                      width: labelText == 'Current Age' ||
                              labelText == 'Retirement Age'
                          ? 37.5.w - 2
                          : 84.w - 2,
                      child: TextFormField(
                        readOnly: widget
                            .retirementCalculatorData.isRetirementCalculator,
                        controller: controller,
                        style: textStyle11(colorText3D3D).copyWith(height: 1.3),
                        maxLines: 1,
                        decoration: InputDecoration.collapsed(
                            hintText: hintText,
                            hintStyle: textStyle11(colorText3D3D),
                            fillColor: colorWhite,
                            filled: true,
                            border: InputBorder.none),
                        autofocus: true,
                        focusNode: controller == _currentAgeController
                            ? currentAgeFocus
                            : controller == _retirementAgeController
                                ? retirementAgeFocus
                                : controller == _lifeExpectancyController
                                    ? lifeExpectancyFocus
                                    : controller == _monthlyExpensesController
                                        ? monthlyExpensesFocus
                                        : controller ==
                                                _preRetirementReturnController
                                            ? preRetirementReturnFocus
                                            : controller ==
                                                    _postRetirementReturnController
                                                ? postRetirementReturnFocus
                                                : controller ==
                                                        _currentInvestmentController
                                                    ? currentInvestmentFocus
                                                    : controller ==
                                                            _inflationRateController
                                                        ? inflationRateFocus
                                                        : currentAgeFocus,
                        onTap: widget
                                .retirementCalculatorData.isRetirementCalculator
                            ? null
                            : onClick,
                        onFieldSubmitted: (val) {
                          if (controller == _currentAgeController) {
                            setState(() {
                              isCurrentAgeFieldTap = false;
                              isRetirementAgeFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(retirementAgeFocus);
                          }
                          if (controller == _retirementAgeController) {
                            setState(() {
                              isRetirementAgeFieldTap = false;
                              isLifeExpectancyFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(lifeExpectancyFocus);
                          }
                          if (controller == _lifeExpectancyController) {
                            setState(() {
                              isLifeExpectancyFieldTap = false;
                              isMonthlyExpensesFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(monthlyExpensesFocus);
                          }
                          if (controller == _monthlyExpensesController) {
                            setState(() {
                              isMonthlyExpensesFieldTap = false;
                              isPreRetirementReturnFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(preRetirementReturnFocus);
                          }
                          if (controller == _preRetirementReturnController) {
                            setState(() {
                              isPreRetirementReturnFieldTap = false;
                              isPostRetirementReturnFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(postRetirementReturnFocus);
                          }
                          if (controller == _postRetirementReturnController) {
                            setState(() {
                              isPostRetirementReturnFieldTap = false;
                              isCurrentInvestmentFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(currentInvestmentFocus);
                          }
                          if (controller == _currentInvestmentController) {
                            setState(() {
                              isCurrentInvestmentFieldTap = false;
                              isInflationRateFieldTap = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(inflationRateFocus);
                          }
                          if (controller == _inflationRateController) {
                            setState(() {
                              isInflationRateFieldTap = false;
                            });
                            inflationRateFocus.unfocus();
                          }
                        },
                        keyboardType: keyboardType,
                        textInputAction: controller == _inflationRateController
                            ? TextInputAction.done
                            : TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
