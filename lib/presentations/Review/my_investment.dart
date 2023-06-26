import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/presentations/Real_Estate/real_estate_screen.dart';
import 'package:wbc_connect_app/presentations/Review/loan_EMI.dart';
import 'package:wbc_connect_app/presentations/Review/track_investments.dart';
import 'package:wbc_connect_app/widgets/appbarButton.dart';

import '../../resources/resource.dart';
import '../profile_screen.dart';
import 'my_policy.dart';
import 'my_stocks.dart';

class InvestmentReview extends StatefulWidget {
  static const route = '/Review-Investment';

  const InvestmentReview({Key? key}) : super(key: key);

  @override
  State<InvestmentReview> createState() => _InvestmentReviewState();
}

class _InvestmentReviewState extends State<InvestmentReview> {
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
              Text('Review My Investment', style: textStyle14Bold(colorBlack)),
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
                onClick: () {Navigator.of(context).pushNamed(ProfileScreen.route);}),
            SizedBox(width: 5.w)
          ],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colorRed, colorBoxGradiant3333])),
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.h, bottom: 9.h),
                    child: Column(
                      children: [
                        Text('What do you want to review?',
                            style: textStyle20Bold(colorWhite)),
                        SizedBox(height: 1.5.h),
                        SizedBox(
                          width: 80.w,
                          child: Text(
                              'It\'s a Service under which Guidance for New Investment and Review of your old Investment',
                              textAlign: TextAlign.center,
                              style:
                                  textStyle9(colorE5E5).copyWith(height: 1.18)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
            Positioned(
                top: 15.h,
                child: Column(
                  children: [
                    Container(
                      width: 90.w,
                      decoration: decoration(),
                      child: Column(
                        children: [
                          reviews(
                              icStockPortfolio,
                              colorF9C1,
                              'Review My Stock Portfolio',
                              () => Navigator.of(context)
                                  .pushNamed(StocksReview.route)),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          reviews(icMutualFundsInvestment, colorFB83,
                              'Review My Mutual Funds', () {
                            Navigator.of(context)
                                .pushNamed(TrackInvestments.route);
                          }),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          reviews(icDollar, color6C6C, 'Review Loan EMI',
                             () {
                            Navigator.of(context)
                                .pushNamed(LoanEMIReview.route);
                          }),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          reviews(
                              icHome,
                              color47D1,
                              'Review Real Estate Investment',
                              () => Navigator.of(context)
                                  .pushNamed(RealEstateScreen.route)),
                          Container(
                              height: 1,
                              color: colorTextBCBC.withOpacity(0.36)),
                          reviews(
                              icSecure,
                              color9C8B,
                              'Review Your Insurance',
                              () => Navigator.of(context).pushNamed(PolicyReview.route)),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
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

  reviews(String icon, Color bgColor, String title,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 3.w),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          color: colorWhite,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Container(
                  height: 5.5.h,
                  width: 5.5.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(icon,
                      color: colorWhite,
                      height: icon == icMutualFundsInvestment || icon == icHome
                          ? 2.2.h
                          : 2.5.h),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textStyle11Bold(colorBlack)),
                  SizedBox(height: 0.7.h),
                  Row(
                    children: [
                      Text('Get ', style: textStyle8(colorText7070)),
                      Image.asset(icDollarCoin, width: 2.5.w),
                      SizedBox(width: 1.w),
                      Text('100 Redeemable Gold Points in your wallet',
                          style: textStyle8(colorText7070)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Image.asset(icNext, color: colorTextBCBC, height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
