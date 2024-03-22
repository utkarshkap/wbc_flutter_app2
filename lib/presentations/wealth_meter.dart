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
    wealthMeter();
    super.initState();
  }

  showCase() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(myContext!).startShowCase([
        showGlobalKey,
      ]),
    );
  }

  List<bool> queOpenList = [
    false,
    false,
    false,
    false,
    false,
  ];

  // User Details
  String userDoB = '';
  int userAge = 0;
  double interestRate = 7;
  num overdraft = 0;

  // Investments
  num stocksValue = 0;
  num mutualFundsValue = 0;
  num sIPMonthly = 0;
  num pPFMonthly = 0;
  num postOfficeOrVikasPatra = 0;
  num privateInvestmentScheme = 0;

  // INCOME & EXPENSE
  num business = 0;
  num salary = 1;
  num professional = 0;
  num spouseIncome = 0;
  num otherIncome = 0;
  num houseHoldMonthly = 0;

  // Loan
  num housingLoan = 0;
  num vehicleLoan = 0;
  num educationLoan = 0;
  num personalLoan = 0;
  num otherLoan = 0;
  num mortgageLoan = 0;

  // Insurance
  num healthInsurance = 0;
  num vehicleInsurance = 0;
  num termInsurance = 0;
  num traditionalInsurance = 0;
  num otherInsurance = 0;
  num uLIP = 0;

  // Assets
  num gold = 0;
  num cash = 0;
  num realEstate = 0;
  num vehicle = 0;
  num otherAsset = 0;
  num fixedDeposite = 0;
