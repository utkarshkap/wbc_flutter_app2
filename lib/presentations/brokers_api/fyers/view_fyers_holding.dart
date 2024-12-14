import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/blocs/addBrokersHoldingData/add_brokers_holding_data_bloc.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/models/add_broker_holdings_data_model.dart';
import 'package:wbc_connect_app/models/stock_investment_model.dart';
import 'package:wbc_connect_app/presentations/Review/stocks_investment.dart';

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
  var data = <AddbrokerholdingsModel>[];
  bool isSubmit = false;
  double totalHoldingQty = 0;
  double totalHoldingAmount = 0;

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
                    totalHoldingQty = 0;
                    totalHoldingAmount = 0;
                    for (int i = 0;
                        i < state.getFyersHoldings.holdings!.length;
                        i++) {
                      totalHoldingQty += state
                          .getFyersHoldings.holdings![i].quantity!
                          .toDouble();
                      totalHoldingAmount += (state
                              .getFyersHoldings.holdings![i].quantity!
                              .toDouble() *
                          state.getFyersHoldings.holdings![i].marketVal!
                              .toDouble());
                    }
                    return state.getFyersHoldings.holdings!.isEmpty
                        ? Center(
                            child: Text('No Data Available',
                                style: textStyle13Medium(colorBlack)))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      icFyers,
                                      height: 15.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    width: 90.w,
                                    decoration: decoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: ListView.builder(
                                              itemCount: state.getFyersHoldings
                                                  .holdings!.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    reviews(
                                                        state
                                                            .getFyersHoldings
                                                            .holdings![index]
                                                            .holdingType!,
                                                        state
                                                            .getFyersHoldings
                                                            .holdings![index]
                                                            .quantity
                                                            .toString(),
                                                        color47D1,
                                                        (state
                                                                .getFyersHoldings
                                                                .holdings![
                                                                    index]
                                                                .quantity! *
                                                            state
                                                                .getFyersHoldings
                                                                .holdings![
                                                                    index]
                                                                .marketVal!)),
                                                    if (index !=
                                                        state
                                                                .getFyersHoldings
                                                                .holdings!
                                                                .length -
                                                            1)
                                                      Container(
                                                          height: 1,
                                                          color: colorTextBCBC
                                                              .withOpacity(
                                                                  0.36))
                                                  ],
                                                );
                                              }),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 1,
                                                  color: colorTextBCBC
                                                      .withOpacity(0.36)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w,
                                                    vertical: 1.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Qty Total',
                                                            style: textStyle10Bold(
                                                                colorText7070)),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                          CommonFunction()
                                                              .splitString(
                                                                  totalHoldingQty
                                                                      .toStringAsFixed(
                                                                          0)),
                                                          style:
                                                              textStyle11Bold(
                                                                  colorBlack),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Investment',
                                                            style: textStyle10Bold(
                                                                colorText7070)),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                          '₹${CommonFunction().splitString(totalHoldingAmount.toStringAsFixed(0))}',
                                                          style:
                                                              textStyle11Bold(
                                                                  colorBlack),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: BlocConsumer<AddBrokersHoldingDataBloc,
                                      AddBrokersHoldingDataState>(
                                    listener: (context, state1) {
                                      if (state1
                                          is AddBrokersHoldingDataFailed) {
                                        setState(() {
                                          isSubmit = false;
                                        });
                                      }
                                      if (state1
                                          is AddBrokersHoldingDataLoaded) {
                                        setState(() {
                                          isSubmit = false;
                                        });
                                        BlocProvider.of<FetchingDataBloc>(
                                                context)
                                            .add(LoadStockInvestmentEvent(
                                                userId: ApiUser.userId,
                                                investmentPortfolio:
                                                    StockInvestmentModel(
                                                  code: 0,
                                                  message: '',
                                                  portfolio: 0,
                                                  investment: 0,
                                                  gain: 0,
                                                  balanceAmount: 0,
                                                  stocks: [],
                                                )));
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                StocksInvestment.route);
                                      }
                                    },
                                    builder: (context, state1) {
                                      return Center(
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSubmit = true;
                                              });
                                              state.getFyersHoldings.holdings!
                                                  .forEach((element) {
                                                data.add(AddbrokerholdingsModel(
                                                    brokerId: 1,
                                                    userId: int.parse(
                                                        ApiUser.userId),
                                                    symbol: element.symbol,
                                                    quantity: element.quantity,
                                                    rate: element.costPrice,
                                                    isin: element.isin));
                                              });
                                              BlocProvider.of<
                                                          AddBrokersHoldingDataBloc>(
                                                      context)
                                                  .add(
                                                      AddBrokerholdingsDataEvent(
                                                          holdings: data));
                                            },
                                            child: Container(
                                              height: 6.5.h,
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                  color: colorRed,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 3),
                                                        blurRadius: 6,
                                                        color: colorRed
                                                            .withOpacity(0.35))
                                                  ]),
                                              alignment: Alignment.center,
                                              child: isSubmit
                                                  ? SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: colorWhite,
                                                              strokeWidth:
                                                                  0.6.w))
                                                  : Text('Continue',
                                                      style: textStyle12Bold(
                                                          colorWhite)),
                                            )),
                                      );
                                    },
                                  ),
                                ),
                              ]);
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

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.9),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }

  reviews(
    String title,
    String value,
    Color textColor,
    var percentageVal,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 3.w),
      child: Container(
        color: colorWhite,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 65.w,
                    child: Text(title, style: textStyle10Bold(colorBlack))),
                SizedBox(height: 0.7.h),
                Row(
                  children: [
                    Text('Qty: ', style: textStyle9Bold(colorText7070)),
                    Text(value, style: textStyle9Bold(colorText7070)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                    CommonFunction()
                        .splitString(percentageVal.toStringAsFixed(2)),
                    style: textStyle9Bold(colorText7070)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
