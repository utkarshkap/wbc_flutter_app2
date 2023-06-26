import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../resources/resource.dart';
import '../../thousandsSeparatorInputFormatter.dart';
import '../../widgets/appbarButton.dart';
import '../../blocs/emisipcalculator/emisip_calculator_bloc.dart';

class EMISIPCalculatorResult extends StatefulWidget {
  static const route = '/EMISIP-Calculator-result';

  @override
  State<EMISIPCalculatorResult> createState() => _EMISIPCalculatorResultState();
}

class _EMISIPCalculatorResultState extends State<EMISIPCalculatorResult> {

  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset  : true,
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
          title: Text('EMI SIP Calculator Result', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<EMISIPCalculatorBloc, EMISIPCalculatorState>(
          listener: (context, state) {
            print('EMISIPCalculatorState-------$state');
            if (state is EMISIPCalculatorFailed)   {
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
            if (state is EMISIPCalculatorAdded) {
              return Column(
                children: [
                  SizedBox(
                    height: 4.h,
                  ),

                  Table(
                    border: TableBorder.all(color: colorBG),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE5E5),
                        children: [
                          Container(
                            height: 5.3.h,
                            alignment: Alignment.center,
                            child: Text('EMI Amount',
                                textAlign: TextAlign.center,
                                style: textStyle10Bold(colorBlack)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Table(
                    border: TableBorder.all(color: colorE5E5),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: List<TableRow>.generate(
                      1, (index) {
                      return TableRow(
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        children: [
                          Container(
                            height: 43,
                            alignment: Alignment.center,
                            child: Text(
                                state.emiAmount.toString(),
                                textAlign: TextAlign.left,
                                style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                          ),
                        ],
                      );
                    },
                      growable: false,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),

                  Table(
                    border: TableBorder.all(color: colorBG),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE5E5),
                        children: [
                          Container(
                            height: 5.3.h,
                            alignment: Alignment.center,
                            child: Text('SIP Amount',
                                textAlign: TextAlign.center,
                                style: textStyle10Bold(colorBlack)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Table(
                    border: TableBorder.all(color: colorE5E5),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: List<TableRow>.generate(
                      1, (index) {
                      return TableRow(
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        children: [
                          Container(
                            height: 43,
                            alignment: Alignment.center,
                            child: Text(
                                state.sipAmount.toString(),
                                textAlign: TextAlign.left,
                                style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                          ),
                        ],
                      );
                    },
                      growable: false,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),

                  Table(
                    border: TableBorder.all(color: colorBG),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE5E5),
                        children: [
                          Container(
                            height: 5.3.h,
                            alignment: Alignment.center,
                            child: Text('Interest Amount',
                                textAlign: TextAlign.center,
                                style: textStyle10Bold(colorBlack)),
                          ),
                         /* Container(
                            height: 5.3.h,
                            alignment: Alignment.center,
                            child: Text('Total Payable Amount',
                                textAlign: TextAlign.center,
                                style: textStyle10Bold(colorBlack)),
                          ),*/
                        ],
                      )
                    ],
                  ),
                  Table(
                    border: TableBorder.all(color: colorE5E5),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: List<TableRow>.generate(
                      1, (index) {
                      return TableRow(
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        children: [
                          Container(
                            height: 43,
                            alignment: Alignment.center,
                            child: Text(
                                formatter.format(double.parse(state.interestAmount)),
                                textAlign: TextAlign.left,
                                style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                          ),
                         /* Container(
                            height: 43,
                            alignment: Alignment.center,
                            child: Text(
                                formatter.format(double.parse(state.totalPayableAmount)),
                                textAlign: TextAlign.left,
                                style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                          ),*/
                        ],
                      );
                    },
                      growable: false,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),

                  Table(
                    border: TableBorder.all(color: colorBG),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE5E5),
                        children: [
                         Container(
                            height: 5.3.h,
                            alignment: Alignment.center,
                            child: Text('Total Payable Amount',
                                textAlign: TextAlign.center,
                                style: textStyle10Bold(colorBlack)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Table(
                    border: TableBorder.all(color: colorE5E5),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(1),
                    },
                    children: List<TableRow>.generate(
                      1, (index) {
                      return TableRow(
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        children: [
                          Container(
                            height: 43,
                            alignment: Alignment.center,
                            child: Text(
                                formatter.format(double.parse(state.totalPayableAmount)),
                                textAlign: TextAlign.left,
                                style: textStyle11Bold(colorRedFF6).copyWith(height: 1.2)),
                          ),
                        ],
                      );
                    },
                      growable: false,
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

}