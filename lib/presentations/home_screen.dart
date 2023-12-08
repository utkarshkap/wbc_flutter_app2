import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wbc_connect_app/blocs/deletefamilymember/delete_family_member_bloc.dart';
import 'package:wbc_connect_app/models/expanded_category_model.dart';
import 'package:wbc_connect_app/models/munafe_ki_class_model.dart';
import 'package:wbc_connect_app/models/product_category_model.dart';
import 'package:wbc_connect_app/presentations/Real_Estate/real_estate_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import 'package:wbc_connect_app/presentations/wbc_connect.dart';
import 'package:wbc_connect_app/presentations/wealth_meter.dart';
import '../blocs/InsuranceInvestment/insurance_investment_bloc.dart';
import '../blocs/MFInvestments/mf_investments_bloc.dart';
import '../blocs/dashboardbloc/dashboard_bloc.dart';
import '../blocs/fetchingData/fetching_data_bloc.dart';
import '../blocs/mall/mall_bloc.dart';
import '../common_functions.dart';
import '../core/api/api_consts.dart';
import '../core/preferences.dart';
import '../models/dashboard.dart';
import '../models/insurance_investment_model.dart';
import '../models/investment_portfolio_model.dart';
import '../models/loan_investment_model.dart';
import '../models/mGain_investment_model.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/stock_investment_model.dart';
import '../models/trending_data_model.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';
import '../widgets/main_drawer.dart';
import 'M_Gain/M_Gain_Investment.dart';
import 'Review/add_member_details.dart';
import 'Review/emi_sip_calculator.dart';
import 'Review/insurance_calculator.dart';
import 'Review/insurance_investment.dart';
import 'Review/loan_investment.dart';
import 'Review/munafe_ki_class.dart';
import 'Review/mutual_funds_investment.dart';
import 'Review/my_investment.dart';
import 'Review/retirement_calculator.dart';
import 'Review/sip_calculator.dart';
import 'Review/stocks_investment.dart';
import 'WBC_Mega_Mall/product_details_screen.dart';
import 'fastTrack_benefits.dart';

class HomeScreenData {
  final bool rewardPopUpShow;
  final bool isFastTrackActivate;
  final String isSendReview;
  final String? acceptedContacts;

  HomeScreenData({
    this.rewardPopUpShow = false,
    this.isFastTrackActivate = false,
    this.isSendReview = '',
    this.acceptedContacts,
  });
}

class HomeScreen extends StatefulWidget {
  static const route = '/Home-Screen';

  final HomeScreenData homeScreenData;

