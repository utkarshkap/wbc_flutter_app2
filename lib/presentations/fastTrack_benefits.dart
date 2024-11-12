// ignore_for_file: non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gallery_3d/gallery3d.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wbc_connect_app/blocs/payuMoneyPayment/payumoney_payment_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/home_screen.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import '../../resources/resource.dart';
import '../blocs/signingbloc/signing_bloc.dart';
import '../core/preferences.dart';
import '../widgets/appbarButton.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class FastTrackBenefits extends StatefulWidget {
  static const route = '/FastTrack-Benefits';

  const FastTrackBenefits({Key? key}) : super(key: key);

  @override
  State<FastTrackBenefits> createState() => _FastTrackBenefitsState();
}

class _FastTrackBenefitsState extends State<FastTrackBenefits> {
  final pageController = PageController();
  final swipeController = SwiperController();
  int index = 0;
  Razorpay razorpay = Razorpay();

  bool isLoading = false;

  List<String> information = [
    '1. Increased brand recognition.',
    '2. Improved marketing communication.',
    '3. Enhanced customer experience.',
    '4. Improved visitors engagement.',
    '5. Higher conversion rate as compared to web.'
  ];

  List<String> fastTrackImages = [
    imgFastTrack1,
    imgFastTrack2,
    imgFastTrack3,
  ];

