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
    getWealthData();
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

  List<bool> queOpenList = [
    false,
    false,
    false,
    false,
    false,
  ];
  TextEditingController textEditingController = TextEditingController();

  getWealthData() async {
    final pref = await SharedPreferences.getInstance();

    sIPMonthly = pref.getInt('sIPMonthly') ?? 0;
    pPFMonthly = pref.getInt('pPFMonthly') ?? 0;
    postOfficeOrVikasPatra = pref.getInt('postOfficeOrVikasPatra') ?? 0;
    privateInvestmentScheme = pref.getInt('privateInvestmentScheme') ?? 0;
    business = pref.getInt('business') ?? 0;
    salary = pref.getInt('salary') ?? 1;
    professional = pref.getInt('professional') ?? 0;
    spouseIncome = pref.getInt('spouseIncome') ?? 0;
    otherIncome = pref.getInt('otherIncome') ?? 0;
    houseHoldMonthly = pref.getInt('houseHoldMonthly') ?? 0;
    housingLoan = pref.getInt('housingLoan') ?? 0;
    vehicleLoan = pref.getInt('vehicleLoan') ?? 0;
    educationLoan = pref.getInt('educationLoan') ?? 0;
    personalLoan = pref.getInt('personalLoan') ?? 0;
    otherLoan = pref.getInt('otherLoan') ?? 0;
    mortgageLoan = pref.getInt('mortgageLoan') ?? 0;
    healthInsurance = pref.getInt('healthInsurance') ?? 0;
    vehicleInsurance = pref.getInt('vehicleInsurance') ?? 0;
    termInsurance = pref.getInt('termInsurance') ?? 0;
    traditionalInsurance = pref.getInt('traditionalInsurance') ?? 0;
    otherInsurance = pref.getInt('otherInsurance') ?? 0;
    uLIP = pref.getInt('uLIP') ?? 0;
    gold = pref.getInt('gold') ?? 0;
    cash = pref.getInt('cash') ?? 0;
    realEstate = pref.getInt('realEstate') ?? 0;
    vehicle = pref.getInt('vehicle') ?? 0;
    otherAsset = pref.getInt('otherAsset') ?? 0;
    fixedDeposite = pref.getInt('fixedDeposite') ?? 0;
    wealthMeter();
  }

  // User Details
  String userDoB = '';
  int userAge = 0;
  double interestRate = 7;
  int overdraft = 0;

  // Investments
  int stocksValue = 0;
  int mutualFundsValue = 0;
  int sIPMonthly = 0;
  int pPFMonthly = 0;
  int postOfficeOrVikasPatra = 0;
  int privateInvestmentScheme = 0;

  // INCOME & EXPENSE
  int business = 0;
  int salary = 1;
  int professional = 0;
  int spouseIncome = 0;
  int otherIncome = 0;
  int houseHoldMonthly = 0;

  // Loan
  int housingLoan = 0;
  int vehicleLoan = 0;
  int educationLoan = 0;
  int personalLoan = 0;
  int otherLoan = 0;
  int mortgageLoan = 0;

  // Insurance
  int healthInsurance = 0;
  int vehicleInsurance = 0;
  int termInsurance = 0;
  int traditionalInsurance = 0;
  int otherInsurance = 0;
  int uLIP = 0;

  // Assets
  int gold = 0;
  int cash = 0;
  int realEstate = 0;
  int vehicle = 0;
  int otherAsset = 0;
  int fixedDeposite = 0;
