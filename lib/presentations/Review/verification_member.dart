import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/family_member_model.dart';

import '../../blocs/dashboardbloc/dashboard_bloc.dart';
import '../../blocs/signingbloc/signing_bloc.dart';
import '../../resources/resource.dart';
import '../home_screen.dart';

class VerificationMemberData {
  final FamilyMemberModel familyMemberModel;
  final String mono;
  final String verificationId;

  VerificationMemberData(
      {required this.familyMemberModel,
      required this.mono,
      required this.verificationId});
}

class VerificationMember extends StatefulWidget {
  static const route = '/Verification-Member';

  final VerificationMemberData verificationMemberData;

  VerificationMember({required this.verificationMemberData});

  @override
  State<VerificationMember> createState() => _VerificationMemberState();
}

class _VerificationMemberState extends State<VerificationMember> {
  String pinValidationString = "";
  bool isOtpCompleted = false;
  String sms = "";
  Duration myDuration = const Duration(seconds: 30);
  Timer? countdownTimer;
  bool isVerify = false;
  String resendVerificationId = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  resetTimer() {
    reSendOtp();
    setState(() => myDuration = const Duration(seconds: 30));
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
      setState(() {
        isVerify = true;
      });
      print(
          'varificationid-----${widget.verificationMemberData.verificationId}');

      print(resendVerificationId);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendVerificationId.isNotEmpty
              ? resendVerificationId
              : widget.verificationMemberData.verificationId,
          smsCode: sms);

      await auth.signInWithCredential(credential);
      BlocProvider.of<DashboardBloc>(context).add(SetFamilyMemberData(
          familyMemberModel: widget.verificationMemberData.familyMemberModel));
    } catch (e) {
      print('exception------');
      setState(() {
        isVerify = false;
        pinValidationString = 'The Code Is Incorrect';
      });
    }
  }

  reSendOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    print('Submitted your Number: ${widget.verificationMemberData.mono}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.verificationMemberData.mono,
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
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final defaultPinTheme = PinTheme(
      height: 6.h,
      width: 13.w,
      textStyle: textStyle18Bold(colorBlack),
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: colorDFDF, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
        border: Border.all(color: colorRed, width: 1),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
      ),
    );
    return Scaffold(
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
        title: Text('Verification', style: textStyle14Bold(colorBlack)),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is FamilyMemberFailed) {
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
            } else if (state is FamilyMemberAdded) {
              if (state.message == "Duplicate Mobile no ") {
                CommonFunction()
                    .errorDialog(context, 'This number is already added.');
                isVerify = false;
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.route, (route) => false,
                    arguments: HomeScreenData(isSendReview: "FamilyMember"));
              }
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: 100.w,
                    color: colorBG,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Text('Verify Account',
                              style: textStyle22Bold(colorBlack)),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text('Enter 6-digit code we have sent to at',
                              style: textStyle10(colorText3D3D)),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(widget.verificationMemberData.mono,
                              style: textStyle10Bold(colorText7070).copyWith(
                                decoration: TextDecoration.underline,
                              )),
                          SizedBox(
                            height: 7.h,
                          ),
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
                                    'The Code Is Incorrect')
                                  SizedBox(
                                    height: 2.h,
                                    child: Text(' The Code Is Incorrect',
                                        style: textStyle9(colorErrorRed)),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text('Didn’t received the code?',
                              style: textStyle10(colorText3D3D)),
                          SizedBox(
                            height: 1.h,
                          ),
                          myDuration.inSeconds > 0
                              ? Text(
                                  '$minutes:$seconds',
                                  style: textStyle11Medium(colorBlack)
                                      .copyWith(letterSpacing: 0.5.sp),
                                )
                              : InkWell(
                                  onTap: resetTimer,
                                  child: Text('Resend Code',
                                      style:
                                          textStyle11Medium(colorRed).copyWith(
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                          const Spacer(),
                          button(
                            'NEXT',
                            isOtpCompleted ? null : verifyOtp,
                          ),
                          SizedBox(
                            height: 7.h,
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

  button(
    String text,
    Function()? onClick,
  ) {
    return InkWell(
      onTap: onClick,
      child: Container(
          height: 6.5.h,
          width: 90.w,
          decoration: BoxDecoration(
              color: text == 'SKIP' ? colorRed.withOpacity(0.17) : colorRed,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                if (text != 'SKIP')
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      color: colorTextBCBC.withOpacity(0.3))
              ]),
          alignment: Alignment.center,
          child: isVerify
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: colorWhite, strokeWidth: 0.7.w))
              : Text(text, style: textStyle13Bold(colorWhite))),
    );
  }
}
