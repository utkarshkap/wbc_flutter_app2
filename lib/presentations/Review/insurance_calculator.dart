import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/blocs/insurancecalculator/insurance_calculator_bloc.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import '../../resources/resource.dart';
import '../../thousandsSeparatorInputFormatter.dart';
import '../../widgets/appbarButton.dart';

class InsuranceCalculator extends StatefulWidget {
  static const route = '/Insurance-Calculator';

  const InsuranceCalculator({super.key});

  @override
  State<InsuranceCalculator> createState() => _InsuranceCalculatorState();
}

class _InsuranceCalculatorState extends State<InsuranceCalculator> {
  final TextEditingController _monthlyIncomeController =
      TextEditingController(text: "0");
  final TextEditingController _lifeInsuranceController =
      TextEditingController(text: "0");
  final TextEditingController _homeLoanController =
      TextEditingController(text: "0");
  final TextEditingController _loanController =
      TextEditingController(text: "0");
  final TextEditingController _savingsController =
      TextEditingController(text: "0");

  String annualIncomeValidation = "";
  String lifeInsuranceValidation = "";
  String homeLoanValidation = "";
  String loanValidation = "";
  String savingsValidation = "";

  bool isIncomeFieldTap = false;
  bool isLifeInsuranceFieldTap = false;
  bool isHomeLoanFieldTap = false;
  bool isLoanFieldTap = false;
  bool isSavingFieldTap = false;

  FocusNode incomeFocus = FocusNode();
  FocusNode homeLoanFocus = FocusNode();
  FocusNode loanFocus = FocusNode();
  FocusNode lifeInsuranceFocus = FocusNode();
  FocusNode savingFocus = FocusNode();

  String requiredLifeCover = "";

