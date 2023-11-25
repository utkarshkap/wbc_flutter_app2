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
  List<History> data = [];
  String selectedHistoryTime = 'All Time';
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    //added the pagination function with listener
    // scrollController.addListener(pagination);
    super.initState();
  }

  addData() {
    if (data.isEmpty) {
      if (widget.goldPointHistoryData.history.length <= 10) {
        data = widget.goldPointHistoryData.history;
      } else {
        for (int i = 10; i < 20; i++) {}
      }
    }
  }

//_subCategoryModel only use for check the length of product

  void pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent)
        //  &&
        // (_subCategoryModel.products.length < total)
        ) {
      print("IF:::::::::::::::::::::::::::;");
      setState(() {
        isLoading = true;
        // page += 1;
        //add api for load the more data according to new page
      });
    }
    isLoading = false;
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
                                          selectedHistoryTime = earningTime[i];
                                        });
                                      }))),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          // Expanded(
                          //   child: ListView.builder(
                          //       controller: scrollController,
                          //       itemCount:
                          //           widget.goldPointHistoryData.history.length,
                          //       itemBuilder: (context, index) {
                          //         return Padding(
                          //           padding:
                          //               EdgeInsets.symmetric(horizontal: 4.w),
                          //           child: Column(
                          //             children: [
                          //               Padding(
                          //                 padding: EdgeInsets.symmetric(
                          //                     vertical: 1.5.h),
                          //                 child: Row(
                          //                   children: [
                          //                     Padding(
                          //                       padding:
                          //                           EdgeInsets.only(right: 3.w),
                          //                       child: IconButton(
                          //                           padding: EdgeInsets.zero,
                          //                           onPressed: () {},
                          //                           icon: widget
                          //                                   .goldPointHistoryData
                          //                                   .history[index]
                          //                                   .imgUrl
                          //                                   .isEmpty
                          //                               ? Image.asset(icGoldCoin,
                          //                                   height: 4.h)
                          //                               : Image.network(
                          //                                   widget
                          //                                       .goldPointHistoryData
                          //                                       .history[index]
                          //                                       .imgUrl,
                          //                                   height: 4.h)),
                          //                     ),
                          //                     Column(
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(
                          //                             widget.goldPointHistoryData
                          //                                 .history[index].name,
                          //                             style: textStyle11Bold(
                          //                                 colorText3D3D)),
                          //                         SizedBox(height: 0.7.h),
                          //                         RichText(
                          //                           text: TextSpan(
                          //                             text: '4 transactions - ',
                          //                             style: textStyle9(
                          //                                 colorText7070),
                          //                             children: <TextSpan>[
                          //                               TextSpan(
                          //                                   text: widget
                          //                                       .goldPointHistoryData
                          //                                       .history[index]
                          //                                       .status,
                          //                                   style:
                          //                                       textStyle10Medium(
                          //                                           colorGreen)),
                          //                             ],
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                     const Spacer(),
                          //                     Row(
                          //                       children: [
                          //                         Image.asset(
                          //                             widget
                          //                                         .goldPointHistoryData
                          //                                         .history[index]
                          //                                         .status ==
                          //                                     'Completed'
                          //                                 ? icAdd
                          //                                 : icMinus,
                          //                             color: widget
                          //                                         .goldPointHistoryData
                          //                                         .history[index]
                          //                                         .status ==
                          //                                     'Completed'
                          //                                 ? colorGreen
                          //                                 : colorRed,
                          //                             width: 2.5.w),
                          //                         SizedBox(width: 1.w),
                          //                         Text(
                          //                             '${widget.goldPointHistoryData.history[index].gp}',
                          //                             style: textStyle13Medium(
                          //                                 colorGreen)),
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               if (index != 3)
                          //                 Container(
                          //                     height: 1,
                          //                     color:
                          //                         colorTextBCBC.withOpacity(0.36))
                          //             ],
                          //           ),
                          //         );
                          //       }),
                          // ),
                          Column(
                            children: List.generate(
                                widget.goldPointHistoryData.history.length,
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
                                                // Column(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.start,
                                                //   children: [
                                                //     Text(
                                                //         widget
                                                //             .goldPointHistoryData
                                                //             .history[index]
                                                //             .name,
                                                //         style: textStyle11Bold(
                                                //             colorText3D3D)),
                                                //     SizedBox(height: 0.7.h),
                                                //     RichText(
                                                //       text: TextSpan(
                                                //         text:
                                                //             '4 transactions - ',
                                                //         style: textStyle9(
                                                //             colorText7070),
                                                //         children: <TextSpan>[
                                                //           TextSpan(
                                                //               text: widget
                                                //                   .goldPointHistoryData
                                                //                   .history[
                                                //                       index]
                                                //                   .status,
                                                //               style: textStyle10Medium(
                                                //                   colorGreen)),
                                                //         ],
                                                //       ),
                                                //     )
                                                //   ],
                                                // ),

                                                Flexible(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text:
                                                          '${widget.goldPointHistoryData.history[index].description} - ',
                                                      style: textStyle10Bold(
                                                          colorText3D3D),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: widget
                                                                .goldPointHistoryData
                                                                .history[index]
                                                                .status,
                                                            style:
                                                                textStyle10Medium(
                                                                    colorGreen)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                // const Spacer(),
                                                Row(
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
                                    )),
                          ),
                          SizedBox(height: 5.h)
                        ],
                      ),
                    ),
                  )),
            )));
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
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wbc_connect_app/models/dashboard.dart';
// import 'package:wbc_connect_app/presentations/profile_screen.dart';
// import 'package:wbc_connect_app/resources/resource.dart';
// import 'package:wbc_connect_app/widgets/appbarButton.dart';

