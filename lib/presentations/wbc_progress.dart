import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/models/getuser_model.dart';
import 'package:wbc_connect_app/presentations/Review/add_member_details.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import 'package:wbc_connect_app/presentations/viewmycontacts.dart';

import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class WBCProgress extends StatefulWidget {
  static const route = '/WBC-Progress';
  const WBCProgress({Key? key}) : super(key: key);

  @override
  State<WBCProgress> createState() => _WBCProgressState();
}

class _WBCProgressState extends State<WBCProgress> {
  int clientsConverted = 0;
  double percentRatio = 0.0;
  String mono = "";
  int activeClients = 0;

  @override
  void initState() {
    var temp = ApiUser.myContactsList!.length;
    if (GpDashBoardData.inActiveClients!.isNotEmpty) {
      activeClients = temp - GpDashBoardData.inActiveClients![0].count;
    }

    getClientsConvertedMember();
    getMobNog();
    super.initState();
  }

  getClientsConvertedMember() {
    if (ApiUser.myContactsList!.isNotEmpty) {
      percentRatio = activeClients / ApiUser.myContactsList!.length;
      for (int i = 0; i < ApiUser.myContactsList!.length; i++) {
        if (ApiUser.myContactsList![i].userexist == true) {
          clientsConverted++;
        }
      }
    }
  }

