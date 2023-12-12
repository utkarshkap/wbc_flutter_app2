import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wbc_connect_app/blocs/signingbloc/signing_bloc.dart';
import 'package:wbc_connect_app/core/preferences.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const route = '/delete-account';
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool deleteAccount = false;
  signOut() async {
    await auth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    relationType = ['Father', 'Mother', 'Husband', 'Wife', 'Son', 'Daughter'];
    setState(() {});
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
                    if (deleteAccount == false) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/SigIn', (Route<dynamic> route) => false);
                    }
                  },
                  icon: Image.asset(icBack, color: colorRed, width: 6.w)),
              titleSpacing: 0,
              title: Text(
                  deleteAccount == false ? 'Delete account' : 'Account Deleted',
                  style: textStyle14Bold(colorBlack)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deleteAccount == false) ...[
                          Text("app, we're sorry to see you go",
                              style: textStyle15Bold(colorBlack)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              "Are you sure you want to delete your account? You'll lose Your all investment data.",
                              style: textStyle14(colorBlack)),
                          SizedBox(
                            height: 3.h,
                          ),
                          BlocConsumer<SigningBloc, SigningState>(
                            listener: (context, state) {
                              if (state is DeleteUserAccountDataAdded) {
                                if (state.code == 200) {
                                  setState(() {
                                    deleteAccount = true;
                                    signOut();
                                  });
                                }
                              }
                            },
                            builder: (context, state) {
                              return InkWell(
                                  onTap: () async {
                                    BlocProvider.of<SigningBloc>(context).add(
                                        DeleteUserAccount(
                                            mobileNo:
                                                await Preference.getMobNo()));
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 6.5.h,
                                    decoration: BoxDecoration(
                                        color: colorRed,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 3),
                                              blurRadius: 6,
                                              color: colorRed.withOpacity(0.35))
                                        ]),
                                    alignment: Alignment.center,
                                    child: Text('Delete Account',
                                        style: textStyle13Bold(colorWhite)),
                                  ));
                            },
                          ),
                        ] else ...[
                          SizedBox(
                            height: 3.h,
                          ),
                          Text("We've closed your account",
                              style: textStyle15Bold(colorBlack)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              "Your Finer account is now closed,Your account is queued for deletion. It will be deleted after 24 hours.",
                              style: textStyle14(colorBlack)),
                        ]
                      ],
                    ),
                  )),
            )));
  }

  yesNoButton(String text, Function() onClick) {
    return InkWell(
      splashColor: colorWhite,
      onTap: onClick,
      child: Container(
        height: 5.5.h,
        width: 30.w,
        decoration: BoxDecoration(
            color: text == 'No' ? colorWhite : colorRed,
            borderRadius: BorderRadius.circular(30),
            border:
                text == 'No' ? Border.all(color: colorRed, width: 1) : null),
        alignment: Alignment.center,
        child: Text(text,
            style: textStyle12Bold(text == 'No' ? colorRed : colorWhite)),
      ),
    );
  }
}
