import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/Review/history.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../common_functions.dart';
import '../../core/api/api_consts.dart';
import '../../core/preferences.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../home_screen.dart';
import '../profile_screen.dart';

class LoanEMIReview extends StatefulWidget {
    static const route = '/Loan-EMI-Review';
    const LoanEMIReview({Key? key}) : super(key: key);

    @override
    State<LoanEMIReview> createState() => _LoanEMIReviewState();
}

class _LoanEMIReviewState extends State<LoanEMIReview> {

    String selectedBankType = 'Select Bank';
    final TextEditingController _loanAmountController = TextEditingController();
    final TextEditingController _tenureController = TextEditingController();
    final TextEditingController _interestController = TextEditingController();
    final TextEditingController _emiAmountController = TextEditingController();
    bool isBankFieldTap = true;
    bool isLoanAmountFieldTap = false;
    bool isTenureFieldTap = false;
    bool isInterestFieldTap = false;
    bool isEMIAmountFieldTap = false;
    FocusNode loanAmountFocus = FocusNode();
    FocusNode tenureFocus = FocusNode();
    FocusNode interestFocus = FocusNode();
    FocusNode emiAmountFocus = FocusNode();
    String bankValidation = '';
    String loanAmountValidation = '';
    String tenureValidation = '';
    String interestValidation = '';
    String emiAmountValidation = '';
    bool isSend = false;
    String mobileNo = '';

    getMobNo() async {
      mobileNo = await Preference.getMobNo();
      setState(() {});
    }