  _launchCaller() async {
    const url = "tel:7862057414";
    if (await launchUrl(Uri.parse(url))) {
      await canLaunchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    getFastTrackActivationStatus();
    super.initState();
  }

  getFastTrackActivationStatus() async {
    BlocProvider.of<SigningBloc>(context)
        .add(GetUserData(mobileNo: await Preference.getMobNo()));
  }

  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: colorWhite,
          appBar: AppBar(
            toolbarHeight: 8.h,
            backgroundColor: colorWhite,
            elevation: 6,
            shadowColor: colorTextBCBC.withOpacity(0.4),
            leadingWidth: 15.w,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset(icBack, color: colorRed, width: 6.w)),
            titleSpacing: 0,
            title:
                Text('FastTrack Benefits', style: textStyle14Bold(colorBlack)),
            actions: [
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icCall,
                  iconColor: colorText7070,
                  onClick: _launchCaller),
              SizedBox(width: 2.w),
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icNotification,
                  iconColor: colorText7070,
                  onClick: () {
                    Navigator.of(context).pushNamed(NotificationScreen.route);
                  }),
              SizedBox(width: 5.w)
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Gallery3D(
                  itemCount: 3,
                  width: 100.w,
                  height: 52.h,
                  isClip: false,
                  itemConfig: GalleryItemConfig(
                    width: 75.w,
                    height: 52.h,
                    radius: 16,
                    isShowTransformMask: false,
                  ),
                  currentIndex: index,
                  onItemChanged: (i) {
                    setState(() {
                      index = i == 0
                          ? 2
                          : i == 1
                              ? i
                              : 0;
                    });
                  },
                  onClickItem: (index) => print("currentIndex:$index"),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 48.h,
                      margin: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 6, right: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorWhite,
                          boxShadow: [
                            BoxShadow(
                                color: colorTextBCBC.withOpacity(0.7),
                                blurRadius: 6,
                                offset: const Offset(0, 3))
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              fastTrackImages[index],
                              height: 48.h,
                            ),
                            // Text('Secure your personal details',
                            //     textAlign: TextAlign.center,
                            //     style: textStyle22Bold(colorBlack)
                            //         .copyWith(height: 1.2)),
                            // Text(
                            //     'Use these tips to keep your personal information secure offline. Lock your financial and personal documents in a safe place in your home.',
                            //     textAlign: TextAlign.center,
                            //     style: textStyle9Medium(colorText3D3D)
                            //         .copyWith(height: 1.2)),
                          ],
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Center(
                  child: SmoothPageIndicator(
                      controller: PageController(initialPage: index),
                      count: 3,
                      effect: ExpandingDotsEffect(
                          radius: 4.0,
                          dotHeight: 1.7.w,
                          dotWidth: 1.7.w,
                          strokeWidth: 1.5,
                          spacing: 4,
                          dotColor: colorTextBCBC,
                          activeDotColor: colorRed)),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.3.h),
                child: Text('INFORMATION',
                    style:
                        textStyle10Bold(colorText7070).copyWith(height: 1.18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      5,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.3.h),
                            child: Text(information[index],
                                style: textStyle9(colorText7070)
                                    .copyWith(height: 1.18)),
                          )),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              BlocConsumer<SigningBloc, SigningState>(
                listener: (context, state) {
                  if (state is GetUserFailed) {
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
                  if (state is GetUserLoading) {
                    return Center(
                      child: Container(
                        height: 6.5.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: colorRed,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 3),
                                  blurRadius: 6,
                                  color: colorRed.withOpacity(0.35))
                            ]),
                        alignment: Alignment.center,
                        child: Center(
                          child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 0.7.w)),
                        ),
                      ),
                    );
                  } else if (state is GetUserLoaded) {
                    return state.data!.data!.fastTrack
                        ? Container()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });
                              // BlocProvider.of<PayumoneyPaymentBloc>(context)
                              //     .add(
                              //   LoadPayumoneyPaymentEvent(
                              //     amount: fastTrackAmount,
                              //     taxAmount: fastTrackGST,
                              //     txnid: '1',
                              //     email: ApiUser.emailId,
                              //     productinfo: 'Become Merchant',
                              //     firstname: ApiUser.userName,
                              //     user_credentials: ApiUser.emailId,
                              //   ),
                              // );
                              razorpayPayment();

                              setState(() {
                                isLoading = false;
                              });
                              // Navigator.of(context)
                              //     .pushNamed(PayuPayment.route);
                            },
                            child: Center(
                              child: Container(
                                height: 6.5.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                    color: colorRed,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 3),
                                          blurRadius: 6,
                                          color: colorRed.withOpacity(0.35))
                                    ]),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              color: colorWhite,
                                              strokeWidth: 0.7.w))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(icCard,
                                                    color: colorWhite,
                                                    width: 5.w),
                                                SizedBox(width: 3.w),
                                                Text('PAY',
                                                    style: textStyle13Bold(
                                                        colorWhite)),
                                              ],
                                            ),
                                            Text(
                                                '${int.parse(fastTrackAmount) + int.parse(fastTrackGST)} ₹',
                                                style: textStyle13(colorWhite)),
                                          ],
                                        ),
                                ),
                              ),
                            ));
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ));
  }

  Future razorpayPayment() async {
    var options = {
      'key': razorpayKey,
      'amount': ((int.parse(fastTrackAmount) + int.parse(fastTrackGST)) * 100)
          .toString(),
      'name': ApiUser.userName,
      'description': 'Become Merchant',
      'prefill': {'contact': ApiUser.mobileNo, 'email': ApiUser.emailId}
    };
    razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    BlocProvider.of<PayumoneyPaymentBloc>(context).add(UpdateFastTrackUserEvent(
        userId: int.parse(ApiUser.userId),
        mobile: ApiUser.mobileNo,
        date: DateTime.now().toString(),
        paymentAmount: fastTrackAmount,
        taxAmount: fastTrackGST));
    Navigator.of(context).pushReplacementNamed(HomeScreen.route,
        arguments: HomeScreenData(isFastTrackActivate: true));
    // CommonFunction().errorDialog(context, response);
    print(
        "::::::::::::PaymentSuccess::::${response.data}::${response.signature}::::::::::::");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Navigator.pop(context);
    // CommonFunction().errorDialog(context, response['message']);
    print(
        "::::::::::::PaymentErro::::${response.error}::::::${response.message} :: :${response.code}::::::");
  }
}
