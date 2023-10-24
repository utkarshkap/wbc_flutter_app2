import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wbc_connect_app/blocs/bloc/wealth_meter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import '../blocs/MFInvestments/mf_investments_bloc.dart';
import '../core/api/api_consts.dart';
import '../models/investment_portfolio_model.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';
import 'Review/mutual_funds_investment.dart';
import 'Review/stocks_investment.dart';

class WealthMeterScreen extends StatefulWidget {
  static const route = '/Wealth-Meter-Screen';

  const WealthMeterScreen({Key? key}) : super(key: key);

  @override
  State<WealthMeterScreen> createState() => _WealthMeterScreenState();
}

class _WealthMeterScreenState extends State<WealthMeterScreen> {
  @override
  void initState() {
    wealthMeter();
    ageCalculate();
    super.initState();
  }

  String stockInvestmentType = "StocksInvestment";
  String mfInvestmentType = "MutualFundsInvestment";
  int ageValue = 0;
  double wealthMeterScore = 0;

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
            title: Text('KA Wealth Meter', style: textStyle14Bold(colorBlack)),
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
          body: BlocConsumer<WealthMeterBloc, WealthMeterState>(
            listener: (context, state) {
              if (state is WealthMeterFailed) {
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
              } else if (state is WealthMeterDataAdded) {
                setState(() {
                  wealthMeterScore = state.totalScore.toDouble();
                });
              }
            },
            builder: (context, state) {
              if (state is WealthMeterDataAdded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Container(
                            width: 90.w,
                            decoration: decoration(colorWhite),
                            child: Column(
                              children: [
                                SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      startAngle: 145,
                                      endAngle: 35,
                                      radiusFactor: 0.7,
                                      showTicks: false,
                                      showLabels: false,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                          startValue: 0,
                                          endValue: 33.33,
                                          color: Colors.red,
                                          startWidth: 50,
                                          endWidth: 50,
                                          label: 'LOW',
                                          labelStyle: const GaugeTextStyle(
                                              color: colorWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GaugeRange(
                                          startValue: 33.33,
                                          endValue: 66.66,
                                          color: colorTextFFC1,
                                          startWidth: 50,
                                          endWidth: 50,
                                          label: 'MEDIUM',
                                          labelStyle: const GaugeTextStyle(
                                              color: colorWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GaugeRange(
                                          startValue: 66.66,
                                          endValue: 100,
                                          color: colorGreen,
                                          startWidth: 50,
                                          endWidth: 50,
                                          label: 'HIGH',
                                          labelStyle: const GaugeTextStyle(
                                              color: colorWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                          value: wealthMeterScore,
                                          needleLength: 1,
                                          needleStartWidth: 0.1,
                                          needleEndWidth: 7,
                                          knobStyle:
                                              KnobStyle(knobRadius: 0.08),
                                          enableAnimation: true,
                                        )
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Column(
                                              children: [
                                                Text(
                                                    wealthMeterScore
                                                        .toInt()
                                                        .toString(),
                                                    style: textStyle36Bold(
                                                        colorBlack)),
                                                // SizedBox(height: 13.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.h),
                                                  child: Text('WEALTH SCORE',
                                                      style: textStyle13Bold(
                                                              colorBlack)
                                                          .copyWith(
                                                              letterSpacing:
                                                                  0.16)),
                                                ),
                                                SizedBox(
                                                  width: 45.w,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      wealthScoreIndicator(
                                                          Colors.red, 'Low'),
                                                      wealthScoreIndicator(
                                                          colorTextFFC1,
                                                          'Medium'),
                                                      wealthScoreIndicator(
                                                          colorGreen, 'High'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            angle: 90,
                                            positionFactor: 1.8)
                                      ])
                                ]),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                          child: Text('BIRD EYE VIEW',
                              style: textStyle10Bold(colorBlack)
                                  .copyWith(letterSpacing: 0.7)),
                        ),
                        birdEyeView(
                            'INVESTMENTS',
                            icStocksInvestment,
                            'Stocks',
                            '87,903',
                            icMutualFundsInvestment,
                            'Mutual Funds',
                            '97,404',
                            colorF9C1,
                            stockInvestmentType,
                            mfInvestmentType),
                        SizedBox(height: 2.h),
                        birdEyeView(
                            'ASSETS',
                            icCarLoan,
                            'Car Loan',
                            '42,405',
                            icBikeLoan,
                            'Bike Loan',
                            '9,87,863',
                            colorFB83,
                            "",
                            ""),
                        SizedBox(height: 2.h),
                        birdEyeView(
                            'INCOME',
                            icHome,
                            'Home',
                            '87,903',
                            icFactory1,
                            'Factory\'s',
                            '97,404',
                            color6C6C,
                            "",
                            ""),
                        SizedBox(height: 2.h),
                        birdEyeView(
                            'LOAN (LIABILITIES)',
                            icCarLoan,
                            'Car Loan',
                            '42,405',
                            icBikeLoan,
                            'Bike Loan',
                            '9,87,863',
                            colorFB83,
                            "",
                            ""),
                        SizedBox(height: 2.h),
                        birdEyeView(
                            'INSURANCE',
                            icCarLoan,
                            'Car Loan',
                            '42,405',
                            icBikeLoan,
                            'Bike Loan',
                            '9,87,863',
                            colorFB83,
                            "",
                            ""),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 3.h),
                        //   child: Container(
                        //     decoration: decoration(colorWhite),
                        //     child: Column(
                        //       children: [
                        //         Padding(
                        //           padding: EdgeInsets.only(top: 5.h, bottom: 4.h),
                        //           child: Image.asset(imgKAPortfolioDoctor, width: 65.w),
                        //         ),
                        //         Container(
                        //             height: 1, color: colorTextBCBC.withOpacity(0.36)),
                        //         Padding(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 2.5.h, horizontal: 4.w),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Text('Wealth Building Campaign',
                        //                   style: textStyle11Bold(colorBlack)
                        //                       .copyWith(letterSpacing: 0.16)),
                        //               SizedBox(height: 1.h),
                        //               ReadMoreText(
                        //                 'Wealth Building Campaign makes wealth planning easy!! We don’t over complicate things.',
                        //                 trimLines: 2,
                        //                 colorClickableText: colorRed,
                        //                 trimMode: TrimMode.Line,
                        //                 trimCollapsedText: 'See more',
                        //                 trimExpandedText: 'Show less',
                        //                 style: textStyle9(colorText7070)
                        //                     .copyWith(height: 1.4),
                        //                 moreStyle: textStyle9(colorRed).copyWith(
                        //                     fontWeight: FontWeight.w600, height: 1.4),
                        //                 lessStyle: textStyle9(colorRed).copyWith(
                        //                     fontWeight: FontWeight.w600, height: 1.4),
                        //               ),
                        //             ],
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
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
          )),
    );
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

  wealthScoreIndicator(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 1.5.w,
          backgroundColor: color,
        ),
        SizedBox(width: 1.5.w),
        Text(text, style: textStyle9(colorText7070))
      ],
    );
  }

