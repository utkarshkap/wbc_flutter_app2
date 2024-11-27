import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/presentations/verification_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class NRICarnivalScreen extends StatefulWidget {
  static const route = '/nri-carnival';
  const NRICarnivalScreen({super.key});

  @override
  State<NRICarnivalScreen> createState() => _NRICarnivalScreenState();
}

class _NRICarnivalScreenState extends State<NRICarnivalScreen> {
  String mono = "";
  @override
  void initState() {
    getMobNog();
    super.initState();
  }

  getMobNog() async {
    mono = await Preference.getMobNo();
    setState(() {});
    print('mono-----$mono');
  }

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
              title: Text('NRI Carnival', style: textStyle14Bold(colorBlack)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'NRI Carnival-VIII',
                              style: textStyle28Bold(colorBlack),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              'From 20th Nov, 2024 To 31st March, 2025',
                              style: textStyle10Bold(colorSplashBG),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.5.h,
                      ),
                      Text(
                        'What is NRI CARNIVAL ?',
                        style: textStyle13Bold(colorBlack),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "NRI CARNIVAL is the Campaigin for NRI's as they visit India during the period of November to March. The Motive of Campaign is to reach them and help them to make their investments fruitful, give them proper advice, manage their portfolios well and with expertise, provide a safe and sound platform in India and maximize their returns.",
                        style: textStyle13Medium(colorBlack),
                      ),
                      SizedBox(
                        height: 3.5.h,
                      ),
                      Text(
                        'What is the Need of NRI CARNIVAl ?',
                        style: textStyle13Bold(colorBlack),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "As we know, that KA PD Service and M-GAIN is becoming necessity of each and every investment portfolio and for NRI's it is more worthy as in abroad the ROI is quite low as compared to India. Through NRI CARNIVAL, the intention is to pass the information, and bring awareness amongst the investors worldwide.",
                        style: textStyle13Medium(colorBlack),
                      ),
                      SizedBox(
                        height: 3.5.h,
                      ),
                      Text(
                        'Benefits Of Participating in NRI CARNIVAl ?',
                        style: textStyle13Bold(colorBlack),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                          "On Each NRI Reference, participants get 250 Gold Points once the reference gets Approved.",
                          style: textStyle13Medium(colorBlack)),
                      SizedBox(
                        height: 6.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            if (GpDashBoardData.availableContacts != 0) {
                              Preference.setRenewContact(true);
                              Navigator.of(context).pushNamed(
                                  VerificationScreen.route,
                                  arguments: VerificationScreenData(
                                      getNumber: "",
                                      number: mono,
                                      verificationId: "",
                                      isLogin: true,
                                      isNRICarnivalPage: true,
                                      selectedContact:
                                          GpDashBoardData.availableContacts!,
                                      isHomeContactOpen: true));
                            } else {
                              CommonFunction().reachedMaxContactPopup(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                                color: color3061,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'CONTINUE',
                              style: textStyle13Bold(colorWhite),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            )));
  }
}
