import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:pinput/pinput.dart';

import '../../core/preferences.dart';
import '../../resources/resource.dart';

class WithdrawAmountData {
  final String verificationId;

  WithdrawAmountData({required this.verificationId});
}

class WithdrawAmount extends StatefulWidget {
  static const route = '/Withdraw-Amount';

  final WithdrawAmountData withdrawAmountData;

  const WithdrawAmount({required this.withdrawAmountData});

  @override
  State<WithdrawAmount> createState() => _WithdrawAmountState();
}

class _WithdrawAmountState extends State<WithdrawAmount> {
  String mobileNo = '';
  String countryCode = '';
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 180);
  bool isVerify = false;
  String resendVerificationId = "";
  String pinValidationString = "";
  var sms = "";
  String hiddenPhone = "";
  bool isOtpCompleted = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    countryCode = await Preference.getCountryCode();
    hiddenPhone =
        '${mobileNo.substring(0, 3)}${'X' * (mobileNo.length - 5)}${mobileNo.substring(mobileNo.length - 2)}';

    print('countryCode-------$countryCode');
    setState(() {});
  }

  startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  resetTimer() {
    reSendOtp();
    setState(() => myDuration = const Duration(seconds: 180));
    startTimer();
  }

  setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  verifyOtp() async {
    try {
      print('varificationid-----${widget.withdrawAmountData.verificationId}');

      print(resendVerificationId);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendVerificationId.isNotEmpty
              ? resendVerificationId
              : widget.withdrawAmountData.verificationId,
          smsCode: sms);

      await auth.signInWithCredential(credential);
      setState(() {
        isVerify = true;
      });
    } catch (e) {
      print('exception------');
      setState(() {
        isVerify = false;
        pinValidationString = 'The OTP Is Incorrect';
      });
    }
  }

  reSendOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    print('Submitted your Number: $mobileNo');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + mobileNo,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');
        setState(() {
          isVerify = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          resendVerificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    getMobNo();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 6.h,
      width: 13.w,
      textStyle: textStyle18Bold(colorBlack),
      decoration: const BoxDecoration(
        color: colorWhite,
        border: Border(bottom: BorderSide(color: colorTextBCBC, width: 2)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
        border: const Border(bottom: BorderSide(color: colorBlack, width: 2)),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBoxGradiant0040,
        resizeToAvoidBottomInset: false,
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
          title: Text('Withdraw Amount', style: textStyle14Bold(colorBlack)),
        ),
        extendBodyBehindAppBar: isVerify ? true : false,
        body: isVerify
            ? Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        SizedBox(height: 26.h),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 70.h,
                              width: 90.w,
                              decoration: decoration(colorWhite, 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15.h, bottom: 4.h),
                                        child: Text('Payment Request Sent',
                                            style: textStyle16Bold(
                                                colorBoxGradiant0040)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: Text(
                                            'We have received your payment request of\nRs. 25,000. It will be added to your account\nwithin 3 working days. We will notify you\nvia an SMS once the payment is\nprocessed successfully.',
                                            textAlign: TextAlign.center,
                                            style:
                                                textStyle12Medium(colorText3D3D)
                                                    .copyWith(height: 1.4)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                top: -6.5.h,
                                child: Container(
                                  height: 13.h,
                                  width: 13.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorBoxGradiant0040,
                                      border: Border.all(
                                          color: colorBoxGradiant0040,
                                          width: 2.w)),
                                  child: Image.asset(icPaymentSuccess,
                                      fit: BoxFit.fill),
                                )),
                          ],
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Lottie.asset(
                      jsonPaymentSuccess,
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              )
            : Center(
                child: Container(
                  height: 80.h,
                  width: 90.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: decoration(colorWhite, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please enter the OTP\nsent to $hiddenPhone',
                          textAlign: TextAlign.center,
                          style: textStyle18Bold(colorBoxGradiant0040)
                              .copyWith(height: 1.2)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Pinput(
                              length: 6,
                              defaultPinTheme: pinValidationString.isNotEmpty
                                  ? focusedPinTheme
                                  : defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: pinValidationString.isNotEmpty
                                  ? focusedPinTheme
                                  : submittedPinTheme,
                              showCursor: true,
                              onCompleted: (pin) {
                                setState(() {
                                  isOtpCompleted = true;
                                });
                                verifyOtp();
                              },
                              onChanged: (val) {
                                sms = val;
                              },
                            ),
                            if (pinValidationString.isNotEmpty)
                              SizedBox(
                                height: 1.h,
                              ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  if (pinValidationString ==
                                      'The OTP Is Incorrect')
                                    SizedBox(
                                      height: 2.h,
                                      child: Text(' The OTP Is Incorrect',
                                          style: textStyle9(colorErrorRed)),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),
                            if (myDuration.inSeconds > 0)
                              Text('Expires in ${myDuration.inSeconds} seconds',
                                  textAlign: TextAlign.center,
                                  style: textStyle12Medium(colorText4D4D)),
                            SizedBox(height: 1.5.h),
                            myDuration.inSeconds == 0
                                ? InkWell(
                                    onTap: resetTimer,
                                    child: Text('Resend OTP',
                                        style:
                                            textStyle12Bold(colorRed).copyWith(
                                          decoration: TextDecoration.underline,
                                        )),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
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
