import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import '../../../models/get_5Paisa_holding_model.dart';
import '../../../resources/colors.dart';
import '../../../resources/icons.dart';
import '../../../resources/styles.dart';

class View5PaisaHoldings extends StatefulWidget {
  static const route = '/View-5Paisa-Holding';
  const View5PaisaHoldings({Key? key}) : super(key: key);

  @override
  State<View5PaisaHoldings> createState() => _View5PaisaHoldingsState();
}

class _View5PaisaHoldingsState extends State<View5PaisaHoldings> {
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
            title: Text('View 5Paisa Holdings',
                style: textStyle14Bold(colorBlack)),
          ),
          body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
            listener: (context, state) {
              if (state is Get5PaisaAccessTokenErrorState) {
                AwesomeDialog(
                  btnCancelColor: colorRed,
                  padding: EdgeInsets.zero,
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  headerAnimationLoop: false,
                  title: 'Something Went Wrong Get5PaisaAccessToken',
                  btnOkOnPress: () {},
                  btnOkColor: Colors.red,
                ).show();
              }
            },
            builder: (context, state) {
              if (state is Get5PaisaAccessTokenLoadedState) {
                print("AccessToken*************->${state.accessToken}");
                if (state.accessToken != null && state.accessToken != "") {
                  print("AccessToken->${state.accessToken}");
                  BlocProvider.of<FetchingDataBloc>(context).add(
                      Load5PaisaHoldingsEvent(
                          get5PaisaHolding: Get5PaisaHoldingModel(),
                          clientCode: state.clientId.toString(),
                          accessToken: state.accessToken.toString()));
                }
              }
              return BlocConsumer<FetchingDataBloc, FetchingDataState>(
                listener: (context, state) {
                  if (state is Get5PaisaHoldingsErrorState) {
                    AwesomeDialog(
                      btnCancelColor: colorRed,
                      padding: EdgeInsets.zero,
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      headerAnimationLoop: false,
                      title: 'Something Went Wrong HoldingsError',
                      btnOkOnPress: () {},
                      btnOkColor: Colors.red,
                    ).show();
                  }
                },
                builder: (context, state) {
                  if (state is Get5PaisaHoldingsInitial) {
                    return Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                              color: colorRed, strokeWidth: 0.7.w)),
                    );
                  }
                  if (state is Get5PaisaHoldingsLoadedState) {
                    return state.get5PaisaHolding.body!.data!.isEmpty
                        ? Center(
                            child: Text("No record found",
                                style: textStyle13Medium(colorBlack)))
                        : Center(
                            child: Text("Success",
                                style: textStyle13Medium(colorBlack)));
                  }
                  return Container();
                },
              );
            },
          ),
        ));
  }
}
