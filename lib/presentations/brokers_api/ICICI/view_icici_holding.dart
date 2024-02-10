import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/models/get_icici_session_token_model.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class ViewICICIHolding extends StatefulWidget {
  static const route = '/View-ICICI-Holding';
  const ViewICICIHolding({super.key});

  @override
  State<ViewICICIHolding> createState() => _ViewICICIHoldingState();
}

class _ViewICICIHoldingState extends State<ViewICICIHolding> {
  // late StreamController<int> stream_controller;

  // @override
  // void initState() {
  //   super.initState();
  //   stream_controller = StreamController<int>.broadcast();
  // }

  // @override
  // void dispose() {
  //   stream_controller.close();
  //   super.dispose();
  // }

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
              if (state is GetICICISessionTokenErrorState) {
                print("ERROR:::::${state.error}");
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
              if (state is GetICICISessionTokenLoadedState) {
                print(
                    "RESPONSE:::::::::::::::::${state.getIciciSessionToken.success}");
                if (state.getIciciSessionToken.success!.sessionToken != null &&
                    state.getIciciSessionToken.success!.sessionToken != "") {
                  print(
                      "AccessToken->${state.getIciciSessionToken.success!.sessionToken}");
                  // BlocProvider.of<FetchingDataBloc>(context).add(
                  //     LoadFyersHoldingsEvent(
                  //         getFyersHoldings: GetFyersHoldingsModel(),
                  //         fyersAccessToken: state
                  //             .getFyersAccessToken.data!.accessToken
                  //             .toString()));
                }
              }

              return Center(
                child: Text("SUCESS"),
              );
              // return BlocConsumer<FetchingDataBloc, FetchingDataState>(
              //   listener: (context, state) {
              //     if (state is GetFyersHoldingsErrorState) {
              //       AwesomeDialog(
              //         btnCancelColor: colorRed,
              //         padding: EdgeInsets.zero,
              //         context: context,
              //         dialogType: DialogType.error,
              //         animType: AnimType.rightSlide,
              //         headerAnimationLoop: false,
              //         title: 'Something Went Wrong',
              //         btnOkOnPress: () {},
              //         btnOkColor: Colors.red,
              //       ).show();
              //     }
              //   },
              //   builder: (context, state) {
              //     if (state is GetFyersHoldingsInitial) {
              //       return Center(
              //         child: SizedBox(
              //             height: 25,
              //             width: 25,
              //             child: CircularProgressIndicator(
              //                 color: colorRed, strokeWidth: 0.7.w)),
              //       );
              //     }
              //     if (state is GetFyersHoldingsLoadedState) {
              //       return state.getFyersHoldings.holdings!.isEmpty
              //           ? Center(
              //               child: Text('No Data Available',
              //                   style: textStyle13Medium(colorBlack)))
              //           : SingleChildScrollView(
              //               child: Padding(
              //                 padding: EdgeInsets.only(
              //                   top: 8.0.h,
              //                 ),
              //                 child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Align(
              //                         alignment: Alignment.center,
              //                         child: Image.asset(
              //                           icFyers,
              //                           height: 15.h,
              //                         ),
              //                       ),
              //                     ]),
              //               ),
              //             );
              //     }
              //     return Container();
              //   },
              // );
            },
          ),
        ));
  }
}
