import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/dashboard.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import 'package:wbc_connect_app/widgets/appbarButton.dart';

class FastTrackEarningData {
  final List<Earning> earning;

  FastTrackEarningData({
    required this.earning,
  });
}

class FastTrackEarningScreen extends StatefulWidget {
  static const route = '/earning-history';
  final FastTrackEarningData earningHistoryData;

  const FastTrackEarningScreen({super.key, required this.earningHistoryData});

  @override
  State<FastTrackEarningScreen> createState() => _FastTrackEarningScreenState();
}

class _FastTrackEarningScreenState extends State<FastTrackEarningScreen> {
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
              title:
                  Text('FastTrack Earning', style: textStyle14Bold(colorBlack)),
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
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  child: widget.earningHistoryData.earning.isEmpty
                      ? Center(
                          child: Text(
                            'No gold point data',
                            style: textStyle13(colorText7070),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          // width: 90.w,
                          // decoration: decoration(colorWhite),
                          child: Column(
                            children: [
                              // Container(
                              //     height: 1,
                              //     color: colorTextBCBC.withOpacity(0.36)),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .earningHistoryData.earning.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.w, left: 5.w),
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
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {},
                                                          icon: Image.asset(
                                                              icEarning,
                                                              height: 4.h)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: widget
                                                                .earningHistoryData
                                                                .earning[index]
                                                                .narration,
                                                            style:
                                                                textStyle10Bold(
                                                                    colorBlack),
                                                            children: const <TextSpan>[
                                                              // TextSpan(
                                                              //     text: widget
                                                              //         .earningHistoryData
                                                              //         .earning[index]
                                                              //         .narration,
                                                              //     style: textStyle10Medium(widget
                                                              //                 .goldPointHistoryData
                                                              //                 .history[
                                                              //                     index]
                                                              //                 .goldPointType ==
                                                              //             'Redeemable'
                                                              //         ? colorTextFFC1
                                                              //         : widget.goldPointHistoryData.history[index]
                                                              //                     .goldPointType ==
                                                              //                 'Non-Redeemable'
                                                              //             ? colorBoxGradiant0040
                                                              //             : colorRed)),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 0.2.h,
                                                        ),
                                                        Text(
                                                            "Date:${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.earningHistoryData.earning[index].timestamp))}",
                                                            style: textStyle10(
                                                                colorText7070))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Image.asset(
                                                            widget
                                                                        .earningHistoryData
                                                                        .earning[
                                                                            index]
                                                                        .credit !=
                                                                    0
                                                                ? icAdd
                                                                : icMinus,
                                                            color: widget
                                                                        .earningHistoryData
                                                                        .earning[
                                                                            index]
                                                                        .credit !=
                                                                    0
                                                                ? colorGreen
                                                                : colorRed,
                                                            width: 2.5.w),
                                                        SizedBox(width: 1.w),
                                                        if (widget
                                                                .earningHistoryData
                                                                .earning[index]
                                                                .credit !=
                                                            0)
                                                          Text(
                                                              '₹${widget.earningHistoryData.earning[index].credit.toInt()}',
                                                              style: textStyle13Medium(
                                                                  colorGreen)),
                                                        if (widget
                                                                .earningHistoryData
                                                                .earning[index]
                                                                .debit !=
                                                            0)
                                                          Text(
                                                              '₹${widget.earningHistoryData.earning[index].debit.toInt()}',
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
                                                color: colorTextBCBC
                                                    .withOpacity(0.36))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              Container(
                                  height: 1,
                                  color: colorTextBCBC.withOpacity(0.36)),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Total Credit : ',
                                        style: textStyle11Bold(colorBlack)
                                            .copyWith(letterSpacing: 0.7)),
                                    Text(
                                        '₹${CommonFunction().splitString(GpDashBoardData.fastTrackEarning!.toInt().toString())}',
                                        style: textStyle11Bold(colorGreen)
                                            .copyWith(letterSpacing: 0.7)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
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
    String title,
    String selectedGoldPointType,
    List<PopupMenuItem> goldPointTypeList,
    String selectedType,
    List<PopupMenuItem> menuItemList,
  ) {
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
                  Flexible(
                    child: Text(
                      selectedGoldPointType,
                      style: textStyle10(colorText3D3D),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Image.asset(icDropdown, color: colorText3D3D, width: 5.w)
                ],
              ),
              offset: Offset(0, 4.3.h),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: colorRed, width: 1),
                  borderRadius: BorderRadius.circular(7)),
              itemBuilder: (context) => goldPointTypeList,
            ),
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
          ),
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
