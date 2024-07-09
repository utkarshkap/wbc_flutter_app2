import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/signingbloc/signing_bloc.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/presentations/social_login.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import '../core/Google_SignIn.dart';
import '../resources/resource.dart';
import '../widgets/country_picker/country.dart';
import '../widgets/country_picker/country_code_picker.dart';
import 'dart:io';

class SigInPage extends StatefulWidget {
  static const route = '/SigIn';
  const SigInPage({Key? key}) : super(key: key);

  @override
  State<SigInPage> createState() => _SigInPageState();
}

class _SigInPageState extends State<SigInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _numController = TextEditingController();
  FocusNode numNode = FocusNode();
  String countryCode = '+91';
  String validationString = "";
  bool isSendOtp = false;
  bool isLoading = false;

  sendOtp() async {
    setState(() {
      isSendOtp = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    Preference.setMobNo(_numController.text);
    Preference.setCountryCode(countryCode);

    print('Submitted your Number: $countryCode${_numController.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + _numController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');

        setState(() {
          validationString = 'Invalid Number';
          isSendOtp = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print("verificationId--->" + verificationId.toString());
        Navigator.of(context).pushReplacementNamed(VerificationScreen.route,
            arguments: VerificationScreenData(
                getNumber: _numController.text.replaceAll(' ', ''),
                number: "$countryCode ${_numController.text}",
                verificationId: verificationId.toString(),
                selectedContact: 0));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    // Navigator.of(context).pushReplacementNamed(VerificationScreen.route,
    //     arguments: VerificationScreenData(
    //         getNumber: _numController.text.replaceAll(' ', ''),
    //         number: "$countryCode ${_numController.text}",
    //         verificationId: "",
    //         selectedContact: 0));
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerPage();
    if (country != null) {
      setState(() {
        countryCode = country.isdcode;
      });
    }
  }

  Future<Country?> showCountryPickerPage({
    Widget? title,
    double cornerRadius = 35,
    bool focusSearchBox = false,
  }) {
    return showDialog<Country?>(
        context: context,
        barrierDismissible: true,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(cornerRadius))),
              child: SizedBox(
                height: 55.h,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Stack(
                      children: <Widget>[
                        Center(
                          child: title ??
                              const Text(
                                'Choose region',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: CountryPickerWidget(
                          onSelected: (country) =>
                              Navigator.of(context).pop(country)),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBG,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text('Let’s Sign You In',
                        style: textStyle22Bold(colorBlack)),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text('Welcome Back, you’ve been missed!',
                        style: textStyle10(colorText7070)),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 9.h,
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: validationString.isEmpty
                                  ? colorDFDF
                                  : colorErrorRed,
                              width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mobile Number',
                                    style: textStyle8(colorTextBCBC)),
                                SizedBox(height: 0.5.h),
                                SizedBox(
                                  height: 5.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: _showCountryPicker,
                                        child: Container(
                                          height: 4.5.h,
                                          width: 20.w,
                                          decoration: BoxDecoration(
                                              color: colorTextBCBC
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 1.w),
                                                child: Text(
                                                  countryCode,
                                                  style: textStyle13Bold(
                                                      colorBlack),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      SizedBox(
                                          width: 60.w,
                                          child: TextFormField(
                                            controller: _numController,
                                            style: textStyle14Bold(colorBlack),
                                            focusNode: numNode,
                                            maxLength:
                                                countryCode == '+91' ? 10 : 15,
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter Your Mobile Number',
                                                hintStyle:
                                                    textStyle11(colorText7070),
                                                border: InputBorder.none,
                                                counter:
                                                    const SizedBox.shrink(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 1.4.h)),
                                            onChanged: (val) {
                                              setState(() {
                                                validationString = '';
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (validationString.isNotEmpty)
                      SizedBox(
                        height: 1.h,
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Column(
                          children: [
                            if (validationString == 'Empty String')
                              SizedBox(
                                height: 2.h,
                                child: Text('Please Enter a Number',
                                    style: textStyle8Medium(colorErrorRed)),
                              ),
                            if (validationString == 'Invalid String')
                              SizedBox(
                                height: 2.h,
                                child: Text('Please Enter a valid Number',
                                    style: textStyle8Medium(colorErrorRed)),
                              ),
                            if (validationString == 'Invalid Number')
                              SizedBox(
                                height: 2.h,
                                child: Text('Invalid Number',
                                    style: textStyle8Medium(colorErrorRed)),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    BlocListener<SigningBloc, SigningState>(
                      listener: (context, state) {
                        if (state is PendingDeleteUserDataAdded) {
                          setState(() {
                            isLoading = false;
                          });
                          if (state.message ==
                              'Your account is queued for deletion.') {
                            accountRestricteDialogBox();
                          } else {
                            sendOtp();
                          }
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          if (_numController.text.isEmpty) {
                            setState(() {
                              validationString = 'Empty String';
                            });
                          } else {
                            print(
                                '--==-----num------${_numController.text.length}');
                            if (_numController.text.replaceAll(' ', '').length <
                                    10 ||
                                _numController.text.replaceAll(' ', '').length >
                                    10) {
                              setState(() {
                                validationString = 'Invalid String';
                              });
                            } else {
                              print(
                                  'Submitted your Number: ${_numController.text.trim()}');
                              setState(() {
                                validationString = '';
                              });
                              BlocProvider.of<SigningBloc>(context).add(
                                  GetPendingDeleteUser(
                                      mobileNo: _numController.text));
                              isLoading = true;
                            }
                          }
                          print(
                              '--==-----validationString------$validationString');
                        },
                        child: Container(
                          height: 6.5.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              color: colorRed,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Color(0x00000029))
                              ]),
                          alignment: Alignment.center,
                          child: isSendOtp || isLoading == true
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: colorWhite, strokeWidth: 0.7.w))
                              : Text('NEXT',
                                  style: textStyle13Bold(colorWhite)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      height: validationString.isEmpty ? 20.h : 17.h,
                    ),
                    if (Platform.isIOS) ...[Container()]
                    // else ...[
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         height: 0.05.h,
                    //         width: 15.w,
                    //         color: colorTextBCBC,
                    //       ),
                    //       SizedBox(width: 2.w),
                    //       Text('OR', style: textStyle9Bold(colorText4D4D)),
                    //       SizedBox(width: 2.w),
                    //       Container(
                    //         height: 0.05.h,
                    //         width: 15.w,
                    //         color: colorTextBCBC,
                    //       )
                    //     ],
                    //   ),
                    //   SizedBox(
                    //     height: 3.h,
                    //   ),
                    //   logInWithButtons(
                    //     icGoogle,
                    //     'Continue with Google',
                    //     () {
                    //       GoogleSignIn();
                    //     },
                    //   ),
                    //   SizedBox(
                    //     height: 1.h,
                    //   ),
                    //   logInWithButtons(
                    //     icFacebook,
                    //     'Continue with Facebook',
                    //     () {},
                    //   ),
                    //   SizedBox(
                    //     height: 1.h,
                    //   ),
                    //   logInWithButtons(
                    //     icApple,
                    //     'Continue with Apple',
                    //     () {},
                    //   ),
                    //   SizedBox(
                    //     height: 3.h,
                    //   ),
                    // ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  logInWithButtons(String icon, String title, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 6.5.h,
        width: 90.w,
        decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3), blurRadius: 6, color: Color(0x00000005))
            ]),
        alignment: Alignment.center,
        child: Row(
          children: [
            SizedBox(width: 4.w),
            Image.asset(icon, width: 4.5.w),
            const Spacer(),
            Text(title, style: textStyle11Bold(colorText7070)),
            const Spacer(),
            SizedBox(width: 4.w),
          ],
        ),
      ),
    );
  }

  GoogleSignIn() {
    signInWithGoogle().then((result) {
      if (result != null) {
        Navigator.of(context).pushReplacementNamed(SocialLogin.route,
            arguments: SocialLoginData(
              loginType: '',
              googleId: userid.toString(),
              name: name.toString(),
              email: email.toString(),
              phoneNo: phoneNo.toString(),
              selectedContact: 0,
            ));
        print("result-->>$result");
        print("name-->>$name");
        print("userid-->>$userid");
        print("imageUrl-->>$imageUrl");
        print("email-->>$email");
        print("phoneNo-->>$phoneNo");
        print("accessToken-->>$accessToken");
        print("idToken-->>$idToken");
      }
    });
  }

  accountRestricteDialogBox() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: 20.h,
                        width: deviceWidth(context) * 0.778,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Your account is restricted. Please contact to support@kagroup.in for more information',
                                  style: textStyle13Medium(colorBlack)
                                      .copyWith(height: 1.2)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  splashColor: colorWhite,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('okay',
                                      style: textStyle13Bold(colorBlack)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
      ),
      body: Container(
        child: CountryPickerWidget(
          onSelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}