  getMobNog() async {
    mono = await Preference.getMobNo();
    setState(() {});
    print('mono-----$mono');
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
          title: Text('WBC Progress', style: textStyle14Bold(colorBlack)),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                standFastTrack(
                    'Your Base',
                    'Contacts entered',
                    ApiUser.myContactsList!.length,
                    'Contacts converted',
                    clientsConverted, () {
                  Navigator.of(context).pushNamed(ViewMyContacts.route,
                      arguments:
                          ViewScreenData(myContact: ApiUser.myContactsList!));
                }, () {
                  Navigator.of(context).pushNamed(ViewMyContacts.route,
                      arguments: ViewScreenData(
                          myContact: ApiUser.myContactsList!,
                          isClientsConverted: true));
                }),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Text('Your direct referrals',
                          style: textStyle11Bold(colorBlack)
                              .copyWith(letterSpacing: 0.7)),
                    ),
                  ],
                ),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        portFolioWidget(icFamily, 'Family', () {
                          Navigator.of(context).pushNamed(
                              AddMemberDetails.route,
                              arguments: AddMemberDetailsData(
                                  familyList: ApiUser.membersList));
                        }),
                        portFolioWidget(icFriends, 'Friends & Relatives', () {
                          if (GpDashBoardData.availableContacts != 0) {
                            Preference.setRenewContact(true);
                            Navigator.of(context).pushNamed(
                                VerificationScreen.route,
                                arguments: VerificationScreenData(
                                    getNumber: "",
                                    number: mono,
                                    verificationId: "",
                                    isLogin: true,
                                    selectedContact:
                                        GpDashBoardData.availableContacts!,
                                    isHomeContactOpen: true));
                          } else {
                            CommonFunction().reachedMaxContactPopup(context);
                          }
                        }),
                        portFolioWidget(icNeighbour, 'Neighbours', () {
                          if (GpDashBoardData.availableContacts != 0) {
                            Preference.setRenewContact(true);
                            Navigator.of(context).pushNamed(
                                VerificationScreen.route,
                                arguments: VerificationScreenData(
                                    getNumber: "",
                                    number: mono,
                                    verificationId: "",
                                    isLogin: true,
                                    selectedContact:
                                        GpDashBoardData.availableContacts!,
                                    isHomeContactOpen: true));
                          } else {
                            CommonFunction().reachedMaxContactPopup(context);
                          }
                        }),
                        portFolioWidget(icVip, 'HNI/VIP', () {
                          if (GpDashBoardData.availableContacts != 0) {
                            Preference.setRenewContact(true);
                            Navigator.of(context).pushNamed(
                                VerificationScreen.route,
                                arguments: VerificationScreenData(
                                    getNumber: "",
                                    number: mono,
                                    verificationId: "",
                                    isLogin: true,
                                    selectedContact:
                                        GpDashBoardData.availableContacts!,
                                    isHomeContactOpen: true));
                          } else {
                            CommonFunction().reachedMaxContactPopup(context);
                          }
                        }),
                        portFolioWidget(icOthers, 'Others', () {
                          if (GpDashBoardData.availableContacts != 0) {
                            Preference.setRenewContact(true);
                            Navigator.of(context).pushNamed(
                                VerificationScreen.route,
                                arguments: VerificationScreenData(
                                    getNumber: "",
                                    number: mono,
                                    verificationId: "",
                                    isLogin: true,
                                    selectedContact:
                                        GpDashBoardData.availableContacts!,
                                    isHomeContactOpen: true));
                          } else {
                            CommonFunction().reachedMaxContactPopup(context);
                          }
                        }),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: contactsView(icAddContacts, 'Add Your Contacts',
                      'Add Your Contacts You can add ${GpDashBoardData.maxContactPermittedPerMonth} contacts this month',
                      () {
                    if (GpDashBoardData.availableContacts != 0) {
                      Preference.setRenewContact(true);
                      Navigator.of(context).pushNamed(VerificationScreen.route,
                          arguments: VerificationScreenData(
                              getNumber: "",
                              number: mono,
                              verificationId: "",
                              isLogin: true,
                              selectedContact:
                                  GpDashBoardData.availableContacts!,
                              isHomeContactOpen: true));
                    } else {
                      CommonFunction().reachedMaxContactPopup(context);
                    }
                  }),
                ),
                if (GpDashBoardData.contactBase!.isNotEmpty)
                  standFastTrack(
                      'Your Team',
                      'Standard',
                      GpDashBoardData.contactBase![0].count,
                      'FastTrack',
                      GpDashBoardData.contactBase![1].count, () {
                    List<GoldReferral> temp = [];

                    GpDashBoardData.contactBase![0].referralList
                        .forEach((element) {
                      temp.add(GoldReferral(
                          refName: element.refName,
                          refMobile: element.refMobile,
                          refDate: element.refDate,
                          userexist: element.userexist));
                    });
                    Navigator.of(context).pushNamed(ViewMyContacts.route,
                        arguments: ViewScreenData(
                            myContact: temp, title: 'Your Team'));
                  }, () {
                    List<GoldReferral> temp = [];

                    GpDashBoardData.contactBase![1].referralList
                        .forEach((element) {
                      temp.add(GoldReferral(
                          refName: element.refName,
                          refMobile: element.refMobile,
                          refDate: element.refDate,
                          userexist: element.userexist));
                    });
                    Navigator.of(context).pushNamed(ViewMyContacts.route,
                        arguments: ViewScreenData(
                            myContact: temp, title: 'Your Team'));
                  }),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: Row(
                          children: [
                            Text('Active Clients Ratio',
                                style: textStyle11Bold(colorBlack)
                                    .copyWith(letterSpacing: 0.7)),
                            SizedBox(width: 2.w),
                            Image.asset(icRoundQuestionMark,
                                color: colorRed, width: 5.w)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: LinearPercentIndicator(
                          lineHeight: 23,
                          width: 80.w,
                          animation: true,
                          padding: EdgeInsets.zero,
                          animationDuration: 2500,
                          percent: percentRatio,
                          center: Text(
                              activeClients == 0
                                  ? '0 %'
                                  : activeClients ==
                                          ApiUser.myContactsList!.length
                                      ? '100 %'
                                      : percentRatio <= 0.01
                                          ? '01 %'
                                          : '${percentRatio.toStringAsFixed(5).substring(2, 4)} %',
                              style: textStyle9Bold(colorBlack)),
                          barRadius: const Radius.circular(15),
                          backgroundColor: colorTextBCBC.withOpacity(0.25),
                          progressColor: _getProgressColor(percentRatio),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active Clients - $activeClients',
                                style: textStyle9Medium(
                                    colorText7070.withOpacity(0.7))),
                            const SizedBox(height: 5),
                            Text(
                                'Total Clients - ${ApiUser.myContactsList?.length}',
                                style: textStyle9Medium(
                                    colorText7070.withOpacity(0.7)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: contactsView(icAddContacts, 'List of inactive clients',
                      'Make your base stronger!', () => null),
                ),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: contactsView(icAddContacts, 'Add precise Referrals',
                      'We would contact them specially!', () => null),
                ),
                SizedBox(height: 5.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double percentRatio) {
    if (percentRatio >= 0.8) {
      return Colors.green; // or any other color for 100%
    } else if (percentRatio >= 0.5) {
      return Colors.yellow; // or any other color for 50%-99%
    } else {
      return Colors.red; // or any other color for 0%-49%
    }
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

  button(String text, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 4.h,
        width: 8.5.w,
        decoration: BoxDecoration(
            color: colorRed,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                  color: colorRed.withOpacity(0.35))
            ]),
        alignment: Alignment.center,
        child: Image.asset(icAdd, color: colorWhite, width: 3.w),
      ),
    );
  }

  standFastTrack(String title, String title1, int title1Value, String title2,
      int title2Value, Function() onTap1, Function() onTap2) {
    return Container(
      width: 90.w,
      decoration: decoration(colorWhite),
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Text(title,
                style:
                    textStyle11Bold(colorBlack).copyWith(letterSpacing: 0.7)),
          ),
          Container(height: 1, color: colorTextBCBC.withOpacity(0.36)),
          SizedBox(
            height: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onTap1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(title1, style: textStyle9(colorText3D3D)),
                        Text('$title1Value', style: textStyle18Bold(colorRed))
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 10.h,
                    width: 1,
                    color: colorTextBCBC.withOpacity(0.36)),
                Expanded(
                  child: InkWell(
                    onTap: onTap2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(title2, style: textStyle9(colorText3D3D)),
                        Text('$title2Value',
                            style: textStyle18Bold(colorSplashBG))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  portFolioWidget(String icon, String title, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            height: 6.5.h,
            width: 6.5.h,
            decoration: BoxDecoration(
              color: colorRed.withOpacity(0.29),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: icon == 'empty icon'
                ? Container()
                : Image.asset(icon, height: 4.h),
          ),
          SizedBox(height: 1.2.h),
          SizedBox(
            width: 15.w,
            child: Text(title,
                textAlign: TextAlign.center, style: textStyle8(colorText3D3D)),
          )
        ],
      ),
    );
  }

  contactsView(String icon, String title, String subTitle, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.5.w, right: 3.w),
            child: Container(
              height: 4.5.h,
              width: 4.5.h,
              decoration: const BoxDecoration(
                color: colorGreenEFC,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(icon, height: 2.5.h),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle11Bold(colorBlack)),
              const SizedBox(height: 4),
              SizedBox(
                width: 60.w,
                child: title == 'Add Your Contacts'
                    ? RichText(
                        text: TextSpan(
                          text: 'You can add ',
                          style: textStyle9(colorBlack),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${GpDashBoardData.maxContactPermittedPerMonth} Contacts',
                                style: textStyle10Bold(colorRed)),
                            const TextSpan(text: ' this month'),
                          ],
                        ),
                      )
                    : Text(subTitle, style: textStyle9(colorBlack)),
              )
            ],
          ),
          const Spacer(),
          title != 'List of inactive clients'
              ? title == 'Add precise Referrals'
                  ? const Text('')
                  : button('+', onClick)
              : const Text(''),
          // IconButton(
          //     constraints: BoxConstraints(minWidth: 8.5.w, minHeight: 4.h),
          //     padding: EdgeInsets.zero,
          //     onPressed: onClick,
          //     icon: Image.asset(icDownload,
          //         color: colorRed, fit: BoxFit.fill)),
          SizedBox(width: 3.5.w)
        ],
      ),
    );
  }
}
