import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../profile_screen.dart';

class RealEstateProperty extends StatefulWidget {
  static const route = '/Real-Estate-Property';

  const RealEstateProperty({super.key});

  @override
  State<RealEstateProperty> createState() => _RealEstatePropertyState();
}

class _RealEstatePropertyState extends State<RealEstateProperty> {
  final TextEditingController _searchController = TextEditingController();

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Real Estate', style: textStyle14Bold(colorBlack)),
              // SizedBox(height: 0.5.h),
              // Text('Property in Adajan Surat for Sale',
              //     style: textStyle8(colorText7070)),
            ],
          ),
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
          // bottom: PreferredSize(
          //     preferredSize: Size(100.w, 8.h),
          //     child: Padding(
          //       padding: EdgeInsets.only(bottom: 2.h),
          //       child: Container(
          //         height: 6.h,
          //         width: 92.w,
          //         decoration: BoxDecoration(
          //             color: colorF3F3,
          //             borderRadius: BorderRadius.circular(10)),
          //         child: Row(
          //           children: [
          //             Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 4.w),
          //               child: Image.asset(icSearch, width: 5.w),
          //             ),
          //             Expanded(
          //               child: Padding(
          //                 padding: EdgeInsets.only(right: 3.w),
          //                 child: TextFormField(
          //                   controller: _searchController,
          //                   style: textStyle12(colorText7070),
          //                   decoration: InputDecoration.collapsed(
          //                     hintText: 'Office in adajan',
          //                     hintStyle: textStyle12(colorText7070),
          //                     fillColor: colorF3F3,
          //                     filled: true,
          //                     border: OutlineInputBorder(
          //                         borderRadius: BorderRadius.circular(10),
          //                         borderSide: BorderSide.none),
          //                   ),
          //                   onChanged: (val) {},
          //                   keyboardType: TextInputType.name,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     )),
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is RealEstatePropertyErrorState) {
              AwesomeDialog(
                btnCancelColor: colorRed,
                padding: EdgeInsets.zero,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                headerAnimationLoop: false,
                title: 'Something Went Wrong',
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          builder: (context, state) {
            return BlocBuilder<FetchingDataBloc, FetchingDataState>(
              builder: (context, state) {
                if (state is RealEstatePropertyInitial) {
                  return Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            color: colorRed, strokeWidth: 0.7.w)),
                  );
                }
                if (state is RealEstatePropertyLoadedState) {
                  return state.realEstatePropertyModel.realty.isEmpty
                      ? Center(
                          child: Text('No Data',
                              style: textStyle13(colorText7070)))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(4.w, 2.5.h, 4.w, 0),
                            child: Column(
                              children: List.generate(
                                  state.realEstatePropertyModel.realty.length,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Container(
                                          decoration: decoration(colorWhite),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                            left:
                                                                Radius.circular(
                                                                    10)),
                                                    child: Image.asset(
                                                        imgPropertyOffice,
                                                        height: 16.h,
                                                        width: 30.w,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  // Positioned(
                                                  //     left: 0,
                                                  //     top: 0,
                                                  //     child: Container(
                                                  //       margin:
                                                  //           EdgeInsets.all(2.w),
                                                  //       decoration: BoxDecoration(
                                                  //           color: colorRed,
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       5)),
                                                  //       child: Padding(
                                                  //         padding: EdgeInsets
                                                  //             .symmetric(
                                                  //                 vertical:
                                                  //                     0.5.h,
                                                  //                 horizontal:
                                                  //                     1.w),
                                                  //         child: Text('SALE',
                                                  //             style: textStyle6(
                                                  //                 colorWhite)),
                                                  //       ),
                                                  //     ))
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2.5.w, right: 3.w),
                                                child: SizedBox(
                                                  height: 16.h,
                                                  width: 100.w - 43.5.w,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Column(
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment
                                                      //           .start,
                                                      //   children: [
                                                      //     // Text(
                                                      //     //     'Commercial office space for rent in Adajan',
                                                      //     //     style: textStyle8(
                                                      //     //         colorText7070)),
                                                      //     // const SizedBox(
                                                      //     //     height: 5),

                                                      //   ],
                                                      // ),
                                                      Text(
                                                          "ProjectName: ${state.realEstatePropertyModel.realty[index].projectName}",
                                                          style:
                                                              textStyle11Bold(
                                                                  colorBlack)),
                                                      Text(
                                                          "PlotNo: ${state.realEstatePropertyModel.realty[index].plotNo}",
                                                          style:
                                                              textStyle11Bold(
                                                                  colorBlack)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  '₹ ${state.realEstatePropertyModel.realty[index].totalAmount}/-',
                                                              style:
                                                                  textStyle11Bold(
                                                                      colorRed),
                                                              // children: <TextSpan>[
                                                              //   TextSpan(
                                                              //       text:
                                                              //           ' month',
                                                              //       style: textStyle8(
                                                              //           colorText7070)),
                                                              // ],
                                                            ),
                                                          ),
                                                          // Column(
                                                          //   crossAxisAlignment:
                                                          //       CrossAxisAlignment
                                                          //           .end,
                                                          //   children: [
                                                          //     RichText(
                                                          //       text: TextSpan(
                                                          //         text: '450',
                                                          //         style: textStyle12Bold(
                                                          //             colorBlack),
                                                          //         children: <TextSpan>[
                                                          //           TextSpan(
                                                          //               text:
                                                          //                   ' sq.ft',
                                                          //               style: textStyle8(
                                                          //                   colorText7070)),
                                                          //         ],
                                                          //       ),
                                                          //     ),
                                                          //     SizedBox(
                                                          //         height:
                                                          //             0.5.h),
                                                          //     Text(
                                                          //         '(42 sq.m.) Plot Area',
                                                          //         style: textStyle7(
                                                          //             colorText7070)),
                                                          //   ],
                                                          // )
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   children: [
                                                      //     Row(
                                                      //       crossAxisAlignment:
                                                      //           CrossAxisAlignment
                                                      //               .center,
                                                      //       children: [
                                                      //         Image.asset(
                                                      //             icLocation,
                                                      //             color:
                                                      //                 colorRed,
                                                      //             width: 5.w),
                                                      //         SizedBox(
                                                      //             width: 2.w),
                                                      //         Text(
                                                      //             'Adajan, Surat',
                                                      //             style: textStyle9(
                                                      //                 colorText4D4D)),
                                                      //       ],
                                                      //     ),
                                                      //     Text('8 DAYS AGO',
                                                      //         style: textStyle9(
                                                      //             colorRed)),
                                                      //   ],
                                                      // )

                                                      Text(
                                                          'Date: ${DateFormat('dd MMM yy').format(state.realEstatePropertyModel.realty[index].salesDate)}',
                                                          style: textStyle10(
                                                              colorText7070)),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                        );
                }
                return Container();
              },
            );
          },
        ),
        // bottomNavigationBar: Stack(
        //   children: [
        //     Container(
        //       height: 8.h,
        //       decoration: BoxDecoration(boxShadow: [
        //         BoxShadow(
        //           color: colorTextBCBC.withOpacity(0.3),
        //           offset: const Offset(0.0, -3.0),
        //           blurRadius: 6.0,
        //         )
        //       ]),
        //     ),
        //     Container(
        //       height: 8.h,
        //       color: colorWhite,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Row(
        //             children: [
        //               Image.asset(icSort, color: colorBlack, width: 4.w),
        //               SizedBox(width: 0.7.w),
        //               Text('SORT', style: textStyle11Bold(colorBlack)),
        //             ],
        //           ),
        //           Container(
        //               height: 9.h,
        //               width: 1,
        //               color: colorText7070.withOpacity(0.3)),
        //           Row(
        //             children: [
        //               Image.asset(icFilter, color: colorBlack, width: 4.w),
        //               SizedBox(width: 1.w),
        //               Text('FILTER', style: textStyle11Bold(colorBlack)),
        //             ],
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 8,
              color: colorTextBCBC.withOpacity(0.3))
        ]);
  }
}
