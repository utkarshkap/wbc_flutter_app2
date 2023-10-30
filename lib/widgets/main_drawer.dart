import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wbc_connect_app/blocs/order/order_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/mGain_investment_model.dart';
import 'package:wbc_connect_app/presentations/M_Gain/M_Gain_Investment.dart';
import 'package:wbc_connect_app/presentations/Review/loan_EMI.dart';
import 'package:wbc_connect_app/presentations/Review/munafe_ki_class.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/cart_screen.dart';
import 'package:wbc_connect_app/presentations/fastTrack_benefits.dart';
import 'package:wbc_connect_app/presentations/home_screen.dart';
import 'package:wbc_connect_app/presentations/viewmycontacts.dart';
import 'package:wbc_connect_app/presentations/wbc_connect.dart';
import 'package:wbc_connect_app/presentations/wealth_meter.dart';

import '../blocs/fetchingData/fetching_data_bloc.dart';
import '../blocs/mall/mall_bloc.dart';
import '../blocs/review/review_bloc.dart';
import '../core/preferences.dart';
import '../models/faq_model.dart';
import '../models/munafe_ki_class_model.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/product_category_model.dart';
import '../models/sip_calculator_model.dart';
import '../models/terms_conditions_model.dart';
import '../models/trending_data_model.dart';
import '../presentations/FAQs_screen.dart';
import '../presentations/Real_Estate/real_estate_property.dart';
import '../presentations/Review/emi_sip_calculator.dart';
import '../presentations/Review/history.dart';
import '../presentations/Review/insurance_calculator.dart';
import '../presentations/Review/my_policy.dart';
import '../presentations/Review/my_stocks.dart';
import '../presentations/Review/retirement_calculator.dart';
import '../presentations/Review/sip_calculator.dart';
import '../presentations/Review/track_investments.dart';
import '../presentations/WBC_Mega_Mall/order_history.dart';
import '../presentations/WBC_Mega_Mall/wbc_mega_mall.dart';
import '../presentations/profile_screen.dart';
import '../presentations/terms_nd_condition.dart';
import '../presentations/wbc_progress.dart';
import '../resources/resource.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String mobileNo = '';

  signOut() async {
    await auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    relationType = ['Father', 'Mother', 'Husband', 'Wife', 'Son', 'Daughter'];
    setState(() {});
  }

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
    return Drawer(
      width: 75.w,
      backgroundColor: colorWhite,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
                toolbarHeight: 10.h,
                backgroundColor: colorRed,
                leadingWidth: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Finer', style: textStyle16Bold(colorWhite)),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(ApiUser.userName.toString(),
                        style: textStyle10Medium(colorWhite)),
                  ],
                ),
                automaticallyImplyLeading: false),
            SizedBox(
              height: 89.h - 4.3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    titles('Home'),
                    drawerWidget(icProfile, 'Profile', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(ProfileScreen.route);
                    }),
                    drawerWidget(icWealthMeter, 'Wealth Meter', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(WealthMeterScreen.route);
                    }),
                    drawerWidget(icInterestReceived, 'M Gain', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadMGainInvestmentEvent(
                              userId: ApiUser.userId,
                              mGainInvestment: MGainInvestment(
                                  code: 0,
                                  message: '',
                                  mGainTotalInvestment: 0,
                                  totalIntrestReceived: 0,
                                  mGains: [])));
                      Navigator.of(context)
                          .pushNamed(MGainInvestmentScreen.route);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    titles('WBC'),
                    drawerWidget(icDashboard, 'DashBoard', () {
                      Scaffold.of(context).closeDrawer();
                      // Navigator.of(context).pushReplacementNamed(
                      //     HomeScreen.route,
                      //     arguments: HomeScreenData(
                      //         rewardPopUpShow: false, acceptedContacts: ''));
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
                    }),
                    drawerWidget(icMyReferral, 'My Referrals', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(ViewMyContacts.route,
                          arguments: ViewScreenData(
                              myContact: ApiUser.myContactsList!));
                    }),
                    drawerWidget(icProgress, 'progress', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(WBCProgress.route);
                    }),
                    drawerWidget(icFastTrackEarning, 'FastTrack Benefits', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(FastTrackBenefits.route);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    titles('Portfolio Doctor'),
                    drawerWidget(icStocks, 'Review My Stocks', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(StocksReview.route);
                    }),
                    drawerWidget(icMutualFunds, 'Review My MF', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(TrackInvestments.route);
                    }),
                    drawerWidget(icReviewProperty, 'Review Property', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(RealEstateProperty.route);
                    }),
                    drawerWidget(icReviewLoan, 'Review My Loan', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(LoanEMIReview.route);
                    }),
                    drawerWidget(icReviewPolicy, 'Review My Policy', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(PolicyReview.route);
                    }),
                    drawerWidget(icReviewHistory, 'Review History', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<ReviewBloc>(context)
                          .add(LoadReviewHistoryEvent(mobNo: mobileNo));
                      Navigator.of(context).pushNamed(ReviewHistory.route);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    titles('WBC Mega Mall'),
                    drawerWidget(icMall, 'Home', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadProductCategoryEvent(
                              productCategory: ProductCategory(
                                  code: 0, message: '', categories: [])));
                      BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                          popular: Popular(code: 0, message: '', products: []),
                          newArrival:
                              NewArrival(code: 0, message: '', products: []),
                          trending:
                              Trending(code: 0, message: '', products: [])));
                      Navigator.of(context)
                          .pushReplacementNamed(WbcMegaMall.route);
                    }),
                    drawerWidget(icCart, 'My Cart', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(CartScreen.route);
                    }),
                    drawerWidget(icOrderHistory, 'Order History', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<OrderBloc>(context)
                          .add(GetOrderHistory(userId: ApiUser.userId));

                      Navigator.of(context).pushNamed(OrderHistory.route,
                          arguments: OrderHistoryData());
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    // titles('Vendor'),
                    // drawerWidget(icSearch, 'Search', () {
                    //   Scaffold.of(context).closeDrawer();
                    //   // Navigator.of(context).pushNamed(FAQs.route);
                    // }),
                    // drawerWidget(icGoldCoin, 'Pay & Earn GP', () {
                    //   Scaffold.of(context).closeDrawer();
                    //   // Navigator.of(context).pushNamed(FAQs.route);
                    // }),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 4),
                    //   child: Container(
                    //       height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    // ),
                    titles('Utilities'),
                    drawerWidget(icInsuranceCalculator, 'Insurance Calculator',
                        () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context)
                          .pushNamed(InsuranceCalculator.route);
                    }),
                    drawerWidget(icInsuranceCalculator, 'SIP Calculator', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(SIPCalculator.route);
                    }),
                    drawerWidget(icInsuranceCalculator, 'EMI SIP Calculator',
                        () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(EMISIPCalculator.route);
                    }),
                    drawerWidget(
                        icInsuranceCalculator, 'Retirement  Calculator', () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).pushNamed(
                          RetirementCalculator.route,
                          arguments: RetirementCalculatorData());
                    }),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    titles('Knowledgebase'),
                    drawerWidget(icFAQs, 'FAQs', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadFAQEvent(
                              faq: Faq(code: 0, message: '', questions: [])));
                      Navigator.of(context).pushNamed(FAQs.route);
                    }),
                    drawerWidget(icMunafeKiClass, 'Munafe ki Class', () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadMunafeKiClassEvent(
                              munafeKiClass: MunafeKiClass(
                                  code: 0, message: '', list: [])));
                      Navigator.of(context)
                          .pushNamed(MunafeKiClassScreen.route);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                          height: 1, color: colorTextBCBC.withOpacity(0.36)),
                    ),
                    drawerWidget(icTermsAndConditions, 'Terms & Conditions',
                        () {
                      Scaffold.of(context).closeDrawer();
                      BlocProvider.of<FetchingDataBloc>(context).add(
                          LoadTermsConditionsEvent(
                              termsConditions: TermsConditions(
                                  code: 0, message: '', terms: [])));
                      Navigator.of(context).pushNamed(TermsNdConditions.route);
                    }),
                    drawerWidget(icLogout, 'Log Out', () {
                      Scaffold.of(context).closeDrawer();

                      showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          transitionBuilder: (context, a1, a2, widget) {
                            return ScaleTransition(
                                scale: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: FadeTransition(
                                    opacity: Tween<double>(begin: 0.5, end: 1.0)
                                        .animate(a1),
                                    child: StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        content: SizedBox(
                                          height: 20.h,
                                          width: deviceWidth(context) * 0.778,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Are you sure you want to Log out?',
                                                    style: textStyle12Medium(
                                                            colorBlack)
                                                        .copyWith(height: 1.2)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    yesNoButton(
                                                        'No',
                                                        () => Navigator.of(
                                                                context)
                                                            .pop()),
                                                    yesNoButton('Yes', () {
                                                      signOut();
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/SigIn',
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    }),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )));
                          },
                          pageBuilder: (context, animation1, animation2) {
                            return Container();
                          });

                      // CommonFunction().confirmationDialog(
                      //     context, 'Are you sure you want to Log out?', () {
                      //   signOut();
                      //   Navigator.of(context).pushNamed(SigInPage.route);
                      // });
                    }),
                    SizedBox(height: 1.5.h)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  yesNoButton(String text, Function() onClick) {
    return InkWell(
      splashColor: colorWhite,
      onTap: onClick,
      child: Container(
        height: 5.5.h,
        width: 30.w,
        decoration: BoxDecoration(
            color: text == 'No' ? colorWhite : colorRed,
            borderRadius: BorderRadius.circular(30),
            border:
                text == 'No' ? Border.all(color: colorRed, width: 1) : null),
        alignment: Alignment.center,
        child: Text(text,
            style: textStyle12Bold(text == 'No' ? colorRed : colorWhite)),
      ),
    );
  }

  titles(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 13, left: 4.w),
      child: Text(title, style: textStyle11Medium(colorText7070)),
    );
  }

  drawerWidget(String icon, String title, Function() onClick) {
    return InkWell(
      onTap: onClick,
      splashColor: colorBG,
      child: Ink(
        width: 75.w,
        color: colorWhite,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 6.w),
                child: SizedBox(
                    height: 3.h,
                    width: 6.w,
                    child: icon == icGoldCoin
                        ? Image.asset(icon, width: 5.5.w)
                        : Image.asset(icon, width: 5.w, color: colorText8181)),
              ),
              Text(title, style: textStyle12Bold(colorBlack.withOpacity(0.8)))
            ],
          ),
        ),
      ),
    );
  }
}