    @override
    void initState() {
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
              title: Text('Review loan EMI', style: textStyle14Bold(colorBlack)),
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
                    icon: icProfile,
                    iconColor: colorText7070,
                    onClick: () {
                      Navigator.of(context).pushNamed(ProfileScreen.route);
                    }),
                SizedBox(width: 5.w)
              ],
            ),
            body: BlocConsumer<ReviewBloc, ReviewState>(
              listener: (context, state) {
                if (state is LoanReviewFailed) {
                  isSend = false;
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
                } else if (state is LoanReviewDataAdded) {
                  BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                      popular: Popular(code: 0, message: '', products: []),
                      newArrival: NewArrival(code: 0, message: '', products: []),
                      trending: Trending(code: 0, message: '', products: [])));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.route, (route) => false,
                      arguments: HomeScreenData(acceptedContacts: '', isSendReview: 'SendReview'));
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
                              SizedBox(height: 1.h),
                              Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<FetchingDataBloc>(context).add(LoadLoanBanksEvent(loanBanks: const []));
                                    setState(() {
                                      isBankFieldTap = true;
                                      isLoanAmountFieldTap = false;
                                      isTenureFieldTap = false;
                                      isInterestFieldTap = false;
                                      isEMIAmountFieldTap = false;
                                    });
                                    loanAmountFocus.unfocus();
                                    tenureFocus.unfocus();
                                    interestFocus.unfocus();
                                    emiAmountFocus.unfocus();
                                    CommonFunction().selectFormDialog(
                                        context, 'Select Bank', [], (val) {
                                      setState(() {
                                        selectedBankType = val;
                                        isBankFieldTap = false;
                                        isLoanAmountFieldTap = true;
                                        isTenureFieldTap = false;
                                        isInterestFieldTap = false;
                                        isEMIAmountFieldTap = false;
                                      });
                                      loanAmountFocus.requestFocus();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: isBankFieldTap ? colorRed : colorDFDF,
                                            width: 1)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1.h),
                                            child: Text('Choose your bank',
                                                style: textStyle9(colorText8181)),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                                            child: SizedBox(
                                              width: 84.w - 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(selectedBankType,
                                                        style:
                                                        textStyle11(colorText3D3D)),
                                                  ),
                                                  Image.asset(icDropdown,
                                                      color: colorText3D3D, width: 5.w)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (bankValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: bankValidation == 'Empty Bank'
                                      ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Select a bank',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer('Loan amount', 'Enter your amount',
                                  isLoanAmountFieldTap, () {
                                    setState(() {
                                      isBankFieldTap = false;
                                      isLoanAmountFieldTap = true;
                                      isTenureFieldTap = false;
                                      isInterestFieldTap = false;
                                      isEMIAmountFieldTap = false;
                                    });
                                    loanAmountFocus.requestFocus();
                                  }, _loanAmountController, TextInputType.number
                              ),
                              if (loanAmountValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: loanAmountValidation == 'Empty Amount'
                                      ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Enter an Amount',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer(
                                  'Tenure', 'Enter your tenure', isTenureFieldTap, () {
                                setState(() {
                                  isBankFieldTap = false;
                                  isLoanAmountFieldTap = false;
                                  isTenureFieldTap = true;
                                  isInterestFieldTap = false;
                                  isEMIAmountFieldTap = false;
                                });
                                tenureFocus.requestFocus();
                              }, _tenureController, TextInputType.text),
                              if (tenureValidation.isNotEmpty) SizedBox(
                                height: 0.5.h,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: tenureValidation == 'Empty Tenure'
                                      ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Enter a tenure',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer('Rate of Interest',
                                  'Enter your Interest rate', isInterestFieldTap, () {
                                    setState(() {
                                      isBankFieldTap = false;
                                      isLoanAmountFieldTap = false;
                                      isTenureFieldTap = false;
                                      isInterestFieldTap = true;
                                      isEMIAmountFieldTap = false;
                                    });
                                    interestFocus.requestFocus();
                                  }, _interestController, TextInputType.number),
                              if (interestValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: interestValidation == 'Empty Interest'
                                      ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error, color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Enter an Interest Rate',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer(
                                  'EMI', 'Enter your EMI amount', isEMIAmountFieldTap,
                                      () {
                                    setState(() {
                                      isBankFieldTap = false;
                                      isLoanAmountFieldTap = false;
                                      isTenureFieldTap = false;
                                      isInterestFieldTap = false;
                                      isEMIAmountFieldTap = true;
                                    });
                                    emiAmountFocus.requestFocus();
                                  }, _emiAmountController, TextInputType.number
                              ),
                              if (emiAmountValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: emiAmountValidation == 'Empty Amount'
                                  ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error, color: colorRed, size: 13),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Enter an Amount',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ),
                              ),
                              if (bankValidation.isEmpty ||
                                  loanAmountValidation.isEmpty ||
                                  tenureValidation.isEmpty ||
                                  interestValidation.isEmpty ||
                                  emiAmountValidation.isEmpty)
                                SizedBox(height: 4.5.h),
                              button(icSendReview, 'Send For Review', () {
                                if (selectedBankType == 'Select Bank') {
                                  setState(() {
                                    bankValidation = 'Empty Bank';
                                  });
                                } else {
                                  setState(() {
                                    bankValidation = '';
                                  });
                                }
                                if (_loanAmountController.text.isEmpty) {
                                  setState(() {
                                    loanAmountValidation = 'Empty Amount';
                                  });
                                } else {
                                  setState(() {
                                    loanAmountValidation = '';
                                  });
                                }
                                if (_tenureController.text.isEmpty) {
                                  setState(() {
                                    tenureValidation = 'Empty Tenure';
                                  });
                                } else {
                                  setState(() {
                                    tenureValidation = '';
                                  });
                                }
                                if (_interestController.text.isEmpty) {
                                  setState(() {
                                    interestValidation = 'Empty Interest';
                                  });
                                } else {
                                  setState(() {
                                    interestValidation = '';
                                  });
                                }
                                if (_emiAmountController.text.isEmpty) {
                                  setState(() {
                                    emiAmountValidation = 'Empty Amount';
                                  });
                                } else {
                                  setState(() {
                                    emiAmountValidation = '';
                                  });
                                }
                                if (selectedBankType != 'Select Bank' &&
                                    _loanAmountController.text.isNotEmpty &&
                                    _tenureController.text.isNotEmpty &&
                                    _interestController.text.isNotEmpty &&
                                    _emiAmountController.text.isNotEmpty) {
                                  setState(() {
                                    isSend = true;
                                  });
                                  BlocProvider.of<ReviewBloc>(context).add(
                                      CreateLoanReview(
                                          userid: int.parse(ApiUser.userId),
                                          mobile: mobileNo,
                                          bankname: selectedBankType,
                                          loantype: 1,
                                          loanamount: int.parse(_loanAmountController.text),
                                          tenure: int.parse(_tenureController.text),
                                          email: int.parse(_emiAmountController.text),
                                          rateofinterest: double.parse(_interestController.text)));
                                }
                              }),
                              SizedBox(height: 2.h),
                              button(icCheckReview, 'Check Review Report', () {
                                BlocProvider.of<ReviewBloc>(context).add(LoadReviewHistoryEvent(mobNo: mobileNo));
                                Navigator.of(context).pushNamed(ReviewHistory.route);
                              }),
                              SizedBox(height: 2.h)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                },
            )
        ),
      );
    }

    BoxDecoration decoration(Color bgColor) {
      return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (bgColor == colorWhite)
              BoxShadow(
                  color: colorTextBCBC.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 6))
          ]);
    }

    button(String icon, String text, Function() onClick) {
      return InkWell(
        onTap: onClick,
        child: Container(
          height: 6.5.h,
          width: 90.w,
          decoration: BoxDecoration(
              color: text == 'Check Review Report'
                  ? colorRed.withOpacity(0.17)
                  : colorRed,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (text != 'Check Review Report')
                  BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: colorRed.withOpacity(0.3))
              ]),
          alignment: Alignment.center,
          child: text == 'Send For Review'
              ? isSend
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: colorWhite, strokeWidth: 0.6.w))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(icon, width: 4.w),
                        SizedBox(width: 2.5.w),
                        Text(text, style: textStyle13Bold(colorWhite)),
                      ],
                    )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(icon, width: 4.w),
                    SizedBox(width: 2.5.w),
                    Text(text, style: textStyle13Bold(colorRed)),
                  ],
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
          onTap: onClick,
          child: Container(
            height: 8.h,
            decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isSelected ? colorRed : colorDFDF, width: 1)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(labelText, style: textStyle9(colorText8181)),
                  SizedBox(
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
                      focusNode: controller == _tenureController
                          ? tenureFocus
                          : controller == _interestController
                              ? interestFocus
                              : controller == _emiAmountController
                                  ? emiAmountFocus
                                  : loanAmountFocus,
                      onTap: onClick,
                      onFieldSubmitted: (val) {
                        if (controller == _loanAmountController) {
                          setState(() {
                            isLoanAmountFieldTap = false;
                            isTenureFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(tenureFocus);
                        }
                        if (controller == _tenureController) {
                          setState(() {
                            isTenureFieldTap = false;
                            isInterestFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(interestFocus);
                        }
                        if (controller == _interestController) {
                          setState(() {
                            isInterestFieldTap = false;
                            isEMIAmountFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(emiAmountFocus);
                        }
                      },
                      keyboardType: keyboardType,
                      textInputAction: controller == _emiAmountController
                          ? TextInputAction.done
                          : TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
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