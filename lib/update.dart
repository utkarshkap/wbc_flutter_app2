// package_info_plus
// url_launcher

// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:package_info_plus/package_info_plus.dart';
// class UpdateChecker {
//   static Future<void> checkForUpdate(BuildContext context) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String currentVersion = packageInfo.version;

//     // Simulate fetching the latest version from server or Firebase Remote Config
//     String latestVersion = "2.0.0"; // example hardcoded

//     if (currentVersion != latestVersion) {
//       showUpdateDialog(context);
//     }
//   }

//   static void showUpdateDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // force update if needed
//       builder: (context) => AlertDialog(
//         title: Text("Update Available"),
//         content: Text("A new version of the app is available. Please update to continue."),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               const url = "https://yourappstorelink.com"; // Replace with your store URL
//               if (await canLaunch(url)) {
//                 await launch(url);
//               }
//             },
//             child: Text("Update"),
//           ),
//           // Optionally allow skip:
//           // TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Later")),
//         ],
//       ),
//     );
//   }
// }


// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     UpdateChecker.checkForUpdate(context);
//   });
// }

// You can integrate Firebase Remote Config to dynamically change the latestVersion.

// For mandatory updates, skip the "Later" button.

// For Android, store link: https://play.google.com/store/apps/details?id=com.yourapp.id

// For iOS: https://apps.apple.com/app/idYOUR_APP_ID
// --------



//------------------------------------ push  -------------------------------------------------------

// https://www.youtube.com/watch?v=cyTRyYdpKRA&t=108s
// https://www.youtube.com/watch?v=k0zGEbiDJcQ




//----------------------------------------------------------- net ----------------------------------------------------


// <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

// <key>NSAppTransportSecurity</key>
// <dict>
//   <key>NSAllowsArbitraryLoads</key>
//   <true/>
// </dict>


// dependencies:
//   flutter_bloc: ^8.1.4
//   connectivity_plus: ^6.0.3
//   internet_connection_checker: ^1.0.0+1


// ✅ connectivity_event.dart

// abstract class ConnectivityEvent {}

// class ConnectivityChanged extends ConnectivityEvent {}


// ✅ connectivity_state.dart

// enum ConnectivityStatus { connected, disconnected }

// class ConnectivityState {
//   final ConnectivityStatus status;
//   const ConnectivityState(this.status);
// }

// ✅ connectivity_bloc.dart


// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'connectivity_event.dart';
// import 'connectivity_state.dart';

// class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
//   late StreamSubscription _subscription;

//   ConnectivityBloc() : super(const ConnectivityState(ConnectivityStatus.connected)) {
//     _subscription = Connectivity().onConnectivityChanged.listen((_) {
//       add(ConnectivityChanged());
//     });
//     on<ConnectivityChanged>((event, emit) async {
//       final hasConnection = await InternetConnectionChecker().hasConnection;
//       emit(ConnectivityState(hasConnection
//           ? ConnectivityStatus.connected
//           : ConnectivityStatus.disconnected));
//     });
//     // Initial check
//     add(ConnectivityChanged());
//   }

//   @override
//   Future<void> close() {
//     _subscription.cancel();
//     return super.close();
//   }
// }

// ---- Provide the BLoC at the App Root

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'connectivity_bloc.dart';
// import 'connectivity_event.dart';
// import 'global_network_banner.dart';
// import 'home_page.dart';

// void main() {
//   runApp(
//     BlocProvider(
//       create: (_) => ConnectivityBloc(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: GlobalNetworkBanner(
//         child: HomePage(),
//       ),
//     );
//   }
// }


// Create the Global Network Banner Widget
// ✅ global_network_banner.dart


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'connectivity_bloc.dart';
// import 'connectivity_state.dart';

// class GlobalNetworkBanner extends StatelessWidget {
//   final Widget child;

//   const GlobalNetworkBanner({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         child,
//         BlocBuilder<ConnectivityBloc, ConnectivityState>(
//           builder: (context, state) {
//             if (state.status == ConnectivityStatus.disconnected) {
//               return Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: SafeArea(
//                   child: Container(
//                     color: Colors.red,
//                     padding: const EdgeInsets.all(12),
//                     child: const Center(
//                       child: Text(
//                         'No Internet Connection',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
// }


