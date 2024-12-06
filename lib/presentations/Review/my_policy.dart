import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/Review/history.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/mall/mall_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../common_functions.dart';
import '../../core/preferences.dart';
import '../../models/newArrival_data_model.dart';
import '../../models/popular_data_model.dart';
import '../../models/trending_data_model.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../home_screen.dart';
import '../profile_screen.dart';

class PolicyReview extends StatefulWidget {
  static const route = '/Policy-Review';

  const PolicyReview({Key? key}) : super(key: key);

  @override
  State<PolicyReview> createState() => _PolicyReviewState();
}

class _PolicyReviewState extends State<PolicyReview> {
  String mobileNo = '';
  String selectedInsuranceCompany = 'Select your insurance company';
  String selectedInsuranceType = 'Select Insurance Type';
  int insuranceTypeId = 0;
  final TextEditingController _insuranceAmountController =
      TextEditingController();
  final TextEditingController _premiumController = TextEditingController();
  final TextEditingController _payingTermController = TextEditingController();
  bool isInsuranceCompanyFieldTap = false;
  bool isInsuranceTypeFieldTap = true;
  bool isInsuranceAmountFieldTap = false;
  bool isPremiumFieldTap = false;
  bool isPayingTermFieldTap = false;
  bool isRenewalDateFieldTap = false;
  bool isPremiumPayingDateFieldTap = false;
  bool isPremiumPayingModeFieldTap = false;
  bool isuploadEventTap = false;
  FocusNode insuranceAmountFocus = FocusNode();
  FocusNode premiumFocus = FocusNode();
  FocusNode payingTermFocus = FocusNode();
  String companyValidation = '';
  String typeValidation = '';
  String insuranceAmountValidation = '';
  String premiumValidation = '';
  String payingTermValidation = '';
  String renewalDateValidation = '';
  String premiumPayingDateValidation = '';
  String premiumPayingModeValidation = '';
  bool isSend = false;
  DateTime? selectedDate;
  String renewalDate = 'Select your Renewal Date';
  String premiumPayingDate = 'Select your Premium Paying Date';
  String selectedPremiumPayingMode = 'Yearly';
  File? uploadFile;
  String fileName = 'Upload your Policy PDF';

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    setState(() {});
  }

  @override
  void initState() {
    getMobNo();
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
                Navigator.of(context).pop();
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('Review My Policy', style: textStyle14Bold(colorBlack)),
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
              if (state is InsuranceReviewFailed) {
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
              } else if (state is InsuranceReviewDataAdded) {
                BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                    popular: Popular(code: 0, message: '', products: []),
                    newArrival: NewArrival(code: 0, message: '', products: []),
                    trending: Trending(code: 0, message: '', products: [])));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.route, (route) => false,
                    arguments: HomeScreenData(
                        acceptedContacts: '', isSendReview: 'SendReview'));
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          dropDownWidget(
                              'Choose your type of insurance',
                              selectedInsuranceType,
                              isInsuranceTypeFieldTap, () {
                            BlocProvider.of<FetchingDataBloc>(context).add(
                                LoadInsuranceCategoryEvent(
                                    insuranceCategory: const []));
                            setState(() {
                              isInsuranceTypeFieldTap = true;
                              isInsuranceCompanyFieldTap = false;
                              isInsuranceAmountFieldTap = false;
                              isPremiumFieldTap = false;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = false;
                              isPremiumPayingDateFieldTap = false;
                              isPremiumPayingModeFieldTap = false;
                              isuploadEventTap = false;
                            });
                            insuranceAmountFocus.unfocus();
                            premiumFocus.unfocus();
                            payingTermFocus.unfocus();
                            CommonFunction().selectFormDialog(
                                context, 'Select Insurance Type', [], (val) {
                              print('-----selectedType--=---$val');
                              setState(() {
                                selectedInsuranceType = val.name;
                                insuranceTypeId = val.id;
                                // isInsuranceTypeFieldTap = false;
                                // isInsuranceAmountFieldTap = true;
                                if (selectedInsuranceType != 'Life') {
                                  _payingTermController.text = '1';
                                }
                              });
                              print(
                                  '-----selectedInsuranceType--=---$selectedInsuranceType');
                              print(
                                  '-----insuranceTypeId--=---$insuranceTypeId');

                              Navigator.of(context).pop();
                            });
                          }),
                          if (typeValidation.isNotEmpty)
                            SizedBox(
                              height: 0.5.h,
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: typeValidation == 'Empty Insurance Type'
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
                                              'Please Select an Insurance Type',
                                              style: textStyle9(colorErrorRed)),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          dropDownWidget(
                              'Choose your insurance company',
                              selectedInsuranceCompany,
                              isInsuranceCompanyFieldTap, () {
                            BlocProvider.of<FetchingDataBloc>(context).add(
                                LoadInsuranceCompanyEvent(
                                    insuranceCompany: const []));
                            setState(() {
                              isInsuranceTypeFieldTap = false;
                              isInsuranceCompanyFieldTap = true;
                              isInsuranceAmountFieldTap = false;
                              isPremiumFieldTap = false;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = false;
                              isPremiumPayingDateFieldTap = false;
                              isPremiumPayingModeFieldTap = false;
                              isuploadEventTap = false;
                            });
                            insuranceAmountFocus.unfocus();
                            premiumFocus.unfocus();
                            payingTermFocus.unfocus();
                            CommonFunction().selectFormDialog(
                                context, 'Select Insurance Company', [], (val) {
                              setState(() {
                                selectedInsuranceCompany = val;
                                isInsuranceCompanyFieldTap = false;
                                isInsuranceAmountFieldTap = true;
                              });
                              insuranceAmountFocus.requestFocus();
                              Navigator.of(context).pop();
                            });
                          }),
                          if (companyValidation.isNotEmpty)
                            SizedBox(
                              height: 0.5.h,
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: companyValidation ==
                                      'Empty Insurance Company'
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
                                              'Please Select an Insurance Company',
                                              style: textStyle9(colorErrorRed)),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          textFormFieldContainer(
                              'Sum Assured amount',
                              'Enter your amount',
                              isInsuranceAmountFieldTap, () {
                            setState(() {
                              isInsuranceCompanyFieldTap = false;
                              isInsuranceTypeFieldTap = false;
                              isInsuranceAmountFieldTap = true;
                              isPremiumFieldTap = false;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = false;
                              isPremiumPayingDateFieldTap = false;
                              isuploadEventTap = false;
                            });
                            insuranceAmountFocus.requestFocus();
                          }, _insuranceAmountController, TextInputType.number),
                          if (insuranceAmountValidation.isNotEmpty)
                            SizedBox(
                              height: 0.5.h,
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: insuranceAmountValidation == 'Empty Amount'
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
                                          child: Text('Please Enter an Amount',
                                              style: textStyle9(colorErrorRed)),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          textFormFieldContainer('Yearly premium',
                              'Enter your Premium', isPremiumFieldTap, () {
                            setState(() {
                              isInsuranceCompanyFieldTap = false;
                              isInsuranceTypeFieldTap = false;
                              isInsuranceAmountFieldTap = false;
                              isPremiumFieldTap = true;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = false;
                              isPremiumPayingDateFieldTap = false;
                              isPremiumPayingModeFieldTap = false;
                              isuploadEventTap = false;
                            });
                            premiumFocus.requestFocus();
                          },
                              _premiumController,
                              const TextInputType.numberWithOptions(
                                  decimal: true)),
                          if (premiumValidation.isNotEmpty)
                            SizedBox(
                              height: 0.5.h,
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: premiumValidation == 'Empty Premium'
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
                                              'Please Enter a Premium value',
                                              style: textStyle9(colorErrorRed)),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          if (selectedInsuranceType == 'Life') ...[
                            textFormFieldContainer(
                                'Premium paying term',
                                'Enter your paying term',
                                isPayingTermFieldTap, () {
                              setState(() {
                                isInsuranceCompanyFieldTap = false;
                                isInsuranceTypeFieldTap = false;
                                isInsuranceAmountFieldTap = false;
                                isPremiumFieldTap = false;
                                isPayingTermFieldTap = true;
                                isRenewalDateFieldTap = false;
                                isPremiumPayingDateFieldTap = false;
                                isPremiumPayingModeFieldTap = false;
                                isuploadEventTap = false;
                              });
                              payingTermFocus.requestFocus();
                            }, _payingTermController, TextInputType.number),
                            if (payingTermValidation.isNotEmpty)
                              SizedBox(
                                height: 0.5.h,
                              ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: payingTermValidation ==
                                        'Empty Paying Term'
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
                                                'Please Enter your Paying term',
                                                style:
                                                    textStyle9(colorErrorRed)),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ),
                          ],

                          dropDownWidget(
                              'Choose your premium paying mode',
                              selectedPremiumPayingMode,
                              isPremiumPayingModeFieldTap, () {
                            setState(() {
                              isInsuranceCompanyFieldTap = false;
                              isInsuranceTypeFieldTap = false;
                              isInsuranceAmountFieldTap = false;
                              isPremiumFieldTap = false;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = false;
                              isPremiumPayingDateFieldTap = false;
                              isPremiumPayingModeFieldTap = true;
                              isuploadEventTap = false;
                            });
                            insuranceAmountFocus.unfocus();
                            premiumFocus.unfocus();
                            payingTermFocus.unfocus();

                            CommonFunction().selectDialog(
                                context, 'Select Premium Paying Mode', [
                              'Yearly',
                              'Half yearly',
                              'Quarterly',
                              'Monthly'
                            ], (val) {
                              setState(() {
                                selectedPremiumPayingMode = val.toString();
                              });
                              Navigator.of(context).pop();
                            });
                          }),
                          dropDownWidget('Choose your Renewal Date',
                              renewalDate, isRenewalDateFieldTap, () {
                            setState(() {
                              isInsuranceCompanyFieldTap = false;
                              isInsuranceTypeFieldTap = false;
                              isInsuranceAmountFieldTap = false;
                              isPremiumFieldTap = false;
                              isPayingTermFieldTap = false;
                              isRenewalDateFieldTap = true;
                              isPremiumPayingDateFieldTap = false;
                              isPremiumPayingModeFieldTap = false;
                              isuploadEventTap = false;
                            });
                            insuranceAmountFocus.unfocus();
                            premiumFocus.unfocus();
                            payingTermFocus.unfocus();
                            dateOfBirth(true);
                          }),
                          if (renewalDateValidation.isNotEmpty)
                            SizedBox(
                              height: 0.5.h,
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: renewalDateValidation ==
                                      'Empty Renewal Date'
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
                                              'Please Select an Renewal Date',
                                              style: textStyle9(colorErrorRed)),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          // dropDownWidget(
                          //     'Choose your Premium Paying Date',
                          //     premiumPayingDate,
                          //     isPremiumPayingDateFieldTap, () {
                          //   setState(() {
                          //     isInsuranceCompanyFieldTap = false;
                          //     isInsuranceTypeFieldTap = false;
                          //     isInsuranceAmountFieldTap = false;
                          //     isPremiumFieldTap = false;
                          //     isPayingTermFieldTap = false;
                          //     isRenewalDateFieldTap = false;
                          //     isPremiumPayingDateFieldTap = true;
                          //     isPremiumPayingFrequencyFieldTap = false;
                          //   });
                          //   insuranceAmountFocus.unfocus();
                          //   premiumFocus.unfocus();
                          //   payingTermFocus.unfocus();
                          //   dateOfBirth(false);
                          // }),
                          // if (premiumPayingDateValidation.isNotEmpty)
                          //   SizedBox(
                          //     height: 0.5.h,
                          //   ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(left: 2.w),
                          //     child: premiumPayingDateValidation ==
                          //             'Empty Premium Paying Date'
                          //         ? Row(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: [
                          //               const Icon(Icons.error,
                          //                   color: colorRed, size: 13),
                          //               const SizedBox(width: 4),
                          //               Container(
                          //                 height: 2.h,
                          //                 alignment: Alignment.center,
                          //                 child: Text(
                          //                     'Please Select an Premim Paying Date',
                          //                     style: textStyle9(colorErrorRed)),
                          //               ),
                          //             ],
                          //           )
                          //         : Container(),
                          //   ),
                          // ),

                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.5.h, left: 2.5, right: 2.5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isInsuranceCompanyFieldTap = false;
                                  isInsuranceTypeFieldTap = false;
                                  isInsuranceAmountFieldTap = false;
                                  isPremiumFieldTap = false;
                                  isPayingTermFieldTap = false;
                                  isRenewalDateFieldTap = false;
                                  isPremiumPayingDateFieldTap = false;
                                  isPremiumPayingModeFieldTap = false;
                                  isuploadEventTap = true;
                                });
                                pickPdfFile();
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                color: isuploadEventTap
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          fileName,
                                          style: textStyle11Bold(colorText7070),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
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
                                                      'Upload your Policy PDF';
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

                          SizedBox(
                            height: 1.h,
                          ),
                          if (companyValidation.isEmpty ||
                              typeValidation.isEmpty ||
                              insuranceAmountValidation.isEmpty ||
                              premiumValidation.isEmpty ||
                              payingTermValidation.isEmpty ||
                              renewalDateValidation.isEmpty ||
                              premiumPayingDateValidation.isEmpty)
                            SizedBox(height: 3.5.h),
                          button(icSendReview, 'Send For Review', () {
                            if (selectedInsuranceCompany ==
                                'Select your insurance company') {
                              setState(() {
                                companyValidation = 'Empty Insurance Company';
                              });
                            } else {
                              setState(() {
                                companyValidation = '';
                              });
                            }
                            if (selectedInsuranceType ==
                                'Select Insurance Type') {
                              setState(() {
                                typeValidation = 'Empty Insurance Type';
                              });
                            } else {
                              setState(() {
                                typeValidation = '';
                              });
                            }
                            if (_insuranceAmountController.text.isEmpty) {
                              setState(() {
                                insuranceAmountValidation = 'Empty Amount';
                              });
                            } else {
                              setState(() {
                                insuranceAmountValidation = '';
                              });
                            }
                            if (_premiumController.text.isEmpty) {
                              setState(() {
                                premiumValidation = 'Empty Premium';
                              });
                            } else {
                              setState(() {
                                premiumValidation = '';
                              });
                            }
                            if (_payingTermController.text.isEmpty) {
                              setState(() {
                                payingTermValidation = 'Empty Paying Term';
                              });
                            } else {
                              setState(() {
                                payingTermValidation = '';
                              });
                            }
                            if (renewalDate == 'Select your Renewal Date') {
                              setState(() {
                                renewalDateValidation = 'Empty Renewal Date';
                              });
                            } else {
                              setState(() {
                                renewalDateValidation = '';
                              });
                            }
                            if (premiumPayingDate ==
                                'Select your Premium Paying Date') {
                              setState(() {
                                premiumPayingDateValidation =
                                    'Empty Premium Paying Date';
                              });
                            } else {
                              setState(() {
                                premiumPayingDateValidation = '';
                              });
                            }
                            if (selectedInsuranceCompany !=
                                    'Select your insurance company' &&
                                selectedInsuranceType !=
                                    'Select Insurance Type' &&
                                renewalDate != 'Select your Renewal Date' &&
                                premiumPayingDate !=
                                    'Select your Premium Paying Date' &&
                                _insuranceAmountController.text.isNotEmpty &&
                                _premiumController.text.isNotEmpty &&
                                _payingTermController.text.isNotEmpty) {
                              setState(() {
                                isSend = true;
                              });
                              BlocProvider.of<ReviewBloc>(context).add(
                                  CreateInsuranceReview(
                                      userid: ApiUser.userId,
                                      mobile: mobileNo,
                                      company: selectedInsuranceCompany,
                                      insurancetype: '4',
                                      insuranceSubType:
                                          insuranceTypeId.toString(),
                                      insuranceamount:
                                          _insuranceAmountController.text,
                                      premium: _premiumController.text,
                                      premiumterm: _payingTermController.text,
                                      renewaldate: renewalDate,
                                      premiumPayingDate: premiumPayingDate,
                                      premiumPayingFrequency:
                                          selectedPremiumPayingMode,
                                      uploadFilePath:
                                          fileName == 'Upload your Policy PDF'
                                              ? ''
                                              : uploadFile!.path,
                                      uploadFileName:
                                          fileName == 'Upload your Policy PDF'
                                              ? ''
                                              : fileName));
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
                            Navigator.of(context)
                                .pushNamed(ReviewHistory.route);
                          }),
                          SizedBox(height: 2.h)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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

  dropDownWidget(String title, String selectedType, bool isSelectedField,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelectedField ? colorRed : colorDFDF, width: 1)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(title, style: textStyle9(colorText8181)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                  child: SizedBox(
                    width: 84.w - 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(selectedType,
                              style: textStyle11(colorText3D3D)),
                        ),
                        Image.asset(
                            title == 'Choose your Renewal Date' ||
                                    title == 'Choose your Premium Paying Date'
                                ? icCalendar
                                : icDropdown,
                            color: colorText3D3D,
                            width: 5.w)
                      ],
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
                    inputFormatters: controller == _premiumController
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                          ]
                        : labelText == 'Premium paying term'
                            ? [LengthLimitingTextInputFormatter(2)]
                            : [],
                    decoration: InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: textStyle11(colorText3D3D),
                        fillColor: colorWhite,
                        filled: true,
                        border: InputBorder.none),
                    focusNode: controller == _premiumController
                        ? premiumFocus
                        : controller == _payingTermController
                            ? payingTermFocus
                            : insuranceAmountFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _insuranceAmountController) {
                        setState(() {
                          isInsuranceAmountFieldTap = false;
                          isPremiumFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(premiumFocus);
                      }
                      if (controller == _premiumController) {
                        setState(() {
                          isPremiumFieldTap = false;
                          isPayingTermFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(payingTermFocus);
                      }
                      if (controller == _payingTermController) {
                        setState(() {
                          isPayingTermFieldTap = false;
                        });
                        payingTermFocus.unfocus();
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: controller == _payingTermController
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

  dateOfBirth(bool select) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1951, 1, 1),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: colorRed,
                  onPrimary: colorWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    textStyle: textStyle14Bold(colorRed),
                  ),
                ),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print('-------pickedDate---$pickedDate');
      setState(() {
        selectedDate = pickedDate;
        // if (select == true) {
        renewalDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        // } else {
        premiumPayingDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        // }
      });
    });
  }
}
