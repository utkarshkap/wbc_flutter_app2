import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/Review/connect_brokers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../blocs/review/review_bloc.dart';
import '../../common_functions.dart';
import '../../core/preferences.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../../widgets/video_player/youtubeView.dart';
import 'history.dart';

class StocksReview extends StatefulWidget {
  static const route = '/Stocks-Review';

  const StocksReview({Key? key}) : super(key: key);

  @override
  State<StocksReview> createState() => _StocksReviewState();
}

class _StocksReviewState extends State<StocksReview> {
  String mobileNo = '';
  String selectedStocks = 'NSDL';
  bool isStocksFieldTap = true;
  bool uploadEventTap = false;
  bool isSend = false;
  String fileValidation = '';
  String fileName = 'Upload your stock investment PDF';
  File? uploadFile;

  List<String> stocksType = [
    'CDSL',
    'NSDL',
  ];

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    setState(() {});
  }

  pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      uploadFile = File(result.files.single.path!);

      setState(() {
        fileName = uploadFile!.path.split('/').last;
        fileValidation = '';
      });
    } else {}
  }

  @override
  void initState() {
    getMobNo();
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
          title: Text('Review My Stocks', style: textStyle14Bold(colorBlack)),
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
                onClick: () {}),
            SizedBox(width: 5.w)
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              dropDownWidget('Stock Investment', selectedStocks, isStocksFieldTap, () {
                    setState(() {
                      isStocksFieldTap = true;
                      uploadEventTap = false;
                    });
                    CommonFunction().selectFormDialog(
                        context, 'Select Repository', stocksType, (val) {
                      setState(() {
                        selectedStocks = val;
                        isStocksFieldTap = false;
                        uploadEventTap = true;
                      });
                      Navigator.of(context).pop();
                    });
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Container(
                  decoration: decoration(colorWhite),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 23.h, width: 90.w,
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: YoutubeVideoPlayer(
                            key: ObjectKey(selectedStocks=='NSDL'?'gBX8Y9CHjfM':'cbvKi81qZNw'),
                            controller: YoutubePlayerController(
                                initialVideoId: selectedStocks=='NSDL'?'gBX8Y9CHjfM':'cbvKi81qZNw',
                                flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    enableCaption: false,
                                    showLiveFullscreenButton:
                                    false)),
                            bufferIndicator: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                CircularProgressIndicator(
                                    color: colorRed,
                                    strokeWidth: 0.7.w)),
                            bottomActions: [
                              CurrentPosition(),
                              SizedBox(width: 2.w),
                              ProgressBar(
                                  isExpanded: true,
                                  colors: ProgressBarColors(
                                      backgroundColor:
                                      colorWhite,
                                      bufferedColor: colorRed
                                          .withOpacity(0.5))),
                              SizedBox(width: 2.w),
                              RemainingDuration(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Learn To Download Stock Statement',
                                style: textStyle10(colorBlack)),
                            GestureDetector(
                                onTap: () {},
                                child: Text('View more',
                                    style: textStyle9(colorRed).copyWith(
                                        decoration:
                                            TextDecoration.underline)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isStocksFieldTap = false;
                      uploadEventTap = true;
                    });
                    pickPdfFile();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    color: uploadEventTap
                        ? colorRed
                        : colorTextBCBC.withOpacity(0.36),
                    padding: EdgeInsets.zero,
                    strokeWidth: 5,
                    dashPattern: const [5, 5],
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fileName,
                              style: textStyle11Bold(colorText7070)),
                          uploadFile == null
                              ? Image.asset(icUpload,
                                  color: colorRed, width: 5.w)
                              : IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(minWidth: 5.w),
                                  onPressed: () {
                                    setState(() {
                                      fileName =
                                          'Upload your stock investment PDF';
                                      uploadFile = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: colorRed,
                                  )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (fileValidation.isNotEmpty) SizedBox(
                  height: 0.5.h,
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: fileValidation == 'Empty file'
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                color: colorRed, size: 13),
                            const SizedBox(width: 4),
                            Container(
                              height: 2.h,
                              alignment: Alignment.center,
                              child: Text('Please Select PDF file',
                                  style: textStyle9(colorErrorRed)),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              const Spacer(),
              button(icSendReview, 'Send For Review', () {
                print('selectedstock------$selectedStocks');

                if (uploadFile == null) {
                  setState(() {
                    fileValidation = 'Empty file';
                  });
                } else {
                  setState(() {
                    fileValidation = '';
                  });
                }
                if (selectedStocks != 'Select Your Stocks Investment' &&
                    uploadFile != null) {}
              }),
              SizedBox(height: 2.h),
              button(icCheckReview, 'Check Review Report', () {
                BlocProvider.of<ReviewBloc>(context).add(LoadReviewHistoryEvent(mobNo: mobileNo));
                Navigator.of(context).pushNamed(ReviewHistory.route);
              }),
              SizedBox(height: 2.h),
              button(icConnectFastTrack, 'Connect Your Brokers', () {
                Navigator.of(context).pushNamed(ConnectBrokers.route);
              }),
              SizedBox(height: 2.h)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorDFDF, width: 1),
        boxShadow: [
          if (bgColor == colorRed)
            BoxShadow(
                color: colorTextBCBC.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 6))
        ]);
  }

  button(String icon, String text, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 6.5.h,
        width: 90.w,
        decoration: BoxDecoration(
            color: text == 'Send For Review'
                ? colorRed : colorRed.withOpacity(0.17),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (text =='Send For Review')
                BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                    color: colorRed.withOpacity(0.3))
            ]),
        alignment: Alignment.center,
        child: text == 'Send For Review' ? isSend ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                color: colorWhite,
                strokeWidth: 0.6.w)) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon, width: 4.w),
            SizedBox(width: 2.5.w),
            Text(text,
                style: textStyle13Bold(colorWhite)),
          ],
        )  :Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon, width: text == "Connect Your Brokers" ? 5.5.w : 4.w),
            SizedBox(width: 2.5.w),
            Text(text,
                style: textStyle13Bold(colorRed)),
          ],
        ),
      ),
    );
  }

  dropDownWidget(String title, String selectedType, bool isSelectedField, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelectedField ? colorRed : colorDFDF, width: 1)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(title, style: textStyle9(colorText8181)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                  child: SizedBox(
                    width: 84.w - 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(selectedType,
                              style: textStyle11(colorText3D3D)),
                        ),
                        Image.asset(icDropdown,
                            color: colorText3D3D, width: 5.w)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}