  const HomeScreen(this.homeScreenData, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey globalKey = GlobalKey();
  bool isAddContact = false;
  bool isRenewContact = false;
  String mono = "";
  bool isRewardPopup = false;
  bool isPopular = false;
  bool isShowCase = false;
  DateTime? currentBackPressTime;
  bool fastTrackStatus = false;
  num clientsConverted = 0;
  double stocksValue = 0;
  double mutualFundsValue = 0;
  double total = 0;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Press again to exit',
          backgroundColor: colorE5E5,
          textColor: colorBlack);
      return Future.value(false);
    }
    return Future.value(true);
  }

  getShowCase() async {
    isShowCase = await Preference.getShowCase();
    if (!isShowCase) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([globalKey]));
    }
    print('isShowCase-----$isShowCase');
  }

  @override
  void initState() {
    super.initState();
    getClientsConvertedMember();

    // getShowCase();
    getFastTrackStatus();
    print('userId-----${ApiUser.userId}');
    print('rewardPopup-----${widget.homeScreenData.rewardPopUpShow}');
    Future.delayed(Duration.zero, () {
      if (widget.homeScreenData.isSendReview == 'SendReview') {
        CommonFunction().successPopup(
            context,
            'Thank You',
            'You Will Get Your Review Report Withing 48 Working Hours In Your Register Email.',
            jsonReviewSuccess,
            mono);
      }
      if (widget.homeScreenData.isSendReview == 'SubmitRealEstate') {
        CommonFunction().successPopup(
            context,
            'Thank You',
            'Your data has been successfully submitted.',
            jsonReviewSuccess,
            mono);
      }
      if (widget.homeScreenData.isSendReview == 'FamilyMember') {
        CommonFunction().successPopup(
            context,
            'Thank You',
            'Your Family Member has been successfully Added.',
            jsonReviewSuccess,
            mono,
            globalKey,
            isShowCase);
      }
    });

    BlocProvider.of<DashboardBloc>(context)
        .add(GetDashboardData(userId: ApiUser.userId));
  }

  getFastTrackStatus() async {
    if (widget.homeScreenData.isFastTrackActivate == true) {
      setState(() {
        fastTrackStatus = true;
      });
      Preference.setFastTrackStatus(true);
    } else {
      fastTrackStatus = await Preference.getFastTrackStatus();
    }
    print("fastTrackStatus-->$fastTrackStatus");
  }

  getCheckUserLog() async {
    isAddContact = await Preference.getIsContact();
    mono = await Preference.getMobNo();
    isRenewContact = await Preference.getRenewContact();

    print('isAddcontact-----$isAddContact');
  }

  getClientsConvertedMember() {
    for (int i = 0; i < ApiUser.myContactsList!.length; i++) {
      if (ApiUser.myContactsList![i].userexist == true) {
        clientsConverted++;
      }
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
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Image.asset(icMenu, width: 7.w));
          }),
          titleSpacing: 0,
          title: Text('Finer', style: textStyle15Bold(colorBlack)),
          actions: [
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
        drawer: const MainDrawer(),
        body: BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {
            print('state=====$state');
            if (state is DashboardDataLoaded) {
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
              Preference.setApproveContactCount(
                  state.data!.data.addContacts.toString());
              ApiUser.goldReferralPoint = state.data!.data.goldPoint;
              ApiUser.offersList = state.data!.data.offers;
              GpDashBoardData.history = state.data!.data.history;
              GpDashBoardData.contactBase = state.data!.data.contactBase;
              GpDashBoardData.inActiveClients = state.data!.data.inActive;
              GpDashBoardData.availableContacts =
                  state.data!.data.availableContacts;
              GpDashBoardData.goldPoint = state.data!.data.goldPoint;
              GpDashBoardData.fastTrackEarning = state.data!.data.fastTrack;
              GpDashBoardData.earning = state.data!.data.earning;
              GpDashBoardData.redeemable = state.data!.data.redeemable;
              GpDashBoardData.nonRedeemable = state.data!.data.nonRedeemable;
              GpDashBoardData.onTheSpot = state.data!.data.onTheSpot;

              print('memberlistdetlete---------${state.data!.data.memberlist}');

              ApiUser.membersList = state.data!.data.memberlist;
              isRewardPopup = widget.homeScreenData.rewardPopUpShow;

              getCheckUserLog();
              print('dash---------$isRewardPopup');

              if (isRewardPopup) {
                CommonFunction().successPopup(
                    context,
                    'Congratulations',
                    ApiUser.numberList.length == 0
                        ? 'Congratulations! Your ${int.parse(widget.homeScreenData.acceptedContacts!)} contacts are approved in WBC and you have received ${int.parse(widget.homeScreenData.acceptedContacts!) * 100} Gold Points for the same.'
                        : 'Congratulations! Your ${int.parse(widget.homeScreenData.acceptedContacts!)} contacts are approved in WBC and you have received ${int.parse(widget.homeScreenData.acceptedContacts!) * 100} Gold Points for the same.${ApiUser.numberList.toString().replaceAll('[', '').replaceAll(']', '')},are not added because its already available',
                    jsonRewardPopup);
              }
            }
            if (state is DashboardFailed) {
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
            if (state is DashboardDataLoaded) {
              print('state---------${state.data!.data}');
              return WillPopScope(
                onWillPop: onWillPop,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocListener<MFInvestmentsBloc, MFInvestmentsState>(
                          listener: (context, state) {
                            if (state is MFInvestmentsLoadedState) {
                              mutualFundsValue = 0;
                              for (int i = 0;
                                  i < state.investmentPortfolio.mFStocks.length;
                                  i++) {
                                if (state.investmentPortfolio.mFStocks[i].unit
                                        .toInt() !=
                                    0) {
                                  mutualFundsValue += ((state
                                              .investmentPortfolio
                                              .mFStocks[i]
                                              .investment_Unit -
                                          state.investmentPortfolio.mFStocks[i]
                                              .sale_Unit) *
                                      state
                                          .investmentPortfolio.mFStocks[i].nav);
                                }
                              }
                              setState(() {});
                            }
                          },
                          child:
                              BlocListener<FetchingDataBloc, FetchingDataState>(
                            listener: (context, state) {
                              if (state is StockInvestmentLoadedState) {
                                stocksValue = 0;
                                for (int i = 0;
                                    i <
                                        state.stockInvestmentPortfolio.stocks
                                            .length;
                                    i++) {
                                  stocksValue += ((state
                                          .stockInvestmentPortfolio
                                          .stocks[i]
                                          .balanceQty) *
                                      state.stockInvestmentPortfolio.stocks[i]
                                          .rate);
                                }
                                setState(() {});
                              }
                              total = mutualFundsValue + stocksValue;
                            },
                            child: Container(
                              width: 90.w,
                              decoration: decoration(),
                              padding: EdgeInsets.only(
                                  top: 1.h, bottom: 1.h, left: 0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 4.w, bottom: 1.h),
                                    child: Text(
                                        'Your Net Worth: ₹ ${CommonFunction().splitString(total.toStringAsFixed(0))}',
                                        style: textStyle14Bold(colorBlack)),
                                  ),
                                  Container(
                                      height: 1,
                                      color: colorTextBCBC.withOpacity(0.36)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 4.w, left: 0.w, top: 1.h),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 1.5.w),
                                            width: 13.w,
                                            child: Image.asset(
                                                'assets/images/portfolio-icon.png',
                                                width: 13.w),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Mutual Funds: ',
                                              style: textStyle10(colorText7070),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '₹ ${CommonFunction().splitString(mutualFundsValue.toStringAsFixed(0))}',
                                                    style: textStyle10Bold(
                                                        colorBlack)),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Stocks: ',
                                              style: textStyle10(colorText7070),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '₹ ${CommonFunction().splitString(stocksValue.toStringAsFixed(0))}',
                                                    style: textStyle10Bold(
                                                        colorBlack)),
                                              ],
                                            ),
                                          )
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 90.w,
                          decoration: decoration(),
                          child: Column(
                            children: [
                              pointsView(
                                  icGoldCoin,
                                  'Your Gold Points',
                                  CommonFunction().splitString(
                                      state.data!.data.goldPoint.toString()),
                                  'Redeem Now',
                                  state.data!.data.history,
                                  state.data!.data.contactBase,
                                  state.data!.data.inActive,
                                  state.data!.data.availableContacts,
                                  state.data!.data.goldPoint,
                                  state.data!.data.fastTrack,
                                  state.data!.data.earning,
                                  state.data!.data.redeemable,
                                  state.data!.data.nonRedeemable,
                                  state.data!.data.onTheSpot, () {
                                BlocProvider.of<FetchingDataBloc>(context).add(
                                    LoadProductCategoryEvent(
                                        productCategory: ProductCategory(
                                            code: 0,
                                            message: '',
                                            categories: [])));
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
                                Navigator.of(context)
                                    .pushReplacementNamed(WbcMegaMall.route);
                              }, 'Gold Points'),
                              Container(
                                  height: 1,
                                  color: colorTextBCBC.withOpacity(0.36)),
                              pointsView(
                                  rupeeIcon,
                                  'Your FastTrack Earnings',
                                  '₹ ${CommonFunction().splitString(state.data!.data.fastTrack.toString())}',
                                  'Become Member',
                                  state.data!.data.history,
                                  state.data!.data.contactBase,
                                  state.data!.data.inActive,
                                  state.data!.data.availableContacts,
                                  state.data!.data.goldPoint,
                                  state.data!.data.fastTrack,
                                  state.data!.data.earning,
                                  state.data!.data.redeemable,
                                  state.data!.data.nonRedeemable,
                                  state.data!.data.onTheSpot, () {
                                Navigator.of(context)
                                    .pushNamed(FastTrackBenefits.route);
                                // Navigator.of(context).pushNamed(RequestPayment.route);
                              }, 'FastTrack')
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MunafeKiClassScreen.route);
                            BlocProvider.of<FetchingDataBloc>(context).add(
                                LoadMunafeKiClassEvent(
                                    munafeKiClass: MunafeKiClass(
                                        code: 0, message: '', list: [])));
                          },
                          child: Container(
                            width: 90.w,
                            decoration: decoration(),
                            padding: EdgeInsets.only(
                                top: 2.h, bottom: 2.h, left: 4.w),
                            child: Row(
                              children: [
                                Image.asset(icCoinCash, height: 3.h),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text('Learn how to earn more',
                                    style: textStyle12Medium(colorBlack)),
                                Text(' Gold ',
                                    style: textStyle13Bold(colorRed)),
                                Text('Points',
                                    style: textStyle12Medium(colorBlack)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 90.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/NRI-CARNIVAL-7-BANNER.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 90.w,
                          decoration: decoration(),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('My Account',
                                        style: textStyle12Bold(colorBlack)
                                            .copyWith(letterSpacing: 0.16)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 2.h),
                                      child: Container(
                                          height: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Wrap(
                                    runSpacing: 1.5.h,
                                    children: [
                                      BlocListener<MFInvestmentsBloc,
                                          MFInvestmentsState>(
                                        listener: (context, state) {
                                          if (state
                                              is MFInvestmentsLoadedState) {
                                            // Navigator.of(context).pushNamed(MutualFundsInvestment.route);
                                          }
                                        },
                                        child: portFolioWidget(icMutualFunds,
                                            'Mutual Funds', false, () {
                                          BlocProvider.of<MFInvestmentsBloc>(
                                                  context)
                                              .add(LoadMFInvestmentsEvent(
                                                  userId: ApiUser.userId,
                                                  investmentPortfolio:
                                                      InvestmentPortfolio(
                                                          code: 0,
                                                          message: '',
                                                          portfolio: 0,
                                                          investment: 0,
                                                          gain: 0,
                                                          mFStocks: [])));
                                          Navigator.of(context).pushNamed(
                                              MutualFundsInvestment.route);
                                        }, () {}),
                                      ),
                                      BlocListener<FetchingDataBloc,
                                          FetchingDataState>(
                                        listener: (context, state) {
                                          if (state
                                              is StockInvestmentLoadedState) {
                                            // Navigator.of(context).pushNamed(StocksInvestment.route);
                                          }
                                        },
                                        child: portFolioWidget(
                                            icStocks, 'Stocks', false, () {
                                          BlocProvider.of<FetchingDataBloc>(
                                                  context)
                                              .add(LoadStockInvestmentEvent(
                                                  userId: ApiUser.userId,
                                                  investmentPortfolio:
                                                      StockInvestmentModel(
                                                    code: 0,
                                                    message: '',
                                                    portfolio: 0,
                                                    investment: 0,
                                                    gain: 0,
                                                    stocks: [],
                                                  )));
                                          Navigator.of(context).pushNamed(
                                              StocksInvestment.route);
                                        }, () {}),
                                      ),
                                      BlocListener<InsuranceInvestmentBloc,
                                          InsuranceInvestmentState>(
                                        listener: (context, state) {
                                          if (state
                                              is InsuranceInvestmentLoadedState) {
                                            print(
                                                '--------insurance22---investment');
                                            // Navigator.of(context).pushNamed(InsuranceInvestmentScreen.route);
                                          }
                                        },
                                        child: portFolioWidget(icLifeInsurance,
                                            'Life Insurance', false, () {
                                          print(
                                              '--------insurance11---investment');
                                          BlocProvider.of<
                                                      InsuranceInvestmentBloc>(
                                                  context)
                                              .add(LoadInsuranceInvestmentEvent(
                                                  userId: ApiUser.userId,
                                                  typeId: 4,
                                                  subTypeId: 5,
                                                  insuranceInvestment:
                                                      InsuranceInvestment(
                                                          code: 0,
                                                          message: '',
                                                          totalInsuranceAmt: 0,
                                                          policies: [])));
                                          Navigator.of(context).pushNamed(
                                            InsuranceInvestmentScreen.route,
                                            arguments: InsuranceInvestmentData(
                                                isFromLI: true),
                                          );
                                        }, () {}),
                                      ),
                                      BlocListener<InsuranceInvestmentBloc,
                                          InsuranceInvestmentState>(
                                        listener: (context, state) {
                                          if (state
                                              is InsuranceInvestmentLoadedState) {
                                            // Navigator.of(context).pushNamed(InsuranceInvestmentScreen.route);
                                          }
                                        },
                                        child: portFolioWidget(
                                            icGeneralInsurance,
                                            'General Insurance',
                                            false, () {
                                          BlocProvider.of<
                                                      InsuranceInvestmentBloc>(
                                                  context)
                                              .add(LoadInsuranceInvestmentEvent(
                                                  userId: ApiUser.userId,
                                                  typeId: 4,
                                                  subTypeId: 15,
                                                  insuranceInvestment:
                                                      InsuranceInvestment(
                                                          code: 0,
                                                          message: '',
                                                          totalInsuranceAmt: 0,
                                                          policies: [])));
                                          Navigator.of(context).pushNamed(
                                            InsuranceInvestmentScreen.route,
                                            arguments: InsuranceInvestmentData(
                                                isFromLI: false),
                                          );
                                        }, () {}),
                                      ),
                                      BlocListener<FetchingDataBloc,
                                          FetchingDataState>(
                                        listener: (context, state) {
                                          if (state
                                              is LoanInvestmentLoadedState) {
                                            Navigator.of(context).pushNamed(
                                                LoanInvestmentScreen.route);
                                          }
                                        },
                                        child: portFolioWidget(
                                            icLoan, 'Loan', false, () {
                                          BlocProvider.of<FetchingDataBloc>(
                                                  context)
                                              .add(LoadLoanInvestmentEvent(
                                                  userId: ApiUser.userId,
                                                  loanInvestment:
                                                      LoanInvestment(
                                                          code: 0,
                                                          message: '',
                                                          totalLoanAmt: 0,
                                                          loans: [])));
                                        }, () {}),
                                      ),
                                      portFolioWidget(
                                          icRealEstate, 'Real\nEstate', false,
                                          () {
                                        Navigator.of(context)
                                            .pushNamed(RealEstateScreen.route);
                                      }, () {}),
                                      portFolioWidget(icMGain, 'MGain', false,
                                          () {
                                        BlocProvider.of<FetchingDataBloc>(
                                                context)
                                            .add(LoadMGainInvestmentEvent(
                                                userId: ApiUser.userId,
                                                mGainInvestment:
                                                    MGainInvestment(
                                                        code: 0,
                                                        message: '',
                                                        mGainTotalInvestment: 0,
                                                        totalIntrestReceived: 0,
                                                        mGains: [])));
                                        Navigator.of(context).pushNamed(
                                            MGainInvestmentScreen.route);
                                      }, () {}),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.5.h),
                        Container(
                          width: 90.w,
                          decoration: decoration(),
                          child: Column(
                            children: [
                              contactsView(
                                  familyIcon,
                                  'Add Your Family',
                                  state.data!.data.memberlist.length.toString(),
                                  '+',
                                  () => Navigator.of(context).pushNamed(
                                      AddMemberDetails.route,
                                      arguments: AddMemberDetailsData(
                                          familyList:
                                              state.data!.data.memberlist))),
                              Container(
                                  height: 1,
                                  color: colorTextBCBC.withOpacity(0.36)),
                              contactsView(
                                  icAddContacts, 'Add Your Contacts', '', '+',
                                  () {
                                print('add contact------');
                                print(state.data!.data.availableContacts);

                                if (state.data!.data.availableContacts != 0) {
                                  Preference.setRenewContact(true);
                                  Navigator.of(context).pushNamed(
                                      VerificationScreen.route,
                                      arguments: VerificationScreenData(
                                          getNumber: "",
                                          number: mono,
                                          verificationId: "",
                                          isLogin: true,
                                          selectedContact: state
                                              .data!.data.availableContacts!,
                                          isHomeContactOpen: true));
                                } else {
                                  CommonFunction()
                                      .reachedMaxContactPopup(context);
                                }
                              }),
                              Container(
                                  height: 1,
                                  color: colorTextBCBC.withOpacity(0.36)),
                              contactsView(
                                  icConnectFastTrack,
                                  'Connect FastTrack',
                                  'And earn on your team\'s business',
                                  'Benefits',
                                  () => Navigator.of(context)
                                      .pushNamed(FastTrackBenefits.route))
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 90.w,
                          decoration: decoration(),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Track your family\'s portfolio',
                                        style: textStyle12Bold(colorBlack)
                                            .copyWith(letterSpacing: 0.16)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 2.h),
                                      child: Container(
                                          height: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                    physics: const PageScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(left: 1.0.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        portFolioWidget(
                                            icAddMmeber, 'Add Member', true,
                                            () {
                                          Navigator.of(context).pushNamed(
                                              AddMemberDetails.route,
                                              arguments: AddMemberDetailsData(
                                                  familyList: state
                                                      .data!.data.memberlist));
                                        }, () {}),
                                        BlocListener<DeleteFamilyMemberBloc,
                                            DeleteFamilyMemberState>(
                                          listener: (context, state) {
                                            if (state is DeletedFamilyMember) {
                                              print(
                                                  '-------mobNumber--=---${state.mobNo}');
                                              ApiUser.membersList.removeWhere(
                                                  (element) =>
                                                      element.mobileno ==
                                                      state.mobNo);
                                              setState(() {});
                                            }
                                            if (state
                                                is DeleteFamilyMemberFailed) {
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
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                state.data!.data.memberlist
                                                    .length,
                                                (i) => i == 0
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 2.5.w),
                                                        child: GestureDetector(
                                                          onLongPress: () {
                                                            CommonFunction()
                                                                .confirmationDialog(
                                                                    context,
                                                                    'Are you sure you want to delete this member?',
                                                                    () {
                                                              print(
                                                                  '--yes clicked--=----');
                                                              BlocProvider.of<
                                                                          DeleteFamilyMemberBloc>(
                                                                      context)
                                                                  .add(DeleteFamilyMember(
                                                                      mobNo: ApiUser
                                                                          .membersList[
                                                                              i]
                                                                          .mobileno));

                                                              setState(() {
                                                                ApiUser
                                                                    .membersList
                                                                    .removeWhere((element) =>
                                                                        element
                                                                            .mobileno ==
                                                                        ApiUser
                                                                            .membersList[i]
                                                                            .mobileno);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              // Showcase(
                                                              //   key: globalKey,
                                                              //   onTargetClick:
                                                              //       () {
                                                              //     print(
                                                              //         '-----onClick----showcase');
                                                              //     Preference
                                                              //         .setShowCase(
                                                              //             true);
                                                              //   },
                                                              //   disposeOnTap:
                                                              //       true,
                                                              //   targetShapeBorder:
                                                              //       const CircleBorder(),
                                                              //   description:
                                                              //       'Long press to delete member.',
                                                              //   descTextStyle:
                                                              //       textStyle10Medium(
                                                              //           colorBlack),
                                                              //   child:
                                                              Container(
                                                                height: 6.5.h,
                                                                width: 6.5.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: colorRed
                                                                      .withOpacity(
                                                                          0.29),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    ApiUser
                                                                        .membersList[
                                                                            i]
                                                                        .name
                                                                        .substring(
                                                                            0,
                                                                            1)
                                                                        .toUpperCase(),
                                                                    style: textStyle20(
                                                                        colorRed)),
                                                              ),
                                                              // ),
                                                              SizedBox(
                                                                  height:
                                                                      1.2.h),
                                                              SizedBox(
                                                                width: 15.w,
                                                                child: Text(
                                                                    ApiUser
                                                                        .membersList[
                                                                            i]
                                                                        .name,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: textStyle8(
                                                                            colorText3D3D)
                                                                        .copyWith(
                                                                            height:
                                                                                1.1)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : portFolioWidget(
                                                        ApiUser
                                                            .membersList[i].name
                                                            .substring(0, 1),
                                                        ApiUser.membersList[i]
                                                            .name,
                                                        true,
                                                        () {}, () {
                                                        CommonFunction()
                                                            .confirmationDialog(
                                                                context,
                                                                'Are you sure you want to delete this member?',
                                                                () {
                                                          print(
                                                              '--yes clicked--=----');
                                                          BlocProvider.of<
                                                                      DeleteFamilyMemberBloc>(
                                                                  context)
                                                              .add(DeleteFamilyMember(
                                                                  mobNo: ApiUser
                                                                      .membersList[
                                                                          i]
                                                                      .mobileno));

                                                          setState(() {
                                                            ApiUser.membersList
                                                                .removeWhere((element) =>
                                                                    element
                                                                        .mobileno ==
                                                                    ApiUser
                                                                        .membersList[
                                                                            i]
                                                                        .mobileno);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      }),
                                              )),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          width: 90.w,
                          decoration: decoration(),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Utilities',
                                        style: textStyle12Bold(colorBlack)
                                            .copyWith(letterSpacing: 0.16)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 2.h),
                                      child: Container(
                                          height: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SingleChildScrollView(
                                    physics: const PageScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(left: 1.0.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        portFolioWidget(icInsuranceCalculator,
                                            'Insurance\nCalculator', true, () {
                                          Navigator.of(context).pushNamed(
                                              InsuranceCalculator.route);
                                        }, () {}),
                                        portFolioWidget(icInsuranceCalculator,
                                            'SIP\nCalculator', true, () {
                                          Navigator.of(context)
                                              .pushNamed(SIPCalculator.route);
                                        }, () {}),
                                        portFolioWidget(icInsuranceCalculator,
                                            'EMI SIP\nCalculator', true, () {
                                          Navigator.of(context).pushNamed(
                                              EMISIPCalculator.route);
                                        }, () {}),
                                        portFolioWidget(icInsuranceCalculator,
                                            'Retirement\nCalculator', true, () {
                                          Navigator.of(context).pushNamed(
                                              RetirementCalculator.route,
                                              arguments:
                                                  RetirementCalculatorData());
                                        }, () {}),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        if (state.data!.data.offers.isNotEmpty)
                          Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 2.5.h, bottom: 2.h),
                                child: SizedBox(
                                  width: 90.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('OFFERS NEAR YOU...',
                                          style: textStyle11Bold(colorBlack)
                                              .copyWith(letterSpacing: 0.7)),
                                      Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Text('All Offers',
                                                  style: textStyle10(colorRed)),
                                              SizedBox(width: 2.w),
                                              Image.asset(icNext,
                                                  color: colorRed,
                                                  height: 1.5.h)
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      state.data!.data.offers.length,
                                      (index) => Padding(
                                            padding: EdgeInsets.only(
                                                left: index == 0 ? 5.w : 0,
                                                right: 2.5.w,
                                                bottom: 2.h),
                                            child: Container(
                                              height: 15.h,
                                              width: 60.w,
                                              decoration: decoration(),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                      imgBaseUrl +
                                                          state
                                                              .data!
                                                              .data
                                                              .offers[index]
                                                              .imgUrl,
                                                      fit: BoxFit.fill)),
                                            ),
                                          )),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 3.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(WealthMeterScreen.route);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            colorBoxGradiant0020,
                                            colorBoxGradiant0040
                                          ])),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(3.5.w, 2.h, 2.w, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 55.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Check Your',
                                                  style: textStyle11Medium(
                                                      colorRed)),
                                              SizedBox(height: 0.5.h),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Wealth Score',
                                                  style:
                                                      textStyle14(colorTextFFC1)
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: ' For Free',
                                                        style: textStyle11Bold(
                                                            colorWhite)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 43.w,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 1.5.h),
                                                      child: Container(
                                                        height: 1,
                                                        color: colorBG
                                                            .withOpacity(0.45),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: 'GET',
                                                            style: textStyle8(
                                                                colorWhite),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      ' FREE ',
                                                                  style: textStyle8(
                                                                      colorTextFFC1)),
                                                              TextSpan(
                                                                  text:
                                                                      'WEALTH REPORT',
                                                                  style: textStyle8(
                                                                      colorWhite)),
                                                            ],
                                                          ),
                                                        ),
                                                        Image.asset(icNext,
                                                            color: colorWhite,
                                                            height: 1.2.h)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2.h)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child:
                                      Image.asset(imgWealthScore, height: 16.h))
                            ],
                          ),
                        ),
                        SizedBox(height: 2.5.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(InvestmentReview.route);
                          },
                          child: Container(
                            width: 90.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorBoxGradiant505E,
                                      colorBoxGradiantD167
                                    ])),
                            child: Row(
                              children: [
                                Container(
                                  height: 20.w,
                                  width: 20.w,
                                  decoration: const BoxDecoration(
                                      color: colorWhite,
                                      shape: BoxShape.circle),
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  child: Image.asset(imgKAPortfolioDoctor),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2.7.h),
                                    Text('Get Wealth Checkup Done',
                                        style: textStyle11Light(colorWhite)),
                                    SizedBox(height: 0.5.h),
                                    Text('By Portfolio Doctor Experts',
                                        style: textStyle13Bold(colorWhite)),
                                    SizedBox(
                                      width: 62.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5.h),
                                            child: Container(
                                              width: 25.w,
                                              decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                    horizontal: 2.w),
                                                child: Row(
                                                  children: [
                                                    Text('CLICK NOW',
                                                        style: textStyle7Bold(
                                                            colorBoxGradiant505E)),
                                                    SizedBox(width: 5.w),
                                                    Image.asset(icNext,
                                                        color:
                                                            colorBoxGradiant505E,
                                                        height: 1.h)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.w),
                                            child: Image.asset(imgWealthCheckup,
                                                width: 22.w),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MunafeKiClassScreen.route);
                            BlocProvider.of<FetchingDataBloc>(context).add(
                                LoadMunafeKiClassEvent(
                                    munafeKiClass: MunafeKiClass(
                                        code: 0, message: '', list: [])));
                          },
                          child: Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorBoxGradiant0020,
                                        colorBoxGradiant0040
                                      ])),
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(3.5.w, 2.h, 2.w, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 50.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('BECOME',
                                              style: textStyle8(colorTextFFC1)),
                                          SizedBox(height: 0.1.h),
                                          Text('Finer Expert',
                                              style:
                                                  textStyle15Medium(colorRed)),
                                          // SizedBox(height: 0.5.h),
                                          // RichText(
                                          //   text: TextSpan(
                                          //     text: 'with ',
                                          //     style:
                                          //         textStyle11Medium(colorWhite),
                                          //     children: <TextSpan>[
                                          //       TextSpan(
                                          //           text: 'Munafe Ki Class',
                                          //           style: textStyle12Medium(
                                          //                   colorTextFFC1)
                                          //               .copyWith(
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w600)),
                                          //     ],
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.5.h),
                                            child: Container(
                                              height: 1,
                                              color: colorBG.withOpacity(0.45),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('LEARN FROM WBC TOP USERS',
                                                  style:
                                                      textStyle8(colorWhite)),
                                              Image.asset(icNext,
                                                  color: colorWhite,
                                                  height: 1.2.h)
                                            ],
                                          ),
                                          SizedBox(height: 2.h)
                                        ],
                                      ),
                                    ),
                                    Image.asset(imgMunafeKiClass, width: 30.w)
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(height: 2.5.h),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pushNamed(WBCProgress.route);
                          },
                          child: Container(
                            width: 90.w,
                            decoration: decoration(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Your Finer Progress',
                                              style: textStyle11Bold(colorBlack)
                                                  .copyWith(
                                                      letterSpacing: 0.7)),
                                          SizedBox(width: 2.w),
                                          Image.asset(icRoundQuestionMark,
                                              color: colorRed, width: 5.w)
                                        ],
                                      ),
                                      // Image.asset(icNext,
                                      //     color: colorRed, height: 1.5.h)
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 1,
                                    color: colorTextBCBC.withOpacity(0.36)),
                                SizedBox(
                                  height: 9.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('My Referrals',
                                              style: textStyle9(colorText3D3D)),
                                          Text(
                                              ApiUser.myContactsList!.length
                                                  .toString(),
                                              style: textStyle18Bold(colorRed))
                                        ],
                                      ),
                                      Container(
                                          height: 9.h,
                                          width: 1,
                                          color:
                                              colorTextBCBC.withOpacity(0.36)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Clients converted',
                                              style: textStyle9(colorText3D3D)),
                                          Text(clientsConverted.toString(),
                                              style: textStyle18Bold(
                                                  colorSplashBG))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (!isPopular)
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h, bottom: 2.h),
                            child: SizedBox(
                              width: 90.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Shop & Smile',
                                      style: textStyle11Bold(colorBlack)
                                          .copyWith(letterSpacing: 0.7)),
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<FetchingDataBloc>(
                                                context)
                                            .add(LoadProductCategoryEvent(
                                                productCategory:
                                                    ProductCategory(
                                                        code: 0,
                                                        message: '',
                                                        categories: [])));
                                        BlocProvider.of<MallBloc>(context).add(
                                            LoadMallDataEvent(
                                                popular: Popular(
                                                    code: 0,
                                                    message: '',
                                                    products: []),
                                                newArrival: NewArrival(
                                                    code: 0,
                                                    message: '',
                                                    products: []),
                                                trending: Trending(
                                                    code: 0,
                                                    message: '',
                                                    products: [])));
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                WbcMegaMall.route);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('View All',
                                              style: textStyle10(colorRed)),
                                          SizedBox(width: 2.w),
                                          Image.asset(icNext,
                                              color: colorRed, height: 1.3.h)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        BlocConsumer<MallBloc, MallState>(
                          listener: (context, state) {
                            if (state is MallDataLoadedState) {
                              if (state.popular.products.isEmpty) {
                                isPopular = true;
                              }
                            } else if (state is MallDataErrorState) {
                              isPopular = true;
                            }
                          },
                          builder: (context, state) {
                            print('------mallState--=---$state');
                            if (state is MallDataInitial) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: SingleChildScrollView(
                                  physics: const PageScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        3,
                                        (index) => Padding(
                                              padding: EdgeInsets.only(
                                                  left: index == 0 ? 5.w : 0,
                                                  right: 2.5.w,
                                                  bottom: 2.h),
                                              child: Container(
                                                height: 25.h,
                                                width: 42.w,
                                                decoration: decoration(),
                                              ),
                                            )),
                                  ),
                                ),
                              );
                            }
                            if (state is MallDataLoadedState) {
                              return state.popular.products.isEmpty
                                  ? Container()
                                  : SingleChildScrollView(
                                      physics: const PageScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            state.popular.products.length,
                                            (index) =>
                                                state.popular.products[index]
                                                        .img.isEmpty
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: index == 0
                                                              ? 5.w
                                                              : 0,
                                                        ),
                                                        child: Container(),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: index == 0
                                                                    ? 5.w
                                                                    : 0,
                                                                right: 2.5.w,
                                                                bottom: 2.h),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).pushNamed(
                                                                ProductDetailScreen
                                                                    .route,
                                                                arguments: ProductDetailData(
                                                                    categoryId: state
                                                                        .popular
                                                                        .products[
                                                                            index]
                                                                        .catId,
                                                                    product: ProductList(
                                                                        id: state
                                                                            .popular
                                                                            .products[
                                                                                index]
                                                                            .id,
                                                                        name: state
                                                                            .popular
                                                                            .products[
                                                                                index]
                                                                            .name,
                                                                        price: state
                                                                            .popular
                                                                            .products[
                                                                                index]
                                                                            .price,
                                                                        discount: state
                                                                            .popular
                                                                            .products[index]
                                                                            .discount,
                                                                        availableQty: state.popular.products[index].availableQty,
                                                                        description: state.popular.products[index].description,
                                                                        rate: state.popular.products[index].rate,
                                                                        img: state.popular.products[index].img)));
                                                          },
                                                          child: Container(
                                                            width: 42.w,
                                                            decoration:
                                                                decoration(),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.w),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              colorGreen,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                0.5.h,
                                                                            horizontal: 1.w),
                                                                        child: Text(
                                                                            '${state.popular.products[index].discount}% off',
                                                                            style:
                                                                                textStyle8(colorWhite)),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        1.h),
                                                                SizedBox(
                                                                  height: 14.h,
                                                                  width: 35.w,
                                                                  child: Image.network(
                                                                      imgBaseUrl +
                                                                          state
                                                                              .popular
                                                                              .products[
                                                                                  index]
                                                                              .img
                                                                              .first
                                                                              .imgPath,
                                                                      fit: BoxFit
                                                                          .contain),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 2
                                                                              .h,
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            35.w,
                                                                        child: Text(
                                                                            state.popular.products[index].name,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: textStyle9(colorBlack).copyWith(fontWeight: FontWeight.w600, height: 1.2)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Image.asset(
                                                                            icGoldCoin,
                                                                            width:
                                                                                2.w),
                                                                        SizedBox(
                                                                            width:
                                                                                1.w),
                                                                        Text(
                                                                            '${state.popular.products[index].price.toInt() - ((state.popular.products[index].price.toInt() * state.popular.products[index].discount) ~/ 100).toInt()}GP',
                                                                            style:
                                                                                textStyle8Bold(colorTextFFC1)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Image.asset(
                                                                            icGoldCoin,
                                                                            width:
                                                                                2.w),
                                                                        SizedBox(
                                                                            width:
                                                                                1.w),
                                                                        Text(
                                                                            '${state.popular.products[index].price.toInt()}GP',
                                                                            style:
                                                                                textStyle8(colorText7070).copyWith(decoration: TextDecoration.lineThrough)),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        1.h),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                      ),
                                    );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(height: 3.h)
                      ],
                    ),
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

  button(String text, Function() onClick) {
    return text == 'Benefits'
        ? InkWell(
            onTap: onClick,
            child: Container(
              height: text == '+' ? 4.h : 4.5.h,
              width: text == '+' ? 8.5.h : 18.w,
              decoration: BoxDecoration(
                  color: colorRed,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        color: colorRed.withOpacity(0.35))
                  ]),
              alignment: Alignment.center,
              child: text == '+'
                  ? Image.asset(icAdd, color: colorWhite, width: 3.w)
                  : Text(text, style: textStyle9Bold(colorWhite)),
            ),
          )
        : InkWell(
            onTap: onClick,
            child: Container(
              height: text == '+' ? 4.h : 4.5.h,
              width: text == '+' ? 4.h : 30.w,
              decoration: BoxDecoration(
                  color: colorRed,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        color: colorRed.withOpacity(0.35))
                  ]),
              alignment: Alignment.center,
              child: text == '+'
                  ? Image.asset(icAdd, color: colorWhite, width: 3.w)
                  : Text(text, style: textStyle9Bold(colorWhite)),
            ),
          );
  }

  pointsView(
      String icon,
      String title,
      String subTitle,
      String buttonText,
      List<History> history,
      List<ContactBase> contactBase,
      List<ContactBase> inActiveClients,
      int availableContacts,
      int goldPoint,
      double fastTrackEarning,
      List earning,
      int redeemable,
      int nonRedeemable,
      int onTheSpot,
      Function() onClick,
      String type) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.5.w, right: 3.w),
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (icon == icGoldCoin) {
                    Navigator.of(context).pushNamed(
                      WBCConnect.route,
                      // arguments: WBCConnectData(
                      //     history: history,
                      //     contactBase: contactBase,
                      //     inActiveClients: inActiveClients,
                      //     availableContacts: availableContacts,
                      //     goldPoint: goldPoint,
                      //     fastTrackEarning: fastTrackEarning,
                      //     earning: earning,
                      //     redeemable: redeemable,
                      //     nonRedeemable: nonRedeemable,
                      //     onTheSpot: onTheSpot)
                    );
                  }
                },
                icon: Image.asset(icon, width: 10.w)),
          ),
          GestureDetector(
            onTap: () {
              if (icon == icGoldCoin) {
                Navigator.of(context).pushNamed(
                  WBCConnect.route,
                  // arguments: WBCConnectData(
                  //     history: history,
                  //     contactBase: contactBase,
                  //     inActiveClients: inActiveClients,
                  //     availableContacts: availableContacts,
                  //     goldPoint: goldPoint,
                  //     fastTrackEarning: fastTrackEarning,
                  //     earning: earning,
                  //     redeemable: redeemable,
                  //     nonRedeemable: nonRedeemable,
                  //     onTheSpot: onTheSpot)
                );
              }
            },
            child: Container(
              color: colorWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textStyle9(colorText7070)),
                  SizedBox(height: 0.5.h),
                  Text(subTitle, style: textStyle15Bold(colorBlack))
                ],
              ),
            ),
          ),
          const Spacer(),
          type == "FastTrack" && fastTrackStatus == true
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("FastTrack", style: textStyle10Bold(colorBlack)),
                      SizedBox(
                        width: 3.w,
                      ),
                      Icon(Icons.done, size: 2.8.h, color: colorGreen),
                    ],
                  ),
                )
              : button(buttonText, onClick),
          SizedBox(width: 3.5.w)
        ],
      ),
    );
  }

  contactsView(String icon, String title, String subTitle, String buttonText,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.5.w, right: 3.w),
            child: Container(
              height: 4.5.h,
              width: 4.5.h,
              decoration: const BoxDecoration(
                color: colorGreenEFC,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                icon,
                height: 2.5.h,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle11Bold(colorBlack)),
              const SizedBox(height: 4),
              SizedBox(
                width: buttonText == '+' ? 60.w : 50.w,
                child: title == 'Add Your Contacts'
                    ? RichText(
                        text: TextSpan(
                          text: 'And earn',
                          style: textStyle9(colorBlack),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' 100 Gold ',
                                style: textStyle10Bold(colorRed)),
                            const TextSpan(text: 'points per contact'),
                          ],
                        ),
                      )
                    : title == 'Add Your Family'
                        ? RichText(
                            text: TextSpan(
                              text: 'Your',
                              style: textStyle9(colorBlack),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' ${subTitle} ',
                                    style: textStyle10Bold(colorRed)),
                                const TextSpan(text: 'member connected'),
                              ],
                            ),
                          )
                        : Text(subTitle, style: textStyle9(colorText3D3D)),
              )
            ],
          ),
          const Spacer(),
          button(buttonText, onClick),
          SizedBox(width: 3.w)
        ],
      ),
    );
  }

  portFolioWidget(
    String icon,
    String title,
    bool redColor,
    Function() onClick,
    Function() onLongPress,
  ) {
    return GestureDetector(
      onTap: onClick,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.2.w),
        child: Column(
          children: [
            Container(
              height: 6.5.h,
              width: 6.5.h,
              decoration: BoxDecoration(
                color: redColor == true ? colorRedFFC : colorGreenEFC,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: icon.length == 1
                  ? Text(icon.toUpperCase(), style: textStyle20(colorRed))
                  : Image.asset(icon,
                      color: redColor == true ? colorRed : null,
                      height: icon == icAddMmeber
                          ? 3.5.h
                          : icon == icInsuranceCalculator
                              ? 3.2.h
                              : title == 'MGain'
                                  ? 1.8.h
                                  : 4.h),
            ),
            SizedBox(height: 1.2.h),
            SizedBox(
              width: 15.2.w,
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: textStyle8(colorText3D3D).copyWith(height: 1.1)),
            )
          ],
        ),
      ),
    );
  }
}
