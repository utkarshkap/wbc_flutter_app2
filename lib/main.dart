import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/bloc/wealth_meter_bloc.dart';
import 'package:wbc_connect_app/blocs/dashboardbloc/dashboard_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/blocs/insurancecalculator/insurance_calculator_bloc.dart';
import 'package:wbc_connect_app/blocs/signingbloc/signing_bloc.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          BlocProvider(create: (context) => WealthMeterBloc())
        ],
        child: MaterialApp(
          title: 'Finer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: colorRed,
            primarySwatch: Colors.red,
            primaryColorDark: Colors.red,
            // accentColor: Colors.red,
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

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() {
//   final dateString = '2020-06-16T10:31:12.000Z';
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Map> list = [
//     {
//       "time": "2020-06-16T10:31:12.000Z",
//       "message":
//           "P2 BGM-01 HV buiten materieel (Gas lekkage) Franckstraat Arnhem 073631"
//     },
//     {
//       "time": "2020-06-16T10:29:35.000Z",
//       "message": "A1 Brahmslaan 3862TD Nijkerk 73278"
//     },
//     {
//       "time": "2020-06-16T10:29:35.000Z",
//       "message": "A2 NS Station Rheden Dr. Langemijerweg 6991EV Rheden 73286"
//     },
//     {
//       "time": "2020-06-15T09:41:18.000Z",
//       "message": "A2 VWS Utrechtseweg 6871DR Renkum 74636"
//     },
//     {
//       "time": "2020-06-14T09:40:58.000Z",
//       "message":
//           "B2 5623EJ : Michelangelolaan Eindhoven Obj: ziekenhuizen 8610 Ca CATH route 522 PAAZ Rit: 66570"
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ListView.builder(
//             itemCount: list.length,
//             itemBuilder: (_, index) {
//               bool isSameDate = true;
//               final String dateString = list[index]['time'];
//               final DateTime date = DateTime.parse(dateString);
//               final item = list[index];
//               if (index == 0) {
//                 isSameDate = false;
//               } else {
//                 final String prevDateString = list[index - 1]['time'];
//                 final DateTime prevDate = DateTime.parse(prevDateString);
//                 isSameDate = date.isSameDate(prevDate);
//               }
//               if (index == 0 || !(isSameDate)) {
//                 return Column(children: [
//                   Text(date.formatDate()),
//                   ListTile(title: Text('item $index'))
//                 ]);
//               } else {
//                 return ListTile(title: Text('item $index'));
//               }
//             }),
//       ),
//     );
//   }
// }

// const String dateFormatter = 'MMMM dd, y';

// extension DateHelper on DateTime {
//   String formatDate() {
//     final formatter = DateFormat(dateFormatter);
//     return formatter.format(this);
//   }

//   bool isSameDate(DateTime other) {
//     return this.year == other.year &&
//         this.month == other.month &&
//         this.day == other.day;
//   }

//   int getDifferenceInDaysWithNow() {
//     final now = DateTime.now();
//     return now.difference(this).inDays;
//   }
// }
