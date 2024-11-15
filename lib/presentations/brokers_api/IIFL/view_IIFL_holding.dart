import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/add_broker_holdings_data_model.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class ViewIIFLHolding extends StatefulWidget {
  static const route = '/View-IIFL-Holding';

  const ViewIIFLHolding({super.key});

  @override
  State<ViewIIFLHolding> createState() => _ViewIIFLHoldingState();
}

class _ViewIIFLHoldingState extends State<ViewIIFLHolding> {
  var data = <AddbrokerholdingsModel>[];

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
                  BlocProvider.of<FetchingDataBloc>(context)
                      .add(AddBrokerholdingsEvent(holdings: data));
                },
                icon: Image.asset(icBack, color: colorRed, width: 6.w)),
            titleSpacing: 0,
            title:
                Text('View IIFL Holdings', style: textStyle14Bold(colorBlack)),
          ),
          body: WillPopScope(
            onWillPop: () async {
              BlocProvider.of<FetchingDataBloc>(context)
                  .add(AddBrokerholdingsEvent(holdings: data));
              return true;
            },
            child: BlocConsumer<FetchingDataBloc, FetchingDataState>(
              listener: (context, state) {
                print("FAILi-----------------------------");

                if (state is IIFLHoldingFailed) {
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
                if (state is IIFLHoldingitial) {
                  print("INITIL-----------------------------");
                  return Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            color: colorRed, strokeWidth: 0.7.w)),
                  );
                }
                if (state is IIFLHoldingLoaded) {
                  print("LOADED-----------------------------");

                  state.iiflHoldingData.body!.data!.forEach((element) {
                    data.add(AddbrokerholdingsModel(
                        brokerId: 3,
                        userId: int.parse(ApiUser.userId),
                        symbol: element.fullName,
                        quantity: element.quantity,
                        rate: element.currentPrice,
                        isin: element.bseCode.toString()));
                  });

                  BlocProvider.of<FetchingDataBloc>(context)
                      .add(AddBrokerholdingsEvent(holdings: data));
                  return state.iiflHoldingData.body!.data!.isEmpty
                      ? Center(
                          child: Text('No Data Available',
                              style: textStyle13Medium(colorBlack)))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 2.0.h,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      icIifl,
                                      height: 15.h,
                                    ),
                                  ),
                                  ...List.generate(
                                      state.iiflHoldingData.body!.data!.length,
                                      (index) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h, horizontal: 5.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                cRichText(
                                                    'Symbol Type:- ',
                                                    state
                                                        .iiflHoldingData
                                                        .body!
                                                        .data![index]
                                                        .fullName!),
                                                cRichText(
                                                    'Quantity:- ',
                                                    state.iiflHoldingData.body!
                                                        .data![index].quantity
                                                        .toString()),
                                                cRichText(
                                                    'Current Price:- ',
                                                    state
                                                        .iiflHoldingData
                                                        .body!
                                                        .data![index]
                                                        .currentPrice
                                                        .toString()),
                                                // cRichText(
                                                //     'PL:- ',
                                                //     state.getFyersHoldings
                                                //         .holdings![index].pl
                                                //         .toString()),
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
            ),
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
