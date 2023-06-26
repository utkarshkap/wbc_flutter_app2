import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/models/earning_data.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';

import '../common_functions.dart';
import '../core/preferences.dart';
import '../models/dashboard.dart';
import '../models/piechart_data.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';
import 'fastTrack_benefits.dart';

class WBCConnectData {
  final List<History> history;
  final List<ContactBase> contactBase;
  final List<ContactBase> inActiveClients;
  final int availableContacts;

  WBCConnectData(
      {required this.history,
      required this.contactBase,
      required this.inActiveClients,
      required this.availableContacts});
}

class WBCConnect extends StatefulWidget {
  static const route = '/WBC-Connect';
  final WBCConnectData connectData;

  const WBCConnect({super.key, required this.connectData});

  @override
  State<WBCConnect> createState() => _WBCConnectState();
}

class _WBCConnectState extends State<WBCConnect> {
  DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
  String mono = "";
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  String selectedEarningTime = 'All Time';
  String selectedHistoryTime = 'All Time';
  List<String> years = [];

  List<String> earningTime = [
    'All Time',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  List<ChartData> mainList = [
    ChartData(activity: 'Redeemable', value: 35, color: colorTextFFC1),
    ChartData(
        activity: 'Non-Redeemable', value: 20, color: colorBoxGradiant0040),
    ChartData(activity: 'On The Spot', value: 45, color: colorRed),
  ];

  List<EarningData> earningDataList = [
    EarningData(year: 2016, value: 1000),
    EarningData(year: 2017, value: 300),
    EarningData(year: 2018, value: 700),
    EarningData(year: 2019, value: 867),
    EarningData(year: 2020, value: 500),
    EarningData(year: 2021, value: 400),
    EarningData(year: 2022, value: 650),
  ];

  getMobNog() async {
    mono = await Preference.getMobNo();
    setState(() {});
    print('mono-----$mono');
  }

  @override
  void initState() {
    getMobNog();
    years.add(currentDate.year.toString());
    for (int i = 0; i < 6; i++) {
      var date = currentDate.subtract(const Duration(days: 365));
      years.add(date.year.toString());
      currentDate = date;
    }
    years = List.from(years.reversed);
    print('----years--==----$years');
    print('----history--==----${widget.connectData.history}');
    print('----contactBase--==----${widget.connectData.contactBase}');
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
          title: Text('Finer', style: textStyle14Bold(colorBlack)),
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
                onClick: () {Navigator.of(context).pushNamed(ProfileScreen.route);}),
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
                        SizedBox(height: 1.h),
                        AspectRatio(
                            aspectRatio: 1.5,
                            child: PieChart(PieChartData(
                              sections: _chartSections(),
                              startDegreeOffset: 270,
                              sectionsSpace: 13,
                              centerSpaceRadius: 15.w,
                            ))),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Text('TOTAL GOLD POINTS',
                              style: textStyle11(colorText7070)),
                        ),
                        Text('6,02,304', style: textStyle26Bold(colorBlack)),
                        Padding(
                          padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              wealthScoreIndicator(colorTextFFC1, 'Redeemable'),
                              wealthScoreIndicator(
                                  colorBoxGradiant0040, 'Non-Redeemable'),
                              wealthScoreIndicator(colorRed, 'On The Spot'),
                            ],
                          ),
                        ),
                        Container(
                            height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        pointsView(icGoldCoin, 'Fastrack Earnings',
                            '₹ 36,95,325/-', 'Benefits', () {
                              Navigator.of(context).pushNamed(FastTrackBenefits.route);
                              // Navigator.of(context)
                              //     .pushNamed(RequestPayment.route);
                            }),
                      ],
                    ),
                  ),
                ),
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
                                  }))),
                      Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                      Padding(
                        padding: EdgeInsets.only(top: 5.h, bottom: 3.h),
                        child: AspectRatio(
                          aspectRatio: 1.8,
                          child:
                          // selectedEarningTime == 'Monthly'
                          //     ? monthView()
                          //     :
                          weekView(),
                        ),
                      ),
                      Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          children: [
                            SizedBox(width: 4.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('₹45,525',
                                    style:
                                        textStyle13Bold(colorBoxGradiant0040)),
                                SizedBox(height: 0.5.h),
                                Text('TOTAL', style: textStyle9(colorText7070)),
                              ],
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('₹25,525',
                                    style: textStyle12Bold(colorText4747)),
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    width: 90.w,
                    decoration: decoration(colorWhite),
                    child: Column(
                      children: [
                        dropDownRow(
                            'HISTORY',
                            selectedHistoryTime,
                            List.generate(
                                earningTime.length,
                                (i) => menuItem(earningTime[i], () {
                                      setState(() {
                                        selectedHistoryTime = earningTime[i];
                                      });
                                    }))),
                        Container(
                            height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        Column(
                          children: List.generate(
                              widget.connectData.history.length > 4
                                  ? 4
                                  : widget.connectData.history.length,
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
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 3.w),
                                                child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {},
                                                    icon: widget
                                                            .connectData
                                                            .history[index]
                                                            .imgUrl
                                                            .isEmpty
                                                        ? Image.asset(imgBurger,
                                                            height: 4.h)
                                                        : Image.network(
                                                            widget
                                                                .connectData
                                                                .history[index]
                                                                .imgUrl,
                                                            height: 4.h)),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      widget.connectData
                                                          .history[index].name,
                                                      style: textStyle11Bold(
                                                          colorText3D3D)),
                                                  SizedBox(height: 0.7.h),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '4 transactions - ',
                                                      style: textStyle9(
                                                          colorText7070),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: widget
                                                                .connectData
                                                                .history[index]
                                                                .status,
                                                            style:
                                                                textStyle10Medium(
                                                                    colorGreen)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      widget
                                                                  .connectData
                                                                  .history[
                                                                      index]
                                                                  .status ==
                                                              'Completed'
                                                          ? icAdd
                                                          : icMinus,
                                                      color: widget
                                                                  .connectData
                                                                  .history[
                                                                      index]
                                                                  .status ==
                                                              'Completed'
                                                          ? colorGreen
                                                          : colorRed,
                                                      width: 2.5.w),
                                                  SizedBox(width: 1.w),
                                                  Text(
                                                      '${widget.connectData.history[index].gp}',
                                                      style: textStyle13Medium(
                                                          colorGreen)),
                                                ],
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.5.h),
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
                      ],
                    ),
                  ),
                ),
                standFastTrack(
                    'MY CONTACTS BASE',
                    widget.connectData.contactBase[0].type,
                    widget.connectData.contactBase[0].count,
                    widget.connectData.contactBase[1].type,
                    widget.connectData.contactBase[1].count),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Container(
                    width: 90.w,
                    decoration: decoration(colorWhite),
                    child: contactsView(
                        icAddContacts,
                        'Add Your Contacts',
                        'Add Your Contacts You can add 96 contacts this month',
                        () {
                          print('add contacts------${widget.connectData.availableContacts}');

                          if (widget.connectData.availableContacts != 0) {
                            Preference.setRenewContact(true);
                            Navigator.of(context).pushNamed(
                                VerificationScreen.route,
                                arguments: VerificationScreenData(
                                    getNumber: "",
                                    number: mono,
                                    verificationId: "",
                                    isLogin: true,
                                    selectedContact: widget.connectData.availableContacts,
                                    isHomeContactOpen: true));
                          } else {
                            CommonFunction().reachedMaxContactPopup(context);
                          }
                        }),
                  ),
                ),
                standFastTrack('INACTIVE CLIENTS',
                    widget.connectData.inActiveClients[0].type,
                    widget.connectData.inActiveClients[0].count,
                    widget.connectData.inActiveClients[1].type,
                    widget.connectData.inActiveClients[1].count),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: GestureDetector(
                    onTap: (){
                      print('add contacts------${widget.connectData.availableContacts}');

                      if (widget.connectData.availableContacts != 0) {
                        Preference.setRenewContact(true);
                        Navigator.of(context).pushNamed(
                            VerificationScreen.route,
                            arguments: VerificationScreenData(
                                getNumber: "",
                                number: mono,
                                verificationId: "",
                                isLogin: true,
                                selectedContact: widget.connectData.availableContacts,
                                isHomeContactOpen: true));
                      } else {
                        CommonFunction()
                            .reachedMaxContactPopup(context);
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          child: Text('Add 10 Contacts To',
                                              style: textStyle13Bold(colorRed)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.7.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text('900 On The Sport',
                                                  style:
                                                      textStyle10Bold(colorWhite)
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
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
                                                      style:
                                                          textStyle8(colorWhite)),
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

  monthView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 400,
        width: deviceWidth(context) * 3.7,
        child: BarChart(
          BarChartData(
            barGroups: _chartGroups(),
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
                            text: '\$${rod.toY.round()}',
                            style: textStyle9(colorGreen)),
                      ]);
                },
              ),
            ),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: getTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  weekView() {
    return BarChart(
      BarChartData(
        barGroups: _chartGroups(),
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
                        text: '\$${rod.toY.round()}',
                        style: textStyle9(colorGreen)),
                  ]);
            },
          ),
        ),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
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

  wealthScoreIndicator(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 1.5.w,
          backgroundColor: color,
        ),
        SizedBox(width: 1.5.w),
        Text(text, style: textStyle9(colorText7070))
      ],
    );
  }

  dropDownRow(
      String title, String selectedType, List<PopupMenuItem> menuItemList) {
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
          Container(
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
                  Image.asset(icDropdown, color: colorText3D3D, width: 5.w)
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

  List<BarChartGroupData> _chartGroups() {
    return earningDataList
        .map((point) => BarChartGroupData(x: point.year, barRods: [
              BarChartRodData(
                  toY: point.value,
                  width: 3.w,
                  color: colorBoxGradiant0040,
                  borderRadius: BorderRadius.circular(5))
            ]))
        .toList();
  }

  Widget getTitles(double value, TitleMeta meta) {
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
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.5.w),
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
          button(buttonText, onClick),
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
              decoration: BoxDecoration(
                color: colorRed.withOpacity(0.29),
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
                          text: ' 96 Contacts ',
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

  standFastTrack(String title, String title1, int title1Value, String title2,
      int title2Value) {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(title1, style: textStyle9(colorText3D3D)),
                    Row(
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
                Container(
                    height: 10.h,
                    width: 1,
                    color: colorTextBCBC.withOpacity(0.36)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(title2, style: textStyle9(colorText3D3D)),
                    Row(
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
