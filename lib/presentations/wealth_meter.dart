import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/blocs/wealthMeter/wealth_meter_bloc.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/models/investment_portfolio_model.dart';
import 'package:wbc_connect_app/models/stock_investment_model.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import '../blocs/MFInvestments/mf_investments_bloc.dart';
import '../core/api/api_consts.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

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
    getWealthData();
    BlocProvider.of<MFInvestmentsBloc>(context).add(LoadMFInvestmentsEvent(
        userId: ApiUser.userId,
        investmentPortfolio: InvestmentPortfolio(
          code: 0,
          message: '',
          response: [],
          totalAmount: 0,
          totalBalanceUnit: 0,
          totalPurchaseAmount: 0,
          totalRedeemAmount: 0,
          totalScheme: 0,
        )));
    BlocProvider.of<FetchingDataBloc>(context).add(LoadStockInvestmentEvent(
        userId: ApiUser.userId,
        investmentPortfolio: StockInvestmentModel(
          code: 0,
          message: '',
          portfolio: 0,
          investment: 0,
          gain: 0,
          balanceAmount: 0,
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

  List<bool> queOpenList = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool isCheckedStocks = false;
  bool isCheckedMutualFunds = false;
  TextEditingController textEditingController = TextEditingController();

  getWealthData() async {
    final pref = await SharedPreferences.getInstance();

    stocksValue = pref.getInt('stocksValue') ?? 0;
    mutualFundsValue = pref.getInt('mutualFundsValue') ?? 0;
    pPFMonthly = pref.getInt('pPFMonthly') ?? 0;
    debenture = pref.getInt('debenture') ?? 0;
    fixedDeposite = pref.getInt('fixedDeposite') ?? 0;
    business = pref.getInt('business') ?? 0;
    salary = pref.getInt('salary') ?? 0;
    spouseIncome = pref.getInt('spouseIncome') ?? 0;
    otherIncome = pref.getInt('otherIncome') ?? 0;
    houseHoldMonthly = pref.getInt('houseHoldMonthly') ?? 0;
    totalMonthlyEmi = pref.getInt('totalMonthlyEmi') ?? 0;
    childrenEducationYearly = pref.getInt('childrenEducationYearly') ?? 0;
    housingLoan = pref.getInt('housingLoan') ?? 0;
    vehicleLoan = pref.getInt('vehicleLoan') ?? 0;
    educationLoan = pref.getInt('educationLoan') ?? 0;
    personalLoan = pref.getInt('personalLoan') ?? 0;
    mortgageLoan = pref.getInt('mortgageLoan') ?? 0;
    otherLoan = pref.getInt('otherLoan') ?? 0;
    termInsurance = pref.getInt('termInsurance') ?? 0;
    vehicleInsurance = pref.getInt('vehicleInsurance') ?? 0;
    traditionalInsurance = pref.getInt('traditionalInsurance') ?? 0;
    uLIP = pref.getInt('uLIP') ?? 0;
    healthInsurance = pref.getInt('healthInsurance') ?? 0;
    otherInsurance = pref.getInt('otherInsurance') ?? 0;
    vehicle = pref.getInt('vehicle') ?? 0;
    gold = pref.getInt('gold') ?? 0;
    emergencyFunds = pref.getInt('emergencyFunds') ?? 0;
    otherAsset = pref.getInt('otherAsset') ?? 0;
    wealthMeter();
  }

  // User Details
  String userDoB = '';
  int userAge = 0;
  double interestRate = 6.5;
  int overdraft = 0;

  int stocksApiData = 0;
  int mutualFundsApiData = 0;

  // Investments
  int stocksValue = 0;
  int mutualFundsValue = 0;
  int pPFMonthly = 0;
  int debenture = 0;
  int fixedDeposite = 0;

  // INCOME
  int business = 0;
  int salary = 0;
  int spouseIncome = 0;
  int otherIncome = 0;

  // EXPENSE
  int houseHoldMonthly = 0;
  int totalMonthlyEmi = 0;
  int childrenEducationYearly = 0;

  // Loan
  int housingLoan = 0;
  int vehicleLoan = 0;
  int educationLoan = 0;
  int personalLoan = 0;
  int mortgageLoan = 0;
  int otherLoan = 0;

  // Insurance
  int termInsurance = 0;
  int vehicleInsurance = 0;
  int traditionalInsurance = 0;
  int uLIP = 0;
  int healthInsurance = 0;
  int otherInsurance = 0;

  // Assets
  int vehicle = 0;
  int gold = 0;
  int emergencyFunds = 0;
  int otherAsset = 0;

//

  int cash = 0;
  int realEstate = 0;
  int pPF = 0;
  int savingAccount = 0;
  int guided = 0;
  int unguided = 0;
  int totalInsurancePremiumYearly = 0;
  int otherExpenseYearly = 0;
  int pMS = 0;
  int professional = 0;
  int sIPMonthly = 0;
  int postOfficeOrVikasPatra = 0;
  int privateInvestmentScheme = 0;
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
                      Preference.setWealthScore(ApiUser.wealthMeterScore);
                      Navigator.of(context).pop(true);
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
                      onClick: () {
                        Navigator.of(context)
                            .pushNamed(NotificationScreen.route);
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
                      if (state.totalScore <= 0) {
                        ApiUser.wealthMeterScore = 0;
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
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Container(
                              width: 90.w,
                              decoration: decoration(colorWhite),
                              child: SfRadialGauge(axes: <RadialAxis>[
                                RadialAxis(
                                    startAngle: 145,
                                    endAngle: 35,
                                    radiusFactor: 0.7,
                                    showTicks: false,
                                    showLabels: false,
                                    centerY: 0.45,
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
                                        knobStyle:
                                            const KnobStyle(knobRadius: 0.08),
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
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.h),
                                              child: Text('WEALTH SCORE',
                                                  style: textStyle13Bold(
                                                          colorBlack)
                                                      .copyWith(
                                                          letterSpacing: 0.16)),
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
                                                      colorTextFFC1, 'Medium'),
                                                  wealthScoreIndicator(
                                                      colorGreen, 'High'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        angle: 90,
                                        positionFactor: 1.8,
                                      )
                                    ])
                              ]),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  queOpenList.length,
                                  (index) => index == 0
                                      ?
                                      //  INVESTMENTS
                                      Container(
                                          width: 90.w,
                                          decoration: decoration(colorWhite),
                                          child: BlocListener<MFInvestmentsBloc,
                                              MFInvestmentsState>(
                                            listener: (context, state) {
                                              if (state
                                                  is MFInvestmentsLoadedState) {
                                                mutualFundsApiData = 0;
                                                mutualFundsApiData = state
                                                    .investmentPortfolio
                                                    .totalAmount
                                                    .toInt();
                                                setState(() {});
                                              }
                                            },
                                            child: BlocListener<
                                                FetchingDataBloc,
                                                FetchingDataState>(
                                              listener: (context, state) {
                                                if (state
                                                    is StockInvestmentLoadedState) {
                                                  stocksApiData = 0;

                                                  for (int i = 0;
                                                      i <
                                                          state
                                                              .stockInvestmentPortfolio
                                                              .stocks
                                                              .length;
                                                      i++) {
                                                    stocksApiData += ((state
                                                                .stockInvestmentPortfolio
                                                                .stocks[i]
                                                                .balanceQty) *
                                                            state
                                                                .stockInvestmentPortfolio
                                                                .stocks[i]
                                                                .rate)
                                                        .toInt();
                                                  }
                                                  setState(() {});
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.h,
                                                        bottom: 2.h,
                                                        left: 3.5.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('INVESTMENTS',
                                                            style: textStyle10Bold(
                                                                    colorBlack)
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        0.7)),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5.w),
                                                          child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  queOpenList[
                                                                          index] =
                                                                      !queOpenList[
                                                                          index];
                                                                });
                                                              },
                                                              child: Icon(
                                                                queOpenList[
                                                                        index]
                                                                    ? Icons
                                                                        .keyboard_arrow_up_rounded
                                                                    : Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                size: 2.7.h,
                                                                opticalSize:
                                                                    25.h,
                                                                color:
                                                                    colorBlack,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 1,
                                                      color: colorTextBCBC
                                                          .withOpacity(0.36)),
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 00),
                                                    curve: Curves.easeInOut,
                                                    height: !queOpenList[index]
                                                        ? 9.h
                                                        : 27.h,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            iconTextValue(
                                                                icStocks,
                                                                colorGreenEFC,
                                                                'Stocks',
                                                                stocksValue
                                                                    .toString(),
                                                                () {
                                                              textEditingController
                                                                      .text =
                                                                  stocksValue ==
                                                                          0
                                                                      ? ''
                                                                      : stocksValue
                                                                          .toString();

                                                              newSelectFormDialog(
                                                                  'Stocks',
                                                                  icStocks);
                                                            }),
                                                            Container(
                                                                height: 9.h,
                                                                width: 1,
                                                                color: colorTextBCBC
                                                                    .withOpacity(
                                                                        0.36)),
                                                            iconTextValue(
                                                                icMutualFunds,
                                                                colorGreenEFC,
                                                                'Mutual Funds',
                                                                mutualFundsValue
                                                                    .toString(),
                                                                () {
                                                              textEditingController
                                                                  .text = mutualFundsValue ==
                                                                      0
                                                                  ? ''
                                                                  : mutualFundsValue
                                                                      .toString();

                                                              newSelectFormDialog(
                                                                  'Mutual Funds',
                                                                  icMutualFunds);
                                                            })
                                                          ],
                                                        ),
                                                        if (queOpenList[
                                                            index]) ...[
                                                          Row(
                                                            children: [
                                                              iconTextValue(
                                                                  icPPF,
                                                                  colorGreenEFC,
                                                                  'PPF Monthly',
                                                                  pPFMonthly
                                                                      .toString(),
                                                                  () {
                                                                textEditingController
                                                                    .text = pPFMonthly ==
                                                                        0
                                                                    ? ''
                                                                    : pPFMonthly
                                                                        .toString();
                                                                newSelectFormDialog(
                                                                    'PPF Monthly',
                                                                    icPPF);
                                                              }),
                                                              Container(
                                                                  height: 9.h,
                                                                  width: 1,
                                                                  color: colorTextBCBC
                                                                      .withOpacity(
                                                                          0.36)),
                                                              iconTextValue(
                                                                  icDebenture,
                                                                  colorGreenEFC,
                                                                  'Debenture',
                                                                  debenture
                                                                      .toString(),
                                                                  () {
                                                                textEditingController
                                                                        .text =
                                                                    debenture ==
                                                                            0
                                                                        ? ''
                                                                        : debenture
                                                                            .toString();
                                                                newSelectFormDialog(
                                                                    'Debenture',
                                                                    icDebenture);
                                                              })
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              iconTextValue(
                                                                  icFixeDeposit,
                                                                  colorGreenEFC,
                                                                  'Fixed Deposite',
                                                                  fixedDeposite
                                                                      .toString(),
                                                                  () {
                                                                textEditingController
                                                                    .text = fixedDeposite ==
                                                                        0
                                                                    ? ''
                                                                    : fixedDeposite
                                                                        .toString();

                                                                newSelectFormDialog(
                                                                    'Fixed Deposite',
                                                                    icFixeDeposit);
                                                              }),
                                                              Container(
                                                                  height: 9.h,
                                                                  width: 1,
                                                                  color: colorTextBCBC
                                                                      .withOpacity(
                                                                          0.36)),
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
                                        )
                                      : index == 1
                                          ?
                                          // INCOME
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: Container(
                                                width: 90.w,
                                                decoration:
                                                    decoration(colorWhite),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2.h,
                                                          bottom: 2.h,
                                                          left: 3.5.w),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('INCOME',
                                                              style: textStyle10Bold(
                                                                      colorBlack)
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.7)),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5.w),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    queOpenList[
                                                                            index] =
                                                                        !queOpenList[
                                                                            index];
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  queOpenList[
                                                                          index]
                                                                      ? Icons
                                                                          .keyboard_arrow_up_rounded
                                                                      : Icons
                                                                          .keyboard_arrow_down_outlined,
                                                                  size: 2.7.h,
                                                                  opticalSize:
                                                                      25.h,
                                                                  color:
                                                                      colorBlack,
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 1,
                                                        color: colorTextBCBC
                                                            .withOpacity(0.36)),
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 00),
                                                      curve: Curves.easeInOut,
                                                      height:
                                                          !queOpenList[index]
                                                              ? 9.h
                                                              : 18.h,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              iconTextValue(
                                                                  icBusiness,
                                                                  colorGreenEFC,
                                                                  'Business',
                                                                  business
                                                                      .toString(),
                                                                  () {
                                                                textEditingController
                                                                        .text =
                                                                    business ==
                                                                            0
                                                                        ? ''
                                                                        : business
                                                                            .toString();

                                                                newSelectFormDialog(
                                                                    'Business',
                                                                    icBusiness);
                                                              }),
                                                              Container(
                                                                  height: 9.h,
                                                                  width: 1,
                                                                  color: colorTextBCBC
                                                                      .withOpacity(
                                                                          0.36)),
                                                              iconTextValue(
                                                                  icSalary,
                                                                  colorGreenEFC,
                                                                  'Salary',
                                                                  salary
                                                                      .toString(),
                                                                  () {
                                                                textEditingController
                                                                        .text =
                                                                    salary == 0
                                                                        ? ''
                                                                        : salary
                                                                            .toString();
                                                                newSelectFormDialog(
                                                                  'Salary',
                                                                  icSalary,
                                                                );
                                                              })
                                                            ],
                                                          ),
                                                          if (queOpenList[
                                                              index]) ...[
                                                            Row(
                                                              children: [
                                                                iconTextValue(
                                                                    icSpouselncome,
                                                                    colorGreenEFC,
                                                                    'Spouse',
                                                                    spouseIncome
                                                                        .toString(),
                                                                    () {
                                                                  textEditingController
                                                                      .text = spouseIncome ==
                                                                          0
                                                                      ? ''
                                                                      : spouseIncome
                                                                          .toString();

                                                                  newSelectFormDialog(
                                                                      'Spouse',
                                                                      icSpouselncome);
                                                                }),
                                                                Container(
                                                                    height: 9.h,
                                                                    width: 1,
                                                                    color: colorTextBCBC
                                                                        .withOpacity(
                                                                            0.36)),
                                                                iconTextValue(
                                                                    icOtherIncome,
                                                                    colorGreenEFC,
                                                                    'Other',
                                                                    otherIncome
                                                                        .toString(),
                                                                    () {
                                                                  textEditingController
                                                                      .text = otherIncome ==
                                                                          0
                                                                      ? ''
                                                                      : otherIncome
                                                                          .toString();

                                                                  newSelectFormDialog(
                                                                      'Other Income',
                                                                      icOtherIncome);
                                                                }),
                                                              ],
                                                            ),
                                                          ]
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : index == 2
                                              ?
                                              // EXPENSE
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2.h),
                                                  child: Container(
                                                    width: 90.w,
                                                    decoration:
                                                        decoration(colorWhite),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h,
                                                                  bottom: 2.h,
                                                                  left: 3.5.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text('EXPENSE',
                                                                  style: textStyle10Bold(
                                                                          colorBlack)
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              0.7)),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: 5
                                                                            .w),
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        queOpenList[index] =
                                                                            !queOpenList[index];
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      queOpenList[
                                                                              index]
                                                                          ? Icons
                                                                              .keyboard_arrow_up_rounded
                                                                          : Icons
                                                                              .keyboard_arrow_down_outlined,
                                                                      size:
                                                                          2.7.h,
                                                                      opticalSize:
                                                                          25.h,
                                                                      color:
                                                                          colorBlack,
                                                                    )),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            height: 1,
                                                            color: colorTextBCBC
                                                                .withOpacity(
                                                                    0.36)),
                                                        AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      00),
                                                          curve:
                                                              Curves.easeInOut,
                                                          height: !queOpenList[
                                                                  index]
                                                              ? 9.h
                                                              : 18.h,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  iconTextValue(
                                                                      icHouseHoldMonthly,
                                                                      colorGreenEFC,
                                                                      'HouseHold',
                                                                      houseHoldMonthly
                                                                          .toString(),
                                                                      () {
                                                                    textEditingController
                                                                        .text = houseHoldMonthly ==
                                                                            0
                                                                        ? ''
                                                                        : houseHoldMonthly
                                                                            .toString();
                                                                    newSelectFormDialog(
                                                                        'HouseHold',
                                                                        icHouseHoldMonthly);
                                                                  }),
                                                                  Container(
                                                                      height:
                                                                          9.h,
                                                                      width: 1,
                                                                      color: colorTextBCBC
                                                                          .withOpacity(
                                                                              0.36)),
                                                                  iconTextValue(
                                                                      icEMI,
                                                                      colorGreenEFC,
                                                                      'EMI',
                                                                      totalMonthlyEmi
                                                                          .toString(),
                                                                      () {
                                                                    textEditingController
                                                                        .text = totalMonthlyEmi ==
                                                                            0
                                                                        ? ''
                                                                        : totalMonthlyEmi
                                                                            .toString();
                                                                    newSelectFormDialog(
                                                                      'EMI',
                                                                      icEMI,
                                                                    );
                                                                  })
                                                                ],
                                                              ),
                                                              if (queOpenList[
                                                                  index]) ...[
                                                                Row(
                                                                  children: [
                                                                    iconTextValue(
                                                                        icChildrenEducation,
                                                                        colorGreenEFC,
                                                                        'Children Fees',
                                                                        childrenEducationYearly
                                                                            .toString(),
                                                                        () {
                                                                      textEditingController
                                                                          .text = childrenEducationYearly ==
                                                                              0
                                                                          ? ''
                                                                          : childrenEducationYearly
                                                                              .toString();

                                                                      newSelectFormDialog(
                                                                          'Children Fees',
                                                                          icChildrenEducation);
                                                                    }),
                                                                    Container(
                                                                        height:
                                                                            9.h,
                                                                        width:
                                                                            1,
                                                                        color: colorTextBCBC
                                                                            .withOpacity(0.36)),
                                                                  ],
                                                                ),
                                                              ]
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : index == 3
                                                  ?
                                                  // LOAN
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 2.h),
                                                      child: Container(
                                                        width: 90.w,
                                                        decoration: decoration(
                                                            colorWhite),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 2.h,
                                                                      bottom:
                                                                          2.h,
                                                                      left: 3.5
                                                                          .w),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text('LOAN',
                                                                      style: textStyle10Bold(
                                                                              colorBlack)
                                                                          .copyWith(
                                                                              letterSpacing: 0.7)),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right: 5
                                                                            .w),
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          setState(
                                                                              () {
                                                                            queOpenList[index] =
                                                                                !queOpenList[index];
                                                                          });
                                                                        },
                                                                        child: Icon(
                                                                          queOpenList[index]
                                                                              ? Icons.keyboard_arrow_up_rounded
                                                                              : Icons.keyboard_arrow_down_outlined,
                                                                          size:
                                                                              2.7.h,
                                                                          opticalSize:
                                                                              25.h,
                                                                          color:
                                                                              colorBlack,
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 1,
                                                                color: colorTextBCBC
                                                                    .withOpacity(
                                                                        0.36)),
                                                            AnimatedContainer(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          00),
                                                              curve: Curves
                                                                  .easeInOut,
                                                              height:
                                                                  !queOpenList[
                                                                          index]
                                                                      ? 9.h
                                                                      : 27.h,
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      iconTextValue(
                                                                          icHousingLoan,
                                                                          colorGreenEFC,
                                                                          'Housing',
                                                                          housingLoan
                                                                              .toString(),
                                                                          () {
                                                                        textEditingController
                                                                            .text = housingLoan ==
                                                                                0
                                                                            ? ''
                                                                            : housingLoan.toString();

                                                                        newSelectFormDialog(
                                                                            'Housing',
                                                                            icHousingLoan);
                                                                      }),
                                                                      Container(
                                                                          height: 9
                                                                              .h,
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              colorTextBCBC.withOpacity(0.36)),
                                                                      iconTextValue(
                                                                          icVehicalLoan,
                                                                          colorGreenEFC,
                                                                          'Vehicle',
                                                                          vehicleLoan
                                                                              .toString(),
                                                                          () {
                                                                        textEditingController
                                                                            .text = vehicleLoan ==
                                                                                0
                                                                            ? ''
                                                                            : vehicleLoan.toString();
                                                                        newSelectFormDialog(
                                                                          'Vehicle Loan',
                                                                          icVehicalLoan,
                                                                        );
                                                                      })
                                                                    ],
                                                                  ),
                                                                  if (queOpenList[
                                                                      index]) ...[
                                                                    Row(
                                                                      children: [
                                                                        iconTextValue(
                                                                            icEducationLoan,
                                                                            colorGreenEFC,
                                                                            'Education',
                                                                            educationLoan.toString(),
                                                                            () {
                                                                          textEditingController
                                                                              .text = educationLoan ==
                                                                                  0
                                                                              ? ''
                                                                              : educationLoan.toString();

                                                                          newSelectFormDialog(
                                                                              'Education',
                                                                              icEducationLoan);
                                                                        }),
                                                                        Container(
                                                                            height: 9
                                                                                .h,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                colorTextBCBC.withOpacity(0.36)),
                                                                        iconTextValue(
                                                                            icPersonalLoan,
                                                                            colorGreenEFC,
                                                                            'Personal',
                                                                            personalLoan.toString(),
                                                                            () {
                                                                          textEditingController
                                                                              .text = personalLoan ==
                                                                                  0
                                                                              ? ''
                                                                              : personalLoan.toString();
                                                                          newSelectFormDialog(
                                                                              'Personal',
                                                                              icPersonalLoan);
                                                                        })
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        iconTextValue(
                                                                            icMortgageLoan,
                                                                            colorGreenEFC,
                                                                            'Mortgage',
                                                                            mortgageLoan.toString(),
                                                                            () {
                                                                          textEditingController
                                                                              .text = mortgageLoan ==
                                                                                  0
                                                                              ? ''
                                                                              : mortgageLoan.toString();

                                                                          newSelectFormDialog(
                                                                              'Mortgage',
                                                                              icMortgageLoan);
                                                                        }),
                                                                        Container(
                                                                            height: 9
                                                                                .h,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                colorTextBCBC.withOpacity(0.36)),
                                                                        iconTextValue(
                                                                            icOtherLoan,
                                                                            colorGreenEFC,
                                                                            'Other',
                                                                            otherLoan.toString(),
                                                                            () {
                                                                          textEditingController
                                                                              .text = otherLoan ==
                                                                                  0
                                                                              ? ''
                                                                              : otherLoan.toString();

                                                                          newSelectFormDialog(
                                                                              'Other Loan',
                                                                              icOtherLoan);
                                                                        }),
                                                                      ],
                                                                    ),
                                                                  ]
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : index == 4
                                                      ?
                                                      // INSURANCE COVER
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h),
                                                          child: Container(
                                                            width: 90.w,
                                                            decoration:
                                                                decoration(
                                                                    colorWhite),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 2.h,
                                                                      bottom:
                                                                          2.h,
                                                                      left: 3.5
                                                                          .w),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          'INSURANCE COVER',
                                                                          style:
                                                                              textStyle10Bold(colorBlack).copyWith(letterSpacing: 0.7)),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 5.w),
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                queOpenList[index] = !queOpenList[index];
                                                                              });
                                                                            },
                                                                            child: Icon(
                                                                              queOpenList[index] ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_outlined,
                                                                              size: 2.7.h,
                                                                              opticalSize: 25.h,
                                                                              color: colorBlack,
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    height: 1,
                                                                    color: colorTextBCBC
                                                                        .withOpacity(
                                                                            0.36)),
                                                                AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          00),
                                                                  curve: Curves
                                                                      .easeInOut,
                                                                  height: !queOpenList[
                                                                          index]
                                                                      ? 9.h
                                                                      : 27.h,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          iconTextValue(
                                                                              icTermInsurance,
                                                                              colorGreenEFC,
                                                                              'Term',
                                                                              termInsurance.toString(),
                                                                              () {
                                                                            textEditingController.text = termInsurance == 0
                                                                                ? ''
                                                                                : termInsurance.toString();

                                                                            newSelectFormDialog('Term',
                                                                                icTermInsurance);
                                                                          }),
                                                                          Container(
                                                                              height: 9.h,
                                                                              width: 1,
                                                                              color: colorTextBCBC.withOpacity(0.36)),
                                                                          iconTextValue(
                                                                              icVehicleInsurance,
                                                                              colorGreenEFC,
                                                                              'Vehicle',
                                                                              vehicleInsurance.toString(),
                                                                              () {
                                                                            textEditingController.text = vehicleInsurance == 0
                                                                                ? ''
                                                                                : vehicleInsurance.toString();
                                                                            newSelectFormDialog('Vehicle Insurance',
                                                                                icVehicleInsurance);
                                                                          })
                                                                        ],
                                                                      ),
                                                                      if (queOpenList[
                                                                          index]) ...[
                                                                        Row(
                                                                          children: [
                                                                            iconTextValue(
                                                                                icTraditionalInsurance,
                                                                                colorGreenEFC,
                                                                                'Traditional',
                                                                                traditionalInsurance.toString(),
                                                                                () {
                                                                              textEditingController.text = traditionalInsurance == 0 ? '' : traditionalInsurance.toString();
                                                                              newSelectFormDialog('Traditional', icTraditionalInsurance);
                                                                            }),
                                                                            Container(
                                                                                height: 9.h,
                                                                                width: 1,
                                                                                color: colorTextBCBC.withOpacity(0.36)),
                                                                            iconTextValue(
                                                                                icUlip,
                                                                                colorGreenEFC,
                                                                                'ULIP',
                                                                                uLIP.toString(),
                                                                                () {
                                                                              textEditingController.text = uLIP == 0 ? '' : uLIP.toString();
                                                                              newSelectFormDialog('ULIP', icUlip);
                                                                            })
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            iconTextValue(
                                                                                icHealthInsurance,
                                                                                colorGreenEFC,
                                                                                'Health',
                                                                                healthInsurance.toString(),
                                                                                () {
                                                                              textEditingController.text = healthInsurance == 0 ? '' : healthInsurance.toString();
                                                                              newSelectFormDialog('Health', icHealthInsurance);
                                                                            }),
                                                                            Container(
                                                                                height: 9.h,
                                                                                width: 1,
                                                                                color: colorTextBCBC.withOpacity(0.36)),
                                                                            iconTextValue(
                                                                                icOtherInsurance,
                                                                                colorGreenEFC,
                                                                                'Other',
                                                                                otherInsurance.toString(),
                                                                                () {
                                                                              textEditingController.text = otherInsurance == 0 ? '' : otherInsurance.toString();
                                                                              newSelectFormDialog('Other Insurance', icUlip);
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
                                                        )
                                                      :
                                                      //  ASSETS
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h),
                                                          child: Container(
                                                            width: 90.w,
                                                            decoration:
                                                                decoration(
                                                                    colorWhite),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 2.h,
                                                                      bottom:
                                                                          2.h,
                                                                      left: 3.5
                                                                          .w),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          'ASSETS',
                                                                          style:
                                                                              textStyle10Bold(colorBlack).copyWith(letterSpacing: 0.7)),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 5.w),
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                queOpenList[index] = !queOpenList[index];
                                                                              });
                                                                            },
                                                                            child: Icon(
                                                                              queOpenList[index] ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_outlined,
                                                                              size: 2.7.h,
                                                                              opticalSize: 25.h,
                                                                              color: colorBlack,
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    height: 1,
                                                                    color: colorTextBCBC
                                                                        .withOpacity(
                                                                            0.36)),
                                                                AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          00),
                                                                  curve: Curves
                                                                      .easeInOut,
                                                                  height: !queOpenList[
                                                                          index]
                                                                      ? 9.h
                                                                      : 18.h,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          iconTextValue(
                                                                              icVehical,
                                                                              colorGreenEFC,
                                                                              'Vehicle',
                                                                              vehicle.toString(),
                                                                              () {
                                                                            textEditingController.text = vehicle == 0
                                                                                ? ''
                                                                                : vehicle.toString();

                                                                            newSelectFormDialog('Vehicle',
                                                                                icVehical);
                                                                          }),
                                                                          Container(
                                                                              height: 9.h,
                                                                              width: 1,
                                                                              color: colorTextBCBC.withOpacity(0.36)),
                                                                          iconTextValue(
                                                                              icGold,
                                                                              colorGreenEFC,
                                                                              'Gold',
                                                                              gold.toString(),
                                                                              () {
                                                                            textEditingController.text = gold == 0
                                                                                ? ''
                                                                                : gold.toString();
                                                                            newSelectFormDialog('Gold',
                                                                                icGold);
                                                                          })
                                                                        ],
                                                                      ),
                                                                      if (queOpenList[
                                                                          index]) ...[
                                                                        Row(
                                                                          children: [
                                                                            iconTextValue(
                                                                                icEmergencyFunds,
                                                                                colorGreenEFC,
                                                                                'Emergency Funds',
                                                                                emergencyFunds.toString(),
                                                                                () {
                                                                              textEditingController.text = emergencyFunds == 0 ? '' : emergencyFunds.toString();
                                                                              newSelectFormDialog('Emergency Funds', icEmergencyFunds);
                                                                            }),
                                                                            Container(
                                                                                height: 9.h,
                                                                                width: 1,
                                                                                color: colorTextBCBC.withOpacity(0.36)),
                                                                            iconTextValue(
                                                                                icOtherAssets,
                                                                                colorGreenEFC,
                                                                                'Other',
                                                                                otherAsset.toString(),
                                                                                () {
                                                                              textEditingController.text = otherAsset == 0 ? '' : otherAsset.toString();
                                                                              newSelectFormDialog('Other Asset', icOtherAssets);
                                                                            })
                                                                          ],
                                                                        ),
                                                                      ]
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ))),
                            ),
                          ),
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
      int value1,
      String icon2,
      String text2,
      int value2,
      String icon3,
      String text3,
      int value3,
      String icon4,
      String text4,
      int value4,
      String icon5,
      String text5,
      int value5,
      String icon6,
      String text6,
      int value6,
      Color bgColor,
      Function() onOpen) {
    return Container(
      width: 90.w,
      decoration: decoration(colorWhite),
      child: BlocListener<MFInvestmentsBloc, MFInvestmentsState>(
        listener: (context, state) {
          if (state is MFInvestmentsLoadedState) {
            mutualFundsApiData = 0;
            mutualFundsApiData = state.investmentPortfolio.totalAmount.toInt();
            setState(() {});
          }
        },
        child: BlocListener<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is StockInvestmentLoadedState) {
              stocksApiData = 0;

              for (int i = 0;
                  i < state.stockInvestmentPortfolio.stocks.length;
                  i++) {
                stocksApiData +=
                    ((state.stockInvestmentPortfolio.stocks[i].balanceQty) *
                            state.stockInvestmentPortfolio.stocks[i].rate)
                        .toInt();
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
                            size: 2.7.h,
                            opticalSize: 25.h,
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        iconTextValue(icon1, bgColor, text1, value1.toString(),
                            () async {
                          final pref = await SharedPreferences.getInstance();

                          if (text1 == 'Stocks') {
                            textEditingController.text =
                                pref.getInt('stocksValue').toString() == '0'
                                    ? ''
                                    : pref.getInt('stocksValue').toString();
                          } else if (text1 == 'Business') {
                            textEditingController.text =
                                pref.getInt('business').toString() == '0'
                                    ? ''
                                    : pref.getInt('business').toString();
                          } else if (text1 == 'HousingLoan') {
                            textEditingController.text =
                                pref.getInt('housingLoan').toString() == 'null'
                                    ? ''
                                    : pref.getInt('housingLoan').toString();
                          } else if (text1 == 'HealthInsurance') {
                            textEditingController.text =
                                pref.getInt('healthInsurance').toString() ==
                                        'null'
                                    ? ''
                                    : pref.getInt('healthInsurance').toString();
                          } else if (text1 == 'Gold') {
                            textEditingController.text =
                                pref.getInt('gold').toString() == 'null'
                                    ? ''
                                    : pref.getInt('gold').toString();
                          }
                          newSelectFormDialog(text1, icon1);
                        }),
                        Container(
                            height: 9.h,
                            width: 1,
                            color: colorTextBCBC.withOpacity(0.36)),
                        iconTextValue(icon2, bgColor, text2, value2.toString(),
                            () async {
                          final pref = await SharedPreferences.getInstance();
                          if (text2 == 'Mutual Funds') {
                            textEditingController.text = pref
                                        .getInt('mutualFundsValue')
                                        .toString() ==
                                    'null'
                                ? ''
                                : pref.getInt('mutualFundsValue').toString();
                          } else if (text2 == 'Salary') {
                            textEditingController.text =
                                pref.getInt('salary').toString() == 'null'
                                    ? ''
                                    : pref.getInt('salary').toString();
                          } else if (text2 == 'VehicleLoan') {
                            textEditingController.text =
                                pref.getInt('vehicleLoan').toString() == 'null'
                                    ? ''
                                    : pref.getInt('vehicleLoan').toString();
                          } else if (text2 == 'VehicleInsurance') {
                            textEditingController.text = pref
                                        .getInt('vehicleInsurance')
                                        .toString() ==
                                    'null'
                                ? ''
                                : pref.getInt('vehicleInsurance').toString();
                          } else if (text2 == 'Cash') {
                            textEditingController.text =
                                pref.getInt('cash').toString() == 'null'
                                    ? ''
                                    : pref.getInt('cash').toString();
                          }
                          newSelectFormDialog(text2, icon2);
                        })
                      ],
                    ),
                    if (isSelect) ...[
                      Row(
                        children: [
                          iconTextValue(
                              icon3, bgColor, text3, value3.toString(),
                              () async {
                            final pref = await SharedPreferences.getInstance();

                            if (text3 == 'SIPMonthly') {
                              textEditingController.text =
                                  pref.getInt('sIPMonthly').toString() == 'null'
                                      ? ''
                                      : pref.getInt('sIPMonthly').toString();
                            } else if (text3 == 'Professional') {
                              textEditingController.text =
                                  pref.getInt('professional').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('professional').toString();
                            } else if (text3 == 'EducationLoan') {
                              textEditingController.text =
                                  pref.getInt('educationLoan').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('educationLoan').toString();
                            } else if (text3 == 'TermInsurance') {
                              textEditingController.text =
                                  pref.getInt('termInsurance').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('termInsurance').toString();
                            } else if (text3 == 'RealEstate') {
                              textEditingController.text =
                                  pref.getInt('realEstate').toString() == 'null'
                                      ? ''
                                      : pref.getInt('realEstate').toString();
                            }
                            newSelectFormDialog(text3, icon3);
                          }),
                          Container(
                              height: 9.h,
                              width: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          iconTextValue(
                              icon4, bgColor, text4, value4.toString(),
                              () async {
                            final pref = await SharedPreferences.getInstance();

                            if (text4 == 'PPFMonthly') {
                              textEditingController.text =
                                  pref.getInt('pPFMonthly').toString() == 'null'
                                      ? ''
                                      : pref.getInt('pPFMonthly').toString();
                            } else if (text4 == 'SpouseIncome') {
                              textEditingController.text =
                                  pref.getInt('spouseIncome').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('spouseIncome').toString();
                            } else if (text4 == 'PersonalLoan') {
                              textEditingController.text =
                                  pref.getInt('personalLoan').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('personalLoan').toString();
                            } else if (text4 == 'TraditionalInsurance') {
                              textEditingController.text = pref
                                          .getInt('traditionalInsurance')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref
                                      .getInt('traditionalInsurance')
                                      .toString();
                            } else if (text4 == 'Vehicle') {
                              textEditingController.text =
                                  pref.getInt('vehicle').toString() == 'null'
                                      ? ''
                                      : pref.getInt('vehicle').toString();
                            }
                            newSelectFormDialog(text4, icon4);
                          })
                        ],
                      ),
                      Row(
                        children: [
                          iconTextValue(
                              icon5, bgColor, text5, value5.toString(),
                              () async {
                            final pref = await SharedPreferences.getInstance();

                            if (text5 == 'PostOfficeOrVikas..') {
                              textEditingController.text = pref
                                          .getInt('postOfficeOrVikasPatra')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref
                                      .getInt('postOfficeOrVikasPatra')
                                      .toString();
                            } else if (text5 == 'OtherIncome') {
                              textEditingController.text =
                                  pref.getInt('otherIncome').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('otherIncome').toString();
                            } else if (text5 == 'OtherLoan') {
                              textEditingController.text =
                                  pref.getInt('otherLoan').toString() == 'null'
                                      ? ''
                                      : pref.getInt('otherLoan').toString();
                            } else if (text5 == 'OtherInsurance') {
                              textEditingController.text = pref
                                          .getInt('otherInsurance')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref.getInt('otherInsurance').toString();
                            } else if (text5 == 'OtherAsset') {
                              textEditingController.text =
                                  pref.getInt('otherAsset').toString() == 'null'
                                      ? ''
                                      : pref.getInt('otherAsset').toString();
                            }
                            newSelectFormDialog(text5, icon5);
                          }),
                          Container(
                              height: 9.h,
                              width: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          iconTextValue(
                              icon6, bgColor, text6, value6.toString(),
                              () async {
                            final pref = await SharedPreferences.getInstance();

                            if (text6 == 'PrivateInvestment..') {
                              textEditingController.text = pref
                                          .getInt('privateInvestmentScheme')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref
                                      .getInt('privateInvestmentScheme')
                                      .toString();
                            } else if (text6 == 'HouseHoldMonthly') {
                              textEditingController.text = pref
                                          .getInt('houseHoldMonthly')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref.getInt('houseHoldMonthly').toString();
                            } else if (text6 == 'MortgageLoan') {
                              textEditingController.text =
                                  pref.getInt('mortgageLoan').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('mortgageLoan').toString();
                            } else if (text6 == 'ULIP') {
                              textEditingController.text =
                                  pref.getInt('uLIP').toString() == 'null'
                                      ? ''
                                      : pref.getInt('uLIP').toString();
                            } else if (text6 == 'FixedDeposite') {
                              textEditingController.text =
                                  pref.getInt('fixedDeposite').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('fixedDeposite').toString();
                            }
                            newSelectFormDialog(text6, icon6);
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

  newSelectFormDialog(String lable, String icon) {
    isCheckedStocks = false;
    isCheckedMutualFunds = false;
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
                                  if (lable == 'Stocks' ||
                                      lable == 'Mutual Funds') ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                            value: lable == 'Stocks'
                                                ? isCheckedStocks
                                                : isCheckedMutualFunds,
                                            focusColor: colorWhite,
                                            activeColor: colorRedFFC,
                                            checkColor: colorRed,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            side: const BorderSide(
                                                color: colorDFDF),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            onChanged: (val) {
                                              setState(() {
                                                if (lable == 'Stocks') {
                                                  isCheckedStocks =
                                                      !isCheckedStocks;
                                                  if (isCheckedStocks == true) {
                                                    textEditingController.text =
                                                        stocksApiData
                                                            .toString();
                                                  }
                                                } else {
                                                  isCheckedMutualFunds =
                                                      !isCheckedMutualFunds;
                                                  if (isCheckedMutualFunds ==
                                                      true) {
                                                    textEditingController.text =
                                                        mutualFundsApiData
                                                            .toString();
                                                  }
                                                }
                                              });
                                            }),
                                        Text(
                                          'Fetch my investment details',
                                          style: textStyle12(colorText7070),
                                        )
                                      ],
                                    ),
                                  ],
                                  SizedBox(
                                    height: lable == 'Stocks' ||
                                            lable == 'Mutual Funds'
                                        ? 0.h
                                        : 2.h,
                                  ),
                                  cTextFormField(
                                    'Enter $lable',
                                    (values) {},
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                    splashColor: colorWhite,
                                    onTap: () async {
                                      int value = textEditingController
                                              .text.isNotEmpty
                                          ? int.parse(textEditingController.text
                                              .replaceAll(',', ''))
                                          : 0;
                                      final pref =
                                          await SharedPreferences.getInstance();
                                      if (lable == 'Stocks') {
                                        stocksValue = value;
                                        await pref.setInt(
                                            'stocksValue', stocksValue);
                                      } else if (lable == 'Mutual Funds') {
                                        mutualFundsValue = value;
                                        await pref.setInt(
                                            'mutualFundsValue', value);
                                      } else if (lable == 'PPF Monthly') {
                                        pPFMonthly = value;
                                        await pref.setInt(
                                            'pPFMonthly', pPFMonthly);
                                      } else if (lable == 'Debenture') {
                                        debenture = value;
                                        await pref.setInt(
                                            'debenture', debenture);
                                      } else if (lable == 'Fixed Deposite') {
                                        fixedDeposite = value;
                                        await pref.setInt(
                                            'fixedDeposite', fixedDeposite);
                                      } else if (lable == 'Business') {
                                        business = value;
                                        await pref.setInt('business', business);
                                      } else if (lable == 'Salary') {
                                        salary = value;
                                        await pref.setInt('salary', salary);
                                      } else if (lable == 'Spouse') {
                                        spouseIncome = value;
                                        await pref.setInt(
                                            'spouseIncome', spouseIncome);
                                      } else if (lable == 'Other Income') {
                                        otherIncome = value;
                                        await pref.setInt(
                                            'otherIncome', otherIncome);
                                      } else if (lable == 'HouseHold') {
                                        houseHoldMonthly = value;
                                        await pref.setInt('houseHoldMonthly',
                                            houseHoldMonthly);
                                      } else if (lable == 'EMI') {
                                        totalMonthlyEmi = value;
                                        await pref.setInt(
                                            'totalMonthlyEmi', totalMonthlyEmi);
                                      } else if (lable == 'Children Fees') {
                                        childrenEducationYearly = value;
                                        await pref.setInt(
                                            'childrenEducationYearly',
                                            childrenEducationYearly);
                                      } else if (lable == 'FixedDeposite') {
                                        fixedDeposite = value;
                                        await pref.setInt(
                                            'fixedDeposite', fixedDeposite);
                                      } else if (lable == 'Housing') {
                                        housingLoan = value;
                                        await pref.setInt(
                                            'housingLoan', housingLoan);
                                      } else if (lable == 'Vehicle Loan') {
                                        vehicleLoan = value;
                                        await pref.setInt(
                                            'vehicleLoan', vehicleLoan);
                                      } else if (lable == 'Education') {
                                        educationLoan = value;
                                        await pref.setInt(
                                            'educationLoan', educationLoan);
                                      } else if (lable == 'Personal') {
                                        personalLoan = value;
                                        await pref.setInt(
                                            'personalLoan', personalLoan);
                                      } else if (lable == 'Mortgage') {
                                        mortgageLoan = value;
                                        await pref.setInt(
                                            'mortgageLoan', mortgageLoan);
                                      } else if (lable == 'Other Loan') {
                                        otherLoan = value;
                                        await pref.setInt(
                                            'otherLoan', otherLoan);
                                      } else if (lable == 'Term') {
                                        termInsurance = value;
                                        await pref.setInt(
                                            'termInsurance', termInsurance);
                                      } else if (lable == 'Vehicle Insurance') {
                                        vehicleInsurance = value;
                                        await pref.setInt('vehicleInsurance',
                                            vehicleInsurance);
                                      } else if (lable == 'Traditional') {
                                        traditionalInsurance = value;
                                        await pref.setInt(
                                            'traditionalInsurance',
                                            traditionalInsurance);
                                      } else if (lable == 'ULIP') {
                                        uLIP = value;
                                        await pref.setInt('uLIP', uLIP);
                                      } else if (lable == 'Health') {
                                        healthInsurance = value;
                                        await pref.setInt(
                                            'healthInsurance', healthInsurance);
                                      } else if (lable == 'Other Insurance') {
                                        otherInsurance = value;
                                        await pref.setInt(
                                            'otherInsurance', otherInsurance);
                                      } else if (lable == 'Vehicle') {
                                        vehicle = value;
                                        await pref.setInt('vehicle', vehicle);
                                      } else if (lable == 'Gold') {
                                        gold = value;
                                        await pref.setInt('gold', gold);
                                      } else if (lable == 'Emergency Funds') {
                                        emergencyFunds = value;
                                        await pref.setInt(
                                            'emergencyFunds', emergencyFunds);
                                      } else if (lable == 'Other Asset') {
                                        otherAsset = value;
                                        await pref.setInt(
                                            'otherAsset', otherAsset);
                                      }

                                      wealthMeter();
                                      Navigator.of(context).pop();
                                      checkWealthScoreDialogBox();
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
    return text == 'Business'
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
                      child: Image.asset(icon, height: 3.5.h),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(text,
                                overflow: TextOverflow.fade,
                                style: textStyle9(colorText3D3D)),
                            if (text == 'Business') ...[
                              SizedBox(
                                width: 1.w,
                              ),
                              Image.asset(business == 0 ? icWarning : icCheck,
                                  height: 1.5.h)
                            ]
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                            value.length == 6
                                ? '₹${value.substring(0, 1)}.${value.substring(1, 2)} L'
                                : value.length == 7
                                    ? '₹${value.substring(0, 2)}.${value.substring(2, 3)} L'
                                    : value.length == 8
                                        ? '₹${value.substring(0, 1)}.${value.substring(1, 2)} Cr'
                                        : value.length == 9
                                            ? '₹${value.substring(0, 2)}.${value.substring(2, 3)} Cr'
                                            : value.length == 10
                                                ? '₹${value.substring(0, 3)}.${value.substring(3, 4)} Cr'
                                                : '₹ ${CommonFunction().splitString(value)}',
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
                    child: Image.asset(icon, height: 3.5.h),
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(text,
                              overflow: TextOverflow.fade,
                              style: textStyle9(colorText3D3D)),
                          if (text == 'Salary') ...[
                            SizedBox(
                              width: 1.w,
                            ),
                            Image.asset(salary == 0 ? icWarning : icCheck,
                                height: 1.5.h)
                          ] else if (text == 'HouseHold') ...[
                            SizedBox(
                              width: 1.w,
                            ),
                            Image.asset(
                                houseHoldMonthly == 0 ? icWarning : icCheck,
                                height: 1.5.h)
                          ]
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                          value.length == 6
                              ? '₹${value.substring(0, 1)}.${value.substring(1, 2)} L'
                              : value.length == 7
                                  ? '₹${value.substring(0, 2)}.${value.substring(2, 3)} L'
                                  : value.length == 8
                                      ? '₹${value.substring(0, 1)}.${value.substring(1, 2)} Cr'
                                      : value.length == 9
                                          ? '₹${value.substring(0, 2)}.${value.substring(2, 3)} Cr'
                                          : value.length == 10
                                              ? '₹${value.substring(0, 3)}.${value.substring(3, 4)} Cr'
                                              : '₹ ${CommonFunction().splitString(value)}',
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
        userId: int.parse(ApiUser.userId),
        name: ApiUser.userName,
        dob: userDoB,
        age: userAge,
        interestRate: interestRate,
        business: business,
        salary: salary,
        professional: 0,
        spouseIncome: spouseIncome,
        otherIncome: otherIncome,
        houseHoldMonthly: houseHoldMonthly,
        totalMonthlyEmi: totalMonthlyEmi,
        totalInsurancePremiumYearly: 0,
        childrenEducationYearly: childrenEducationYearly,
        otherExpenseYearly: 0,
        vehicle: vehicle,
        gold: gold,
        savingAccount: 0,
        cash: 0,
        emergencyFunds: emergencyFunds,
        otherAsset: otherAsset,
        mutualFunds: mutualFundsValue,
        pPF: 0,
        sIPMonthly: 0,
        pPFMonthly: pPFMonthly,
        debenture: debenture,
        fixedDeposite: fixedDeposite,
        stockPortfolio: stocksValue,
        guided: 0,
        unguided: 0,
        postOfficeOrVikasPatra: 0,
        pMS: 0,
        privateInvestmentScheme: 0,
        realEstate: 0,
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
        overdraft: 0,
        otherLoan: otherLoan));
  }

  cTextFormField(
    String hintText,
    ValueChanged<String> onChanged,
  ) {
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
          controller: textEditingController,
          autofocus: true,
          style: textStyle12(colorText7070),
          inputFormatters: [
            IndianNumberInputFormatter(),
            // ThousandsSeparatorInputFormatter(),
            LengthLimitingTextInputFormatter(13),
          ],
          decoration: InputDecoration.collapsed(
            hintText: hintText,
            hintStyle: textStyle12(colorText7070),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          // textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}

class IndianNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formattedText = _formatIndianNumber(cleanText);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedText.length),
      ),
    );
  }

  String _formatIndianNumber(String text) {
    return text.length >= 10
        ? '${text.substring(0, 3)},${text.substring(3, 5)},${text.substring(5, 7)},${text.substring(7)}'
        : text.length == 9
            ? '${text.substring(0, 2)},${text.substring(2, 4)},${text.substring(4, 6)},${text.substring(6)}'
            : text.length == 8
                ? '${text.substring(0, 1)},${text.substring(1, 3)},${text.substring(3, 5)},${text.substring(5)}'
                : text.length == 7
                    ? '${text.substring(0, 2)},${text.substring(2, 4)},${text.substring(4)}'
                    : text.length == 6
                        ? '${text.substring(0, 1)},${text.substring(1, 3)},${text.substring(3)}'
                        : text.length == 5
                            ? '${text.substring(0, 2)},${text.substring(2)}'
                            : text.length == 4
                                ? '${text.substring(0, 1)},${text.substring(1)}'
                                : text;
  }
}
