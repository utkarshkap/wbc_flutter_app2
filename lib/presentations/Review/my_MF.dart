import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/get_gmail_inbox_model.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../common_functions.dart';
import '../../core/Google_SignIn.dart';
import '../../core/preferences.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../home_screen.dart';
import 'history.dart';

class MFReviewScreenData {
  final String panNumber;
  final bool isSendReview;

  MFReviewScreenData({required this.panNumber, required this.isSendReview});
}

class MFReviewScreen extends StatefulWidget {
  static const route = '/MF-Review';
  final MFReviewScreenData mfReviewScreenData;

  const MFReviewScreen({super.key, required this.mfReviewScreenData});

  @override
  State<MFReviewScreen> createState() => _MFReviewScreenState();
}

class _MFReviewScreenState extends State<MFReviewScreen> {
  String mobileNo = '';
  String email = '';
  bool uploadEventTap = false;
  String fileValidation = '';
  bool isSend = false;
  String panCardValidation = '';
  String fileName = 'Upload your stock investment PDF';
  bool isPanFieldTap = true;

  bool isLogin = false;

  final TextEditingController _panCardController = TextEditingController();

  FocusNode panCardFocus = FocusNode();

  File? uploadFile;

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    email = await Preference.getEmail();
    setState(() {});
  }

  @override
  void initState() {
    getMobNo();
    _panCardController.text = widget.mfReviewScreenData.panNumber;
    if (widget.mfReviewScreenData.isSendReview) {
      Future.delayed(Duration.zero, () {
        CommonFunction().successPopup(
            context,
            'Thank You',
            'You will get your MF investment review report withing 24 hours in your register email.',
            jsonReviewSuccess,
            mobileNo);
      });
    }
    super.initState();
  }

  pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      uploadFile = File(result.files.single.path!);

      setState(() {
        fileName = uploadFile!.path.split('/').last;
        fileValidation = '';
      });

      print('uploadfilepath------$uploadFile');
    } else {}
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(HomeScreen.route, (route) => false,
                        arguments: HomeScreenData(
                          acceptedContacts: '',
                        ));
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('Review My Mutual Funds',
              style: textStyle14Bold(colorBlack)),
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
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: BlocConsumer<ReviewBloc, ReviewState>(
              listener: (context, state) {
                if (state is UploadMFReviewFailed) {
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
                } else if (state is UploadReviewDataAdded) {
                  Navigator.of(context).pushReplacementNamed(HomeScreen.route,
                      arguments: HomeScreenData(isSendReview: 'SendReview'));
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Container(
                          decoration: decoration(colorWhite),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(imgLearnStocks,
                                      height: 23.h,
                                      width: 90.w,
                                      fit: BoxFit.fill),
                                  // CircleAvatar(
                                  //   radius: 4.5.w,
                                  //   backgroundColor: colorWhite,
                                  //   child: Icon(Icons.pause,
                                  //       color: colorBlack, size: 7.w),
                                  // )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 2.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Learn To Download MF Statement',
                                        style: textStyle10(colorBlack)),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Text('View more',
                                            style: textStyle9(colorRed)
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .underline)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      textFormFieldContainer(
                          'Pan Card', 'Enter your Pan Card No', isPanFieldTap,
                          () {
                        setState(() {
                          isPanFieldTap = true;
                          uploadEventTap = false;
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
                      Padding(
                        padding:
                            EdgeInsets.only(top: 1.5.h, left: 2.5, right: 2.5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPanFieldTap = false;
                              uploadEventTap = true;
                            });

                            // signInWithGoogle().then((result) {
                            //   print("Result::::::::::::------$result");
                            //   if (result != null) {
                            //     log("accessToken-->>" + accessToken.toString());
                            //     print(
                            //         "accessToken-->>" + accessToken.toString());
                            //     print("idToken-->>" + idToken.toString());
                            //     setState(() {
                            //       isLogin = true;
                            //     });
                            //     /*Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => const GmailFunctionality()),
                            //     );*/

                            //     BlocProvider.of<FetchingDataBloc>(context).add(
                            //         LoadGmailInboxEvent(
                            //             accessToken: accessToken.toString(),
                            //             gmailInbox: GetGmailInboxModel(
                            //                 resultSizeEstimate: 0,
                            //                 nextPageToken: '',
                            //                 messages: [])));
                            //   }
                            // });

                            pickPdfFile();
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            color: uploadEventTap
                                ? colorRed
                                : colorTextBCBC.withOpacity(0.36),
                            padding: EdgeInsets.zero,
                            strokeWidth: 5,
                            dashPattern: const [5, 5],
                            child: Container(
                              height: 6.h,
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fileName,
                                      style: textStyle11Bold(colorText7070)),
                                  uploadFile == null
                                      ? Image.asset(icUpload,
                                          color: colorRed, width: 5.w)
                                      : IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints:
                                              BoxConstraints(minWidth: 5.w),
                                          onPressed: () {
                                            setState(() {
                                              fileName =
                                                  'Upload your stock investment PDF';
                                              uploadFile = null;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: colorRed,
                                          )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (fileValidation.isNotEmpty)
                        SizedBox(
                          height: 0.5.h,
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: fileValidation == 'Empty file'
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error,
                                        color: colorRed, size: 13),
                                    const SizedBox(width: 4),
                                    Container(
                                      height: 2.h,
                                      alignment: Alignment.center,
                                      child: Text('Please Select PDF file',
                                          style: textStyle9(colorErrorRed)),
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Center(
                          child: Container(
                            height: 17.h,
                            width: 17.h,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: colorTextBCBC.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 6))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Powered By',
                                    style: textStyle9(colorTextBCBC)),
                                SizedBox(height: 1.5.h),
                                Image.asset(imgKAPortfolioDoctor, width: 15.h),
                                SizedBox(height: 1.5.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      button(icSendReview, 'Send For Review', () {
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

                        if (uploadFile == null) {
                          setState(() {
                            fileValidation = 'Empty file';
                          });
                        } else {
                          setState(() {
                            fileValidation = '';
                          });
                        }

                        if (_panCardController.text.isNotEmpty &&
                            RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}')
                                .hasMatch(_panCardController.text) &&
                            uploadFile != null) {
                          setState(() {
                            isSend = true;
                          });

                          BlocProvider.of<ReviewBloc>(context).add(
                              UploadMFReview(
                                  userId: ApiUser.userId,
                                  email: email,
                                  mono: mobileNo,
                                  panNumber: _panCardController.text,
                                  requestType: "1",
                                  requestSubtype: '9',
                                  uploadFileName: fileName,
                                  uploadFilePath: uploadFile!.path));
                        } else {
                          setState(() {
                            isSend = false;
                          });
                        }
                      }),
                      SizedBox(height: 2.h),
                      button(icCheckReview, 'Check Review Report', () {
                        BlocProvider.of<ReviewBloc>(context)
                            .add(LoadReviewHistoryEvent(mobNo: mobileNo));
                        Navigator.of(context).pushNamed(ReviewHistory.route);
                      }),
                      SizedBox(height: 2.h)
                    ],
                  ),
                );
              },
            )),
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
                    // autofocus: isSelected,
                    decoration: InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: textStyle11(colorText3D3D),
                        fillColor: colorWhite,
                        filled: true,
                        border: InputBorder.none),
                    focusNode: panCardFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _panCardController) {
                        setState(() {
                          isPanFieldTap = false;
                        });
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: TextInputAction.next,
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