// class GoldPointHistoryData {
//   final List<History> history;

//   GoldPointHistoryData({
//     required this.history,
//   });
// }

// class GoldPointHistoryScreen extends StatefulWidget {
//   static const route = '/gold-point-history';
//   final GoldPointHistoryData goldPointHistoryData;
//   const GoldPointHistoryScreen({super.key, required this.goldPointHistoryData});

//   @override
//   State<GoldPointHistoryScreen> createState() => _GoldPointHistoryScreenState();
// }

// class _GoldPointHistoryScreenState extends State<GoldPointHistoryScreen> {
//   List<String> earningTime = [
//     'All Time',
//     'Weekly',
//     'Monthly',
//     'Yearly',
//   ];
//   List<History> historyData = [];
//   String selectedHistoryTime = 'All Time';
//   ScrollController scrollController = ScrollController();
//   bool isDataOver = false;
//   var counts = 0;

//   @override
//   void initState() {
//     addGoldpointsHistoryData();
//     scrollController.addListener(pagination);
//     super.initState();
//   }

//   addGoldpointsHistoryData() {
//     if (historyData.isEmpty) {
//       for (int i = 0; i < 10; i++) {
//         if (i == widget.goldPointHistoryData.history.length) {
//           isDataOver = true;
//           break;
//         } else {
//           historyData.add(widget.goldPointHistoryData.history[i]);
//         }
//       }
//     }
//   }

//   void pagination() {
//     if (isDataOver == false) {
//       if ((scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent)) {
//         setState(() {
//           counts += 10;
//           addData(counts);
//         });
//       }
//     }
//   }