//

  int emergencyFunds = 0;
  int pPF = 0;
  int savingAccount = 0;
  int guided = 0;
  int unguided = 0;
  int totalMonthlyEmi = 0;
  int totalInsurancePremiumYearly = 0;
  int childrenEducationYearly = 0;
  int otherExpenseYearly = 0;
  int debenture = 0;
  int pMS = 0;

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
                                          stocksValue,
                                          icMutualFunds,
                                          'Mutual Funds',
                                          mutualFundsValue,
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
            mutualFundsValue = 0;
            for (int i = 0;
                i < state.investmentPortfolio.mFStocks.length;
                i++) {
              if (state.investmentPortfolio.mFStocks[i].unit.toInt() != 0) {
                mutualFundsValue += ((state.investmentPortfolio.mFStocks[i]
                                .investment_Unit -
                            state.investmentPortfolio.mFStocks[i].sale_Unit) *
                        state.investmentPortfolio.mFStocks[i].nav)
                    .toInt();
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
                                .pushNamed(StocksInvestment.route);
                          } else {
                            final pref = await SharedPreferences.getInstance();
                            if (text1 == 'Business') {
                              textEditingController.text =
                                  pref.getInt('business').toString() == 'null'
                                      ? ''
                                      : pref.getInt('business').toString();
                            } else if (text1 == 'HousingLoan') {
                              textEditingController.text =
                                  pref.getInt('housingLoan').toString() ==
                                          'null'
                                      ? ''
                                      : pref.getInt('housingLoan').toString();
                            } else if (text1 == 'HealthInsurance') {
                              textEditingController.text = pref
                                          .getInt('healthInsurance')
                                          .toString() ==
                                      'null'
                                  ? ''
                                  : pref.getInt('healthInsurance').toString();
                            } else if (text1 == 'Gold') {
                              textEditingController.text =
                                  pref.getInt('gold').toString() == 'null'
                                      ? ''
                                      : pref.getInt('gold').toString();
                            }
                            newSelectFormDialog(mainTitle, text1, icon1);
                          }
                        }),
                        Container(
                            height: 9.h,
                            width: 1,
                            color: colorTextBCBC.withOpacity(0.36)),
                        iconTextValue(icon2, bgColor, text2, value2.toString(),
                            () async {
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
                            Navigator.of(context)
                                .pushNamed(MutualFundsInvestment.route);
                          } else {
                            final pref = await SharedPreferences.getInstance();

                            if (text2 == 'Salary') {
                              textEditingController.text =
                                  pref.getInt('salary').toString() == 'null'
                                      ? ''
                                      : pref.getInt('salary').toString();
                            } else if (text2 == 'VehicleLoan') {
                              textEditingController.text =
                                  pref.getInt('vehicleLoan').toString() ==
                                          'null'
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
                            newSelectFormDialog(mainTitle, text2, icon2);
                          }
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
                            newSelectFormDialog(mainTitle, text3, icon3);
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
                            newSelectFormDialog(mainTitle, text4, icon4);
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
                            newSelectFormDialog(mainTitle, text5, icon5);
                          }),
                          Container(
                              height: 9.h,
                              width: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          iconTextValue(
                              icon6, bgColor, text6, value6.toString(),
                              () async {
                            final pref = await SharedPreferences.getInstance();

                            if (text6 == 'PrivateInvestmentScheme..') {
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
                                  cTextFormField(
                                    'Enter $lable',
                                    (values) {
                                      int value =
                                          int.parse(values.replaceAll(',', ''));
                                      if (lable == 'SIPMonthly') {
                                        sIPMonthly = value;
                                      } else if (lable == 'PPFMonthly') {
                                        pPFMonthly = value;
                                      } else if (lable ==
                                          'PostOfficeOrVikas..') {
                                        postOfficeOrVikasPatra = value;
                                      } else if (lable ==
                                          'PrivateInvestment..') {
                                        privateInvestmentScheme = value;
                                      } else if (lable == 'Business') {
                                        business = value;
                                      } else if (lable == 'Salary') {
                                        salary = value;
                                      } else if (lable == 'Professional') {
                                        professional = value;
                                      } else if (lable == 'SpouseIncome') {
                                        spouseIncome = value;
                                      } else if (lable == 'OtherIncome') {
                                        otherIncome = value;
                                      } else if (lable == 'HouseHoldMonthly') {
                                        houseHoldMonthly = value;
                                      } else if (lable == 'HousingLoan') {
                                        housingLoan = value;
                                      } else if (lable == 'VehicleLoan') {
                                        vehicleLoan = value;
                                      } else if (lable == 'EducationLoan') {
                                        educationLoan = value;
                                      } else if (lable == 'PersonalLoan') {
                                        personalLoan = value;
                                      } else if (lable == 'OtherLoan') {
                                        otherLoan = value;
                                      } else if (lable == 'MortgageLoan') {
                                        mortgageLoan = value;
                                      } else if (lable == 'HealthInsurance') {
                                        healthInsurance = value;
                                      } else if (lable == 'VehicleInsurance') {
                                        vehicleInsurance = value;
                                      } else if (lable == 'TermInsurance') {
                                        termInsurance = value;
                                      } else if (lable ==
                                          'TraditionalInsurance') {
                                        traditionalInsurance = value;
                                      } else if (lable == 'OtherInsurance') {
                                        otherInsurance = value;
                                      } else if (lable == 'ULIP') {
                                        uLIP = value;
                                      } else if (lable == 'Gold') {
                                        gold = value;
                                      } else if (lable == 'Cash') {
                                        cash = value;
                                      } else if (lable == 'RealEstate') {
                                        realEstate = value;
                                      } else if (lable == 'OtherAsset') {
                                        otherAsset = value;
                                      } else if (lable == 'Vehicle') {
                                        vehicle = value;
                                      } else if (lable == 'FixedDeposite') {
                                        fixedDeposite = value;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                    splashColor: colorWhite,
                                    onTap: () async {
                                      final pref =
                                          await SharedPreferences.getInstance();
                                      if (lable == 'SIPMonthly') {
                                        await pref.setInt(
                                            'sIPMonthly', sIPMonthly);
                                      } else if (lable == 'PPFMonthly') {
                                        await pref.setInt(
                                            'pPFMonthly', pPFMonthly);
                                      } else if (lable ==
                                          'PostOfficeOrVikas..') {
                                        await pref.setInt(
                                            'postOfficeOrVikasPatra',
                                            postOfficeOrVikasPatra);
                                      } else if (lable ==
                                          'PrivateInvestment..') {
                                        await pref.setInt(
                                            'privateInvestmentScheme',
                                            privateInvestmentScheme);
                                      } else if (lable == 'Business') {
                                        await pref.setInt('business', business);
                                      } else if (lable == 'Salary') {
                                        await pref.setInt('salary', salary);
                                      } else if (lable == 'Professional') {
                                        await pref.setInt(
                                            'professional', professional);
                                      } else if (lable == 'SpouseIncome') {
                                        await pref.setInt(
                                            'spouseIncome', spouseIncome);
                                      } else if (lable == 'OtherIncome') {
                                        await pref.setInt(
                                            'otherIncome', otherIncome);
                                      } else if (lable == 'HouseHoldMonthly') {
                                        await pref.setInt('houseHoldMonthly',
                                            houseHoldMonthly);
                                      } else if (lable == 'HousingLoan') {
                                        await pref.setInt(
                                            'housingLoan', housingLoan);
                                      } else if (lable == 'VehicleLoan') {
                                        await pref.setInt(
                                            'vehicleLoan', vehicleLoan);
                                      } else if (lable == 'EducationLoan') {
                                        await pref.setInt(
                                            'educationLoan', educationLoan);
                                      } else if (lable == 'PersonalLoan') {
                                        await pref.setInt(
                                            'personalLoan', personalLoan);
                                      } else if (lable == 'OtherLoan') {
                                        await pref.setInt(
                                            'otherLoan', otherLoan);
                                      } else if (lable == 'MortgageLoan') {
                                        await pref.setInt(
                                            'mortgageLoan', mortgageLoan);
                                      } else if (lable == 'HealthInsurance') {
                                        await pref.setInt(
                                            'healthInsurance', healthInsurance);
                                      } else if (lable == 'VehicleInsurance') {
                                        await pref.setInt('vehicleInsurance',
                                            vehicleInsurance);
                                      } else if (lable == 'TermInsurance') {
                                        await pref.setInt(
                                            'termInsurance', termInsurance);
                                      } else if (lable ==
                                          'TraditionalInsurance') {
                                        await pref.setInt(
                                            'traditionalInsurance',
                                            traditionalInsurance);
                                      } else if (lable == 'OtherInsurance') {
                                        await pref.setInt(
                                            'otherInsurance', otherInsurance);
                                      } else if (lable == 'ULIP') {
                                        await pref.setInt('uLIP', uLIP);
                                      } else if (lable == 'Gold') {
                                        await pref.setInt('gold', gold);
                                      } else if (lable == 'Cash') {
                                        await pref.setInt('cash', cash);
                                      } else if (lable == 'RealEstate') {
                                        await pref.setInt(
                                            'realEstate', realEstate);
                                      } else if (lable == 'OtherAsset') {
                                        await pref.setInt(
                                            'otherAsset', otherAsset);
                                      } else if (lable == 'Vehicle') {
                                        await pref.setInt('vehicle', vehicle);
                                      } else if (lable == 'FixedDeposite') {
                                        await pref.setInt(
                                            'fixedDeposite', fixedDeposite);
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
                        Text(text,
                            overflow: TextOverflow.fade,
                            style: textStyle9(colorText3D3D)),
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
                      Text(text,
                          overflow: TextOverflow.fade,
                          style: textStyle9(colorText3D3D)),
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
        professional: professional,
        spouseIncome: spouseIncome,
        otherIncome: otherIncome,
        houseHoldMonthly: houseHoldMonthly,
        totalMonthlyEmi: 0,
        totalInsurancePremiumYearly: 0,
        childrenEducationYearly: 0,
        otherExpenseYearly: 0,
        vehicle: vehicle,
        gold: gold,
        savingAccount: 0,
        cash: cash,
        emergencyFunds: 0,
        otherAsset: otherAsset,
        mutualFunds: mutualFundsValue,
        pPF: 0,
        sIPMonthly: sIPMonthly,
        pPFMonthly: pPFMonthly,
        debenture: 0,
        fixedDeposite: 0,
        stockPortfolio: stocksValue,
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
