import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String selectedHistoryTime = 'All Time';
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
            body: SingleChildScrollView(
                child: Padding(
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
                                            selectedHistoryTime =
                                                earningTime[i];
                                          });
                                        }))),
                            Container(
                                height: 1,
                                color: colorTextBCBC.withOpacity(0.36)),
                            Column(
                              children: List.generate(
                                  widget.goldPointHistoryData.history.length,
                                  (index) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5.h),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 3.w),
                                                    child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () {},
                                                        icon: widget
                                                                .goldPointHistoryData
                                                                .history[index]
                                                                .imgUrl
                                                                .isEmpty
                                                            ? Image.asset(
                                                                imgBurger,
                                                                height: 4.h)
                                                            : Image.network(
                                                                widget
                                                                    .goldPointHistoryData
                                                                    .history[
                                                                        index]
                                                                    .imgUrl,
                                                                height: 4.h)),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          widget
                                                              .goldPointHistoryData
                                                              .history[index]
                                                              .name,
                                                          style: textStyle11Bold(
                                                              colorText3D3D)),
                                                      SizedBox(height: 0.7.h),
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '4 transactions - ',
                                                          style: textStyle9(
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
                                                      )
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          widget
                                                                      .goldPointHistoryData
                                                                      .history[
                                                                          index]
                                                                      .status ==
                                                                  'Completed'
                                                              ? icAdd
                                                              : icMinus,
                                                          color: widget
                                                                      .goldPointHistoryData
                                                                      .history[
                                                                          index]
                                                                      .status ==
                                                                  'Completed'
                                                              ? colorGreen
                                                              : colorRed,
                                                          width: 2.5.w),
                                                      SizedBox(width: 1.w),
                                                      Text(
                                                          '${widget.goldPointHistoryData.history[index].gp}',
                                                          style:
                                                              textStyle13Medium(
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
                            SizedBox(height: 5.h)
                          ],
                        ),
                      ),
                    )))));
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