//   addData(int count) {
//     for (int i = count; i < count + 10; i++) {
//       if (i == widget.goldPointHistoryData.history.length) {
//         isDataOver = true;
//         break;
//       } else {
//         historyData.add(widget.goldPointHistoryData.history[i]);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.dark,
//         child: Scaffold(
//             backgroundColor: colorBG,
//             appBar: AppBar(
//               toolbarHeight: 8.h,
//               backgroundColor: colorWhite,
//               elevation: 6,
//               shadowColor: colorTextBCBC.withOpacity(0.3),
//               leadingWidth: 15.w,
//               leading: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: Image.asset(icBack, color: colorRed, width: 6.w)),
//               titleSpacing: 0,
//               title: Text('Gold Points History',
//                   style: textStyle14Bold(colorBlack)),
//               actions: [
//                 AppBarButton(
//                     splashColor: colorWhite,
//                     bgColor: colorF3F3,
//                     icon: icProfile,
//                     iconColor: colorText7070,
//                     onClick: () {
//                       Navigator.of(context).pushNamed(ProfileScreen.route);
//                     }),
//                 SizedBox(width: 5.w)
//               ],
//             ),
//             body: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 5.w),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 3.h),
//                   child: Container(
//                     width: 90.w,
//                     decoration: decoration(colorWhite),
//                     child: Column(
//                       children: [
//                         dropDownRow(
//                             'HISTORY',
//                             selectedHistoryTime,
//                             List.generate(
//                                 earningTime.length,
//                                 (i) => menuItem(earningTime[i], () {
//                                       setState(() {
//                                         selectedHistoryTime = earningTime[i];
//                                       });
//                                     }))),
//                         Container(
//                             height: 1, color: colorTextBCBC.withOpacity(0.36)),
//                         Expanded(
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               controller: scrollController,
//                               itemCount: historyData.length,
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding:
//                                       EdgeInsets.symmetric(horizontal: 4.w),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 1.5.h),
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   EdgeInsets.only(right: 3.w),
//                                               child: IconButton(
//                                                   padding: EdgeInsets.zero,
//                                                   onPressed: () {},
//                                                   icon: historyData[index]
//                                                           .imgUrl
//                                                           .isEmpty
//                                                       ? Image.asset(icGoldCoin,
//                                                           height: 4.h)
//                                                       : Image.network(
//                                                           historyData[index]
//                                                               .imgUrl,
//                                                           height: 4.h)),
//                                             ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(historyData[index].name,
//                                                     style: textStyle11Bold(
//                                                         colorText3D3D)),
//                                                 SizedBox(height: 0.7.h),
//                                                 RichText(
//                                                   text: TextSpan(
//                                                     text: '4 transactions - ',
//                                                     style: textStyle9(
//                                                         colorText7070),
//                                                     children: <TextSpan>[
//                                                       TextSpan(
//                                                           text:
//                                                               historyData[index]
//                                                                   .status,
//                                                           style:
//                                                               textStyle10Medium(
//                                                                   colorGreen)),
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             const Spacer(),
//                                             Row(
//                                               children: [
//                                                 Image.asset(
//                                                     historyData[index].status ==
//                                                             'Completed'
//                                                         ? icAdd
//                                                         : icMinus,
//                                                     color: historyData[index]
//                                                                 .status ==
//                                                             'Completed'
//                                                         ? colorGreen
//                                                         : colorRed,
//                                                     width: 2.5.w),
//                                                 SizedBox(width: 1.w),
//                                                 Text('${historyData[index].gp}',
//                                                     style: textStyle13Medium(
//                                                         colorGreen)),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 1,
//                                           color:
//                                               colorTextBCBC.withOpacity(0.36))
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ),
//                         SizedBox(height: 5.h)
//                       ],
//                     ),
//                   ),
//                 ))));
//   }

//   BoxDecoration decoration(Color bgColor) {
//     return BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           if (bgColor == colorWhite)
//             BoxShadow(
//                 color: colorTextBCBC.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 6))
//         ]);
//   }

//   dropDownRow(
//       String title, String selectedType, List<PopupMenuItem> menuItemList) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.7.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 0.7.w),
//             child: Text(title,
//                 style:
//                     textStyle11Bold(colorBlack).copyWith(letterSpacing: 0.7)),
//           ),
//           Container(
//             height: 4.h,
//             width: 28.w,
//             decoration: BoxDecoration(
//                 border: Border.all(
//                     color: colorTextBCBC.withOpacity(0.36), width: 1),
//                 borderRadius: BorderRadius.circular(5)),
//             child: PopupMenuButton(
//               icon: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(selectedType, style: textStyle10(colorText3D3D)),
//                   Image.asset(icDropdown, color: colorText3D3D, width: 5.w)
//                 ],
//               ),
//               offset: Offset(0, 4.3.h),
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: colorRed, width: 1),
//                   borderRadius: BorderRadius.circular(7)),
//               itemBuilder: (context) => menuItemList,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   PopupMenuItem menuItem(String title, Function() onClick) {
//     return PopupMenuItem(
//         height: 4.5.h,
//         padding: EdgeInsets.zero,
//         onTap: onClick,
//         child: Container(
//             width: 25.w,
//             color: colorTransparent,
//             padding: const EdgeInsets.only(left: 10),
//             child: Text(title, style: textStyle10(colorText3D3D))));
//   }
// }
