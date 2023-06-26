import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wbc_connect_app/presentations/vender_bill_pay.dart';
import 'package:permission_handler/permission_handler.dart'
as contactPermission;

import '../core/preferences.dart';
import '../models/contacts_data.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class PayNdSend extends StatefulWidget {
  static const route = '/Pay-Send';

  const PayNdSend({Key? key}) : super(key: key);

  @override
  State<PayNdSend> createState() => _PayNdSendState();
}

class _PayNdSendState extends State<PayNdSend> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isNumberFieldTap = false;
  bool isAmountFieldTap = false;
  FocusNode numberFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  String numberValidation = '';
  String amountValidation = '';
  List<ContactsData> contactsList = [];
  List<ContactsData> contactsData = [];
  bool isEmptyContacts = false;
  int count = 0;
  int contactCount = 0;

  getContacts() async {
    contactsList = [];
    contactsList =
        await FlutterContacts.getContacts(withProperties: true, withPhoto: true)
            .then((value) {
      print('-----contacts--all-----$value');
      if (value.isEmpty) {
        Timer(const Duration(seconds: 2), () {
          setState(() {
            isEmptyContacts = true;
          });
        });
      } else {
        count = 0;
        contactCount = 0;
        for (int i = 0; i < value.length; i++) {
          if (i > 0) {
            print('---xxx------$i---xxx----${value[i].name.first}');
            if (value[i].name.first.isNotEmpty) {
              if (value[i - 1].name.first.isEmpty) {
                setState(() {
                  if (value[i].name.first.substring(0, 1).toUpperCase() ==
                      value[i - 2].name.first.substring(0, 1).toUpperCase()) {
                    print(
                        '----isMatched----$i--${value[i - 2].name.first}--${value[i - 2].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count;
                  } else {
                    print(
                        '----unMatched----$i--${value[i - 2].name.first}--${value[i - 2].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count + 1;
                  }
                  print('------count11---$count');
                });
              } else {
                setState(() {
                  if (value[i].name.first.substring(0, 1).toUpperCase() ==
                      value[i - 1].name.first.substring(0, 1).toUpperCase()) {
                    print(
                        '----isMatched----$i--${value[i - 1].name.first}--${value[i - 1].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count;
                  } else {
                    print(
                        '----unMatched----$i--${value[i - 1].name.first}--${value[i - 1].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count + 1;
                  }
                  print('------count11---$count');
                });
              }
            }
          }
          if (count == 4) {
            print('-----is--4---$count');
            setState(() {
              count = 0;
            });
          }
          contactsList.add(ContactsData(
              contact: value[i], isAdd: false, color: colorContacts[count]));
        }
      }
      return contactsList;
    });
    setState(() {
      contactsData = contactsList;
    });
    print('--=---contacts----${contactsData.length}');
    setState(() {});
  }

  void getContactPermission() async {
    Preference.setIsLogin(true);
    if (await contactPermission.Permission.contacts.request().isGranted) {
      // setState(() {
      //   isContactPermission = true;
      // });

      print('permission granted-------hhhh');

      await getContacts();
    } else if (await contactPermission.Permission.contacts.request().isDenied) {
      // setState(() {
      //   isContactPermission = false;
      //   isContactPermissionDenied = true;
      // });
      print('------is-perminatily---denied');
    } else if (await contactPermission.Permission.contacts
        .request()
        .isPermanentlyDenied) {
      // setState(() {
      //   isContactPermission = false;
      //   isContactPermissionDenied = true;
      // });
      await contactPermission.openAppSettings();
      print('------is-perminatily---denied');
    }
  }

  @override
  void initState() {
    getContactPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: colorTransparent,
          elevation: 0,
          leadingWidth: 15.w,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset(icBack, color: colorWhite, width: 6.w)),
          actions: [
            AppBarButton(splashColor: colorWhite, bgColor: colorWhite, icon: icImage, iconColor: colorText7070, onClick: (){}),
            SizedBox(width: 2.w),
            AppBarButton(splashColor: colorWhite, bgColor: colorWhite, icon: icFlash, iconColor: colorText7070, onClick: (){}),
            SizedBox(width: 2.w),
            AppBarButton(splashColor: colorWhite, bgColor: colorWhite, icon: icNotification, iconColor: colorText7070, onClick: (){}),
            SizedBox(width: 5.w)
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image.asset(imgScanner,
                height: 50.h, width: 100.w, fit: BoxFit.cover),
            DraggableScrollableSheet(
              initialChildSize: 0.53,
              minChildSize: 0.53,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: colorWhite,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Container(
                            height: 3,
                            width: 15.w,
                            decoration: BoxDecoration(
                                color: colorTextBCBC,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          child: Container(
                            height: 6.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colorE5E5, width: 1)),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Image.asset(icSearch, width: 5.w),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: TextFormField(
                                      controller: _searchController,
                                      style: textStyle12(colorText7070),
                                      decoration: InputDecoration.collapsed(
                                        hintText:
                                            'Type a name or phone number to send',
                                        hintStyle: textStyle12(colorText7070),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {},
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          child: Row(
                            children: [
                              Text('Add Account',
                                  style: textStyle12Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                            ],
                          ),
                        ),
                        textFormFieldContainer(
                            'Bill Number', 'Enter your Prepaid Mobile Number', isNumberFieldTap, () {
                          setState(() {
                            isNumberFieldTap = true;
                            isAmountFieldTap = false;
                          });
                          numberFocus.requestFocus();
                        }, _numberController, TextInputType.text),
                        if (numberValidation.isEmpty)
                          SizedBox(
                            height: 1.h,
                          ),
                        if (numberValidation.isNotEmpty)
                          SizedBox(
                            height: 0.5.h,
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: numberValidation == 'Empty PanCard'
                                ? SizedBox(
                              height: 2.h,
                              child: Text('Please Enter a Pan Card No.',
                                  style: textStyle9(colorErrorRed)),
                            )
                                : Container(),
                          ),
                        ),
                        textFormFieldContainer(
                            'Bill Amount', 'Enter your Bill Amount', isAmountFieldTap, () {
                          setState(() {
                            isNumberFieldTap = false;
                            isAmountFieldTap = true;
                          });
                          amountFocus.requestFocus();
                        }, _amountController, TextInputType.emailAddress),
                        if (amountValidation.isEmpty)
                          SizedBox(
                            height: 1.h,
                          ),
                        if (amountValidation.isNotEmpty)
                          SizedBox(
                            height: 0.5.h,
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: amountValidation == 'Empty Amount'
                                ? SizedBox(
                              height: 2.5.h,
                              child: Text('Please Enter an Email',
                                  style: textStyle9(colorErrorRed)),
                            )
                                : Container(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('1. Enter your prepaid mobile number',
                                  style: textStyle9(colorTextBCBC)
                                      .copyWith(height: 1.18)),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                                child: Text(
                                    '2. Select your mobile operator and circle if WBC can’t detect automatically',
                                    style: textStyle9(colorTextBCBC)
                                        .copyWith(height: 1.18)),
                              ),
                              Text('3. Enter the amount',
                                  style: textStyle9(colorTextBCBC)
                                      .copyWith(height: 1.18)),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          child: Row(
                            children: [
                              Text('Pay and Send',
                                  style: textStyle12Bold(colorBlack)
                                      .copyWith(letterSpacing: 0.7)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                          child: contactsData.isEmpty ? Center(
                              child: isEmptyContacts
                                  ? Text('No Contacts Available',
                                  style: textStyle12(colorText7070))
                                  : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: colorRed, strokeWidth: 0.7.w)))
                              : ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: contactsData.length,
                              itemBuilder: (context, index) {
                                Uint8List? image = contactsData[index].contact.photo;
                                return Padding(
                                  padding:  EdgeInsets.only(left: index == 0 ? 5.w : 0),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1.h),
                                            child: (contactsData[index].contact.photo == null)
                                                ? CircleAvatar(
                                                    radius: 8.w,
                                                    backgroundColor: contactsData[index]
                                                        .color
                                                        .withOpacity(0.3),
                                                    child: Text(
                                                      contactsData[index]
                                                          .contact
                                                          .name
                                                          .first
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: textStyle16Bold(
                                                          contactsData[index].color),
                                                    ))
                                                : CircleAvatar(
                                                    radius: 8.w,
                                                    backgroundImage:
                                                        MemoryImage(image!),
                                                  ),
                                          ),
                                          Text(
                                            "${contactsData[index].contact.name.first} ${contactsData[index].contact.name.middle} ${contactsData[index].contact.name.last}",
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: textStyle9Medium(
                                                colorBlack),
                                          ),
                                        ],
                                      ),
                                  ),
                                );}),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(VendorBillPay.route);
                              },
                              child: Center(
                                child: Container(
                                  height: 6.5.h,
                                  width: 90.w,
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
                                  child: Text('PROCEED TO RECHARGE',
                                      style: textStyle13Bold(colorWhite)),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
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
                    focusNode: controller == _amountController
                        ? amountFocus
                        : numberFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _numberController) {
                        setState(() {
                          isNumberFieldTap = false;
                          isAmountFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(amountFocus);
                      }
                      if (controller == _amountController) {
                        setState(() {
                          isNumberFieldTap = false;
                          isAmountFieldTap = false;
                        });
                        amountFocus.unfocus();
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: controller == _amountController
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
