import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../../blocs/review/review_bloc.dart';
import '../../core/preferences.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../profile_screen.dart';
import 'my_MF.dart';

class TrackInvestments extends StatefulWidget {
  static const route = '/Track-Investment';

  const TrackInvestments({Key? key}) : super(key: key);

  @override
  State<TrackInvestments> createState() => _TrackInvestmentsState();
}

class _TrackInvestmentsState extends State<TrackInvestments> {
  String mobileNo = '';
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPanFieldTap = true;
  bool isEmailFieldTap = false;
  FocusNode panCardFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  String panCardValidation = '';
  String emailValidation = '';
  String autoRefreshValidation = '';
  bool autoRefreshInvestment = true;
  bool isSend = false;

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
        resizeToAvoidBottomInset: false,
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
          title: Text('Track Investments', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {
                  Navigator.of(context).pushNamed(NotificationScreen.route);
                }),
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
            if (state is MFReviewFailed) {
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
            } else if (state is MFReviewDataAdded) {
              Navigator.of(context).pushNamed(MFReviewScreen.route,
                  arguments: MFReviewScreenData(
                      panNumber: _panCardController.text,
                      isSendReview: true,
                      requestId: json
                          .decode(state.data.body)['reviewresponse']
                              ['request_id']
                          .toString()));
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: 100.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 65.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Track Mutual\nFund Investments',
                                    style: textStyle18Bold(colorBlack)
                                        .copyWith(height: 1.34)),
                                SizedBox(height: 1.5.h),
                                Text(
                                    'Enter your Email ID Linked with mutual funds investments to start tracking your portfolio.',
                                    style: textStyle9(colorText7070)
                                        .copyWith(height: 1.2)),
                              ],
                            ),
                          ),
                          Image.asset(imgTrackInvestment, width: 25.w)
                        ],
                      ),
                    ),
                    textFormFieldContainer(
                        'Pan Card', 'Enter your Pan Card No', isPanFieldTap,
                        () {
                      setState(() {
                        isPanFieldTap = true;
                        isEmailFieldTap = false;
                      });
                      panCardFocus.requestFocus();
                    }, _panCardController, TextInputType.text),
                    if (panCardValidation.isNotEmpty)
                      SizedBox(
                        height: 0.5.h,
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: panCardValidation == 'Empty PanCard'
                            ? errorText('Please Enter a Pan Card No.')
                            : panCardValidation == 'Invalid Pan Card'
                                ? errorText('Invalid Pan Number')
                                : Container(),
                      ),
                    ),
                    textFormFieldContainer(
                        'Email Id', 'Enter your Email ID', isEmailFieldTap, () {
                      setState(() {
                        isPanFieldTap = false;
                        isEmailFieldTap = true;
                      });
                      emailFocus.requestFocus();
                    }, _emailController, TextInputType.emailAddress),
                    if (emailValidation.isNotEmpty)
                      SizedBox(
                        height: 0.5.h,
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: emailValidation == 'Empty Email'
                            ? errorText('Please Enter a Email')
                            : emailValidation == 'Invalid Email'
                                ? errorText('Invalid Email')
                                : Container(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            autoRefreshInvestment = !autoRefreshInvestment;
                          });
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 1.w, right: 3.w),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Checkbox(
                                    value: autoRefreshInvestment,
                                    focusColor: colorWhite,
                                    activeColor: colorRedFFC,
                                    checkColor: colorRed,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                        color: autoRefreshValidation.isEmpty
                                            ? colorDFDF
                                            : colorErrorRed),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onChanged: (val) {
                                      setState(() {
                                        autoRefreshInvestment =
                                            !autoRefreshInvestment;
                                      });
                                    }),
                              ),
                            ),
                            Text('Auto Refresh Investments',
                                style: textStyle11(colorText7070))
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    button(icSendReview, 'Send For Review', () {
                      //Pan validation
                      if (_panCardController.text.isEmpty) {
                        setState(() {
                          panCardValidation = 'Empty PanCard';
                        });
                      } else if (!RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}')
                          .hasMatch(_panCardController.text)) {
                        print(
                            '--==-----panCard------${_panCardController.text}');
                        setState(() {
                          panCardValidation = 'Invalid Pan Card';
                        });
                      } else {
                        setState(() {
                          panCardValidation = '';
                        });
                      }

                      //Email validation
                      if (_emailController.text.isEmpty) {
                        setState(() {
                          emailValidation = 'Empty Email';
                        });
                      } else if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(_emailController.text)) {
                        print(
                            '--==-----email------${_emailController.text.length}');
                        setState(() {
                          emailValidation = 'Invalid Email';
                        });
                      } else {
                        setState(() {
                          emailValidation = '';
                        });
                      }

                      setState(() {
                        isSend = true;
                      });
                      if (_panCardController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}')
                              .hasMatch(_panCardController.text) &&
                          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(_emailController.text)) {
                        setState(() {
                          isSend = true;
                        });
                        BlocProvider.of<ReviewBloc>(context).add(CreateMFReview(
                            requestUserid: int.parse(ApiUser.userId),
                            requestMobile: mobileNo,
                            requestDate: DateTime.now().toString(),
                            requestType: 1,
                            requestSubtype: 9,
                            requestPan: _panCardController.text,
                            requestEmail: _emailController.text));
                      } else {
                        setState(() {
                          isSend = false;
                        });
                      }
                    }),
                    SizedBox(height: 2.h),
                    button(icCheckReview, 'Send Request Again', () {
                      Navigator.of(context).pushNamed(MFReviewScreen.route,
                          arguments: MFReviewScreenData(
                              panNumber: _panCardController.text,
                              isSendReview: false,
                              requestId: ''));
                    }),
                    SizedBox(height: 2.h)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorDFDF, width: 1),
        boxShadow: [
          if (bgColor == colorRed)
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
            color: text == 'Send Request Again'
                ? colorRed.withOpacity(0.17)
                : colorRed,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (text != 'Send Request Again')
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
            : Text(text, style: textStyle13Bold(colorRed)),
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
                    // autofocus: isSelected,
                    decoration: InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: textStyle11(colorText3D3D),
                        fillColor: colorWhite,
                        filled: true,
                        border: InputBorder.none),
                    focusNode: controller == _emailController
                        ? emailFocus
                        : panCardFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _panCardController) {
                        setState(() {
                          isPanFieldTap = false;
                          isEmailFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(emailFocus);
                      }
                      if (controller == _emailController) {
                        setState(() {
                          isPanFieldTap = false;
                          isEmailFieldTap = false;
                        });
                        emailFocus.unfocus();
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: controller == _emailController
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textCapitalization: controller == _panCardController
                        ? TextCapitalization.characters
                        : TextCapitalization.none,
                  ),
                ),
              ],
            ),
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
