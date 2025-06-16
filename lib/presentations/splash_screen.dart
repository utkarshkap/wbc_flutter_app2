import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/presentations/sigIn_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';

import '../blocs/mall/mall_bloc.dart';
import '../blocs/signingbloc/signing_bloc.dart';
import '../core/handler.dart';
import '../models/cart_model.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/trending_data_model.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogin = false;
  bool isAddContact = false;
  bool isHomeLogin = false;
  bool isGetData = false;
  String mono = "";
  String email = "";
  int selectedContact = 0;
  DatabaseHelper helper = DatabaseHelper();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void getCartData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CartItem>?> cartList = helper.getCartDataList();
      cartList.then((data) {
        if (data!.isNotEmpty) {
          setState(() {
            cartItemList = data;
          });
        }
        print('----cartItemList----$cartItemList');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoginValue();
    getCartData();
    _requestPermission();
    firebaseMessaging.getToken().then((value) {
      print("FCM Token: $value");
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Received message in the foreground: ${message.notification?.title}");

      // Show proper notification for foreground messages
      if (message.notification != null) {
        _showNotification(
            title: message.notification!.title ?? 'No title',
            body: message.notification!.body ?? 'No body');
      }
    });

    // Handle when app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked in background: ${message.notification?.title}");

      // Handle background message
      _handleMessage(message);
    });

    // Handle when the app is launched from a terminated state by clicking the notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
            "App opened from a terminated state: ${message.notification?.title}");
        _handleMessage(message);
      }
    });
  }

  // Request notification permission
  void _requestPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Handle the background and terminated messages
  void _handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showNotification(
        title: message.notification!.title ?? 'No title',
        body: message.notification!.body ?? 'No body',
      );
    }
  }

  // Show system notification using flutter_local_notifications
  void _showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'This_over_channel', // channel id
            'High Importance Notifications', // channel name
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            icon: '@mipmap/finer_logo');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: IOSNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  getLoginValue() async {
    isLogin = await Preference.getIsLogin();
    isAddContact = await Preference.getIsContact();
    mono = await Preference.getMobNo();
    email = await Preference.getEmail();

    print("mono-->$mono");
    print("isLogin-->$isLogin");
    print("email-->$email");

    Timer(
        const Duration(
          microseconds: 1000000,
          // milliseconds: 100
        ),
        () => isLogin
            ? mono.isNotEmpty
                ? BlocProvider.of<SigningBloc>(context)
                    .add(GetUserData(mobileNo: mono))
                : null
            : null);

    print('mono------$mono');
    print('isAddcont------$isAddContact');
    print('isHomeLogin------$isHomeLogin');

    ApiUser.userId = await Preference.getUserId();
    ApiUser.emailId = await Preference.getEmail();
    ApiUser.mobileNo = await Preference.getMobNo();

    print('email-----${ApiUser.emailId}');
    setState(() {});
    print('isLogin------$isLogin');
  }

  Future<void> fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    await remoteConfig.fetchAndActivate();

    ApiUser.wbcMall = remoteConfig.getString('wbc_mall');
    ApiUser.wbcGp = remoteConfig.getString('wbc_gp');
    print(
        'Remote Config wbcMall: ${ApiUser.wbcMall}-----wbcGp ${ApiUser.wbcGp}');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: BlocConsumer<SigningBloc, SigningState>(
        listener: (context, state) {
          if (isLogin && !isHomeLogin) {
            if (state is GetUserLoaded) {
              selectedContact = state.data!.data!.availableContacts;
              ApiUser.userName = state.data!.data!.name;
              ApiUser.userDob = state.data!.data!.dob.toString();
              ApiUser.myContactsList = state.data!.goldReferrals;
              ApiUser.termNdCondition = state.data!.data!.tnc;

              print('MyRefferal List------${state.data!.goldReferrals}');

              /*ApiUser.myContactsList = state.data!.goldReferrals;
              ApiUser.emailId = state.data!.data!.email;
              */
              BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                  popular: Popular(code: 0, message: '', products: []),
                  newArrival: NewArrival(code: 0, message: '', products: []),
                  trending: Trending(code: 0, message: '', products: [])));
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.route, (route) => false,
                  arguments: HomeScreenData());

              /*if (state.data!.data!.availableContacts == 0) {
                ApiUser.myContactsList = state.data!.goldReferrals;
                ApiUser.emailId = state.data!.data!.email;
                BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                    popular: Popular(code: 0, message: '', products: []),
                    newArrival: NewArrival(code: 0, message: '', products: []),
                    trending: Trending(code: 0, message: '', products: [])));
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.route, (route) => false,
                    arguments: HomeScreenData());
              } else {
                Navigator.of(context).pushReplacementNamed(
                    VerificationScreen.route,
                    arguments: VerificationScreenData(
                        getNumber: "",
                        number: mono,
                        verificationId: "",
                        selectedContact: selectedContact,
                        isLogin: true));
              }
              print('splash-----selected contact no-------$selectedContact');*/
            }
          }
        },
        builder: (context, state) {
          return Container(
            height: deviceHeight(context),
            width: deviceWidth(context),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage(imgSplashBG),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  colorSplashBG.withOpacity(0.9), BlendMode.darken),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7.h,
                ),
                Expanded(
                    flex: 7,
                    child: Image.asset(
                      imgSplashLogo,
                      width: 70.w,
                    )),
                SizedBox(
                  height: 5.h,
                ),
                Expanded(
                  flex: 2,
                  child: Text('Welcome\nFiner',
                      textAlign: TextAlign.center,
                      style: textStyle24(colorWhite).copyWith(height: 1.2)),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Image.asset(icIndicator, width: deviceWidth(context) * 0.13),
                SizedBox(
                  height: 10.h,
                ),
                Text('Made in India',
                    textAlign: TextAlign.center,
                    style: textStyle18(colorWhite)),
                SizedBox(
                  height: 1.5.h,
                ),
                isLogin
                    ? Container()
                    : InkWell(
                        onTap: () {
                          if (isHomeLogin) {
                            BlocProvider.of<MallBloc>(context).add(
                                LoadMallDataEvent(
                                    popular: Popular(
                                        code: 0, message: '', products: []),
                                    newArrival: NewArrival(
                                        code: 0, message: '', products: []),
                                    trending: Trending(
                                        code: 0, message: '', products: [])));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HomeScreen.route, (route) => false,
                                arguments: HomeScreenData());
                          } else {
                            isLogin
                                ? mono.isNotEmpty
                                    ? BlocProvider.of<SigningBloc>(context)
                                        .add(GetUserData(mobileNo: mono))
                                    : null
                                : Navigator.of(context)
                                    .pushNamed(SigInPage.route);
                          }
                        },
                        child: Container(
                          height: 6.5.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              color: colorRed,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Color(0x00000029))
                              ]),
                          alignment: Alignment.center,
                          child: state is GetUserLoading
                              ? Center(
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: colorWhite,
                                          strokeWidth: 0.7.w)))
                              : Text('GET STARTED',
                                  style: textStyle13Bold(colorWhite)),
                        ),
                      ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
