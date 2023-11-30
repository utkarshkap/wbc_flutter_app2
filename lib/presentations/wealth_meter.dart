import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wbc_connect_app/blocs/bloc/wealth_meter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/models/investment_portfolio_model.dart';
import 'package:wbc_connect_app/models/stock_investment_model.dart';
import 'package:wbc_connect_app/presentations/Review/mutual_funds_investment.dart';
import '../blocs/MFInvestments/mf_investments_bloc.dart';
import '../core/api/api_consts.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';
import 'Review/stocks_investment.dart';

class WealthMeterScreen extends StatefulWidget {
  static const route = '/Wealth-Meter-Screen';

  const WealthMeterScreen({Key? key}) : super(key: key);

  @override
  State<WealthMeterScreen> createState() => _WealthMeterScreenState();
}

class _WealthMeterScreenState extends State<WealthMeterScreen> {
  final GlobalKey showGlobalKey = GlobalKey();
  BuildContext? myContext;

  @override
  void initState() {
    BlocProvider.of<MFInvestmentsBloc>(context).add(LoadMFInvestmentsEvent(
        userId: ApiUser.userId,
        investmentPortfolio: InvestmentPortfolio(
            code: 0,
            message: '',
            portfolio: 0,
            investment: 0,
            gain: 0,
            mFStocks: [])));
    BlocProvider.of<FetchingDataBloc>(context).add(LoadStockInvestmentEvent(
        userId: ApiUser.userId,
        investmentPortfolio: StockInvestmentModel(
          code: 0,
          message: '',
          portfolio: 0,
          investment: 0,
          gain: 0,
          stocks: [],
        )));
    showCase();
    ageCalculate();

    super.initState();
  }

