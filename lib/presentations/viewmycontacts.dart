import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';

import '../models/contacts_data.dart';
import '../models/getuser_model.dart';
import '../resources/colors.dart';
import '../resources/icons.dart';
import '../resources/list.dart';
import '../resources/styles.dart';
import '../widgets/appbarButton.dart';

class ViewScreenData {
  final List<GoldReferral> myContact;

  ViewScreenData({required this.myContact});
}

class ViewMyContacts extends StatefulWidget {
  static const route = "/MyContact-Screen";

  final ViewScreenData viewScreenData;

  const ViewMyContacts({required this.viewScreenData});

  @override
  State<ViewMyContacts> createState() => _ViewMyContactsState();
}

class _ViewMyContactsState extends State<ViewMyContacts> {
  final TextEditingController _searchController1 = TextEditingController();
  DateTime firstDateTime = DateTime.now();
  DateTime secondDateTime = DateTime.now();
  String firstDate = '';
  String secondDate = '';
  List<GoldReferral> contactsList = [];
  List<MyContactData> contactsData = [];
  List<MyContactData> sortedContactsData = [];
  List<GoldReferral> selectedContacts = [];
  String filteredContacts = '';
  bool isEmptyContacts = false;
  int count = 0;
  int? contactCount;
  bool isShowDateRange = false;
  List<bool> isFamilyMember = [];

  getContacts() async {
    if (contactsList.isEmpty) {
      Timer(const Duration(seconds: 2), () {
        setState(() {
          isEmptyContacts = true;
        });
      });
    } else {
      count = 0;
      contactCount = 0;
      setState(() {
        if (contactsList.length == 1) {
          firstDate =
              DateFormat('dd-MMM-yyyy').format(contactsList.first.refDate);
          firstDateTime = contactsList.first.refDate;
          secondDate =
              DateFormat('dd-MMM-yyyy').format(contactsList.first.refDate);
          secondDateTime = contactsList.first.refDate;
        } else {
          firstDate =
              DateFormat('dd-MMM-yyyy').format(contactsList.first.refDate);
          firstDateTime = contactsList.first.refDate;
          secondDate =
              DateFormat('dd-MMM-yyyy').format(contactsList.last.refDate);
          secondDateTime = contactsList.last.refDate;
        }
      });
      for (int i = 0; i < contactsList.length; i++) {
        if (i > 0) {
          print('---xxxx------$i---xxx----${contactsList[i].refName}');
          if (contactsList[i].refName.isNotEmpty) {
            if (contactsList[i - 1].refName.isEmpty) {
              setState(() {
                if (contactsList[i].refName.substring(0, 1).toUpperCase() ==
                    contactsList[i - 2].refName.substring(0, 1).toUpperCase()) {
                  print(
                      '----isMatched----$i--${contactsList[i - 2].refName}--${contactsList[i - 2].refName.substring(0, 1)}--=--${contactsList[i].refName}--${contactsList[i].refName.substring(0, 1)}');
                  count = count;
                } else {
                  print(
                      '----unMatched----$i--${contactsList[i - 2].refName}--${contactsList[i - 2].refName.substring(0, 1)}--=--${contactsList[i].refName}--${contactsList[i].refName.substring(0, 1)}');
                  count = count + 1;
                }
                print('------count11---$count');
              });
            } else {
              setState(() {
                if (contactsList[i].refName.substring(0, 1).toUpperCase() ==
                    contactsList[i - 1].refName.substring(0, 1).toUpperCase()) {
                  print(
                      '----isMatched----$i--${contactsList[i - 1].refName}--${contactsList[i - 1].refName.substring(0, 1)}--=--${contactsList[i].refName}--${contactsList[i].refName.substring(0, 1)}');
                  count = count;
                } else {
                  print(
                      '----unMatched----$i--${contactsList[i - 1].refName}--${contactsList[i - 1].refName.substring(0, 1)}--=--${contactsList[i].refName}--${contactsList[i].refName.substring(0, 1)}');
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
        contactsData.add(MyContactData(
            contact: contactsList[i],
            isAdd: false,
            color: colorContacts[count]));
      }
      setState(() {
        sortedContactsData = contactsData;
      });
    }
    print('--=---contacts----${contactsData.length}');
    setState(() {});
  }

  selectFirstDate() {
    showDatePicker(
        context: context,
        initialDate: firstDateTime,
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
                    // primary: colorRed, // button text color
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
        firstDateTime = pickedDate;
        firstDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        sortedContactsData = [];
      });
      for (int i = 0; i < contactsData.length; i++) {
        if (contactsData[i].contact.refDate.difference(firstDateTime) >=
                const Duration(days: 0) &&
            secondDateTime.difference(contactsData[i].contact.refDate) >
                const Duration(days: 0)) {
          sortedContactsData.add(contactsData[i]);
        }
      }
    });
  }

  selectSecondDate() {
    showDatePicker(
        context: context,
        initialDate: secondDateTime,
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
                    // primary: colorRed, // button text color
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
        secondDateTime = pickedDate;
        secondDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        sortedContactsData = [];
      });
      for (int i = 0; i < contactsData.length; i++) {
        if (contactsData[i].contact.refDate.difference(firstDateTime) >=
                const Duration(days: 0) &&
            secondDateTime.difference(contactsData[i].contact.refDate) >
                const Duration(days: 0)) {
          sortedContactsData.add(contactsData[i]);
        }
      }
    });
  }

