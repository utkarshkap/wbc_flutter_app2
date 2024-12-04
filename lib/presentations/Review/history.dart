import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/review_report_screen.dart';

import '../../blocs/review/review_bloc.dart';
import '../../core/pdfdownloadhandler.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../profile_screen.dart';

class ReviewHistory extends StatefulWidget {
  static const route = '/Review-History';

  const ReviewHistory({Key? key}) : super(key: key);

  @override
  State<ReviewHistory> createState() => _ReviewHistoryState();
}

class _ReviewHistoryState extends State<ReviewHistory> {
  List<double> progressList = [];
  List<bool> isDownloadList = [];
  bool startProgressBar = false;

  // String pdf =
  //     "http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf";

  startDownloading(int index, var pdfId) async {
    String pdf =
        'https://wbcapi.kagroup.in/api/user/GetReviewReport?requestId=$pdfId';
    print("PDF PATH------$pdf");
    try {
      setState(() {
        startProgressBar = true;
        isDownloadList[index] = true;
      });
      if (await PermissionClass.i.getStoragePermission()) {
        String path = await FileHelper.i.getDirectoryPath();
        String filePath = '$path/PDAdvisory-$pdfId-${ApiUser.userName}.pdf';

        Dio dio = Dio();
        await dio.download(
          pdf,
          filePath,
          onReceiveProgress: (count, total) {
            progressList[index] = (count / total);
            setState(() {});
          },
        ).then(
          (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Pdf Downloaded Successfully",
                  style: TextStyle(
                    color: colorWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                backgroundColor: colorSplashBG,
              ),
            );
          },
        );
        
          File file = File(filePath);
          if (await file.exists()) {
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                                    .pushNamed(ReviewReportScreen.route,arguments: ReviewReportData(pdf:file ));
            print("IF------------------$filePath");
 
          } else {
            print('File does not exist at $filePath');
          }
        
      }
    } catch (e) {
      print('download error-----${e.toString()}');
    } finally {
      setState(() {
        startProgressBar = false;
        isDownloadList[index] = false;
        progressList[index] = 0;
      });
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
          title: Text('Review History', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is ReviewHistoryLoadedState) {
              progressList = List.generate(
                  state.reviewHistory.reviewresponse.length, (index) => 0);
              isDownloadList = List.generate(
                  state.reviewHistory.reviewresponse.length, (index) => false);
            }
          },
          builder: (context, state) {
            print('--=-=-----history--state--=---$state');
            if (state is ReviewHistoryInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            }
            if (state is ReviewHistoryLoadedState) {
              // print(
              //     '--=-=-----reviewresponse--=---${state.reviewHistory.reviewresponse[0].investmentName}');

              if (state.reviewHistory.reviewresponse.isEmpty) {
                return Center(
                    child: Text('There are no History',
                        style: textStyle13(colorText7070)));
              } else {
                return SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    state.reviewHistory.reviewresponse.length,
                    (index) => reviews(
                        index,
                        state.reviewHistory.reviewresponse[index]
                                    .investmentName ==
                                'Stock/MF'
                            ? icStockPortfolio
                            : state.reviewHistory.reviewresponse[index]
                                        .investmentName ==
                                    'Mutual Funds'
                                ? icMutualFundsInvestment
                                : state.reviewHistory.reviewresponse[index]
                                            .investmentName ==
                                        'Insurance'
                                    ? icInsurance
                                    : icReviewLoan,
                        '${state.reviewHistory.reviewresponse[index].investmentName} Review',
                        DateTime.now()
                            .difference(state
                                .reviewHistory.reviewresponse[index].reqDate)
                            .inDays,
                        () => null,
                        state.reviewHistory.reviewresponse[index].status,
                        state.reviewHistory.reviewresponse[index].requestId),
                  )),
                );
              }
            }
            if (state is ReviewHistoryErrorState) {
              return Center(
                  child: Text(state.error.toString(),
                      style: textStyle13Medium(colorBlack)));
            }
            return Container();
          },
        ),
      ),
    );
  }

  reviews(int index, String icon, String title, int subValue,
      Function() onClick, String status, var pdfId) {
    return Container(
      margin: EdgeInsets.only(top: 0.7.h),
      decoration: BoxDecoration(color: colorWhite, boxShadow: [
        BoxShadow(
            color: colorTextBCBC.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 6))
      ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.5.w),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Container(
                    height: 5.5.h,
                    width: 5.5.h,
                    decoration: const BoxDecoration(
                      color: colorRed,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(icon, color: colorWhite, height: 2.7.h),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyle11Bold(colorBlack)),
                SizedBox(height: 0.7.h),
                RichText(
                  text: TextSpan(
                    text: 'Reviewed ',
                    style: textStyle9(colorText7070),
                    children: <TextSpan>[
                      TextSpan(
                          text: subValue == 0
                              ? 'Today'
                              : subValue == 1
                                  ? '$subValue day ago'
                                  : '$subValue days ago',
                          style: textStyle10Bold(colorRed)),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(status,
                style: textStyle10Bold(
                    status == 'Pending' ? colorRed : colorGreen),
                textAlign: TextAlign.right),
            SizedBox(
              width: 2.w,
            ),
            GestureDetector(
              onTap: onClick,
              child: isDownloadList[index]
                  ? CircularPercentIndicator(
                      radius: 15,
                      lineWidth: 5,
                      percent: progressList[index],
                      animationDuration: 400,
                      backgroundColor: Colors.grey,
                      progressColor: colorRed,
                      center: FittedBox(
                        child: Text(
                          "${(progressList[index] * 100).floor()}%",
                          style: textStyle7Bold(colorBlack),
                        ),
                      ),
                    )
                  : IconButton(
                      constraints:
                          BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                      padding: EdgeInsets.zero,
                      splashRadius: 5.5.w,
                      splashColor: colorWhite,
                      onPressed: () {
                        if (status != 'Pending') {
                          startDownloading(index, pdfId);
                        }
                      },
                      icon: Image.asset(icDownload,
                          width: 8.w, color: colorTextBCBC)),
            ),
          ],
        ),
      ),
    );
  }
}
