import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';

import '../../../models/get_fyers_holdings_model.dart';
import '../../../resources/colors.dart';
import '../../../resources/icons.dart';
import '../../../resources/styles.dart';

class ViewFyersHolding extends StatefulWidget {
  static const route = '/View-Holding';
  const ViewFyersHolding({Key? key}) : super(key: key);

  @override
  State<ViewFyersHolding> createState() => _ViewFyersHoldingState();
}

class _ViewFyersHoldingState extends State<ViewFyersHolding> {
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
            title: Text('View Holdings', style: textStyle14Bold(colorBlack)),
          ),
          body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
            listener: (context, state) {
              if (state is GetFyersAccessTokenErrorState) {
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
              if (state is GetFyersAccessTokenLoadedState) {
                if (state.getFyersAccessToken.data!.accessToken != null &&
                    state.getFyersAccessToken.data!.accessToken != "") {
                  print(
                      "AccessToken->${state.getFyersAccessToken.data!.accessToken}");
                  BlocProvider.of<FetchingDataBloc>(context).add(
                      LoadFyersHoldingsEvent(
                          getFyersHoldings: GetFyersHoldingsModel(),
                          fyersAccessToken: state
                              .getFyersAccessToken.data!.accessToken
                              .toString()));
                }
              }
              return BlocConsumer<FetchingDataBloc, FetchingDataState>(
                listener: (context, state) {
                  if (state is GetFyersHoldingsErrorState) {
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
                  if (state is GetFyersHoldingsInitial) {
                    return Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                              color: colorRed, strokeWidth: 0.7.w)),
                    );
                  }
                  if (state is GetFyersHoldingsLoadedState) {
                    return state.getFyersHoldings.holdings!.isEmpty
                        ? Center(
                            child: Text('No Data Available',
                                style: textStyle13Medium(colorBlack)))
                        : SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8.0.h,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        icFyers,
                                        height: 15.h,
                                      ),
                                    ),
                                    ...List.generate(
                                        state.getFyersHoldings.holdings!.length,
                                        (index) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3.h,
                                                  horizontal: 5.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  cRichText(
                                                      'Holding Type:- ',
                                                      state
                                                          .getFyersHoldings
                                                          .holdings![index]
                                                          .holdingType!),
                                                  cRichText(
                                                      'Quantity:- ',
                                                      state
                                                          .getFyersHoldings
                                                          .holdings![index]
                                                          .quantity
                                                          .toString()),
                                                  cRichText(
                                                      'Cost Price:- ',
                                                      state
                                                          .getFyersHoldings
                                                          .holdings![index]
                                                          .costPrice
                                                          .toString()),
                                                  cRichText(
                                                      'PL:- ',
                                                      state.getFyersHoldings
                                                          .holdings![index].pl
                                                          .toString()),
                                                  // Text(
                                                  //     "PL:- ${state.getFyersHoldings.holdings![index].pl}"),
                                                ],
                                              ),
                                            )),
                                  ]),
                            ),
                          );
                  }
                  return Container();
                },
              );
            },
          ),
        ));
  }

  cRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        text: title,
        style: textStyle12Bold(colorBlack),
        children: <TextSpan>[
          TextSpan(text: value, style: textStyle11Bold(colorText7070)),
        ],
      ),
    );
  }
}
