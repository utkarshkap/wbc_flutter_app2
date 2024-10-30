import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/get_brokerList_model.dart';
import 'package:wbc_connect_app/presentations/brokers_api/ICICI/webview_ICICI.dart';
import 'package:wbc_connect_app/presentations/brokers_api/angel/webview_angel.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../brokers_api/5paisa/webview_5paisa.dart';
import '../brokers_api/IIFL/webview_IIFL.dart';
import '../brokers_api/fyers/weview_fyers.dart';
import '../profile_screen.dart';

class ConnectBrokers extends StatefulWidget {
  static const route = '/Connect-Brokers';
  const ConnectBrokers({Key? key}) : super(key: key);

  @override
  State<ConnectBrokers> createState() => _ConnectBrokersState();
}

class _ConnectBrokersState extends State<ConnectBrokers> {
  List<BrokersModel> brokersList = [
    // BrokersModel(brokerName: 'Fyers', logoUrl: icFyers, isSelected: false),
    // BrokersModel(
    //     brokerName: '5paisa Capital Limited',
    //     logoUrl: ic5paisa,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'IIFL Wealth Management Limited',
    //     logoUrl: icIifl,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'Zerodha Securities Private Limited',
    //     logoUrl: icZerodha,
    //     isSelected: false),
    // BrokersModel(brokerName: 'Upstox', logoUrl: icUpstox, isSelected: false),
    // BrokersModel(brokerName: 'Groww', logoUrl: icGroww, isSelected: false),
    // BrokersModel(
    //     brokerName: 'Angel Broking Limited',
    //     logoUrl: icAngelbroking,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'Hdfc Bank Limited', logoUrl: icHdfc, isSelected: false),
    // BrokersModel(
    //     brokerName: 'ICICI Bank Limited', logoUrl: icIcici, isSelected: false),
    // BrokersModel(
    //     brokerName: 'Motilal Oswal Financial Services Limited',
    //     logoUrl: icMotilal,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'Paytm Moeny', logoUrl: icPaytm, isSelected: false),
    // BrokersModel(
    //     brokerName: 'Kotak Securities Limited',
    //     logoUrl: icKotak,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'Alice Blue Financial Services Private Limited',
    //     logoUrl: icAlice,
    //     isSelected: false),
    // BrokersModel(
    //     brokerName: 'Trustline Securities Limited',
    //     logoUrl: icTrustline,
    //     isSelected: false),
  ];
  navigateScreen(int index, String screenName) {
    Navigator.of(context).pushNamed(screenName).then((value) {
      setState(() {
        brokersList[index].isSelected = false;
      });
    });
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
          title:
              Text('Connect your brokers', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is GetBrokersListErrorState) {
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
            if (state is GetBrokersListInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            }
            if (state is GetBrokersListLoadedState) {
              brokersList.clear();
              state.getBroker.brokerList!.forEach((element) {
                brokersList.add(BrokersModel(
                    id: element.id,
                    brokerName: element.brokerName,
                    logoUrl: imgNewBaseUrl + element.logoUrl!,
                    isActive: element.isActive,
                    isSelected: false));
              });

              return Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [colorRed, colorBoxGradiant3333])),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h, bottom: 6.h),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "The only Auto Tracking across all your brokers in India",
                                      style: textStyle14Bold(colorWhite)
                                          .copyWith(height: 1.2),
                                    ),
                                    SizedBox(
                                      height: 0.8.w,
                                    ),
                                    Text(
                                      'Analyse your stock investments with multiple brokers in a single step',
                                      style: textStyle9(colorE5E5)
                                          .copyWith(height: 1.2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(height: 2.5.h)
                    ],
                  ),
                  Positioned(
                    top: 15.5.h,
                    child: Container(
                      height: 63.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: colorTextBCBC.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 6))
                          ]),
                      child: SingleChildScrollView(
                        child: Column(
                            children:
                                List.generate(brokersList.length, (index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    brokersList.forEach((element) =>
                                        element.isSelected = false);
                                    brokersList[index].isSelected =
                                        !brokersList[index].isSelected;
                                  });
                                  String selectedBroker = '';
                                  for (int i = 0; i < brokersList.length; i++) {
                                    if (brokersList[i].isSelected) {
                                      selectedBroker =
                                          brokersList[i].brokerName.toString();
                                    }
                                  }
                                  if (selectedBroker == 'Fyers') {
                                    navigateScreen(index, WebviewFyers.route);
                                  } else if (selectedBroker ==
                                      '5paisa Capital Limited') {
                                    navigateScreen(index, Webview5Paisa.route);
                                  } else if (selectedBroker ==
                                      'IIFL Wealth Management Limited') {
                                    navigateScreen(index, WebviewIIFL.route);
                                  } else if (selectedBroker ==
                                      'Angel Broking Limited') {
                                    navigateScreen(index, WebViewAngel.route);
                                  } else if (selectedBroker ==
                                      'ICICI Bank Limited') {
                                    navigateScreen(index, WebViewICICI.route);
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent),
                                  margin: EdgeInsets.only(top: 0.3.h),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 4.5.w),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: Image.network(
                                              brokersList[index]
                                                  .logoUrl
                                                  .toString(),
                                              height: 2.5.h),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  brokersList[index]
                                                      .brokerName
                                                      .toString(),
                                                  style: textStyle9Bold(
                                                      colorBlack)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: SizedBox(
                                            height: 2.5.h,
                                            width: 2.h,
                                            child: Image.asset(icCheckMark,
                                                color: brokersList[index]
                                                        .isSelected
                                                    ? colorRed
                                                    : colorTextBCBC
                                                        .withOpacity(0.62),
                                                width: 5.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (index != brokersList.length - 1)
                                Container(
                                    height: 1,
                                    color: colorTextBCBC.withOpacity(0.36))
                            ],
                          );
                        })),
                      ),
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class BrokersModel {
  int? id;
  String? brokerName;
  String? logoUrl;
  bool isSelected = false;
  bool? isActive;

  BrokersModel(
      {this.id,
      this.brokerName,
      this.logoUrl,
      required this.isSelected,
      this.isActive});
}
