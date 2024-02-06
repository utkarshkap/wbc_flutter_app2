import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class ViewAngelHolding extends StatefulWidget {
  static const route = '/View-Angel-Holding';
  const ViewAngelHolding({super.key});

  @override
  State<ViewAngelHolding> createState() => _ViewAngelHoldingState();
}

class _ViewAngelHoldingState extends State<ViewAngelHolding> {
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
                if (state is GetAngelHoldingsErrorState) {
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
                if (state is GetAngelHoldingsInitial) {
                  return Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            color: colorRed, strokeWidth: 0.7.w)),
                  );
                }
                if (state is GetAngelHoldingsLoadedState) {
                  print(
                      "Angel holding screen data::::${state.getAngelHoldings}");
                  // return state.getFyersHoldings.holdings!.isEmpty
                  //     ? Center(
                  //         child: Text('No Data Available',
                  //             style: textStyle13Medium(colorBlack)))
                  //     : SingleChildScrollView(
                  //         child: Padding(
                  //           padding: EdgeInsets.only(
                  //             top: 8.0.h,
                  //           ),

                  //         ),
                  //       );

                  return Text("Sucess");
                }
                return Container();
              },
            )));
  }
}
