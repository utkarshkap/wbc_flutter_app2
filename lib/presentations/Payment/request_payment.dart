import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/presentations/Payment/withdraw_amount.dart';
import '../../core/preferences.dart';
import '../../resources/resource.dart';

class RequestPayment extends StatefulWidget {
  static const route = '/Request-Payment';
  const RequestPayment({Key? key}) : super(key: key);

  @override
  State<RequestPayment> createState() => _RequestPaymentState();
}

class _RequestPaymentState extends State<RequestPayment> {
  bool isSendOtp = false;
  String mobileNo = '';
  String countryCode = '';

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    countryCode = await Preference.getCountryCode();
    print('countrycode------$countryCode');
    setState(() {});
  }

  sendOtp() async {
    setState(() {
      isSendOtp = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();

    print('Submitted your Number: $mobileNo');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + mobileNo,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');
        setState(() {
          isSendOtp = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.of(context).pushReplacementNamed(WithdrawAmount.route,
            arguments: WithdrawAmountData(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getMobNo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBoxGradiant0040,
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
          title: Text('Request Payment', style: textStyle14Bold(colorBlack)),
        ),
        body: Center(
          child: Container(
            height: 80.h,
            width: 90.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: decoration(colorWhite, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Image.asset(imgReqPayment,
                      height: 11.h, width: 45.w, fit: BoxFit.contain),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹ 25,000', style: textStyle26Bold(colorTextFFC1)),
                        Text('Amount available for payment',
                            style: textStyle13Bold(colorBlack)),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final boxWidth = constraints.constrainWidth();
                              const dashWidth = 17.0;
                              const dashHeight = 2.0;
                              final dashCount =
                                  (boxWidth / (2 * dashWidth)).floor();
                              return Flex(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                direction: Axis.horizontal,
                                children: List.generate(dashCount, (_) {
                                  return const SizedBox(
                                    width: dashWidth,
                                    height: dashHeight,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: colorTextBCBC),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('What\'s This ',
                                  style: textStyle13Bold(colorText8181)),
                              Image.asset(icRoundQuestionMark,
                                  color: colorRed, width: 4.w)
                            ])
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                    onTap: () {
                      sendOtp();
                    },
                    child: Container(
                      height: 6.5.h,
                      width: 80.w,
                      margin: EdgeInsets.only(bottom: 6.w),
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
                      child: isSendOtp
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: colorWhite, strokeWidth: 0.7.w))
                          : Text('SEND REQUEST',
                              style: textStyle13Bold(colorWhite)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor, double radius) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (bgColor == colorRed)
            BoxShadow(
                color: colorRed.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 3))
        ]);
  }

}