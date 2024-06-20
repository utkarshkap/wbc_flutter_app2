import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../../resources/resource.dart';
import '../blocs/dashboardbloc/dashboard_bloc.dart';
import '../blocs/fetchingData/fetching_data_bloc.dart';
import '../blocs/mall/mall_bloc.dart';
import '../core/api/api_consts.dart';
import '../core/preferences.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/trending_data_model.dart';
import '../widgets/appbarButton.dart';
import 'home_screen.dart';

class TermsNdConditions extends StatefulWidget {
  static const route = '/Terms-Conditions';

  const TermsNdConditions({Key? key}) : super(key: key);

  @override
  State<TermsNdConditions> createState() => _TermsNdConditionsState();
}

class _TermsNdConditionsState extends State<TermsNdConditions> {
  String mobileNo = '';
  bool isTap = false;

  List<String> termsTitles = [
    'Welcome to Website Name!',
    'Cookies',
    'Privacy Policy'
  ];
  List<String> termsSubTitles = [
    'These terms and conditions outline the rules and regulations for the use of Company Name’s Website, located at Website.com.\n\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.',
    'We employ the use of cookies. By accessing Website Name, you agreed to use cookies in agreement with the Company Name’s',
    'Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies. License Unless otherwise stated, Company Name and/or its licensors own the intellectual property rights for all material on Website Name. All intellectual property rights are reserved. You may access this from Website Name for your own personal use subjected to restrictions set in these terms and conditions.'
  ];

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    setState(() {});
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
          title: Text('Terms & Conditions', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {
                  Navigator.of(context).pushNamed(NotificationScreen.route);
                }),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is TermsConditionsErrorState) {
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
            if (state is TermsConditionsInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            } else if (state is TermsConditionsLoadedState) {
              return state.termsConditions.terms.isEmpty
                  ? Center(
                      child: Text('No Data Available',
                          style: textStyle13Medium(colorBlack)))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                              child: Column(
                                children: List.generate(
                                    state.termsConditions.terms.length,
                                    (index) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.5.h),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          index > 8
                                                              ? '${index + 1}. '
                                                              : '0${index + 1}. ',
                                                          style:
                                                              textStyle14Bold(
                                                                  colorRed))),
                                                  Expanded(
                                                      flex: 9,
                                                      child: Text(
                                                          state
                                                              .termsConditions
                                                              .terms[index]
                                                              .title,
                                                          style:
                                                              textStyle14Bold(
                                                                  colorRed))),
                                                ],
                                              ),
                                              SizedBox(height: 1.2.h),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                  Expanded(
                                                      flex: 9,
                                                      child: Text(
                                                        state
                                                            .termsConditions
                                                            .terms[index]
                                                            .description,
                                                        style: textStyle10(
                                                                colorText7070)
                                                            .copyWith(
                                                                height: 1.3),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                              ),
                            ),
                          ),
                        ),
                        if (!ApiUser.termNdCondition)
                          BlocListener<DashboardBloc, DashboardState>(
                            listener: (context, state) {
                              if (state is TNCValueFailed) {
                                setState(() {
                                  isTap = false;
                                });
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
                              if (state is TNCValueUpdated) {
                                BlocProvider.of<MallBloc>(context).add(
                                    LoadMallDataEvent(
                                        popular: Popular(
                                            code: 0, message: '', products: []),
                                        newArrival: NewArrival(
                                            code: 0, message: '', products: []),
                                        trending: Trending(
                                            code: 0,
                                            message: '',
                                            products: [])));
                                Navigator.of(context).pushReplacementNamed(
                                    HomeScreen.route,
                                    arguments: HomeScreenData(
                                        rewardPopUpShow: false,
                                        acceptedContacts: ''));
                                setState(() {
                                  ApiUser.termNdCondition = true;
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.h, bottom: 2.5.h),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isTap = true;
                                    });
                                    BlocProvider.of<DashboardBloc>(context).add(
                                        UpdateTncData(
                                            mobNo: mobileNo, tnc: true));
                                  },
                                  child: Center(
                                    child: Container(
                                      height: 6.5.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                          color: colorRed,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 3),
                                                blurRadius: 6,
                                                color:
                                                    colorRed.withOpacity(0.35))
                                          ]),
                                      alignment: Alignment.center,
                                      child: isTap
                                          ? Center(
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: colorWhite,
                                                          strokeWidth: 0.7.w)),
                                            )
                                          : Text('I AGREE',
                                              style:
                                                  textStyle13Bold(colorWhite)),
                                    ),
                                  )),
                            ),
                          ),
                      ],
                    );
            }
            return Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                      color: colorRed, strokeWidth: 0.7.w)),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }
}
