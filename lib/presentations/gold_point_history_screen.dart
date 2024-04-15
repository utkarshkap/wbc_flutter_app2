import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/models/dashboard.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import 'package:wbc_connect_app/widgets/appbarButton.dart';

class GoldPointHistoryData {
  final List<History> history;

  GoldPointHistoryData({
    required this.history,
  });
}

class GoldPointHistoryScreen extends StatefulWidget {
  static const route = '/gold-point-history';
  final GoldPointHistoryData goldPointHistoryData;
  const GoldPointHistoryScreen({super.key, required this.goldPointHistoryData});

  @override
  State<GoldPointHistoryScreen> createState() => _GoldPointHistoryScreenState();
}

class _GoldPointHistoryScreenState extends State<GoldPointHistoryScreen> {
  List<String> earningTime = [
    'All Time',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  List<History> historyData = [];
  String selectedHistoryTime = 'All Time';
  ScrollController scrollController = ScrollController();
  bool isDataOver = false;
  var counts = 0;
  String filteredItem = '';
  bool month = false;
  @override
  void initState() {
    addGoldpointsHistoryData();
    scrollController.addListener(pagination);
    super.initState();
  }

  addGoldpointsHistoryData() {
    if (historyData.isEmpty) {
      for (int i = 0; i < 10; i++) {
        if (i == widget.goldPointHistoryData.history.length) {
          isDataOver = true;
          break;
        } else {
          historyData.add(widget.goldPointHistoryData.history[i]);
        }
      }
    }
  }

  void pagination() {
    if (isDataOver == false) {
      if ((scrollController.position.pixels ==
          scrollController.position.maxScrollExtent)) {
        setState(() {
          counts += 10;
          addData(counts);
        });
      }
    }
  }

  addData(int count) {
    for (int i = count; i < count + 10; i++) {
      if (i == widget.goldPointHistoryData.history.length) {
        isDataOver = true;
        break;
      } else {
        historyData.add(widget.goldPointHistoryData.history[i]);
      }
    }
  }

  checkData() {
    for (int i = 0; i < widget.goldPointHistoryData.history.length; i++) {
      if (filteredItem ==
          DateFormat('MM-yyyy').format(
              DateTime.parse(widget.goldPointHistoryData.history[i].date))) {
        setState(() {
          month = true;
        });
        break;
      }
    }
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
              title: Text('Gold Points History',
                  style: textStyle14Bold(colorBlack)),
              actions: [
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
                child: Padding(
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
                                        var date = DateTime.now();
                                        if (selectedHistoryTime == 'Weekly') {
                                          var d = DateTime.now();
                                          var weekDay = d.weekday;
                                          var firstDayOfWeek = d.subtract(
                                              Duration(days: weekDay));
                                          // print('-------${date.weekday}');
                                          // print('*********${date.weekday - 1}');
                                        }
                                        if (selectedHistoryTime == 'Monthly') {
                                          filteredItem = DateFormat('MM-yyyy')
                                              .format(date);
                                          checkData();
                                        } else if (selectedHistoryTime ==
                                            'Yearly') {
                                          filteredItem =
                                              DateFormat('yyyy').format(date);
                                        } else {
                                          filteredItem = '';
                                        }
                                      });
                                    }))),
                        Container(
                            height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        if (selectedHistoryTime == 'All Time') ...[
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                controller: scrollController,
                                itemCount: historyData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
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
                                                      icon: widget
                                                              .goldPointHistoryData
                                                              .history[index]
                                                              .imgUrl
                                                              .isEmpty
                                                          ? Image.asset(
                                                              icGoldCoin,
                                                              height: 4.h)
                                                          : Image.network(
                                                              widget
                                                                  .goldPointHistoryData
                                                                  .history[
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
                                                            '${widget.goldPointHistoryData.history[index].description} - ',
                                                        style: textStyle10(
                                                            colorText7070),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: widget
                                                                  .goldPointHistoryData
                                                                  .history[
                                                                      index]
                                                                  .status,
                                                              style: textStyle10Medium(
                                                                  colorGreen)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0.2.h,
                                                    ),
                                                    Text(
                                                        "Date:${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.goldPointHistoryData.history[index].date))}",
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
                                                        widget
                                                                    .goldPointHistoryData
                                                                    .history[
                                                                        index]
                                                                    .credit !=
                                                                0
                                                            ? icAdd
                                                            : icMinus,
                                                        color: widget
                                                                    .goldPointHistoryData
                                                                    .history[
                                                                        index]
                                                                    .credit !=
                                                                0
                                                            ? colorGreen
                                                            : colorRed,
                                                        width: 2.5.w),
                                                    SizedBox(width: 1.w),
                                                    if (widget
                                                            .goldPointHistoryData
                                                            .history[index]
                                                            .credit !=
                                                        0)
                                                      Text(
                                                          '${widget.goldPointHistoryData.history[index].credit}',
                                                          style:
                                                              textStyle13Medium(
                                                                  colorGreen)),
                                                    if (widget
                                                            .goldPointHistoryData
                                                            .history[index]
                                                            .debit !=
                                                        0)
                                                      Text(
                                                          widget
                                                              .goldPointHistoryData
                                                              .history[index]
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
                                        Container(
                                            height: 1,
                                            color:
                                                colorTextBCBC.withOpacity(0.36))
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ] else ...[
                          if (selectedHistoryTime == 'Monthly')
                            if (month == false) ...[
                              SizedBox(
                                height: 100.h / 3,
                              ),
                              Text(
                                'No contact added this month please add contacts and earn gold point.',
                                style: textStyle13(colorText7070),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    widget.goldPointHistoryData.history.length,
                                    (index) => DateFormat(
                                                selectedHistoryTime == 'Yearly'
                                                    ? 'yyyy'
                                                    : selectedHistoryTime ==
                                                            'Monthly'
                                                        ? 'MM-yyyy'
                                                        : '')
                                            .format(DateTime.parse(widget
                                                .goldPointHistoryData
                                                .history[index]
                                                .date))
                                            .contains(filteredItem)
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 3.w),
                                                          child: IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onPressed: () {},
                                                              icon: widget
                                                                      .goldPointHistoryData
                                                                      .history[
                                                                          index]
                                                                      .imgUrl
                                                                      .isEmpty
                                                                  ? Image.asset(
                                                                      icGoldCoin,
                                                                      height:
                                                                          4.h)
                                                                  : Image.network(
                                                                      widget
                                                                          .goldPointHistoryData
                                                                          .history[
                                                                              index]
                                                                          .imgUrl,
                                                                      height:
                                                                          4.h)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    '${widget.goldPointHistoryData.history[index].description} - ',
                                                                style: textStyle10(
                                                                    colorText7070),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                      text: widget
                                                                          .goldPointHistoryData
                                                                          .history[
                                                                              index]
                                                                          .status,
                                                                      style: textStyle10Medium(
                                                                          colorGreen)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 0.2.h,
                                                            ),
                                                            Text(
                                                                "Date:${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.goldPointHistoryData.history[index].date))}",
                                                                style: textStyle10(
                                                                    colorText7070))
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Image.asset(
                                                                widget
                                                                            .goldPointHistoryData
                                                                            .history[
                                                                                index]
                                                                            .credit !=
                                                                        0
                                                                    ? icAdd
                                                                    : icMinus,
                                                                color: widget
                                                                            .goldPointHistoryData
                                                                            .history[index]
                                                                            .credit !=
                                                                        0
                                                                    ? colorGreen
                                                                    : colorRed,
                                                                width: 2.5.w),
                                                            SizedBox(
                                                                width: 1.w),
                                                            if (widget
                                                                    .goldPointHistoryData
                                                                    .history[
                                                                        index]
                                                                    .credit !=
                                                                0)
                                                              Text(
                                                                  '${widget.goldPointHistoryData.history[index].credit}',
                                                                  style: textStyle13Medium(
                                                                      colorGreen)),
                                                            if (widget
                                                                    .goldPointHistoryData
                                                                    .history[
                                                                        index]
                                                                    .debit !=
                                                                0)
                                                              Text(
                                                                  widget
                                                                      .goldPointHistoryData
                                                                      .history[
                                                                          index]
                                                                      .debit
                                                                      .toString()
                                                                      .replaceAll(
                                                                          '-',
                                                                          ''),
                                                                  style: textStyle13Medium(
                                                                      colorRed)),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    height: 1,
                                                    color: colorTextBCBC
                                                        .withOpacity(0.36))
                                              ],
                                            ),
                                          )
                                        : Container()),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 5.h)
                      ],
                    ),
                  ),
                ))));
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
}
