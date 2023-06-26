import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class VendorBillPay extends StatefulWidget {
  static const route = '/Vendor-Bill-Pay';

  const VendorBillPay({Key? key}) : super(key: key);

  @override
  State<VendorBillPay> createState() => _VendorBillPayState();
}

class _VendorBillPayState extends State<VendorBillPay> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBoxGradiant0040,
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
          title: Text('Vendor Bill Pay', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {}),
            SizedBox(width: 5.w)
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 76.h,
                        width: 90.w,
                        decoration: decoration(colorWhite, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 4.h),
                                  Text('Transfer Success',
                                      style: textStyle15Bold(colorBlack)),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 50.w,
                                    ),
                                    decoration: BoxDecoration(
                                        color: colorF2F2,
                                        borderRadius: BorderRadius.circular(50)),
                                    padding: EdgeInsets.symmetric(vertical: 1.1.h),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 2.w),
                                        CircleAvatar(
                                          radius: 2.5.w,
                                          backgroundColor: colorF2F2,
                                          child: Image.asset(icProfile,
                                              color: colorText7070),
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                            child: Text('User name',
                                                style: textStyle11(colorBlack)
                                                    .copyWith(height: 1.2))),
                                        SizedBox(width: 2.w),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Transaction done on ',
                                          style: textStyle10(colorText3D3D),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '1 July 2022.',
                                                style: textStyle10Bold(colorRed)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 0.6.h),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Your reference number is ',
                                          style: textStyle10(colorText3D3D),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '764358',
                                                style: textStyle10(colorText3D3D)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 76.h-30.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(txtCongrats, height: 6.h),
                                  Image.asset(imgSportsGold, height: 12.h),
                                  Text('You have earned',
                                      style: textStyle11(colorText7070)),
                                  Column(
                                    children: [
                                      Text('GP.25000', style: textStyle22(colorTextFFC1)),
                                      SizedBox(height: 0.5.h),
                                      Text('WBC Gold Points',
                                          style: textStyle11Bold(colorBlack)),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 6.5.h,
                                        width: 80.w,
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
                                        child: Text('SUBMIT',
                                            style: textStyle13Bold(colorWhite)),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          top: -6.5.h,
                          child: Container(
                            height: 13.h,
                            width: 13.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorBoxGradiant0040,
                                border: Border.all(
                                    color: colorBoxGradiant0040, width: 2.w)),
                            child: Image.asset(icPaymentSuccess, fit: BoxFit.fill),
                          )),
                      Positioned(
                        top: 25.h,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 2.5.h,
                              backgroundColor: colorBoxGradiant0040,
                            ),
                            SizedBox(width: 1.w),
                            DottedBorder(
                              borderType: BorderType.Rect,
                              color: colorTextBCBC,
                              padding: EdgeInsets.zero,
                              strokeWidth: 2,
                              dashPattern: const [15, 15],
                              child: SizedBox(
                                width: 78.w,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            CircleAvatar(
                              radius: 2.5.h,
                              backgroundColor: colorBoxGradiant0040,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Lottie.asset(
                jsonPaymentSuccess,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor, double radius) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (bgColor == colorRed)
            BoxShadow(
                color: colorRed.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 3))
        ]);
  }
}
