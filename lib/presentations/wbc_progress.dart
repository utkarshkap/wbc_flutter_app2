import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';

import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class WBCProgress extends StatefulWidget {
  static const route = '/WBC-Progress';
  const WBCProgress({Key? key}) : super(key: key);

  @override
  State<WBCProgress> createState() => _WBCProgressState();
}

class _WBCProgressState extends State<WBCProgress> {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                standFastTrack('Your Base', 'Contacts entered', 200,
                    'Contacts converted', 9),
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
                        portFolioWidget(icFamily, 'Family', () {}),
                        portFolioWidget(
                            icFriends, 'Friends & Relatives', () {}),
                        portFolioWidget(icNeighbour, 'Neighbours', () {}),
                        portFolioWidget(icVip, 'HNI/VIP', () {}),
                        portFolioWidget(icOthers, 'Others', () {}),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 90.w,
                  decoration: decoration(colorWhite),
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: contactsView(
                      icAddContacts,
                      'Add Your Contacts',
                      'Add Your Contacts You can add 96 contacts this month',
                      () => null),
                ),
                standFastTrack(
                    'Your Members', 'Standard', 398, 'FastTrack', 6754),
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
                          percent: 0.8,
                          center: Text("40.0%",
                              style: textStyle9Bold(colorTextFFC1)),
                          barRadius: const Radius.circular(15),
                          backgroundColor: colorTextBCBC.withOpacity(0.25),
                          progressColor: colorRed,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
                        child: Column(
                          children: [
                            Text('Active Clients - 80',
                                style: textStyle9Medium(
                                    colorText7070.withOpacity(0.7))),
                            const SizedBox(height: 5),
                            Text('Total Clients - 200',
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
      int title2Value) {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(title1, style: textStyle9(colorText3D3D)),
                    Text('$title1Value', style: textStyle18Bold(colorRed))
                  ],
                ),
                Container(
                    height: 10.h,
                    width: 1,
                    color: colorTextBCBC.withOpacity(0.36)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(title2, style: textStyle9(colorText3D3D)),
                    Text('$title2Value', style: textStyle18Bold(colorSplashBG))
                  ],
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
                          text: 'You can add',
                          style: textStyle9(colorBlack),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' 96 Contacts ',
                                style: textStyle10Bold(colorRed)),
                            const TextSpan(text: 'this month'),
                          ],
                        ),
                      )
                    : Text(subTitle, style: textStyle9(colorBlack)),
              )
            ],
          ),
          const Spacer(),
          title != 'List of inactive clients'
              ? button('+', onClick)
              : IconButton(
                  constraints: BoxConstraints(minWidth: 8.5.w, minHeight: 4.h),
                  padding: EdgeInsets.zero,
                  onPressed: onClick,
                  icon: Image.asset(icDownload,
                      color: colorRed, fit: BoxFit.fill)),
          SizedBox(width: 3.5.w)
        ],
      ),
    );
  }
}
