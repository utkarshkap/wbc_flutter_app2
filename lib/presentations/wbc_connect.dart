import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/earning_data.dart';
import 'package:wbc_connect_app/models/getuser_model.dart';
import 'package:wbc_connect_app/presentations/gold_point_history_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import 'package:wbc_connect_app/presentations/viewmycontacts.dart';

import '../common_functions.dart';
import '../core/preferences.dart';
import '../models/dashboard.dart';
import '../models/piechart_data.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';
import 'fastTrack_benefits.dart';

// class WBCConnectData {
//   final List<History> history;
//   final List<ContactBase> contactBase;
//   final List<ContactBase> inActiveClients;
//   final int availableContacts;
//   final int goldPoint;
//   final double fastTrackEarning;
//   final List earning;
//   final int redeemable;
//   final int nonRedeemable;
//   final int onTheSpot;

//   WBCConnectData({
//     required this.history,
//     required this.contactBase,
//     required this.inActiveClients,
//     required this.availableContacts,
//     required this.goldPoint,
//     required this.fastTrackEarning,
//     required this.earning,
//     required this.redeemable,
//     required this.nonRedeemable,
//     required this.onTheSpot,
//   });
// }

class WBCConnect extends StatefulWidget {
  static const route = '/WBC-Connect';

  // final WBCConnectData connectData;
  const WBCConnect({
    super.key,
    //  required this.connectData
  });

  @override
  State<WBCConnect> createState() => _WBCConnectState();
}

class _WBCConnectState extends State<WBCConnect> {
  DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
  String mono = "";
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  String selectedEarningTime = 'Yearly';
  String selectedHistoryTime = 'All Time';
  List<String> years = [];
  bool fastTrackStatus = false;
  double totalEarning = 0.0;

  List<String> earningTime = [
    'Monthly',
    'Yearly',
  ];
  List<ChartData> mainList = [];
  // List<ChartData> mainList = [
  //   ChartData(activity: 'Redeemable', value: 955, color: colorTextFFC1),
  //   ChartData(
  //       activity: 'Non-Redeemable', value: 10, color: colorBoxGradiant0040),
  //   ChartData(activity: 'On The Spot', value: 15, color: colorRed),
  // ];

  List<EarningDataYearly> earningDataYearlyList = [
    // EarningDataYearly(year: 2017, value: 1000),
    // EarningDataYearly(year: 2018, value: 300),
    // EarningDataYearly(year: 2019, value: 700),
    // EarningDataYearly(year: 2020, value: 867),
    // EarningDataYearly(year: 2021, value: 500),
    // EarningDataYearly(year: 2022, value: 400),
    // EarningDataYearly(year: 2023, value: 650),
  ];

  List<EarningDataMonthly> earningDataMonthlyList = [
    EarningDataMonthly(month: 01, monthName: 'Jan', value: 0),
    EarningDataMonthly(month: 02, monthName: 'Feb', value: 0),
    EarningDataMonthly(month: 03, monthName: 'Mar', value: 0),
    EarningDataMonthly(month: 04, monthName: 'Apr', value: 0),
    EarningDataMonthly(month: 05, monthName: 'May', value: 0),
    EarningDataMonthly(month: 06, monthName: 'Jun', value: 0),
    EarningDataMonthly(month: 07, monthName: 'Jul', value: 0),
    EarningDataMonthly(month: 08, monthName: 'Aug', value: 0),
    EarningDataMonthly(month: 09, monthName: 'Sep', value: 0),
    EarningDataMonthly(month: 10, monthName: 'Oct', value: 0),
    EarningDataMonthly(month: 11, monthName: 'Nov', value: 0),
    EarningDataMonthly(month: 12, monthName: 'Dec', value: 0),
  ];

  getMobNo() async {
    mono = await Preference.getMobNo();
    setState(() {});
    print('mono-----$mono');
  }

