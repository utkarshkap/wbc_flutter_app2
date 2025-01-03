import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/addBrokersHoldingData/add_brokers_holding_data_bloc.dart';
import 'package:wbc_connect_app/blocs/brokers/brokers_bloc.dart';
import 'package:wbc_connect_app/blocs/dashboardbloc/dashboard_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/blocs/insurancecalculator/insurance_calculator_bloc.dart';
import 'package:wbc_connect_app/blocs/signingbloc/signing_bloc.dart';
import 'package:wbc_connect_app/blocs/wealthMeter/wealth_meter_bloc.dart';
import 'package:wbc_connect_app/routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'blocs/InsuranceInvestment/insurance_investment_bloc.dart';
import 'blocs/MFInvestments/mf_investments_bloc.dart';
import 'blocs/MFTransaction/mf_transaction_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/deletefamilymember/delete_family_member_bloc.dart';
import 'blocs/emisipcalculator/emisip_calculator_bloc.dart';
import 'blocs/mall/mall_bloc.dart';
import 'blocs/order/order_bloc.dart';
import 'blocs/payuMoneyPayment/payumoney_payment_bloc.dart';
import 'blocs/retirementcalculator/retirement_calculator_bloc.dart';
import 'blocs/review/review_bloc.dart';
import 'blocs/sipcalculator/sip_calculator_bloc.dart';
import 'blocs/stockInvestmentTransaction/stock_investment_transaction_bloc.dart';
import 'resources/colors.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize local notifications plugin
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/finer_logo');

  // // iOS initialization settings
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // runApp(
  //   DevicePreview(
  //     enabled: true,-
  //     tools: const [
  //       ...DevicePreview.defaultTools,
  //       // const CustomPlugin(),
  //     ],
  //     builder: (context) => const MyApp(),
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SigningBloc(),
          ),
          BlocProvider(
            create: (context) => DashboardBloc(),
          ),
          BlocProvider(
            create: (context) => MallBloc(),
          ),
          BlocProvider(
            create: (context) => FetchingDataBloc(),
          ),
          BlocProvider(
            create: (context) => CartBloc(),
          ),
          BlocProvider(
            create: (context) => OrderBloc(),
          ),
          BlocProvider(
            create: (context) => ReviewBloc(),
          ),
          BlocProvider(
            create: (context) => MFTransactionBloc(),
          ),
          BlocProvider(
            create: (context) => InsuranceCalculatorBloc(),
          ),
          BlocProvider(
            create: (context) => DeleteFamilyMemberBloc(),
          ),
          BlocProvider(
            create: (context) => PayumoneyPaymentBloc(),
          ),
          BlocProvider(
            create: (context) => StockTransactionBloc(),
          ),
          BlocProvider(
            create: (context) => MFInvestmentsBloc(),
          ),
          BlocProvider(
            create: (context) => InsuranceInvestmentBloc(),
          ),
          BlocProvider(
            create: (context) => SIPCalculatorBloc(),
          ),
          BlocProvider(
            create: (context) => EMISIPCalculatorBloc(),
          ),
          BlocProvider(
            create: (context) => RetirementCalculatorBloc(),
          ),
          BlocProvider(create: (context) => WealthMeterBloc()),
          BlocProvider(create: (context) => BrokersBloc()),
          BlocProvider(create: (context) => AddBrokersHoldingDataBloc())
        ],
        child: MaterialApp(
          title: 'Finer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: colorRed,
            primarySwatch: Colors.red,
            primaryColorDark: Colors.red,
            backgroundColor: Colors.white,
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: colorRed,
                selectionColor: colorRedFFC,
                selectionHandleColor: colorRedFFC),
          ),
          onGenerateRoute: onGenerateRoute,
        ),
      );
    });
  }
}