  var formatter = NumberFormat('#,##,000');
  bool isSubmit = false;
  bool isDisplayResult = false;

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
              Text('Insurance Calculator', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<InsuranceCalculatorBloc, InsuranceCalculatorState>(
          listener: (context, state) {
            print('insurancestate-------$state');
            if (state is InsuranceCalculatorFailed) {
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
            } else if (state is InsuranceCalculatorAdded) {
              setState(() {
                isSubmit = false;
                isDisplayResult = true;
                requiredLifeCover = state.requiredInsurance;

                print(
                    "requiredInsurance::::::::::::${state.requiredInsurance}");
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
                                        'Check if\nyou have Enough\nInsurance',
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
                                    textFormFieldContainer(
                                        'My Annual Income is',
                                        'Enter your Annual Income',
                                        isIncomeFieldTap, () {
                                      setState(() {
                                        isIncomeFieldTap = true;
                                        isLifeInsuranceFieldTap = false;
                                        isHomeLoanFieldTap = false;
                                        isLoanFieldTap = false;
                                        isSavingFieldTap = false;
                                      });
                                      incomeFocus.requestFocus();
                                    }, _monthlyIncomeController),
                                    if (annualIncomeValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: annualIncomeValidation ==
                                                'Empty annual Income'
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
                                    textFormFieldContainer(
                                        'Existing life cover, if any',
                                        'Enter your Existing life cover',
                                        isLifeInsuranceFieldTap, () {
                                      setState(() {
                                        isIncomeFieldTap = false;
                                        isLifeInsuranceFieldTap = true;
                                        isHomeLoanFieldTap = false;
                                        isLoanFieldTap = false;
                                        isSavingFieldTap = false;
                                      });
                                      lifeInsuranceFocus.requestFocus();
                                    }, _lifeInsuranceController),
                                    if (lifeInsuranceValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: lifeInsuranceValidation ==
                                                'Empty Life Insurance'
                                            ? errorText(
                                                'Please Enter Life Insurance.')
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
                                    textFormFieldContainer(
                                        'Outstanding home loan if any',
                                        'Enter your Outstanding home loan',
                                        isHomeLoanFieldTap, () {
                                      setState(() {
                                        isIncomeFieldTap = false;
                                        isLifeInsuranceFieldTap = false;
                                        isHomeLoanFieldTap = true;
                                        isLoanFieldTap = false;
                                        isSavingFieldTap = false;
                                      });
                                      homeLoanFocus.requestFocus();
                                    }, _homeLoanController),
                                    if (homeLoanValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: homeLoanValidation ==
                                                'Empty Home Loan'
                                            ? errorText(
                                                'Please Enter Home Loan.')
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
                                    textFormFieldContainer(
                                        'Other outstanding loans',
                                        'Enter your Other outstanding loans',
                                        isLoanFieldTap, () {
                                      setState(() {
                                        isIncomeFieldTap = false;
                                        isLifeInsuranceFieldTap = false;
                                        isHomeLoanFieldTap = false;
                                        isLoanFieldTap = true;
                                        isSavingFieldTap = false;
                                      });
                                      loanFocus.requestFocus();
                                    }, _loanController),
                                    if (loanValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: loanValidation == 'Empty Loan'
                                            ? errorText('Please Enter Loan.')
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
                                    textFormFieldContainer(
                                        'I have existing savings of',
                                        'Enter your Savings',
                                        isSavingFieldTap, () {
                                      setState(() {
                                        isIncomeFieldTap = false;
                                        isLifeInsuranceFieldTap = false;
                                        isHomeLoanFieldTap = false;
                                        isLoanFieldTap = false;
                                        isSavingFieldTap = true;
                                      });
                                      savingFocus.requestFocus();
                                    }, _savingsController),
                                    if (savingsValidation.isNotEmpty)
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: savingsValidation ==
                                                'Empty Savings'
                                            ? errorText('Please Enter Savings.')
                                            : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 2.h, bottom: 2.5.h),
                                child: InkWell(
                                    onTap: () {
                                      if (_monthlyIncomeController
                                          .text.isEmpty) {
                                        setState(() {
                                          annualIncomeValidation =
                                              'Empty annual Income';
                                        });
                                      } else {
                                        setState(() {
                                          annualIncomeValidation = '';
                                        });
                                      }
                                      if (_lifeInsuranceController
                                          .text.isEmpty) {
                                        setState(() {
                                          lifeInsuranceValidation =
                                              'Empty Life Insurance';
                                        });
                                      } else {
                                        setState(() {
                                          lifeInsuranceValidation = '';
                                        });
                                      }
                                      if (_homeLoanController.text.isEmpty) {
                                        setState(() {
                                          homeLoanValidation =
                                              'Empty Home Loan';
                                        });
                                      } else {
                                        setState(() {
                                          homeLoanValidation = '';
                                        });
                                      }
                                      if (_loanController.text.isEmpty) {
                                        setState(() {
                                          loanValidation = 'Empty Loan';
                                        });
                                      } else {
                                        setState(() {
                                          loanValidation = '';
                                        });
                                      }
                                      if (_savingsController.text.isEmpty) {
                                        setState(() {
                                          savingsValidation = 'Empty Savings';
                                        });
                                      } else {
                                        setState(() {
                                          savingsValidation = '';
                                        });
                                      }
                                      if (_monthlyIncomeController.text.isNotEmpty &&
                                          _lifeInsuranceController
                                              .text.isNotEmpty &&
                                          _homeLoanController.text.isNotEmpty &&
                                          _loanController.text.isNotEmpty &&
                                          _savingsController.text.isNotEmpty) {
                                        setState(() {
                                          isSubmit = true;
                                        });
                                        calculateInsurance();
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
                              isDisplayResult
                                  ? Column(
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
                                                  child: Text('Required Cover',
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
                                                        formatter.format(
                                                            double.parse(
                                                                requiredLifeCover)),
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
                                    )
                                  : Container()
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

  void calculateInsurance() {
    BlocProvider.of<InsuranceCalculatorBloc>(context).add(PostInsuranceData(
      name: "",
      gender: "",
      annualincome:
          int.parse(_monthlyIncomeController.text.replaceAll(',', '')),
      existinglifecover:
          int.parse(_lifeInsuranceController.text.replaceAll(',', '')),
      totalloandue: int.parse(_loanController.text.replaceAll(',', '')),
      totalsaving: int.parse(_savingsController.text.replaceAll(',', '')),
      insDate: DateTime.now(),
      totalHomeLoanDue: int.parse(_homeLoanController.text.replaceAll(',', '')),
    ));
  }

  textFormFieldContainer(
      String labelText, String hintText, bool isSelected, Function() onClick,
      [TextEditingController? controller]) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h, left: 2.5.w, right: 2.5.w),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(labelText, style: textStyle10Bold(colorBlack)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                child: SizedBox(
                  width: 84.w - 2,
                  child: TextFormField(
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
                    focusNode: controller == _monthlyIncomeController
                        ? incomeFocus
                        : controller == _lifeInsuranceController
                            ? lifeInsuranceFocus
                            : controller == _homeLoanController
                                ? homeLoanFocus
                                : controller == _loanController
                                    ? loanFocus
                                    : controller == _savingsController
                                        ? savingFocus
                                        : incomeFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _monthlyIncomeController) {
                        setState(() {
                          isIncomeFieldTap = false;
                          isLifeInsuranceFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(lifeInsuranceFocus);
                      }
                      if (controller == _lifeInsuranceController) {
                        setState(() {
                          isLifeInsuranceFieldTap = false;
                          isLifeInsuranceFieldTap = true;
                        });
                        lifeInsuranceFocus.unfocus();
                      }
                      if (controller == _homeLoanController) {
                        setState(() {
                          isHomeLoanFieldTap = false;
                          isLoanFieldTap = true;
                        });
                        homeLoanFocus.unfocus();
                      }
                      if (controller == _loanController) {
                        setState(() {
                          isLoanFieldTap = false;
                          isSavingFieldTap = true;
                        });
                        loanFocus.unfocus();
                      }
                      if (controller == _savingsController) {
                        setState(() {
                          isSavingFieldTap = false;
                        });
                        savingFocus.unfocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      ThousandsSeparatorInputFormatter(),
                    ],
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),
            ],
          ),
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
