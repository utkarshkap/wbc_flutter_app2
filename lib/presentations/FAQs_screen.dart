import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';

import '../blocs/fetchingData/fetching_data_bloc.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class FAQs extends StatefulWidget {
  static const route = '/FAQs';

  const FAQs({Key? key}) : super(key: key);

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  List<bool> queOpenList = [];

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
          title: Text('FAQs', style: textStyle14Bold(colorBlack)),
          actions: [
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
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is FAQLoadedState) {
              setState(() {
                queOpenList =
                    List.generate(state.faq.questions.length, (index) => false);
              });
            }
            if (state is FAQErrorState) {
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
            if (state is FAQInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            } else if (state is FAQLoadedState) {
              return state.faq.questions.isEmpty
                  ? Center(
                      child: Text('No Data Available',
                          style: textStyle13Medium(colorBlack)))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                            state.faq.questions.length,
                            (index) => queAnsView(
                                    queOpenList[index],
                                    index + 1,
                                    state.faq.questions[index].question,
                                    state.faq.questions[index].answer, () {
                                  setState(() {
                                    queOpenList[index] = !queOpenList[index];
                                  });
                                })),
                      ),
                    );
            }
            return Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                      color: colorRed, strokeWidth: 0.7.w)),
            );
          },
        ),
      ),
    );
  }

  queAnsView(bool isSelect, int index, String question, String answer,
      Function() onOpen) {
    print(
        '-----index----$index-----${answer.length}----${(answer.length / 52)}--=---${(answer.length / 52).ceil()}---==---${(answer.length / 52).ceil() * 20}');
    print(
        '-----index----$index-----${question.length}----${(question.length / 35)}--=---${(question.length / 35).ceil()}---==---${(question.length / 35).ceil() * 37}');
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      height: isSelect
          ? max(
              4 * 20.0 + 55,
              ((answer.length / 50).ceil() * 20) +
                  ((question.length / 35).ceil() * 10) +
                  65)
          : (question.length / 35).ceil() == 1
              ? 60
              : (((question.length / 35).ceil() * 10) + 60),
      decoration: BoxDecoration(color: colorWhite, boxShadow: [
        BoxShadow(
            color: colorTextBCBC.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 6))
      ]),
      margin: const EdgeInsets.only(bottom: 3),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('0$index. ', style: textStyle13(colorRed))),
                  Expanded(
                    flex: 8,
                    child: Text(question, style: textStyle13Bold(colorRed)),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        constraints: BoxConstraints(minWidth: 4.w),
                        padding: EdgeInsets.zero,
                        onPressed: onOpen,
                        icon: Image.asset(isSelect ? icMinus : icAdd,
                            width: 4.w, color: colorTextBCBC)),
                  )
                ],
              ),
              if (isSelect) SizedBox(height: 1.h),
              if (isSelect)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 8,
                      child: Text(answer,
                          style:
                              textStyle9(colorText7070).copyWith(height: 1.2)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