  getGoldPointData() {
    if (GpDashBoardData.redeemable == 0 &&
        GpDashBoardData.nonRedeemable == 0 &&
        GpDashBoardData.onTheSpot == 0) {
      mainList.add(ChartData(activity: '', value: 100, color: colorF3F3));
    } else {
      for (int i = 0; i < 3; i++) {
        i == 0
            ? mainList.add(ChartData(
                activity: 'Redeemable',
                value: GpDashBoardData.redeemable!.toDouble(),
                //  GpDashBoardData.redeemable!.toDouble().isNaN
                //     ? GpDashBoardData.redeemable!.toDouble()
                //     : double.parse(GpDashBoardData.redeemable!
                //         .toDouble()
                //         .toString()
                //         .replaceAll('-', '')),
                color: colorTextFFC1))
            : i == 1
                ? mainList.add(ChartData(
                    activity: 'Non-Redeemable',
                    value: GpDashBoardData.nonRedeemable!.toDouble(),
                    color: colorBoxGradiant0040))
                : mainList.add(ChartData(
                    activity: 'On The Spot',
                    value: GpDashBoardData.onTheSpot!.toDouble(),
                    color: colorRed));
      }
    }
  }

  getFastTrackStatus() async {
    fastTrackStatus = await Preference.getFastTrackStatus();
  }

  getLast7Years() {
    years.add(currentDate.year.toString());
    for (int i = 0; i < 6; i++) {
      var date = currentDate.subtract(const Duration(days: 365));
      years.add(date.year.toString());
      currentDate = date;
    }
    years = List.from(years.reversed);
    for (int i = 0; i < years.length; i++) {
      earningDataYearlyList
          .add(EarningDataYearly(year: int.parse(years[i]), value: 0));
    }
  }