  //   List<String> get showRecentTransactions {
  //   DateTime now = DateTime.now();
  //   late DateTime lastMonth;
  //   late DateTime secondLastMonth;

  //   if (now.month == 2) {
  //     lastMonth = DateTime(now.year, 1, 10);
  //     secondLastMonth = DateTime(now.year - 1, 12, 10);
  //   } else if (now.month == 1) {
  //     lastMonth = DateTime(now.year - 1, 12, 10);
  //     secondLastMonth = DateTime(now.year - 1, 11, 10);
  //   } else {
  //     lastMonth = DateTime(now.year, now.month - 1, 10);
  //     secondLastMonth = DateTime(now.year, now.month - 2, 10);
  //   }

  //   return _transactions
  //       .where((element) =>
  //           (element.date.year == now.year &&
  //               element.date.month == now.month) ||
  //           (element.date.year == lastMonth.year &&
  //               element.date.month == lastMonth.month) ||
  //           (element.date.year == secondLastMonth.year &&
  //               element.date.month == secondLastMonth.month))
  //       .toList();
  // }

  @override
  void initState() {
    super.initState();
    contactsList = widget.viewScreenData.myContact;
    getContacts();
    print('myContact----------$contactsList');

    getfamilyMember();
  }

  getfamilyMember() {
    for (int i = 0; i < sortedContactsData.length; i++) {
      isFamilyMember.add(false);
    }
    for (int i = 0; i < ApiUser.membersList.length; i++) {
      for (int j = 0; j < sortedContactsData.length; j++) {
        if (ApiUser.membersList[i].mobileno
            .contains(sortedContactsData[j].contact.refMobile)) {
          isFamilyMember[j] = true;
        } else {
          if (isFamilyMember[j] != true) {
            isFamilyMember[j] = false;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          title: Text('My Referrals', style: textStyle14Bold(colorBlack)),
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
        body: Column(
          children: [
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 6.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      color: colorF3F3,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Image.asset(icSearch, width: 5.w),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: TextFormField(
                            controller: _searchController1,
                            style: textStyle12(colorText7070),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search Contacts',
                              hintStyle: textStyle12(colorText7070),
                              fillColor: colorF3F3,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (val) async {
                              filteredContacts = val;
                              setState(() {});
                            },
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    constraints: BoxConstraints(minWidth: 10.w, minHeight: 6.h),
                    padding: EdgeInsets.zero,
                    splashRadius: 5.5.w,
                    splashColor: colorWhite,
                    onPressed: () {
                      setState(() {
                        isShowDateRange = !isShowDateRange;
                      });
                    },
                    icon: Container(
                      height: 6.h,
                      width: 10.w,
                      decoration: const BoxDecoration(
                          color: colorF3F3, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child:
                          Image.asset(icSort, width: 4.w, color: colorText4D4D),
                    ))
              ],
            ),
            SizedBox(height: 1.5.h),
            Container(
              height: 0.4.h,
              decoration: const BoxDecoration(color: colorF3F3, boxShadow: [
                BoxShadow(color: colorF3F3, offset: Offset(3, 4), blurRadius: 5)
              ]),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              height: isShowDateRange ? 9.4.h : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          dateChose(firstDate, selectFirstDate),
                          Container(
                            height: 1,
                            width: 4.w,
                            color: colorText7070,
                          ),
                          dateChose(secondDate, selectSecondDate),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.4.h,
                      decoration: const BoxDecoration(
                          color: colorF3F3,
                          boxShadow: [
                            BoxShadow(
                                color: colorF3F3,
                                offset: Offset(3, 4),
                                blurRadius: 5)
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: sortedContactsData.isEmpty
                  ? Center(
                      child: Text('No Contacts Available',
                          style: textStyle12(colorText7070)))
                  : ListView.builder(
                      itemCount: sortedContactsData.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isSameDate = true;
                        final String dateString = sortedContactsData[index]
                            .contact
                            .refDate
                            .toString();
                        final DateTime date = DateTime.parse(dateString);
                        // final item = list[index];
                        if (index == 0) {
                          isSameDate = false;
                        } else {
                          final String prevDateString =
                              sortedContactsData[index - 1]
                                  .contact
                                  .refDate
                                  .toString();
                          final DateTime prevDate =
                              DateTime.parse(prevDateString);
                          isSameDate = date.isSameDate(prevDate);
                        }
                        if (index == 0 || !(isSameDate)) {
                          return Column(children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              alignment: Alignment.center,
                              width: double.infinity,
                              color: colorF3F3,
                              child: Text(
                                date.formatDate(),
                                style: textStyle11Medium(colorBlack)
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            sortedContactsData[index]
                                    .contact
                                    .refName
                                    .toLowerCase()
                                    .contains(filteredContacts.toLowerCase())
                                ? sortedContactsData[index]
                                        .contact
                                        .refName
                                        .isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 0.3.h),
                                        child: Container(
                                          height: 9.h,
                                          decoration: const BoxDecoration(
                                              color: colorWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: colorF3F3,
                                                    offset: Offset(3, 4),
                                                    blurRadius: 5)
                                              ]),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor:
                                                          sortedContactsData[
                                                                  index]
                                                              .color
                                                              .withOpacity(0.3),
                                                      child: Text(
                                                        sortedContactsData[
                                                                index]
                                                            .contact
                                                            .refName
                                                            .substring(0, 1)
                                                            .toUpperCase(),
                                                        style: textStyle16Bold(
                                                            sortedContactsData[
                                                                    index]
                                                                .color),
                                                      )),
                                                ),
                                                SizedBox(width: 3.w),
                                                Expanded(
                                                  flex: 10,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        sortedContactsData[
                                                                index]
                                                            .contact
                                                            .refName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: textStyle10Medium(
                                                                colorBlack)
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 0.8.h,
                                                      ),
                                                      Text(
                                                          sortedContactsData[
                                                                  index]
                                                              .contact
                                                              .refMobile,
                                                          style: textStyle12(
                                                              colorText7070))
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (isFamilyMember[index] ==
                                                    true)
                                                  Image.asset(familyIcon,
                                                      width: 7.w),
                                                SizedBox(width: 1.5.w),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                : Container(),
                          ]);
                        } else {
                          return sortedContactsData[index]
                                  .contact
                                  .refName
                                  .toLowerCase()
                                  .contains(filteredContacts.toLowerCase())
                              ? sortedContactsData[index]
                                      .contact
                                      .refName
                                      .isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 0.3.h),
                                      child: Container(
                                        height: 9.h,
                                        decoration: const BoxDecoration(
                                            color: colorWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: colorF3F3,
                                                  offset: Offset(3, 4),
                                                  blurRadius: 5)
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor:
                                                        sortedContactsData[
                                                                index]
                                                            .color
                                                            .withOpacity(0.3),
                                                    child: Text(
                                                      sortedContactsData[index]
                                                          .contact
                                                          .refName
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: textStyle16Bold(
                                                          sortedContactsData[
                                                                  index]
                                                              .color),
                                                    )),
                                              ),
                                              SizedBox(width: 3.w),
                                              Expanded(
                                                flex: 10,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      sortedContactsData[index]
                                                          .contact
                                                          .refName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textStyle10Medium(
                                                              colorBlack)
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: 0.8.h,
                                                    ),
                                                    Text(
                                                        sortedContactsData[
                                                                index]
                                                            .contact
                                                            .refMobile,
                                                        style: textStyle12(
                                                            colorText7070))
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              if (isFamilyMember[index] == true)
                                                Image.asset(familyIcon,
                                                    width: 7.w),
                                              SizedBox(width: 1.5.w),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                              : Container();
                        }
                      },
                    ),
            ),
            // Container(
            //   height: 0.5.h,
            //   decoration: const BoxDecoration(color: colorF3F3, boxShadow: [
            //     BoxShadow(
            //         color: colorF3F3, offset: Offset(3, 4), blurRadius: 5)
            //   ]),
            // ),
          ],
        ));
  }

  dateChose(String date, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 6.h,
        width: 40.w,
        decoration: BoxDecoration(
            color: colorF3F3, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(date, style: textStyle12Medium(colorText7070)),
            Image.asset(icCalender, color: colorText7070, width: 3.w),
          ],
        ),
      ),
    );
  }
}

const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