//

  num emergencyFunds = 0;
  num pPF = 0;
  num savingAccount = 0;
  num guided = 0;
  num unguided = 0;
  num totalMonthlyEmi = 0;
  num totalInsurancePremiumYearly = 0;
  num childrenEducationYearly = 0;
  num otherExpenseYearly = 0;
  num debenture = 0;
  num pMS = 0;

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
                        ApiUser.wealthMeterScore = 50;
                      } else {
                        ApiUser.wealthMeterScore = state.totalScore.toDouble();
                      }
                    });
                  }
                },
                builder: (context, state) {
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
                                            value: ApiUser.wealthMeterScore,
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
                                                      ApiUser.wealthMeterScore
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
                          SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  queOpenList.length,
                                  (index) => index == 0
                                      ? newBirdEyeView(
                                          queOpenList[index],
                                          'INVESTMENTS',
                                          icStocks,
                                          'Stocks',
                                          num.parse(
                                              stocksValue.toStringAsFixed(0)),
                                          icMutualFunds,
                                          'Mutual Funds',
                                          num.parse(mutualFundsValue
                                              .toStringAsFixed(0)),
                                          icSIP,
                                          'SIPMonthly',
                                          sIPMonthly,
                                          icPPF,
                                          'PPFMonthly',
                                          pPFMonthly,
                                          icPostOfficeOrvikasPatra,
                                          'PostOfficeOrVikas..',
                                          postOfficeOrVikasPatra,
                                          icPrivateInvestmentsScheme,
                                          'PrivateInvestment..',
                                          privateInvestmentScheme,
                                          colorGreenEFC, () {
                                          setState(() {
                                            queOpenList[index] =
                                                !queOpenList[index];
                                          });
                                        })
                                      : index == 1
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: newBirdEyeView(
                                                  queOpenList[index],
                                                  'INCOME & EXPENSE',
                                                  icBusiness,
                                                  'Business',
                                                  business,
                                                  icSalary,
                                                  'Salary',
                                                  salary == 1 ? 0 : salary,
                                                  icProfessional,
                                                  'Professional',
                                                  professional,
                                                  icSpouselncome,
                                                  'SpouseIncome',
                                                  spouseIncome,
                                                  icOtherIncome,
                                                  'OtherIncome',
                                                  otherIncome,
                                                  icHouseHoldMonthly,
                                                  'HouseHoldMonthly',
                                                  houseHoldMonthly,
                                                  colorGreenEFC, () {
                                                setState(() {
                                                  queOpenList[index] =
                                                      !queOpenList[index];
                                                });
                                              }),
                                            )
                                          : index == 2
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2.h),
                                                  child: newBirdEyeView(
                                                      queOpenList[index],
                                                      'LOAN (LIABILITIES)',
                                                      icHousingLoan,
                                                      'HousingLoan',
                                                      housingLoan,
                                                      icVehicalLoan,
                                                      'VehicleLoan',
                                                      vehicleLoan,
                                                      icEducationLoan,
                                                      'EducationLoan',
                                                      educationLoan,
                                                      icPersonalLoan,
                                                      'PersonalLoan',
                                                      personalLoan,
                                                      icOtherLoan,
                                                      'OtherLoan',
                                                      otherLoan,
                                                      icMortgageLoan,
                                                      'MortgageLoan',
                                                      mortgageLoan,
                                                      colorGreenEFC, () {
                                                    setState(() {
                                                      queOpenList[index] =
                                                          !queOpenList[index];
                                                    });
                                                  }),
                                                )
                                              : index == 3
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2.h),
                                                      child: newBirdEyeView(
                                                          queOpenList[index],
                                                          'INSURANCE',
                                                          icHealthInsurance,
                                                          'HealthInsurance',
                                                          healthInsurance,
                                                          icVehicleInsurance,
                                                          'VehicleInsurance',
                                                          vehicleInsurance,
                                                          icTermInsurance,
                                                          'TermInsurance',
                                                          termInsurance,
                                                          icTraditionalInsurance,
                                                          'TraditionalInsurance',
                                                          traditionalInsurance,
                                                          icOtherInsurance,
                                                          'OtherInsurance',
                                                          otherInsurance,
                                                          icUlip,
                                                          'ULIP',
                                                          uLIP,
                                                          colorGreenEFC, () {
                                                        setState(() {
                                                          queOpenList[index] =
                                                              !queOpenList[
                                                                  index];
                                                        });
                                                      }),
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2.h),
                                                      child: newBirdEyeView(
                                                          queOpenList[index],
                                                          'ASSETS',
                                                          icGold,
                                                          'Gold',
                                                          gold,
                                                          icCash,
                                                          'Cash',
                                                          cash,
                                                          icRealEstate1,
                                                          'RealEstate',
                                                          realEstate,
                                                          icVehical,
                                                          'Vehicle',
                                                          vehicle,
                                                          icOtherAssets,
                                                          'OtherAsset',
                                                          otherAsset,
                                                          icFixeDeposit,
                                                          'FixedDeposite',
                                                          fixedDeposite,
                                                          colorGreenEFC, () {
                                                        setState(() {
                                                          queOpenList[index] =
                                                              !queOpenList[
                                                                  index];
                                                        });
                                                      }),
                                                    )),
                            ),
                          ),
                          // Image.asset(
                          //     'assets/images/CheckWealthmeterScore.gif'),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                  );
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

  newBirdEyeView(
      bool isSelect,
      String mainTitle,
      String icon1,
      String text1,
      num value1,
      String icon2,
      String text2,
      num value2,
      String icon3,
      String text3,
      num value3,
      String icon4,
      String text4,
      num value4,
      String icon5,
      String text5,
      num value5,
      String icon6,
      String text6,
      num value6,
      Color bgColor,
      Function() onOpen) {
    return Container(
      width: 90.w,
      decoration: decoration(colorWhite),
      child: BlocListener<MFInvestmentsBloc, MFInvestmentsState>(
        listener: (context, state) {
          if (state is MFInvestmentsLoadedState) {
            mutualFundsValue = 0;
            for (int i = 0;
                i < state.investmentPortfolio.mFStocks.length;
                i++) {
              if (state.investmentPortfolio.mFStocks[i].unit.toInt() != 0) {
                mutualFundsValue +=
                    ((state.investmentPortfolio.mFStocks[i].investment_Unit -
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

              for (int i = 0;
                  i < state.stockInvestmentPortfolio.stocks.length;
                  i++) {
                stocksValue +=
                    ((state.stockInvestmentPortfolio.stocks[i].balanceQty) *
                        state.stockInvestmentPortfolio.stocks[i].rate);
              }
              setState(() {});
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 3.5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainTitle,
                        style: textStyle10Bold(colorBlack)
                            .copyWith(letterSpacing: 0.7)),
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: InkWell(
                          onTap: onOpen,
                          child: Icon(
                            isSelect
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_outlined,
                            size: 2.5.h,
                            color: colorBlack,
                          )),
                    )
                  ],
                ),
              ),
              Container(height: 1, color: colorTextBCBC.withOpacity(0.36)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 00),
                curve: Curves.easeInOut,
                height: !isSelect ? 9.h : 27.h,
                // !isExpanded
                //     ? max(4 * 4.0 + 55, 65)
                //     : max(5 * 50.0 + 20, ((100 / 50).ceil() * 20) + 65),

                // : (question.length / 35).ceil()==1?60:(((question.length / 35).ceil()*10)+60),,
                child: Column(
                  children: [
                    Row(
                      children: [
                        iconTextValue(icon1, bgColor, text1, value1.toString(),
                            () {
                          if (text1 == 'Stocks') {
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
                          } else {
                            newSelectFormDialog(mainTitle, text1, icon1);
                          }
                        }),
                        Container(
                            height: 9.h,
                            width: 1,
                            color: colorTextBCBC.withOpacity(0.36)),
                        iconTextValue(icon2, bgColor, text2, value2.toString(),
                            () {
                          if (text2 == 'Mutual Funds') {
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
                            Navigator.of(context).pushReplacementNamed(
                                MutualFundsInvestment.route);
                          } else {
                            newSelectFormDialog(mainTitle, text2, icon2);
                          }
                        })
                      ],
                    ),
                    if (isSelect) ...[
                      Row(
                        children: [
                          iconTextValue(
                              icon3, bgColor, text3, value3.toString(), () {
                            newSelectFormDialog(mainTitle, text3, icon3);
                          }),
                          Container(
                              height: 9.h,
                              width: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          iconTextValue(
                              icon4, bgColor, text4, value4.toString(), () {
                            newSelectFormDialog(mainTitle, text4, icon4);
                          })
                        ],
                      ),
                      Row(
                        children: [
                          iconTextValue(
                              icon5, bgColor, text5, value5.toString(), () {
                            newSelectFormDialog(mainTitle, text5, icon5);
                          }),
                          Container(
                              height: 9.h,
                              width: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          iconTextValue(
                              icon6, bgColor, text6, value6.toString(), () {
                            newSelectFormDialog(mainTitle, text6, icon6);
                          })
                        ],
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  newSelectFormDialog(String mainTitle, String lable, String icon) {
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
                                borderRadius: BorderRadius.circular(15)),
                            content: SizedBox(
                              height: 37.h,
                              width: 77.8.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        splashColor: colorBG,
                                        splashRadius: 5.5.w,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close,
                                            size: 3.h, color: colorRed)),
                                  ),
                                  Image.asset(
                                    icon,
                                    height: 7.h,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(lable,
                                      style: textStyle14Bold(colorBlack)),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  cTextFormField('Enter $lable', (value) {
                                    if (lable == 'SIPMonthly') {
                                      sIPMonthly = num.parse(value);
                                    } else if (lable == 'PPFMonthly') {
                                      pPFMonthly = num.parse(value);
                                    } else if (lable == 'PostOfficeOrVikas..') {
                                      postOfficeOrVikasPatra = num.parse(value);
                                    } else if (lable == 'PrivateInvestment..') {
                                      privateInvestmentScheme =
                                          num.parse(value);
                                    } else if (lable == 'Business') {
                                      business = num.parse(value);
                                    } else if (lable == 'Salary') {
                                      salary = num.parse(value);
                                    } else if (lable == 'Professional') {
                                      professional = num.parse(value);
                                    } else if (lable == 'SpouseIncome') {
                                      spouseIncome = num.parse(value);
                                    } else if (lable == 'OtherIncome') {
                                      otherIncome = num.parse(value);
                                    } else if (lable == 'HouseHoldMonthly') {
                                      houseHoldMonthly = num.parse(value);
                                    } else if (lable == 'HousingLoan') {
                                      housingLoan = num.parse(value);
                                    } else if (lable == 'VehicleLoan') {
                                      vehicleLoan = num.parse(value);
                                    } else if (lable == 'EducationLoan') {
                                      educationLoan = num.parse(value);
                                    } else if (lable == 'PersonalLoan') {
                                      personalLoan = num.parse(value);
                                    } else if (lable == 'OtherLoan') {
                                      otherLoan = num.parse(value);
                                    } else if (lable == 'MortgageLoan') {
                                      mortgageLoan = num.parse(value);
                                    } else if (lable == 'HealthInsurance') {
                                      healthInsurance = num.parse(value);
                                    } else if (lable == 'VehicleInsurance') {
                                      vehicleInsurance = num.parse(value);
                                    } else if (lable == 'TermInsurance') {
                                      termInsurance = num.parse(value);
                                    } else if (lable ==
                                        'TraditionalInsurance') {
                                      traditionalInsurance = num.parse(value);
                                    } else if (lable == 'OtherInsurance') {
                                      otherInsurance = num.parse(value);
                                    } else if (lable == 'ULIP') {
                                      uLIP = num.parse(value);
                                    } else if (lable == 'Gold') {
                                      gold = num.parse(value);
                                    } else if (lable == 'Cash') {
                                      cash = num.parse(value);
                                    } else if (lable == 'RealEstate') {
                                      realEstate = num.parse(value);
                                    } else if (lable == 'OtherAsset') {
                                      otherAsset = num.parse(value);
                                    } else if (lable == 'Vehicle') {
                                      vehicle = num.parse(value);
                                    } else if (lable == 'FixedDeposite') {
                                      fixedDeposite = num.parse(value);
                                    }
                                  }),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                    splashColor: colorWhite,
                                    onTap: () {
                                      wealthMeter();
                                      Navigator.of(context).pop();
                                      checkWealthScoreDialogBox();
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      height: 5.h,
                                      // width: 30.w,
                                      decoration: BoxDecoration(
                                          color: colorRed,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: colorRed, width: 1)),
                                      alignment: Alignment.center,
                                      child: Text('SUBMIT',
                                          style: textStyle12Bold(colorWhite)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  checkWealthScoreDialogBox() {
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
                                borderRadius: BorderRadius.circular(15)),
                            content: SizedBox(
                              height: 37.h,
                              width: 77.8.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        splashColor: colorBG,
                                        splashRadius: 5.5.w,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close,
                                            size: 3.h, color: colorRed)),
                                  ),
                                  Image.asset(
                                    'assets/images/CheckWealthmeterScore.gif',
                                    height: 20.h,
                                    width: 90.w,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                    splashColor: colorWhite,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                          color: colorRed,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: colorRed, width: 1)),
                                      alignment: Alignment.center,
                                      child: Text('GO',
                                          style: textStyle12Bold(colorWhite)),
                                    ),
                                  ),
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
                        // color: colorWhite,
                        height: 3.5.h),
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text,
                          overflow: TextOverflow.fade,
                          style: textStyle9(colorText3D3D)),
                      SizedBox(height: 0.5.h),
                      Text('₹ ${CommonFunction().splitString(value)}/-',
                          overflow: TextOverflow.visible,
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
        business: business,
        salary: salary,
        professional: professional,
        spouseIncome: spouseIncome,
        otherIncome: otherIncome,
        houseHoldMonthly: houseHoldMonthly,
        totalMonthlyEmi: 8500,
        totalInsurancePremiumYearly: 50000,
        childrenEducationYearly: 120000,
        otherExpenseYearly: 0,
        vehicle: vehicle,
        gold: gold,
        savingAccount: 0,
        cash: cash,
        emergencyFunds: 300000,
        otherAsset: otherAsset,
        mutualFunds: mutualFundsValue.toInt(),
        pPF: 0,
        sIPMonthly: sIPMonthly,
        pPFMonthly: pPFMonthly,
        debenture: 0,
        fixedDeposite: 0,
        stockPortfolio: stocksValue.toInt(),
        guided: 0,
        unguided: 0,
        postOfficeOrVikasPatra: postOfficeOrVikasPatra,
        pMS: 0,
        privateInvestmentScheme: privateInvestmentScheme,
        realEstate: realEstate,
        termInsurance: termInsurance,
        traditionalInsurance: traditionalInsurance,
        uLIP: uLIP,
        vehicleInsurance: vehicleInsurance,
        otherInsurance: otherInsurance,
        healthInsurance: healthInsurance,
        housingLoan: housingLoan,
        mortgageLoan: mortgageLoan,
        educationLoan: educationLoan,
        personalLoan: personalLoan,
        vehicleLoan: vehicleLoan,
        overdraft: overdraft,
        otherLoan: otherLoan));
  }

  cTextFormField(String hintText, ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      alignment: Alignment.centerLeft,
      height: 6.h,
      width: 77.8.w,
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: colorTextBCBC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 50.w,
        child: TextFormField(
          autofocus: true,
          style: textStyle12(colorText7070),
          inputFormatters: [LengthLimitingTextInputFormatter(7)],
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
