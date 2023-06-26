import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wbc_connect_app/presentations/viewmycontacts.dart';
import 'package:wbc_connect_app/resources/resource.dart';

import 'blocs/fetchingData/fetching_data_bloc.dart';
import 'core/api/api_consts.dart';

class CommonFunction {
  splitString(String value) {
    return value.length == 9
        ? '${value.substring(0, 2)},${value.substring(2, 4)},${value.substring(
        4, 6)},${value.substring(6)}'
        : value.length == 8
        ? '${value.substring(0, 1)},${value.substring(1, 3)},${value.substring(
        3, 5)},${value.substring(5)}'
        : value.length == 7
        ? '${value.substring(0, 2)},${value.substring(2, 4)},${value.substring(
        4)}'
        : value.length == 6
        ? '${value.substring(0, 1)},${value.substring(1, 3)},${value.substring(
        3)}'
        : value.length == 5
        ? '${value.substring(0, 2)},${value.substring(2)}'
        : value.length == 4
        ? '${value.substring(0, 1)},${value.substring(1)}'
        : value;
  }

  successPopup(BuildContext context, String title, String msg, String lottie,
      [String? mobileNo, GlobalKey? globalKey, bool? isShowCase]) {
    print('call popup-------');
    return Dialogs.materialDialog(
      color: colorWhite,
      msg: msg,
      msgAlign: TextAlign.center,
      title: title,
      lottieBuilder: Lottie.asset(
        lottie,
        fit: BoxFit.contain,
      ),
      context: context,
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            if(msg=='Your Family Member has been successfully Added.'){
              print('----=====------isMemberPopup');
              if(!isShowCase!){
                print('----=====-----xxxxx-----------=----$isShowCase');
                ShowCaseWidget.of(context).startShowCase(
                    [globalKey!]);
              }
            }
          },
          child: Container(
            height: 4.5.h,
            width: 30.w,
            decoration: BoxDecoration(
                color: colorRed,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                      color: colorRed.withOpacity(0.35))
                ]),
            alignment: Alignment.center,
            child: Text('Ok', style: textStyle10Bold(colorWhite)),
          ),
        )
      ],
    );
  }

  reachedMaxContactPopup(BuildContext context) {
    print('call popup-------');
    return Dialogs.materialDialog(
      color: colorWhite,
      msg:
      'You have Reached Maximum Limit of contacts. Take This Benefit again in next Month.',
      msgStyle: textStyle11Medium(colorBlack).copyWith(height: 1.3),
      msgAlign: TextAlign.center,
      lottieBuilder: Lottie.asset(
        jsonThankYou,
        fit: BoxFit.contain,
      ),
      context: context,
      actions: [
        Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 4.5.h,
                decoration: BoxDecoration(
                    color: colorRed,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                          color: colorRed.withOpacity(0.35))
                    ]),
                alignment: Alignment.center,
                child: Text('Ok', style: textStyle10Bold(colorWhite)),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ViewMyContacts.route,
                    arguments:
                    ViewScreenData(myContact: ApiUser.myContactsList!));
              },
              child: Container(
                height: 4.5.h,
                // width: 30.w,
                decoration: BoxDecoration(
                    color: colorRed,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                          color: colorRed.withOpacity(0.35))
                    ]),
                alignment: Alignment.center,
                child: Text('View My Referrals',
                    style: textStyle10Bold(colorWhite)),
              ),
            )
          ],
        )
      ],
    );
  }

  selectFormDialog(BuildContext context, String title, List<dynamic> list, Function(dynamic) onSelect) {
    TextEditingController searchController = TextEditingController();
    String filteredItem = '';
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) =>
                        BlocConsumer<FetchingDataBloc, FetchingDataState>(
                          listener: (context, state) {
                            if (title != 'Select Address Type' ||
                                title != 'Select Repository' ||
                                title != 'Select Property Type' ||
                                title != 'Select Parking Type' ||
                                title != 'Select Year' ||
                                title != 'Select Existing Life Cover' ||
                                title != 'Select Gender'||
                                title != 'Select Member') {
                              if (state is StatesLoadedState) {
                                state.states.sort((a, b) =>
                                    a.statename
                                        .trimLeft()
                                        .toLowerCase()
                                        .compareTo(
                                        b.statename.trimLeft().toLowerCase()));
                                list = state.states;
                              }
                              if (state is CountriesLoadedState) {
                                state.countries.sort((a, b) =>
                                    a.countryname
                                        .trimLeft()
                                        .toLowerCase()
                                        .compareTo(
                                        b.countryname.trimLeft()
                                            .toLowerCase()));
                                list = state.countries;
                              }
                              if (state is InsuranceCompanyLoadedState) {
                                state.insuranceCompany.sort((a, b) =>
                                    a
                                        .insuranceCompanyname
                                        .trimLeft()
                                        .toLowerCase()
                                        .compareTo(b.insuranceCompanyname
                                        .trimLeft()
                                        .toLowerCase()));
                                list = state.insuranceCompany;
                              }
                              if (state is LoanBanksLoadedState) {
                                state.loanBanks.sort((a, b) =>
                                    a.bankname
                                        .trimLeft()
                                        .toLowerCase()
                                        .compareTo(
                                        b.bankname.trimLeft().toLowerCase()));
                                list = state.loanBanks;
                              }
                              if (state is InsuranceCategoryLoadedState) {
                                state.insuranceCategory.sort((a, b) =>
                                    a.name
                                        .trimLeft()
                                        .toLowerCase()
                                        .compareTo(
                                        b.name.trimLeft().toLowerCase()));
                                list = state.insuranceCategory;
                              }
                            }
                            print('------list------$list');
                            print('------state------$state');
                          },
                          builder: (context, state) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              content: SizedBox(
                                height: title == 'Select Year' || title == 'Select State' ||
                                    title == 'Select Insurance Company' || title == 'Select Bank'
                                    ? 51.5.h+60
                                    : title == 'Select Member'?(list.length * 54)+60:(list.length * 50)+60,
                                width: 77.8.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 77.8.w,
                                        decoration: const BoxDecoration(
                                            color: colorBG,
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                                        padding: EdgeInsets.only(left: 3.5.w),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(title,
                                                style: textStyle14Bold(colorBlack)),
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                splashColor: colorBG,
                                                splashRadius: 5.5.w,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.close,size: 3.h, color: colorRed))
                                          ],
                                        )),
                                    SizedBox(
                                      height: title == 'Select Year' ||title == 'Select State' ||
                                          title == 'Select Insurance Company' || title == 'Select Bank'
                                          ? 51.5.h
                                          : title == 'Select Member' ? list.length * 54:list.length * 50,
                                      child: title == 'Select Address Type' ||
                                          title == 'Select Repository' ||
                                          title == 'Select Property Type' ||
                                          title == 'Select Parking Type' ||
                                          title == 'Select Year' ||
                                          title == 'Select Existing Life Cover' ||
                                          title == 'Select Relation' ||
                                          title == 'Select Gender'||
                                          title == 'Select Member'
                                      ? ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: list.length, itemBuilder: (context, i) =>
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      onSelect(list[i]);
                                                    },
                                                    child: Container(
                                                      // width: deviceWidth(context) * 0.778,
                                                      color: colorTransparent,
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.symmetric(vertical: title=='Select Member'?1.1.h:2.h),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 3.5.w, right: 2.5.w),
                                                        child: Row(
                                                          children: [
                                                            if(title=='Select Member')
                                                              SizedBox(
                                                                width: deviceWidth(context) * 0.70,
                                                              child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                        height: 33,
                                                                        width: 33,
                                                                        decoration: const BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: colorRed
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                            list[i].name.substring(0, 1).toUpperCase(),
                                                                            style: textStyle11(colorWhite))
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                                                        child: Text("${list[i].name} (${list[i].relation})",
                                                                            style: textStyle10(colorBlack).copyWith(height: 1.2)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if(title!='Select Member')
                                                              Text(list[i],
                                                                style: textStyle11(colorBlack).copyWith(height: 1.2)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (i != list.length - 1)
                                                    Container(
                                                        height: 1,
                                                        color: colorTextBCBC.withOpacity(0.36))
                                                ],
                                              )
                                      ) : state is StatesInitial || state is CountriesInitial || state is LoanBanksInitial || state is InsuranceCompanyInitial || state is InsuranceCategoryInitial
                                       ? Center(
                                        child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(color: colorRed, strokeWidth: 0.7.w)),
                                      ) : state is StatesLoadedState ||
                                          state is CountriesLoadedState ||
                                          state is LoanBanksLoadedState ||
                                          state is InsuranceCompanyLoadedState ||
                                          state is InsuranceCategoryLoadedState ? Column(
                                        children: [
                                          if (title != 'Select Insurance Type')
                                            Container(
                                              height: 6.h,
                                              width: 77.8.w,
                                              decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: colorTextBCBC.withOpacity(0.5),
                                                        offset: const Offset(0, 3),
                                                        blurRadius: 6
                                                    )
                                                  ]),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                    child:
                                                    Image.asset(
                                                        icSearch,
                                                        width:
                                                        5.w),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets
                                                        .only(
                                                        right:
                                                        3.w),
                                                    child: SizedBox(
                                                      width: 56.w,
                                                      child:
                                                      TextFormField(
                                                        controller:
                                                        searchController,
                                                        style: textStyle12(
                                                            colorText7070),
                                                        decoration:
                                                        InputDecoration
                                                            .collapsed(
                                                          hintText:
                                                          'Search ${title.contains('State') ? 'State'
                                                              : title.contains('Country')
                                                              ? 'Country'
                                                              : title.contains('Bank')
                                                              ? 'Bank' : 'Company'}',
                                                          hintStyle: textStyle12(colorText7070),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide.none),
                                                        ),
                                                        onChanged: (val) async {
                                                          filteredItem = val;
                                                          setState(() {});
                                                        },
                                                        keyboardType: TextInputType.name,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          Expanded(
                                            child: ListView.builder(
                                                padding:
                                                EdgeInsets.zero,
                                                itemCount:
                                                list.length,
                                                itemBuilder: (context, i) =>
                                                title == 'Select State'
                                                    ? list[i].statename.toLowerCase().contains(filteredItem.toLowerCase())
                                                    ? blocListView(context, i, title, list, onSelect)
                                                    : Container()
                                                    : title == 'Select Country'
                                                    ? list[i].countryname.toLowerCase().contains(filteredItem.toLowerCase())
                                                    ? blocListView(
                                                    context, i, title, list, onSelect)
                                                    : Container()
                                                    : title == 'Select Insurance Company'
                                                    ? list[i].insuranceCompanyname.toLowerCase().contains(filteredItem.toLowerCase())
                                                    ? blocListView(context, i, title, list, onSelect)
                                                    : Container()
                                                    : title == 'Select Bank'
                                                    ? list[i].bankname.toLowerCase().contains(filteredItem.toLowerCase())
                                                    ? blocListView(context, i, title, list, onSelect)
                                                    : Container()
                                                    : blocListView(context, i, title, list, onSelect)),
                                          ),
                                        ],
                                      ) : Center(
                                          child: Text('No Data Loaded',
                                              style: textStyle13Medium(
                                                  colorBlack))),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  blocListView(BuildContext context, int i, String title, List<dynamic> list, Function(dynamic) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onSelect(title == 'Select Insurance Company'
                ? list[i].insuranceCompanyname.trimLeft()
                : title == 'Select Bank'
                ? list[i].bankname.trimLeft()
                : title == 'Select State'
                ? list[i].statename.trimLeft()
                : title == 'Select Country'
                ? list[i].countryname.trimLeft()
                : title == 'Select Insurance Type'
                ? list[i]
                : list[i]);
          },
          child: Container(
            width: deviceWidth(context) * 0.778,
            color: colorTransparent,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Padding(
              padding: EdgeInsets.only(left: 3.5.w, right: 2.5.w),
              child: Text(
                  title == 'Select Insurance Company'
                      ? list[i].insuranceCompanyname.trimLeft()
                      : title == 'Select Bank'
                      ? list[i].bankname.trimLeft()
                      : title == 'Select State'
                      ? list[i].statename.trimLeft()
                      : title == 'Select Country'
                      ? list[i].countryname.trimLeft()
                      : title == 'Select Insurance Type'
                      ? list[i].name.trimLeft()
                      : list[i],
                  style: textStyle11(colorBlack).copyWith(height: 1.2)),
            ),
          ),
        ),
        if (i != list.length - 1)
          Container(height: 1, color: colorTextBCBC.withOpacity(0.36))
      ],
    );
  }

  errorDialog(BuildContext context, String text) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) =>
                        AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          content: SizedBox(
                            height: 18.h,
                            width: deviceWidth(context) * 0.788,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) * 0.04),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(text,
                                      style: textStyle13Medium(colorBlack)
                                          .copyWith(height: 1.2)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        splashColor: colorWhite,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 5.5.h,
                                          width: 25.w,
                                          decoration: BoxDecoration(
                                              color: colorRed,
                                              borderRadius:
                                              BorderRadius.circular(30)),
                                          alignment: Alignment.center,
                                          child: Text('OK',
                                              style: textStyle12Bold(
                                                  colorWhite)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  confirmationDialog(BuildContext context, String text, Function() onYesClick) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) =>
                        AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          content: SizedBox(
                            height: 20.h,
                            width: deviceWidth(context) * 0.778,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(text,
                                      style: textStyle12Medium(colorBlack)
                                          .copyWith(height: 1.2)),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      yesNoButton(
                                          'No', () =>
                                          Navigator.of(context).pop()),
                                      yesNoButton('Yes', onYesClick),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
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