import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/family_member_model.dart';
import 'package:wbc_connect_app/presentations/Review/verification_member.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';

import '../../common_functions.dart';
import '../../core/preferences.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../../widgets/country_picker/country.dart';
import '../../widgets/country_picker/country_code_picker.dart';
import '../home_screen.dart';

class AddMemberDetailsData {
  List familyList;

  AddMemberDetailsData({required this.familyList});
}

class AddMemberDetails extends StatefulWidget {
  static const route = '/Add-Member-Details';

  final AddMemberDetailsData addMemberDetailsData;

  const AddMemberDetails({Key? key, required this.addMemberDetailsData})
      : super(key: key);

  @override
  State<AddMemberDetails> createState() => _AddMemberDetailsState();
}

class _AddMemberDetailsState extends State<AddMemberDetails> {
  String mobileNo = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  String selectedRelation = 'Select Relation';
  bool nameFieldTap = true;
  bool relationFieldTap = false;
  bool numFieldTap = false;
  FocusNode nameFocus = FocusNode();
  FocusNode numFocus = FocusNode();
  String nameValidation = '';
  String numValidation = '';
  String relationValidation = '';
  bool isSend = false;
  String countryCode = '+91';
  FocusNode numNode = FocusNode();
  bool isSendOtp = false;

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    setState(() {});
  }

  void _showCountryPicker() async {
    setState(() {
      nameFieldTap = false;
      numFieldTap = true;
      relationFieldTap = false;
    });
    nameFocus.unfocus();
    numFocus.requestFocus();
    final country = await showCountryPickerPage();
    if (country != null) {
      setState(() {
        countryCode = country.isdcode;
      });
    }
  }

  sendOtp() async {
    setState(() {
      isSend = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();

    print('Submitted your Number: $countryCode${_numController.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + _numController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');

        setState(() {
          numValidation = 'Invalid Number';
          isSend = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isSend = false;
        });
        Navigator.of(context).pushNamed(VerificationMember.route,
            arguments: VerificationMemberData(
                familyMemberModel: FamilyMemberModel(
                    userid: int.parse(ApiUser.userId),
                    name: _nameController.text.trim(),
                    mobileNo: _numController.text.trim(),
                    relation: selectedRelation),
                mono: countryCode + _numController.text,
                verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
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
                  borderRadius: BorderRadius.all(
                Radius.circular(cornerRadius),
              )),
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
                            Navigator.of(context).pop(country),
                      ),
                    ),
                  ],
                ),
              ),
            ));
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: colorWhite,
          elevation: 6,
          shadowColor: colorTextBCBC.withOpacity(0.3),
          leadingWidth: 15.w,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.route, (route) => false,
                    arguments: HomeScreenData());
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('Add Member Details', style: textStyle14Bold(colorBlack)),
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
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.route, (route) => false,
                arguments: HomeScreenData());
            return false;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Text(
                        'Enter the details of your family members to\ntrack all the investments at one stop.',
                        style:
                            textStyle10(colorText4747).copyWith(height: 1.2)),
                  ),
                  textFormFieldContainer('Name of the Member', nameFieldTap,
                      () {
                    setState(() {
                      nameFieldTap = true;
                      numFieldTap = false;
                      relationFieldTap = false;
                    });
                    nameFocus.requestFocus();
                  }, _nameController, TextInputType.name),
                  if (nameValidation.isNotEmpty)
                    SizedBox(
                      height: 0.5.h,
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: nameValidation == 'Empty Name'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    color: colorRed, size: 13),
                                const SizedBox(width: 4),
                                Container(
                                  height: 2.h,
                                  alignment: Alignment.center,
                                  child: Text('Please Enter a Name',
                                      style: textStyle9(colorErrorRed)),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Container(
                    height: 9.h,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: !numFieldTap ? colorDFDF : colorErrorRed,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: _showCountryPicker,
                                      child: Container(
                                        height: 4.5.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                            color:
                                                colorTextBCBC.withOpacity(0.3),
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
                                                style:
                                                    textStyle13Bold(colorBlack),
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
                                          onTap: () {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(
                                                  FocusNode()); // Unfocus any current field
                                              nameFieldTap = false;
                                              numFieldTap = true;
                                              relationFieldTap = false;
                                            });
                                            nameFocus.unfocus();
                                            numFocus.requestFocus();
                                          },
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
                                              counter: const SizedBox.shrink(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 1.4.h)),
                                          onChanged: (val) {
                                            setState(() {
                                              numValidation = '';
                                            });
                                          },
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.send,
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
                  if (numValidation.isNotEmpty)
                    SizedBox(
                      height: 0.5.h,
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: numValidation == 'Empty String' ||
                              numValidation == 'Invalid String' ||
                              numValidation == 'Invalid Number' ||
                              numValidation == 'Logged Number'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    color: colorRed, size: 13),
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    if (numValidation == 'Empty String')
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Please Enter a Number',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    if (numValidation == 'Invalid String')
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Please Enter a valid Number',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    if (numValidation == 'Invalid Number')
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text('Invalid Number',
                                            style: textStyle9(colorErrorRed)),
                                      ),
                                    if (numValidation == 'Logged Number')
                                      Container(
                                        height: 3.h,
                                        width: 80.w,
                                        alignment: Alignment.center,
                                        child: Text(
                                            'This number is already Wbc user please enter others family member number',
                                            style: textStyle9(colorErrorRed)
                                                .copyWith(height: 1.2)),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                  dropDownWidget('Relation', selectedRelation, relationFieldTap,
                      () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      nameFieldTap = false;
                      numFieldTap = false;
                      relationFieldTap = true;
                    });
                    nameFocus.unfocus();
                    numFocus.unfocus();
                    CommonFunction().selectFormDialog(
                        context, 'Select Relation', relationType, (val) {
                      setState(() {
                        selectedRelation = val;
                      });
                      Navigator.of(context).pop();
                    });
                  }),
                  if (relationValidation.isNotEmpty)
                    SizedBox(
                      height: 0.5.h,
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: relationValidation == 'Empty Relation'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    color: colorRed, size: 13),
                                const SizedBox(width: 4),
                                Container(
                                  height: 2.h,
                                  alignment: Alignment.center,
                                  child: Text('Please Select a Relation',
                                      style: textStyle9(colorErrorRed)),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ),

                  SizedBox(height: 2.h),
                  if (widget.addMemberDetailsData.familyList.isNotEmpty)
                    Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: colorTextBCBC.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 6))
                          ]),
                      padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('My Family Members',
                                    style: textStyle12Bold(colorBlack)
                                        .copyWith(letterSpacing: 0.16)),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 1.h, bottom: 2.h),
                                  child: Container(
                                      height: 1,
                                      color: colorTextBCBC.withOpacity(0.36)),
                                ),
                                ...List.generate(
                                    widget
                                        .addMemberDetailsData.familyList.length,
                                    (index) => familyView(
                                          widget.addMemberDetailsData
                                              .familyList[index].name,
                                        ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // const Spacer(),
                  SizedBox(height: 3.h),

                  button(icSendReview, 'Next', () {
                    if (_nameController.text.isEmpty) {
                      setState(() {
                        nameValidation = 'Empty Name';
                      });
                    } else {
                      setState(() {
                        nameValidation = '';
                        nameFieldTap = false;
                      });
                    }
                    if (_numController.text.isEmpty) {
                      setState(() {
                        numValidation = 'Empty String';
                      });
                    } else {
                      print('--==-----num------${_numController.text.length}');
                      if (_numController.text.replaceAll(' ', '').length < 10 ||
                          _numController.text.replaceAll(' ', '').length > 10) {
                        setState(() {
                          numValidation = 'Invalid Number';
                        });
                      } else if (_numController.text == mobileNo) {
                        setState(() {
                          numValidation = 'Logged Number';
                        });
                      } else if (_nameController.text.isNotEmpty &&
                          _numController.text.isNotEmpty &&
                          selectedRelation != 'Select Relation') {
                        print(
                            'Submitted your Number: ${_numController.text.trim()}');
                        setState(() {
                          numValidation = '';
                        });
                        sendOtp();
                      }
                    }
                    if (selectedRelation == 'Select Relation') {
                      setState(() {
                        relationValidation = 'Empty Relation';
                      });
                    } else {
                      setState(() {
                        relationValidation = '';
                      });
                    }
                    if (_nameController.text.isNotEmpty &&
                        _numController.text.isNotEmpty &&
                        selectedRelation != 'Select Relation') {}
                  }),
                  SizedBox(height: 2.h)
                ],
              ),
            ),
          ),
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
            color: colorRed, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: isSend
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: colorWhite, strokeWidth: 0.6.w))
            : Text(text, style: textStyle13Bold(colorWhite)),
      ),
    );
  }

  textFormFieldContainer(String labelText, bool isSelected, Function() onClick,
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
                    decoration: const InputDecoration.collapsed(
                        hintText: '',
                        fillColor: colorWhite,
                        filled: true,
                        border: InputBorder.none),
                    focusNode: nameFocus,
                    onTap: onClick,
                    autofocus: true,
                    onFieldSubmitted: (val) {
                      if (controller == _nameController) {
                        setState(() {
                          nameFieldTap = false;
                          numFieldTap = true;
                          relationFieldTap = false;
                        });
                        FocusScope.of(context).requestFocus(numFocus);
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: TextInputAction.next,
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
    );
  }

  familyView(
    String title,
  ) {
    return
        // Container(
        //   decoration: BoxDecoration(
        //       color: colorWhite,
        //       borderRadius: BorderRadius.only(
        //         bottomLeft:
        //             Radius.circular(familyList.length - 1 == index ? 10 : 0),
        //         bottomRight:
        //             Radius.circular(familyList.length - 1 == index ? 10 : 0),
        //       ),
        //       boxShadow: [
        //         BoxShadow(
        //             color: colorTextBCBC.withOpacity(0.3),
        //             blurRadius: 8,
        //             offset: const Offset(0, 6))
        //       ]),
        //   child:
        Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Container(
              height: 4.5.h,
              width: 4.5.h,
              decoration: BoxDecoration(
                color: colorRed.withOpacity(0.29),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(title.substring(0, 1).toUpperCase(),
                  style: textStyle18(colorRed)),
            ),
          ),
          Text(title, style: textStyle11Bold(colorBlack)),
        ],
      ),
      // ),
    );
  }
}