  birdEyeView(
      String title,
      String icon1,
      String text1,
      String value1,
      String icon2,
      String text2,
      String value2,
      Color bgColor,
      String firstRouteName,
      String secondRouteName) {
    return Container(
      width: 90.w,
      decoration: decoration(colorWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 3.5.w),
            child: Text(title,
                style:
                    textStyle10Bold(colorBlack).copyWith(letterSpacing: 0.7)),
          ),
          Container(height: 1, color: colorTextBCBC.withOpacity(0.36)),
          SizedBox(
            height: 9.h,
            child: BlocListener<MFInvestmentsBloc, MFInvestmentsState>(
              listener: (context, state) {
                if (state is MFInvestmentsLoadedState) {
                  Navigator.of(context)
                      .pushReplacementNamed(MutualFundsInvestment.route);
                } else if (state is StockInvestmentLoadedState) {
                  Navigator.of(context)
                      .pushReplacementNamed(StocksInvestment.route);
                }
              },
              child: Row(
                children: [
                  iconTextValue(icon1, bgColor, text1, value1, () {
                    if (firstRouteName == stockInvestmentType) {
                      /*BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadStockInvestmentEvent(
                            userId: ApiUser.userId,
                            stockInvestments: StockInvestmentsModel(
                                code: 0,
                                message: '',
                                portfolio: 0,
                                investment: 0,
                                gain: 0,
                                stocks: []
                            ),
                          ));*/
                    }
                  }),
                  Container(
                      height: 9.h,
                      width: 1,
                      color: colorTextBCBC.withOpacity(0.36)),
                  iconTextValue(icon2, bgColor, text2, value2, () {
                    if (secondRouteName == mfInvestmentType) {
                      BlocProvider.of<MFInvestmentsBloc>(context).add(
                          LoadMFInvestmentsEvent(
                              userId: ApiUser.userId,
                              investmentPortfolio: InvestmentPortfolio(
                                  code: 0,
                                  message: '',
                                  portfolio: 0,
                                  investment: 0,
                                  gain: 0,
                                  mFStocks: [])));
                    }
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  iconTextValue(String icon, Color bgColor, String text, String value,
      Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: SizedBox(
        width: 45.w - 0.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 3.w),
            CircleAvatar(
              radius: 2.5.h,
              backgroundColor: bgColor,
              child: Image.asset(icon,
                  color: colorWhite,
                  height: icon == icStocksInvestment
                      ? 2.5.h
                      : icon == icFactory
                          ? 4.h
                          : 2.2.h),
            ),
            SizedBox(width: 2.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: textStyle9(colorText3D3D)),
                SizedBox(height: 0.5.h),
                Text('₹ $value/-', style: textStyle13Bold(colorBlack))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void ageCalculate() {
    setState(() {
      if (ApiUser.userDob.isEmpty || ApiUser.userDob == null) {
        ageValue = 0;
      } else {
        var userDate =
            DateFormat('yyyy MM dd').format(DateTime.parse(ApiUser.userDob));

        final splitValue = userDate.split(' ');
        ageValue = DateTime.now()
                .difference(DateTime(int.parse(splitValue[0]),
                    int.parse(splitValue[1]), int.parse(splitValue[2])))
                .inDays ~/
            365;
      }
    });

    print("USER AGE:::::${ageValue}");
  }

  void wealthMeter() {
    BlocProvider.of<WealthMeterBloc>(context).add(WealthMeterDataEvent(
        userId: 2613,
        name: 'Jignesh',
        dob: "1984/09/11",
        age: 38,
        interestRate: 6.5,
        business: 0,
        salary: 101166,
        professional: 0,
        spouseIncome: 0,
        otherIncome: 0,
        houseHoldMonthly: 25000,
        totalMonthlyEmi: 8500,
        totalInsurancePremiumYearly: 50000,
        childrenEducationYearly: 120000,
        otherExpenseYearly: 0,
        vehicle: 750000,
        gold: 500000,
        savingAccount: 0,
        cash: 0,
        emergencyFunds: 300000,
        otherAsset: 0,
        mutualFunds: 1300000,
        pPF: 0,
        sIPMonthly: 17000,
        pPFMonthly: 0,
        debenture: 0,
        fixedDeposite: 0,
        stockPortfolio: 600000,
        guided: 0,
        unguided: 0,
        postOfficeOrVikasPatra: 0,
        pMS: 0,
        privateInvestmentScheme: 0,
        realEstate: 0,
        termInsurance: 500000,
        traditionalInsurance: 0,
        uLIP: 0,
        vehicleInsurance: 0,
        otherInsurance: 0,
        healthInsurance: 600000,
        housingLoan: 0,
        mortgageLoan: 0,
        educationLoan: 0,
        personalLoan: 0,
        vehicleLoan: 500000,
        overdraft: 0,
        otherLoan: 30000));
  }
}