  showCase() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(myContext!).startShowCase([
        showGlobalKey,
      ]),
    );
  }

  double stocksValue = 0;
  double mutualFundsValue = 0;

  // User Details
  String userDoB = '';
  int userAge = 0;
  double wealthMeterScore = 50;
  double interestRate = 6.5;

  // Investments Type
  String stockInvestmentType = "StocksInvestment";
  String mfInvestmentType = "MutualFundsInvestment";
  // Assets Type
  String carAssetsType = 'CarAssets';
  String bikeAssetsType = "BikeAssets";
  // Income Type
  String homeIncomeType = 'HomeIncome';
  String factoryIncomeType = "FactoryIncome";
  // Loan Type
  String carLoanType = 'CarLoan';
  String bikeLoanType = "BikeLoan";
  // Insurance Type
  String carInsuranceType = 'CarInsurance';
  String bikeInsuranceType = "BikeInsurance";

  //Investments
  num salary = 1;
  num professional = 0;
  num spouseIncome = 0;
  num otherIncome = 0;
  // Investments
  num mutualFunds = 0;
  num emergencyFunds = 0;
  num pPF = 0;
  num sIPMonthly = 0;
  num pPFMonthly = 0;

  // Assets
  num gold = 0;
  num cash = 0;
  num stockPortfolio = 0;
  num savingAccount = 0;
  num postOfficeOrVikasPatra = 0;
  // Assets
  num vehicle = 0;
  num guided = 0;
  num unguided = 0;
  num overdraft = 0;
  num otherAsset = 0;

  // Income
  num houseHoldMonthly = 0;
  num totalMonthlyEmi = 0;
  num totalInsurancePremiumYearly = 0;
  num childrenEducationYearly = 0;
  num otherExpenseYearly = 0;

  // Income
  num debenture = 0;
  num fixedDeposite = 0;
  num pMS = 0;
  num privateInvestmentScheme = 0;
  num realEstate = 0;
  num business = 0;

  // Loan
  num housingLoan = 0;
  num educationLoan = 0;
  num personalLoan = 0;
  // Loan
  num mortgageLoan = 0;
  num vehicleLoan = 0;
  num otherLoan = 0;
  // Insurance
  num termInsurance = 0;
  num traditionalInsurance = 0;
  num healthInsurance = 0;
  // Insurance
  num vehicleInsurance = 0;
  num uLIP = 0;
  num otherInsurance = 0;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        myContext = context;
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
                    Text('KA Wealth Meter', style: textStyle14Bold(colorBlack)),
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
                      if (state.totalScore == 0) {
                        wealthMeterScore = 50;
                      } else {
                        wealthMeterScore = state.totalScore.toDouble();
                      }
                    });
                  }
                },
                builder: (context, state) {
                  // if (state is WealthMeterDataAdded) {
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
                                            knobStyle: const KnobStyle(
                                                knobRadius: 0.08),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                              stocksValue.toStringAsFixed(0),
                              icMutualFundsInvestment,
                              'Mutual Funds',
                              mutualFundsValue.toStringAsFixed(0),
                              colorF9C1,
                              stockInvestmentType,
                              mfInvestmentType),
                          SizedBox(height: 2.h),
                          birdEyeView(
                              'INCOME',
                              icHome,
                              'Home',
                              '87903',
                              icFactory1,
                              'Factory\'s',
                              '97404',
                              color6C6C,
                              homeIncomeType,
                              factoryIncomeType),
                          SizedBox(height: 2.h),
                          birdEyeView(
                              'LOAN (LIABILITIES)',
                              icCarLoan,
                              'Car Loan',
                              '42405',
                              icBikeLoan,
                              'Bike Loan',
                              '987863',
                              colorFB83,
                              carLoanType,
                              bikeLoanType),
                          SizedBox(height: 2.h),
                          birdEyeView(
                              'INSURANCE',
                              icCarLoan,
                              'Car Loan',
                              '42405',
                              icBikeLoan,
                              'Bike Loan',
                              '987863',
                              colorFB83,
                              carInsuranceType,
                              bikeInsuranceType),
                          SizedBox(height: 2.h),
                          birdEyeView(
                              'ASSETS',
                              icCarLoan,
                              'Car Loan',
                              '42405',
                              icBikeLoan,
                              'Bike Loan',
                              '987863',
                              colorFB83,
                              carAssetsType,
                              bikeAssetsType),
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
                  // }
                  // return Center(
                  //   child: SizedBox(
                  //       height: 25,
                  //       width: 25,
                  //       child: CircularProgressIndicator(
                  //           color: colorRed, strokeWidth: 0.7.w)),
                  // );
                },
              )),
        );
      }),
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
                  mutualFundsValue = 0;
                  for (int i = 0;
                      i < state.investmentPortfolio.mFStocks.length;
                      i++) {
                    if (state.investmentPortfolio.mFStocks[i].unit.toInt() !=
                        0) {
                      mutualFundsValue += ((state.investmentPortfolio
                                  .mFStocks[i].investment_Unit -
                              state.investmentPortfolio.mFStocks[i].sale_Unit) *
                          state.investmentPortfolio.mFStocks[i].nav);
                    }
                  }
                  setState(() {});
                }
              },
              child: BlocListener<FetchingDataBloc, FetchingDataState>(
                listener: (context, state) {
                  if (state is StockInvestmentLoadedState) {
                    stocksValue = 0;
                    // Navigator.of(context)
                    //     .pushReplacementNamed(StocksInvestment.route);

                    for (int i = 0;
                        i < state.stockInvestmentPortfolio.stocks.length;
                        i++) {
                      stocksValue += ((state
                              .stockInvestmentPortfolio.stocks[i].balanceQty) *
                          state.stockInvestmentPortfolio.stocks[i].rate);
                    }
                    setState(() {});
                  }
                },
                child: Row(
                  children: [
                    iconTextValue(icon1, bgColor, text1, value1, () {
                      if (firstRouteName == stockInvestmentType) {
                        BlocProvider.of<FetchingDataBloc>(context)
                            .add(LoadStockInvestmentEvent(
                                userId: ApiUser.userId,
                                investmentPortfolio: StockInvestmentModel(
                                  code: 0,
                                  message: '',
                                  portfolio: 0,
                                  investment: 0,
                                  gain: 0,
                                  stocks: [],
                                )));
                        Navigator.of(context)
                            .pushReplacementNamed(StocksInvestment.route);
                        // selectFormDialog(stockInvestmentType);
                      } else if (firstRouteName == carAssetsType) {
                        selectFormDialog(carAssetsType);
                      } else if (firstRouteName == homeIncomeType) {
                        selectFormDialog(homeIncomeType);
                      } else if (firstRouteName == carLoanType) {
                        selectFormDialog(carLoanType);
                      } else if (firstRouteName == carInsuranceType) {
                        selectFormDialog(carInsuranceType);
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
                        Navigator.of(context)
                            .pushReplacementNamed(MutualFundsInvestment.route);
                        // selectFormDialog(mfInvestmentType);
                      } else if (secondRouteName == bikeAssetsType) {
                        selectFormDialog(bikeAssetsType);
                      } else if (secondRouteName == factoryIncomeType) {
                        selectFormDialog(factoryIncomeType);
                      } else if (secondRouteName == bikeLoanType) {
                        selectFormDialog(bikeLoanType);
                      } else if (secondRouteName == bikeInsuranceType) {
                        selectFormDialog(bikeInsuranceType);
                      }
                    })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  selectFormDialog(String lable) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: SizedBox(
                              height: lable == stockInvestmentType
                                  ? 31.5.h + 60
                                  : lable == homeIncomeType ||
                                          lable == mfInvestmentType ||
                                          lable == carAssetsType ||
                                          lable == bikeAssetsType ||
                                          lable == homeIncomeType
                                      ? 38.5.h + 60
                                      : lable == factoryIncomeType
                                          ? 45.5.h + 60
                                          : 25.5.h + 60,
                              width: 77.8.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 60,
                                      width: 77.8.w,
                                      decoration: const BoxDecoration(
                                          color: colorBG,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10))),
                                      padding: EdgeInsets.only(left: 3.5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              lable == stockInvestmentType ||
                                                      lable == mfInvestmentType
                                                  ? 'Investments'
                                                  : lable == carAssetsType ||
                                                          lable ==
                                                              bikeAssetsType
                                                      ? 'Assets'
                                                      : lable == homeIncomeType ||
                                                              lable ==
                                                                  factoryIncomeType
                                                          ? 'Income'
                                                          : lable == carLoanType ||
                                                                  lable ==
                                                                      bikeLoanType
                                                              ? 'Loan'
                                                              : lable == carInsuranceType ||
                                                                      lable ==
                                                                          bikeInsuranceType
                                                                  ? 'Insurance'
                                                                  : '',
                                              style:
                                                  textStyle14Bold(colorBlack)),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              splashColor: colorBG,
                                              splashRadius: 5.5.w,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close,
                                                  size: 3.h, color: colorRed))
                                        ],
                                      )),
                                  SizedBox(
                                      height: lable == stockInvestmentType
                                          ? 31.5.h
                                          : lable == homeIncomeType ||
                                                  lable == mfInvestmentType ||
                                                  lable == carAssetsType ||
                                                  lable == bikeAssetsType ||
                                                  lable == homeIncomeType
                                              ? 38.5.h
                                              : lable == factoryIncomeType
                                                  ? 45.5.h
                                                  : 25.5.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              //  Investments

                                              if (lable ==
                                                  stockInvestmentType) ...[
                                                cTextFormField('Enter Salary',
                                                    (value) {
                                                  salary = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter Professional',
                                                    (value) {
                                                  professional =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter SpouseIncome',
                                                    (value) {
                                                  spouseIncome =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter OtherIncome',
                                                    (value) {
                                                  otherIncome =
                                                      num.parse(value);
                                                }),
                                              ] else if (lable ==
                                                  mfInvestmentType) ...[
                                                cTextFormField(
                                                    'Enter MutualFunds',
                                                    (value) {
                                                  mutualFunds =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter EmergencyFunds',
                                                    (value) {
                                                  emergencyFunds =
                                                      num.parse(value);
                                                }),
                                                cTextFormField('Enter PPF',
                                                    (value) {
                                                  pPF = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter SIPMonthly',
                                                    (value) {
                                                  sIPMonthly = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter PPFMonthly',
                                                    (value) {
                                                  pPFMonthly = num.parse(value);
                                                }),
                                              ]
                                              // Assets
                                              else if (lable ==
                                                  carAssetsType) ...[
                                                cTextFormField('Enter Gold',
                                                    (value) {
                                                  gold = num.parse(value);
                                                }),
                                                cTextFormField('Enter Cash',
                                                    (value) {
                                                  cash = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter StockPortfolio',
                                                    (value) {
                                                  stockPortfolio =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter SavingAccount',
                                                    (value) {
                                                  savingAccount =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter PostOfficeOrVikasPatra',
                                                    (value) {
                                                  postOfficeOrVikasPatra =
                                                      num.parse(value);
                                                }),
                                              ] else if (lable ==
                                                  bikeAssetsType) ...[
                                                cTextFormField('Enter Vehicle',
                                                    (value) {
                                                  vehicle = num.parse(value);
                                                }),
                                                cTextFormField('Enter Guided',
                                                    (value) {
                                                  guided = num.parse(value);
                                                }),
                                                cTextFormField('Enter Unguided',
                                                    (value) {
                                                  unguided = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter Overdraft', (value) {
                                                  overdraft = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter OtherAsset',
                                                    (value) {
                                                  otherAsset = num.parse(value);
                                                }),
                                              ]
                                              // Income
                                              else if (lable ==
                                                  homeIncomeType) ...[
                                                cTextFormField(
                                                    'Enter HouseHoldMonthly',
                                                    (value) {
                                                  houseHoldMonthly =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter TotalMonthlyEmi',
                                                    (value) {
                                                  totalMonthlyEmi =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter TotalInsurancePremiumYearly',
                                                    (value) {
                                                  totalInsurancePremiumYearly =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter ChildrenEducationYearly',
                                                    (value) {
                                                  childrenEducationYearly =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter OtherExpenseYearly',
                                                    (value) {
                                                  otherExpenseYearly =
                                                      num.parse(value);
                                                }),
                                              ] else if (lable ==
                                                  factoryIncomeType) ...[
                                                cTextFormField(
                                                    'Enter Debenture', (value) {
                                                  debenture = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter FixedDeposite',
                                                    (value) {
                                                  fixedDeposite =
                                                      num.parse(value);
                                                }),
                                                cTextFormField('Enter PMS',
                                                    (value) {
                                                  pMS = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter PrivateInvestmentScheme',
                                                    (value) {
                                                  privateInvestmentScheme =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter RealEstate',
                                                    (value) {
                                                  realEstate = num.parse(value);
                                                }),
                                                cTextFormField('Enter Business',
                                                    (value) {
                                                  business = num.parse(value);
                                                }),
                                              ]
                                              //  Loan
                                              else if (lable ==
                                                  carLoanType) ...[
                                                cTextFormField(
                                                    'Enter HousingLoan',
                                                    (value) {
                                                  housingLoan =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter EducationLoan',
                                                    (value) {
                                                  educationLoan =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter PersonalLoan',
                                                    (value) {
                                                  personalLoan =
                                                      num.parse(value);
                                                }),
                                              ] else if (lable ==
                                                  bikeLoanType) ...[
                                                cTextFormField(
                                                    'Enter MortgageLoan',
                                                    (value) {
                                                  mortgageLoan =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter VehicleLoan',
                                                    (value) {
                                                  vehicleLoan =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter OtherLoan', (value) {
                                                  otherLoan = num.parse(value);
                                                }),
                                              ]
                                              // Insurance
                                              else if (lable ==
                                                  carInsuranceType) ...[
                                                cTextFormField(
                                                    'Enter TermInsurance',
                                                    (value) {
                                                  termInsurance =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter TraditionalInsurance',
                                                    (value) {
                                                  traditionalInsurance =
                                                      num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter HealthInsurance',
                                                    (value) {
                                                  healthInsurance =
                                                      num.parse(value);
                                                }),
                                              ] else if (lable ==
                                                  bikeInsuranceType) ...[
                                                cTextFormField(
                                                    'Enter VehicleInsurance',
                                                    (value) {
                                                  vehicleInsurance =
                                                      num.parse(value);
                                                }),
                                                cTextFormField('Enter ULIP',
                                                    (value) {
                                                  uLIP = num.parse(value);
                                                }),
                                                cTextFormField(
                                                    'Enter OtherInsurance',
                                                    (value) {
                                                  otherInsurance =
                                                      num.parse(value);
                                                }),
                                              ],
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              InkWell(
                                                splashColor: colorWhite,
                                                onTap: () {
                                                  // if(salary == 0){

                                                  // }else{
                                                  // wealthMeter();
                                                  // }
                                                  wealthMeter();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  height: 4.5.h,
                                                  width: 30.w,
                                                  decoration: BoxDecoration(
                                                      color: colorRed,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: colorRed,
                                                          width: 1)),
                                                  alignment: Alignment.center,
                                                  child: Text('Submit',
                                                      style: textStyle12Bold(
                                                          colorWhite)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ))));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  iconTextValue(String icon, Color bgColor, String text, String value,
      Function() onClick) {
    return text == 'Home'
        ? Showcase(
            key: showGlobalKey,
            description: 'Press here to calculate score',
            child: InkWell(
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
                        Text('₹ ${CommonFunction().splitString(value)}/-',
                            style: textStyle13Bold(colorBlack))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
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
                      Text('₹ ${CommonFunction().splitString(value)}/-',
                          style: textStyle13Bold(colorBlack))
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  void ageCalculate() {
    setState(() {
      if (ApiUser.userDob.isEmpty ||
          ApiUser.userDob == 'null' ||
          ApiUser.userDob == '') {
        userAge = 0;
        userDoB = '';
      } else {
        var userDate =
            DateFormat('yyyy MM dd').format(DateTime.parse(ApiUser.userDob));
        userDoB = userDate.replaceAll(' ', '/');

        final splitValue = userDate.split(' ');
        userAge = DateTime.now()
                .difference(DateTime(int.parse(splitValue[0]),
                    int.parse(splitValue[1]), int.parse(splitValue[2])))
                .inDays ~/
            365;
      }
    });
  }

  void wealthMeter() {
    BlocProvider.of<WealthMeterBloc>(context).add(WealthMeterDataEvent(
        userId: num.parse(ApiUser.userId),
        name: ApiUser.userName,
        dob: userDoB,
        age: userAge,
        interestRate: interestRate,
        business: 0,
        salary: salary,
        professional: professional,
        spouseIncome: spouseIncome,
        otherIncome: otherIncome,
        // salary: 101166,
        // professional: 0,
        // spouseIncome: 0,
        // otherIncome: 0,
        //
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

  cTextFormField(String hintText, ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      alignment: Alignment.centerLeft,
      height: 6.h,
      width: 77.8.w,
      decoration: BoxDecoration(color: colorWhite, boxShadow: [
        BoxShadow(
            color: colorTextBCBC, offset: const Offset(0, 3), blurRadius: 6)
      ]),
      child: SizedBox(
        width: 56.w,
        child: TextFormField(
          style: textStyle12(colorText7070),
          decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: textStyle12(colorText7070),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
