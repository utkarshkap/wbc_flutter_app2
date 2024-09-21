import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/presentations/home_screen.dart';

import '../blocs/payuMoneyPayment/payumoney_payment_bloc.dart';
import '../common_functions.dart';
import '../core/api/api_consts.dart';
import '../resources/colors.dart';
import '../resources/icons.dart';
import '../resources/styles.dart';

class PayuPayment extends StatefulWidget {
  static const route = '/Payu-Payment';

  const PayuPayment({Key? key}) : super(key: key);

  @override
  State<PayuPayment> createState() => _Payu_paymentState();
}

class _Payu_paymentState extends State<PayuPayment> {
  @override
  Widget build(BuildContext context) {
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
            title: Text('Payu Payment', style: textStyle14Bold(colorBlack)),
          ),
          body: BlocConsumer<PayumoneyPaymentBloc, PayumoneyPaymentState>(
            listener: (context, state) {
              if (state is PayumoneyHashKeyErrorState) {
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
              if (state is PayumoneyHashKeyLoadedState) {
                if (state.customPayumoneyHashkeyModel.paymentHash != null &&
                    state.customPayumoneyHashkeyModel.paymentHash != "") {
                  // BlocProvider.of<PayumoneyPaymentBloc>(context)
                  //     .add(UpdateFastTrackUserEvent(
                  //   userId: int.parse(ApiUser.userId),
                  //   mobile: ApiUser.mobileNo,
                  //   date: DateTime.now().toString(),
                  //   paymentAmount: fastTrackAmount,
                  //   taxAmount: fastTrackGST,
                  // ));
                  payuPayment(state.customPayumoneyHashkeyModel.paymentHash);
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text('Loading...',
                          style: textStyle14Medium(colorBlack))),
                ],
              );
            },
          ),
        ));
  }

  Future<void> payuPayment(String paymentHash) async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    var response = await PayumoneyProUnofficial.payUParams(
      email: ApiUser.emailId,
      firstName: ApiUser.userName,
      merchantName: ApiUser.userName,
      isProduction: true,
      merchantKey: merchantKey,
      merchantSalt: merchantSalt,
      amount: (int.parse(fastTrackAmount) + int.parse(fastTrackGST)).toString(),
      productInfo: 'Become Merchant', // Enter Product Name
      transactionId: orderId,
      hashUrl: paymentHash.toString(),
      userCredentials: ApiUser.emailId,
      showLogs: true,
      userPhoneNumber: ApiUser.mobileNo,
    );

    print("response pay==> ${response}");
    if (response['status'] == PayUParams.success) {
      BlocProvider.of<PayumoneyPaymentBloc>(context).add(
          UpdateFastTrackUserEvent(
              userId: int.parse(ApiUser.userId),
              mobile: ApiUser.mobileNo,
              date: DateTime.now().toString(),
              paymentAmount: fastTrackAmount,
              taxAmount: fastTrackGST));
      // Preference.setFastTrackStatus(true);
      Navigator.of(context).pushReplacementNamed(HomeScreen.route,
          arguments: HomeScreenData(isFastTrackActivate: true));
      CommonFunction().errorDialog(context, response['message']);
    }
    if (response['status'] == PayUParams.failed) {
      print("fail=== ");
      Navigator.pop(context);
      CommonFunction().errorDialog(context, response['message']);
    }
  }
}