  calculateYearlyEarningAnalysis() {
    if (GpDashBoardData.earning!.isNotEmpty) {
      var date = DateTime.now();
      for (int i = 0; i < GpDashBoardData.earning!.length; i++) {
        var formatDate = DateFormat('yyyy')
            .format(DateTime.parse(GpDashBoardData.earning![i].timestamp));
        if (formatDate == DateFormat('yyyy').format(date)) {
          earningDataYearlyList[6].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 1))) {
          earningDataYearlyList[5].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 2))) {
          earningDataYearlyList[4].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 3))) {
          earningDataYearlyList[3].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 4))) {
          earningDataYearlyList[2].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 5))) {
          earningDataYearlyList[1].value += GpDashBoardData.earning![i].credit;
        }
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year - 6))) {
          earningDataYearlyList[0].value += GpDashBoardData.earning![i].credit;
        }
        totalEarning += GpDashBoardData.earning![i].credit;
      }
    }
  }

  calculateMonthlyEarningAnalysis() {
    if (GpDashBoardData.earning!.isNotEmpty) {
      var date = DateTime.now();
      for (int i = 0; i < GpDashBoardData.earning!.length; i++) {
        var formatDate = DateFormat('yyyy')
            .format(DateTime.parse(GpDashBoardData.earning![i].timestamp));
        var month = DateFormat('MM')
            .format(DateTime.parse(GpDashBoardData.earning![i].timestamp));
        if (formatDate == DateFormat('yyyy').format(DateTime(date.year))) {
          if (month.toString() == '01') {
            earningDataMonthlyList[0].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '02') {
            earningDataMonthlyList[1].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '03') {
            earningDataMonthlyList[2].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '04') {
            earningDataMonthlyList[3].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '05') {
            earningDataMonthlyList[4].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '06') {
            earningDataMonthlyList[5].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '07') {
            earningDataMonthlyList[6].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '08') {
            earningDataMonthlyList[7].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '09') {
            earningDataMonthlyList[8].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '10') {
            earningDataMonthlyList[9].value +=
                GpDashBoardData.earning![i].credit;
          }

          if (month.toString() == '11') {
            earningDataMonthlyList[10].value +=
                GpDashBoardData.earning![i].credit;
          }
          if (month.toString() == '12') {
            earningDataMonthlyList[11].value +=
                GpDashBoardData.earning![i].credit;
          }
        }
      }
    }
  }

  @override
  void initState() {
    getFastTrackStatus();
    getMobNo();
    getGoldPointData();
    getLast7Years();
    calculateMonthlyEarningAnalysis();
    calculateYearlyEarningAnalysis();

    super.initState();
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
          title: Text('GP Dashboard', style: textStyle14Bold(colorBlack)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    width: 90.w,
                    decoration: decoration(colorWhite),
                    child: Column(
                      children: [
                        AspectRatio(
                            aspectRatio: 1.7,
                            child: PieChart(PieChartData(
                              sections: _chartSections(),
                              startDegreeOffset: 270,
                              sectionsSpace: 5,
                              centerSpaceRadius: 12.w,
                            ))),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: Text('TOTAL GOLD POINTS',
                              style: textStyle11(colorText7070)),
                        ),
                        Text(
                            CommonFunction().splitString(
                                GpDashBoardData.goldPoint.toString()),
                            style: textStyle26Bold(colorBlack)),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              wealthScoreIndicator(colorTextFFC1, 'Redeemable',
                                  GpDashBoardData.redeemable.toString()),
                              wealthScoreIndicator(
                                  colorBoxGradiant0040,
                                  'Non-Redeemable',
                                  GpDashBoardData.nonRedeemable.toString()),
                              wealthScoreIndicator(colorRed, 'On The Spot',
                                  GpDashBoardData.onTheSpot.toString()),
                            ],
                          ),
                        ),
                        Container(
                            height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        pointsView(
                            rupeeIcon,
                            'Fastrack Earnings',
                            '₹ ${CommonFunction().splitString(GpDashBoardData.fastTrackEarning.toString())}',
                            'Benefits', () {
                          Navigator.of(context)
                              .pushNamed(FastTrackBenefits.route);
                          // Navigator.of(context)
                          //     .pushNamed(RequestPayment.route);
                        }),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 90.w,
                      decoration: decoration(colorWhite),
                      child: Column(
                        children: [
                          dropDownRow(
                              'EARNING ANALYSIS',
                              selectedEarningTime,
                              List.generate(
                                  earningTime.length,
                                  (i) => menuItem(earningTime[i], () {
                                        setState(() {
                                          selectedEarningTime = earningTime[i];
                                        });
                                      })),
                              true),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h, bottom: 3.h),
                            child: AspectRatio(
                              aspectRatio: 1.8,
                              child: selectedEarningTime == 'Monthly'
                                  ? monthView()
                                  : yearView(),
                            ),
                          ),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: GpDashBoardData.earning!.isEmpty
                                ? Container(
                                    height: 3.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                        fastTrackStatus == true
                                            ? 'No Data'
                                            : '',
                                        style: textStyle13Medium(colorBlack)),
                                  )
                                : Row(
                                    children: [
                                      SizedBox(width: 4.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '₹${CommonFunction().splitString(totalEarning.toStringAsFixed(0))}',
                                              style: textStyle13Bold(
                                                  colorBoxGradiant0040)),
                                          SizedBox(height: 0.5.h),
                                          Text('TOTAL',
                                              style: textStyle9(colorText7070)),
                                        ],
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '₹${CommonFunction().splitString(GpDashBoardData.fastTrackEarning!.toStringAsFixed(0))}',
                                              style: textStyle12Bold(
                                                  colorText4747)),
                                          SizedBox(height: 0.5.h),
                                          Text('EARNING',
                                              style: textStyle9(colorText7070)),
                                        ],
                                      ),
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                    if (fastTrackStatus != true)
                      Positioned(
                          top: 20.h,
                          left: 14.w,
                          child: GpDashBoardData.earning!.isEmpty
                              ? InkWell(
                                  onTap: () {
                                    CommonFunction().errorDialog(context,
                                        'If you want to fastTrack benefits you need to Pay ₹4248 and you can get all the fasttrack benefits in your account.');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 8.h,
                                        width: 8.w,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          icInformation,
                                          width: 6.w,
                                        ),
                                      ),
                                      Text('You Are Not Fastrack User',
                                          style: textStyle13Medium(colorRed)),
                                    ],
                                  ),
                                )
                              : Container())
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    width: 90.w,
                    decoration: decoration(colorWhite),
                    child: Column(
                      children: [
                        dropDownRow(
                            'RECENT GP',
                            selectedHistoryTime,
                            List.generate(
                                earningTime.length,
                                (i) => menuItem(earningTime[i], () {
                                      setState(() {
                                        selectedHistoryTime = earningTime[i];
                                      });
                                    })),
                            false),
                        Container(
                            height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        Column(
                          children: List.generate(
                              GpDashBoardData.history!.length > 4
                                  ? 4
                                  : GpDashBoardData.history!.length,
                              (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.5.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 3.w),
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {},
                                                      icon: GpDashBoardData
                                                              .history![index]
                                                              .imgUrl
                                                              .isEmpty
                                                          ? Image.asset(
                                                              icGoldCoin,
                                                              height: 4.h)
                                                          : Image.network(
                                                              GpDashBoardData
                                                                  .history![
                                                                      index]
                                                                  .imgUrl,
                                                              height: 4.h)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            '${GpDashBoardData.history![index].description} - ',
                                                        style: textStyle10(
                                                            colorText7070),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  GpDashBoardData
                                                                      .history![
                                                                          index]
                                                                      .status,
                                                              style: textStyle10Medium(GpDashBoardData
                                                                          .history![
                                                                              index]
                                                                          .goldPointType ==
                                                                      'Redeemable'
                                                                  ? colorTextFFC1
                                                                  : GpDashBoardData
                                                                              .history![index]
                                                                              .goldPointType ==
                                                                          'Non-Redeemable'
                                                                      ? colorBoxGradiant0040
                                                                      : colorRed)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.2.h,
                                                    ),
                                                    Text(
                                                        "Date:${DateFormat('dd-MM-yyyy').format(DateTime.parse(GpDashBoardData.history![index].date))}",
                                                        style: textStyle10(
                                                            colorText7070))
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: 2.w,
                                              // ),
                                              // const Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Image.asset(
                                                        GpDashBoardData
                                                                    .history![
                                                                        index]
                                                                    .credit !=
                                                                0
                                                            ? icAdd
                                                            : icMinus,
                                                        color: GpDashBoardData
                                                                    .history![
                                                                        index]
                                                                    .credit !=
                                                                0
                                                            ? colorGreen
                                                            : colorRed,
                                                        width: 2.5.w),
                                                    SizedBox(width: 1.w),
                                                    if (GpDashBoardData
                                                            .history![index]
                                                            .credit !=
                                                        0)
                                                      Text(
                                                          '${GpDashBoardData.history![index].credit}',
                                                          style:
                                                              textStyle13Medium(
                                                                  colorGreen)),
                                                    if (GpDashBoardData
                                                            .history![index]
                                                            .debit !=
                                                        0)
                                                      Text(
                                                          GpDashBoardData
                                                              .history![index]
                                                              .debit
                                                              .toString()
                                                              .replaceAll(
                                                                  '-', ''),
                                                          style:
                                                              textStyle13Medium(
                                                                  colorRed)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (index != 3)
                                          Container(
                                              height: 1,
                                              color: colorTextBCBC
                                                  .withOpacity(0.36))
                                      ],
                                    ),
                                  )),
                        ),
                        GpDashBoardData.history!.isEmpty
                            ? Container(
                                height: 6.h,
                                alignment: Alignment.center,
                                child: Text('No Data',
                                    style: textStyle13Medium(colorBlack)),
                              )
                            : InkWell(
                                onTap: () {
                                  if (GpDashBoardData.history!.length > 4) {
                                    Navigator.of(context).pushNamed(
                                        GoldPointHistoryScreen.route,
                                        arguments: GoldPointHistoryData(
                                            history: GpDashBoardData.history!));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      5.w, 1.5.h, 5.w, 2.5.h),
                                  child: Container(
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: colorBG,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('VIEW ALL',
                                        style: textStyle12Bold(colorRed)),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                standFastTrack(
                    'MY TEAM',
                    GpDashBoardData.contactBase![0].type,
                    GpDashBoardData.contactBase![0].count,
                    GpDashBoardData.contactBase![1].type,
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
                  if (temp.isNotEmpty) {
                    Navigator.of(context).pushNamed(ViewMyContacts.route,
                        arguments: ViewScreenData(
                          myContact: temp,
                        ));
                  }
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
                  if (temp.isNotEmpty) {
                    Navigator.of(context).pushNamed(ViewMyContacts.route,
                        arguments: ViewScreenData(
                          myContact: temp,
                        ));
                  }
                }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    width: 90.w,
                    decoration: decoration(colorWhite),
                    child: contactsView(icAddContacts, 'Add Your Contacts',
                        'Add Your Contacts You can add  contacts this month',
                        () {
                      print(
                          'add contacts------${GpDashBoardData.availableContacts}');

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
                  ),
                ),
                standFastTrack(
                    'INACTIVE CLIENTS',
                    GpDashBoardData.inActiveClients![0].type,
                    GpDashBoardData.inActiveClients![0].count,
                    GpDashBoardData.inActiveClients![1].type,
                    GpDashBoardData.inActiveClients![1].count,
                    () => null,
                    () => null),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: GestureDetector(
                    onTap: () {
                      print(
                          'add contacts------${GpDashBoardData.availableContacts}');

                      if (fastTrackStatus == false) {
                        Navigator.of(context)
                            .pushNamed(FastTrackBenefits.route);
                      } else {
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
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                            width: 90.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorBoxGradiant0020,
                                      colorBoxGradiant0040
                                    ])),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(3.5.w, 2.h, 2.w, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 55.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.h),
                                          child: Text(
                                              'Add ${fastTrackStatus == true ? '30' : '10'} Contacts To',
                                              style: textStyle13Bold(colorRed)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.7.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  '${fastTrackStatus == true ? '3000' : '1000'} On The Sport',
                                                  style: textStyle10Bold(
                                                          colorWhite)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600)),
                                              Text(' Gold Points.',
                                                  style: textStyle10Bold(
                                                      colorTextFFC1)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.4.h),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      colorBG.withOpacity(0.45),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('ADD NOW',
                                                      style: textStyle8(
                                                          colorWhite)),
                                                  Image.asset(icNext,
                                                      color: colorWhite,
                                                      height: 1.2.h)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 2.h)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Positioned(
                            right: 0,
                            bottom: -1.2.h,
                            child: Image.asset(imgSportsGold, height: 14.h))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    final List<PieChartSectionData> list = [];
    for (var i in mainList) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: i.color,
        value: i.value,
        radius: radius,
        title: '',
      );
      list.add(data);
    }
    return list;
  }

  wealthScoreIndicator(Color color, String text, String point) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 1.5.w,
              backgroundColor: color,
            ),
            SizedBox(width: 1.5.w),
            Text(text, style: textStyle9(colorText7070))
          ],
        ),
        SizedBox(height: 0.5.h),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(CommonFunction().splitString(point),
              style: textStyle9Bold(colorBlack)),
        )
      ],
    );
  }

  monthView() {
    return BarChart(
      BarChartData(
        barGroups: _chartGroupsMonthly(),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: colorBG,
            tooltipPadding: EdgeInsets.fromLTRB(1.5.w, 1.2.h, 1.5.w, 0.5.h),
            tooltipMargin: 0.5.h,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem('', textStyle11(colorGreen),
                  children: <TextSpan>[
                    TextSpan(text: '+ ', style: textStyle11(colorGreen)),
                    TextSpan(
                        text: '₹${rod.toY.round()}',
                        style: textStyle9(colorGreen)),
                  ]);
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitlesMonthly,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }

  yearView() {
    return BarChart(
      BarChartData(
        barGroups: _chartGroupsYearly(),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: colorBG,
            tooltipPadding: EdgeInsets.fromLTRB(1.5.w, 1.2.h, 1.5.w, 0.5.h),
            tooltipMargin: 0.5.h,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem('', textStyle11(colorGreen),
                  children: <TextSpan>[
                    TextSpan(text: '+ ', style: textStyle11(colorGreen)),
                    TextSpan(
                        text: '₹${rod.toY.round()}',
                        style: textStyle9(colorGreen)),
                  ]);
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitlesYearly,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroupsYearly() {
    return earningDataYearlyList
        .map((point) => BarChartGroupData(x: point.year, barRods: [
              BarChartRodData(
                  backDrawRodData: BackgroundBarChartRodData(
                      color: colorF3F3, show: true, toY: 3500.0),
                  toY: point.value,
                  width: 3.w,
                  color: colorBoxGradiant0040,
                  borderRadius: BorderRadius.circular(5))
            ]))
        .toList();
  }

  List<BarChartGroupData> _chartGroupsMonthly() {
    return earningDataMonthlyList
        .map((point) => BarChartGroupData(x: point.month, barRods: [
              BarChartRodData(
                  // rodStackItems: [BarChartRodStackItem(10, 700, Colors.red)],
                  backDrawRodData: BackgroundBarChartRodData(
                      color: colorF3F3, show: true, toY: 1500.0),
                  toY: point.value,
                  width: 3.w,
                  color: colorBoxGradiant0040,
                  borderRadius: BorderRadius.circular(5))
            ]))
        .toList();
  }

  Widget getTitlesYearly(double value, TitleMeta meta) {
    String text;
    switch (value.toInt() - (int.parse(years.last) - 6)) {
      case 0:
        text = years[0];
        break;
      case 1:
        text = years[1];
        break;
      case 2:
        text = years[2];
        break;
      case 3:
        text = years[3];
        break;
      case 4:
        text = years[4];
        break;
      case 5:
        text = years[5];
        break;
      case 6:
        text = years[6];
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2.h,
      child: Text(text, style: textStyle9(colorText7070)),
    );
  }

  Widget getTitlesMonthly(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 01:
        text = earningDataMonthlyList[0].monthName;
        break;
      case 02:
        text = earningDataMonthlyList[1].monthName;
        break;
      case 03:
        text = earningDataMonthlyList[2].monthName;
        break;
      case 04:
        text = earningDataMonthlyList[3].monthName;
        break;
      case 05:
        text = earningDataMonthlyList[4].monthName;
        break;
      case 06:
        text = earningDataMonthlyList[5].monthName;
        break;
      case 07:
        text = earningDataMonthlyList[6].monthName;
        break;
      case 08:
        text = earningDataMonthlyList[7].monthName;
        break;
      case 09:
        text = earningDataMonthlyList[8].monthName;
        break;
      case 10:
        text = earningDataMonthlyList[9].monthName;
        break;
      case 11:
        text = earningDataMonthlyList[10].monthName;
        break;
      case 12:
        text = earningDataMonthlyList[11].monthName;
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2.h,
      child: Text(text, style: textStyle9(colorText7070)),
    );
  }

  dropDownRow(String title, String selectedType,
      List<PopupMenuItem> menuItemList, bool isShow) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.7.w),
            child: Text(title,
                style:
                    textStyle11Bold(colorBlack).copyWith(letterSpacing: 0.7)),
          ),
          isShow == true
              ? Container(
                  height: 4.h,
                  width: 28.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: colorTextBCBC.withOpacity(0.36), width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: PopupMenuButton(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedType, style: textStyle10(colorText3D3D)),
                        Image.asset(icDropdown,
                            color: colorText3D3D, width: 5.w)
                      ],
                    ),
                    offset: Offset(0, 4.3.h),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: colorRed, width: 1),
                        borderRadius: BorderRadius.circular(7)),
                    itemBuilder: (context) => menuItemList,
                  ),
                )
              : Container(
                  height: 4.h,
                )
        ],
      ),
    );
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        height: 4.5.h,
        padding: EdgeInsets.zero,
        onTap: onClick,
        child: Container(
            width: 25.w,
            color: colorTransparent,
            padding: const EdgeInsets.only(left: 10),
            child: Text(title, style: textStyle10(colorText3D3D))));
  }

  button(String text, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: text == '+' ? 4.h : 4.5.h,
        width: text == '+' ? 8.5.w : 23.w,
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
        child: text == '+'
            ? Image.asset(icAdd, color: colorWhite, width: 3.w)
            : Text(text, style: textStyle9Bold(colorWhite)),
      ),
    );
  }

  pointsView(String icon, String title, String subTitle, String buttonText,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.5.w),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Image.asset(icon, height: 5.h)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle9(colorText7070)),
              SizedBox(height: 0.5.h),
              Text(subTitle, style: textStyle15Bold(colorBlack))
            ],
          ),
          const Spacer(),
          fastTrackStatus == true
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("FastTrack", style: textStyle10Bold(colorBlack)),
                      SizedBox(
                        width: 3.w,
                      ),
                      Icon(Icons.done, size: 2.8.h, color: colorGreen),
                    ],
                  ),
                )
              : button(buttonText, onClick),
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
              SizedBox(height: 0.5.h),
              SizedBox(
                width: 60.w,
                child: RichText(
                  text: TextSpan(
                    text: 'You can add',
                    style: textStyle9(colorBlack),
                    children: <TextSpan>[
                      TextSpan(
                          text: fastTrackStatus == true
                              ? ' 30 Contacts '
                              : ' 10 Contacts ',
                          style: textStyle10Bold(colorRed)),
                      const TextSpan(text: 'this month'),
                    ],
                  ),
                ),
              )
            ],
          ),
          const Spacer(),
          button('+', onClick),
          SizedBox(width: 3.5.w)
        ],
      ),
    );
  }

  standFastTrack(
    String title,
    String title1,
    int title1Value,
    String title2,
    int title2Value,
    Function() onTap1,
    Function() onTap2,
  ) {
    return Container(
      width: 90.w,
      decoration: decoration(colorWhite),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 1.5.w,
                              backgroundColor: colorBoxGradiant0040,
                            ),
                            SizedBox(width: 3.w),
                            Text('$title1Value',
                                style: textStyle18Bold(colorBlack)),
                          ],
                        )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 1.5.w,
                              backgroundColor: colorRed,
                            ),
                            SizedBox(width: 3.w),
                            Text('$title2Value',
                                style: textStyle18Bold(colorBlack)),
                          ],
                        )
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
}
