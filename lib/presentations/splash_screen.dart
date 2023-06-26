import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/presentations/sigIn_screen.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
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
          microseconds: 10,
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
                Expanded(flex: 7, child: Image.asset(imgSplashLogo)),
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
                Image.asset(icIndicator, width: deviceWidth(context) * 0.13),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                    'Made in India',
                    textAlign: TextAlign.center,
                    style: textStyle18(colorWhite)
                ),
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
                                    ? BlocProvider.of<SigningBloc>(context).add(GetUserData(mobileNo: mono))
                                    : null
                                : Navigator.of(context).pushNamed(SigInPage.route);
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
                                    color: Color(0x00000029)
                                )
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
                              : Text('GET STARTED', style: textStyle13Bold(colorWhite)
                          ),
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
