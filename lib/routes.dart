import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wbc_connect_app/presentations/FAQs_screen.dart';
import 'package:wbc_connect_app/presentations/M_Gain/M_Gain_Investment.dart';
import 'package:wbc_connect_app/presentations/M_Gain/M_Gain_Ledger.dart';
import 'package:wbc_connect_app/presentations/NRI_carnival/nri_carnival_screen.dart';
import 'package:wbc_connect_app/presentations/Payment/request_payment.dart';
import 'package:wbc_connect_app/presentations/Payment/withdraw_amount.dart';
import 'package:wbc_connect_app/presentations/Real_Estate/real_estate_property.dart';
import 'package:wbc_connect_app/presentations/Review/add_member_details.dart';
import 'package:wbc_connect_app/presentations/Review/connect_brokers.dart';
import 'package:wbc_connect_app/presentations/Review/emi_sip_calculator.dart';
import 'package:wbc_connect_app/presentations/Review/history.dart';
import 'package:wbc_connect_app/presentations/Review/insurance_calculator.dart';
import 'package:wbc_connect_app/presentations/Review/insurance_investment.dart';
import 'package:wbc_connect_app/presentations/Review/loan_EMI.dart';
import 'package:wbc_connect_app/presentations/Review/loan_investment.dart';
import 'package:wbc_connect_app/presentations/Review/munafe_ki_class.dart';
import 'package:wbc_connect_app/presentations/Review/mutual_funds_investment.dart';
import 'package:wbc_connect_app/presentations/Review/mutual_funds_transaction.dart';
import 'package:wbc_connect_app/presentations/Review/my_MF.dart';
import 'package:wbc_connect_app/presentations/Review/my_investment.dart';
import 'package:wbc_connect_app/presentations/Review/my_policy.dart';
import 'package:wbc_connect_app/presentations/Review/my_stocks.dart';
import 'package:wbc_connect_app/presentations/Review/retirement_calculator.dart';
import 'package:wbc_connect_app/presentations/Review/stocks_investment.dart';
import 'package:wbc_connect_app/presentations/Review/track_investments.dart';
import 'package:wbc_connect_app/presentations/Review/verification_member.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/add_new_address.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/buy_now_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/cart_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/expand_category.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/order_history.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_category.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/product_details_screen.dart';
import 'package:wbc_connect_app/presentations/brokers_api/5paisa/view_5paisa_holdings.dart';
import 'package:wbc_connect_app/presentations/brokers_api/ICICI/view_icici_holding.dart';
import 'package:wbc_connect_app/presentations/brokers_api/ICICI/webview_ICICI.dart';
import 'package:wbc_connect_app/presentations/brokers_api/angel/view_angel_holding.dart';
import 'package:wbc_connect_app/presentations/brokers_api/angel/webview_angel.dart';
import 'package:wbc_connect_app/presentations/brokers_api/fyers/view_fyers_holding.dart';
import 'package:wbc_connect_app/presentations/brokers_api/5paisa/webview_5paisa.dart';
import 'package:wbc_connect_app/presentations/brokers_api/IIFL/webview_IIFL.dart';
import 'package:wbc_connect_app/presentations/brokers_api/fyers/weview_fyers.dart';
import 'package:wbc_connect_app/presentations/delete_account/delete_account_screen.dart';
import 'package:wbc_connect_app/presentations/emisip_cal_result.dart';
import 'package:wbc_connect_app/presentations/fastTrack_benefits.dart';
import 'package:wbc_connect_app/presentations/gold_point_history_screen.dart';
import 'package:wbc_connect_app/presentations/home_screen.dart';
import 'package:wbc_connect_app/presentations/Real_Estate/real_estate_screen.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/pay_nd_send.dart';
import 'package:wbc_connect_app/presentations/payu_payment.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/presentations/sigIn_screen.dart';
import 'package:wbc_connect_app/presentations/social_login.dart';
import 'package:wbc_connect_app/presentations/splash_screen.dart';
import 'package:wbc_connect_app/presentations/stock_investment_transaction.dart';
import 'package:wbc_connect_app/presentations/terms_nd_condition.dart';
import 'package:wbc_connect_app/presentations/vender_bill_pay.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/wbc_mega_mall.dart';
import 'package:wbc_connect_app/presentations/viewmycontacts.dart';
import 'package:wbc_connect_app/presentations/wbc_connect.dart';
import 'package:wbc_connect_app/presentations/wbc_progress.dart';
import 'package:wbc_connect_app/presentations/wealth_meter.dart';
import 'presentations/Review/sip_calculator.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  final arguments = routeSettings.arguments;
  switch (routeSettings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );

    case '/SigIn':
      return MaterialPageRoute(
        builder: (_) => const SigInPage(),
      );

    case '/Verification-OTP':
      final verificationData = arguments as VerificationScreenData;
      return MaterialPageRoute(
        builder: (_) =>
            VerificationScreen(verificationScreenData: verificationData),
      );

    case '/Home-Screen':
      final data = arguments as HomeScreenData;
      return MaterialPageRoute(
        builder: (_) => ShowCaseWidget(
          builder: Builder(builder: (context) => HomeScreen(data)),
        ),
      );

    case '/Profile-Screen':
      return MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      );

    case '/MyContact-Screen':
      final data = arguments as ViewScreenData;
      return MaterialPageRoute(
        builder: (_) => ViewMyContacts(viewScreenData: data),
      );

    case '/WBC-Connect':
      // final connectData = arguments as WBCConnectData;
      return MaterialPageRoute(
        builder: (_) => WBCConnect(
            // connectData: connectData
            ),
      );

    case '/WBC-Progress':
      return MaterialPageRoute(
        builder: (_) => const WBCProgress(),
      );

    case '/Wealth-Meter-Screen':
      return MaterialPageRoute(
        builder: (_) => const WealthMeterScreen(),
      );

    case '/WBC-Mega-Mall':
      return MaterialPageRoute(
        builder: (_) => const WbcMegaMall(),
      );

    case '/Product-Category':
      final category = arguments as CategoryData;
      return MaterialPageRoute(
        builder: (_) => ProductCategoryScreen(category: category),
      );

    case '/Expand-Category':
      final categoryData = arguments as ExpandCategoryData;
      return MaterialPageRoute(
        builder: (_) => ExpandCategory(categoryData: categoryData),
      );

    case '/Product-Detail':
      final data = arguments as ProductDetailData;
      return MaterialPageRoute(
        builder: (_) => ProductDetailScreen(data: data),
      );

    case '/Cart-Screen':
      return MaterialPageRoute(
        builder: (_) => const CartScreen(),
      );

    case '/BuyNow-Screen':
      final data = arguments as BuyNowData;
      return MaterialPageRoute(
        builder: (_) => BuyNowScreen(data: data),
      );

    case '/Add-New-Address':
      final data = arguments as AddNewAddressData;
      return MaterialPageRoute(
        builder: (_) => AddNewAddress(data: data),
      );

    case '/Order-History':
      final isOrdered = arguments as OrderHistoryData;
      return MaterialPageRoute(
        builder: (_) => OrderHistory(data: isOrdered),
      );

    case '/Real-Estate-Screen':
      return MaterialPageRoute(
        builder: (_) => const RealEstateScreen(),
      );

    case '/Real-Estate-Property':
      return MaterialPageRoute(
        builder: (_) => const RealEstateProperty(),
      );

    case '/Loan-EMI-Review':
      return MaterialPageRoute(
        builder: (_) => const LoanEMIReview(),
      );

    case '/Policy-Review':
      return MaterialPageRoute(
        builder: (_) => const PolicyReview(),
      );

    case '/Review-History':
      return MaterialPageRoute(
        builder: (_) => const ReviewHistory(),
      );

    case '/Review-Investment':
      return MaterialPageRoute(
        builder: (_) => const InvestmentReview(),
      );

    case '/MF-Review':
      final data = arguments as MFReviewScreenData;
      return MaterialPageRoute(
        builder: (_) => MFReviewScreen(mfReviewScreenData: data),
      );

    case '/Stocks-Review':
      return MaterialPageRoute(
        builder: (_) => const StocksReview(),
      );

    case '/Track-Investment':
      return MaterialPageRoute(
        builder: (_) => const TrackInvestments(),
      );

    case '/Add-Member-Details':
      final data = arguments as AddMemberDetailsData;
      return MaterialPageRoute(
        builder: (_) => AddMemberDetails(addMemberDetailsData: data),
      );

    case '/Verification-Member':
      final data = arguments as VerificationMemberData;
      return MaterialPageRoute(
          builder: (_) => VerificationMember(verificationMemberData: data));

    case '/mGain-Investment':
      return MaterialPageRoute(
        builder: (_) => const MGainInvestmentScreen(),
      );

    case '/mGain-Ledger':
      return MaterialPageRoute(
        builder: (_) => const MGainLedgerScreen(),
      );

    case '/Mutual-Funds-Investment':
      return MaterialPageRoute(
        builder: (_) => const MutualFundsInvestment(),
      );

    case '/Stocks-Investment':
      return MaterialPageRoute(
        builder: (_) => const StocksInvestment(),
      );

    case '/Insurance-Investment':
      final insuranceInvestmentData = arguments as InsuranceInvestmentData;
      return MaterialPageRoute(
        builder: (_) => InsuranceInvestmentScreen(
            insuranceInvestmentData: insuranceInvestmentData),
      );

    case '/Loan-Investment':
      return MaterialPageRoute(
        builder: (_) => const LoanInvestmentScreen(),
      );

    case '/Insurance-Calculator':
      return MaterialPageRoute(
        builder: (_) => InsuranceCalculator(),
      );

    case '/EMISIP-Calculator-result':
      return MaterialPageRoute(
        builder: (_) => EMISIPCalculatorResult(),
      );

    case '/Munafe-Ki-Class':
      return MaterialPageRoute(
        builder: (_) => const MunafeKiClassScreen(),
      );

    case '/FAQs':
      return MaterialPageRoute(
        builder: (_) => const FAQs(),
      );

    case '/Terms-Conditions':
      return MaterialPageRoute(
        builder: (_) => const TermsNdConditions(),
      );

    case '/Pay-Send':
      return MaterialPageRoute(
        builder: (_) => const PayNdSend(),
      );

    case '/FastTrack-Benefits':
      return MaterialPageRoute(
        builder: (_) => const FastTrackBenefits(),
      );

    case '/Vendor-Bill-Pay':
      return MaterialPageRoute(
        builder: (_) => const VendorBillPay(),
      );

    case '/Request-Payment':
      return MaterialPageRoute(
        builder: (_) => const RequestPayment(),
      );

    case '/Withdraw-Amount':
      final data = arguments as WithdrawAmountData;
      return MaterialPageRoute(
        builder: (_) => WithdrawAmount(withdrawAmountData: data),
      );

    case '/Notification-Screen':
      return MaterialPageRoute(
        builder: (_) => const NotificationScreen(),
      );

    case '/Social-Login':
      final socialLoginData = arguments as SocialLoginData;
      return MaterialPageRoute(
        builder: (_) => SocialLogin(socialLoginData: socialLoginData),
      );

    case '/Mutual-Funds-Transaction':
      return MaterialPageRoute(
        builder: (_) => const MutualFundsTransaction(),
      );

    case '/Connect-Brokers':
      return MaterialPageRoute(
        builder: (_) => const ConnectBrokers(),
      );

    case '/Payu-Payment':
      return MaterialPageRoute(
        builder: (_) => const PayuPayment(),
      );

    case '/Webview-Fyers':
      return MaterialPageRoute(
        builder: (_) => const WebviewFyers(),
      );

    case '/Webview-5Paisa':
      return MaterialPageRoute(
        builder: (_) => const Webview5Paisa(),
      );

    case '/Webview-IIFL':
      return MaterialPageRoute(
        builder: (_) => const WebviewIIFL(),
      );
    case '/Webview-Angel':
      return MaterialPageRoute(
        builder: (_) => const WebViewAngel(),
      );
    case '/View-Angel-Holding':
      return MaterialPageRoute(
        builder: (_) => const ViewAngelHolding(),
      );
    case '/Webview-ICICI':
      return MaterialPageRoute(
        builder: (_) => const WebViewICICI(),
      );
    case '/View-ICICI-Holding':
      return MaterialPageRoute(
        builder: (_) => const ViewICICIHolding(),
      );
    case '/View-Holding':
      return MaterialPageRoute(
        builder: (_) => const ViewFyersHolding(),
      );

    case '/View-5Paisa-Holding':
      return MaterialPageRoute(
        builder: (_) => const View5PaisaHoldings(),
      );

    case '/Stock-Investment-Transaction':
      return MaterialPageRoute(
        builder: (_) => const StockInvestmentTransaction(),
      );

    case '/SIP-Calculator':
      return MaterialPageRoute(
        builder: (_) => SIPCalculator(),
      );

    case '/EMISIP-Calculator':
      return MaterialPageRoute(
        builder: (_) => EMISIPCalculator(),
      );

    case '/Retirement-Calculator':
      final data = arguments as RetirementCalculatorData;
      return MaterialPageRoute(
        builder: (_) => RetirementCalculator(retirementCalculatorData: data),
      );
    case '/gold-point-history':
      final data = arguments as GoldPointHistoryData;
      return MaterialPageRoute(
        builder: (_) => GoldPointHistoryScreen(goldPointHistoryData: data),
      );
    case '/delete-account':
      return MaterialPageRoute(
        builder: (_) => const DeleteAccountScreen(),
      );
    case '/nri-carnival':
      return MaterialPageRoute(
        builder: (_) => const NRICarnivalScreen(),
      );

    default:
      return MaterialPageRoute(builder: (_) => Container());
  }
}
