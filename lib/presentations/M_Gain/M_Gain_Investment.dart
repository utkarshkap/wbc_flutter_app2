import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wbc_connect_app/models/mGain_ledger_model.dart';
import 'package:wbc_connect_app/presentations/M_Gain/M_Gain_Ledger.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../common_functions.dart';
import '../../core/pdfdownloadhandler.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';

class MGainInvestmentScreen extends StatefulWidget {
  static const route = '/mGain-Investment';

  const MGainInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<MGainInvestmentScreen> createState() => _MGainInvestmentScreenState();
}

class _MGainInvestmentScreenState extends State<MGainInvestmentScreen> {
/*  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  late bool _showContent;

  late bool _permissionReady;
  late bool _saveInPublicStorage;
  late String _localPath;*/
  bool startProgressBar = false;
  List<double> progressList = [];
  List<bool> isDownloadList = [];
  String pdf =
      "http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf";

  startDownloading(int index) async {
    try {
      setState(() {
        startProgressBar = true;
        isDownloadList[index] = true;
      });
      if (await PermissionClass.i.getStoragePermission()) {
        String path = await FileHelper.i.getDirectoryPath();
        Dio dio = Dio();
        print("PATH:::::::::${'$path/${pdf.split('/').last}'}");
        await dio.download(
          pdf,
          '$path/${pdf.split('/').last}',
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
  void initState() {
    // TODO: implement initState
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
          title: Text('M Gain Investments', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {}),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is MGainInvestmentLoadedState) {
              progressList = List.generate(
                  state.mGainInvestment.mGains.length, (index) => 0);
              isDownloadList = List.generate(
                  state.mGainInvestment.mGains.length, (index) => false);
            }
            if (state is MGainInvestmentErrorState) {
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
                if (state is MGainInvestmentInitial) {
                  return Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            color: colorRed, strokeWidth: 0.7.w)),
                  );
                }
                if (state is MGainInvestmentLoadedState) {
                  print(
                      '--=-=-----mGainInvestment--=---${state.mGainInvestment}');
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 100.w,
                            decoration: decoration(30),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 3.h,
                                  bottom: state.mGainInvestment.mGains.isEmpty
                                      ? 3.h
                                      : 9.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  interestValue(
                                      icInvestment,
                                      colorSplashBG,
                                      'Investment',
                                      '₹ ${CommonFunction().splitString(state.mGainInvestment.mGainTotalInvestment.toInt().toString())}/-'),
                                  Container(
                                      height: 10.h,
                                      width: 1,
                                      color: colorTextBCBC.withOpacity(0.36)),
                                  interestValue(
                                      icInterestReceived,
                                      colorRed,
                                      'Interest received',
                                      '₹ ${CommonFunction().splitString(state.mGainInvestment.totalIntrestReceived.toInt().toString())}/-'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container())
                        ],
                      ),
                      Positioned(
                          top: 20.h,
                          child: Container(
                            height: state.mGainInvestment.mGains.isNotEmpty
                                ? 68.h
                                : 0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    state.mGainInvestment.mGains.length,
                                    (index) => mGainValueShow(
                                            state.mGainInvestment.mGains[index]
                                                .mGainId,
                                            index,
                                            CommonFunction().splitString(state
                                                .mGainInvestment
                                                .mGains[index]
                                                .amount
                                                .toInt()
                                                .toString()),
                                            state.mGainInvestment.mGains[index]
                                                .rate
                                                .toInt(),
                                            DateFormat('dd MMM yy').format(state
                                                .mGainInvestment
                                                .mGains[index]
                                                .investmentDate),
                                            DateFormat('dd MMM yy').format(state
                                                .mGainInvestment
                                                .mGains[index]
                                                .maturityDate),
                                            state.mGainInvestment.mGains[index]
                                                .type, () {
                                          print(
                                              '----mGainId--=---${state.mGainInvestment.mGains[index].mGainId}');
                                          BlocProvider.of<FetchingDataBloc>(
                                                  context)
                                              .add(LoadMGainLedgerEvent(
                                                  mGainId: state.mGainInvestment
                                                      .mGains[index].mGainId,
                                                  accountId: state
                                                      .mGainInvestment
                                                      .mGains[index]
                                                      .accountid,
                                                  mGainLedger: MGainLedger(
                                                      code: 0,
                                                      message: '',
                                                      ledgerEntries: [])));
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  MGainLedgerScreen.route,
                                                  arguments:
                                                      MGainLedgerScreenData(
                                                          mGainId: state
                                                              .mGainInvestment
                                                              .mGains[index]
                                                              .mGainId
                                                              .toString()));
                                        }, () {
                                          startDownloading(index);
                                        })),
                              ),
                            ),
                          ))
                    ],
                  );
                }
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: radius == 10
            ? BorderRadius.circular(radius)
            : const BorderRadius.vertical(bottom: Radius.circular(30)),
        border: radius == 10 ? Border.all(color: colorE5E5, width: 1) : null,
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }

  interestValue(String icon, Color bgColor, String title, String value) {
    return Column(
      children: [
        Container(
          height: 6.5.h,
          width: 6.5.h,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(icon, color: colorWhite, height: 4.h),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1.h, bottom: 0.7.h),
          child: Text(title, style: textStyle10(colorBlack)),
        ),
        Text(value,
            style: textStyle16(colorRed).copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  mGainValueShow(
    int mGainId,
    int index,
    String value,
    int percentage,
    String investmentDate,
    String maturityDate,
    String mGainType,
    Function() onDocumentClick,
    Function() onDownloadClick,
  ) {
    return Container(
      width: 90.w,
      decoration: decoration(10),
      margin: EdgeInsets.only(bottom: 1.5.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MGain Id: $mGainId',
                        style: textStyle13Bold(colorBlack)),
                    SizedBox(height: 0.5.h),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '₹ $value/-',
                              style: textStyle11Bold(colorBlack)),
                          TextSpan(
                              text: ' $mGainType - ',
                              style: textStyle10(colorText7070)),
                          TextSpan(
                              text: '$percentage%',
                              style: textStyle10(colorRed)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        constraints:
                            BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                        padding: EdgeInsets.zero,
                        splashRadius: 5.5.w,
                        splashColor: colorWhite,
                        onPressed: onDocumentClick,
                        icon: Image.asset(icDocument,
                            width: 8.w, color: colorTextBCBC)),
                    SizedBox(width: 1.5.w),
                    if (isDownloadList[index]) ...[
                      CircularPercentIndicator(
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
                      ),
                    ] else ...[
                      IconButton(
                          constraints:
                              BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                          padding: EdgeInsets.zero,
                          splashRadius: 5.5.w,
                          splashColor: colorWhite,
                          onPressed: onDownloadClick,
                          icon: Image.asset(icDownload,
                              width: 8.w, color: colorTextBCBC)),
                    ]
                  ],
                )
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Investment Date: $investmentDate',
                    style: textStyle9(colorText7070)),
                Text('Maturity Date: $maturityDate',
                    style: textStyle9(colorText7070)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
