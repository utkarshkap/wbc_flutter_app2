import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../common_functions.dart';
import '../../core/api/api_consts.dart';
import '../../core/preferences.dart';
import '../../models/dashboard.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import 'loan_EMI.dart';

class LoanInvestmentScreen extends StatefulWidget {
  static const route = '/Loan-Investment';

  const LoanInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<LoanInvestmentScreen> createState() => _LoanInvestmentScreenState();
}

class _LoanInvestmentScreenState extends State<LoanInvestmentScreen> {
  String selectedType = 'All';
  String selectedUser = '';
  List<Memberlist> members = [];
  String mobileNo = '';

  List<String> types = [
    'All',
    'KA Group',
  ];

  getMobNo() async {
    mobileNo = await Preference.getMobNo();
    members.add(Memberlist(
        id: int.parse(ApiUser.userId),
        name: ApiUser.userName,
        mobileno: mobileNo,
        relation: 'You',
        familyid: ApiUser.membersList.isNotEmpty
            ? ApiUser.membersList.first.familyid
            : 0, relativeUserId: 0));
    setState(() {});
    for (int i = 0; i < ApiUser.membersList.length; i++) {
      members.add(ApiUser.membersList[i]);
    }
  }

  @override
  void initState() {
    setState(() {
      selectedUser = ApiUser.userName;
    });
    getMobNo();
    super.initState();
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
                Navigator.of(context).pop();
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('My Loan', style: textStyle14Bold(colorBlack)),
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
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is LoanInvestmentErrorState) {
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
            if (state is LoanInvestmentInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            }
            if (state is LoanInvestmentLoadedState) {
              print('----loans------${state.loanInvestment.loans.length}');
              return Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100.w,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [colorRed, colorBoxGradiant3333])),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h, bottom: 5.h),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '₹${CommonFunction().splitString(state.loanInvestment.totalLoanAmt.toInt().toString())}/-',
                                            style: textStyle22(colorWhite)
                                                .copyWith(height: 1.2)),
                                        Text('LOAN PORTFOLIO',
                                            style: textStyle10(colorE5E5)
                                                .copyWith(height: 1.2)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            constraints: BoxConstraints(
                                                minWidth: 5.h, minHeight: 5.h),
                                            padding: EdgeInsets.zero,
                                            splashRadius: 5.5.w,
                                            splashColor: colorWhite,
                                            onPressed: () {
                                              CommonFunction().selectFormDialog(context, 'Select Member', members, (val) {
                                                print('-----val---=---$val');
                                                setState(() {
                                                  selectedUser = val.name.substring(0, 1).toUpperCase();
                                                });
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            icon: Container(
                                                height: 5.h,
                                                width: 5.h,
                                                decoration: const BoxDecoration(
                                                    color: colorF3F3,
                                                    shape: BoxShape.circle),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    selectedUser
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: textStyle20Bold(
                                                        colorRed)))),
                                        const SizedBox(height: 5),
                                        popupButton(
                                            false,
                                            selectedType,
                                            List.generate(
                                                types.length,
                                                (i) => menuItem(types[i], () {
                                                      setState(() {
                                                        selectedType = types[i];
                                                      });
                                                    }))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(LoanEMIReview.route);
                          },
                          child: Container(
                            height: 6.5.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                                color: colorRed,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 3),
                                      blurRadius: 6,
                                      color: colorRed.withOpacity(0.35))
                                ]),
                            alignment: Alignment.center,
                            child: Text(
                                'Track investments of your family members',
                                style: textStyle12Bold(colorWhite)),
                          )),
                      SizedBox(height: 2.5.h)
                    ],
                  ),
                  Positioned(
                      top: 17.h,
                      child: Container(
                        height: state.loanInvestment.loans.isNotEmpty?55.h:0,
                        width: 90.w,
                        decoration: decoration(),
                        child: Column(
                          children: List.generate(
                              state.loanInvestment.loans.length,
                              (index) => Column(
                                    children: [
                                      reviews(
                                          state
                                              .loanInvestment.loans[index].name,
                                          state.loanInvestment.loans[index]
                                              .installmentamount
                                              .toStringAsFixed(2),
                                          '${CommonFunction().splitString(state.loanInvestment.loans[index].loanInvAmount.toInt().toString())}',
                                          () => null),
                                      if (index !=
                                          state.loanInvestment.loans.length - 1)
                                        Container(
                                            height: 1,
                                            color:
                                                colorTextBCBC.withOpacity(0.36))
                                    ],
                                  )),
                        ),
                      )),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        height: 4.5.h,
        padding: EdgeInsets.zero,
        onTap: onClick,
        child: Container(
            width: 25.w,
            color: colorTransparent,
            padding: const EdgeInsets.only(left: 10),
            child: Text(title, style: textStyle10(colorText3D3D))));
  }

  popupButton(bool isMemberField, String selectedItem,
      List<PopupMenuItem> menuItemList) {
    return Container(
      height: 4.h,
      width: 30.w,
      decoration: BoxDecoration(
          border: Border.all(color: colorWhite, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: PopupMenuButton(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedItem, style: textStyle10(colorWhite)),
            Image.asset(icDropdown, color: colorWhite, width: 5.w)
          ],
        ),
        offset: Offset(0, 4.h),
        elevation: 3,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: colorRed, width: 1),
            borderRadius: BorderRadius.circular(7)),
        itemBuilder: (context) => menuItemList,
      ),
    );
  }

  showValue(String icon, Color bgColor, String title, String val) {
    return Container(
      width: 43.w,
      decoration: BoxDecoration(
          color: colorWhite, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      child: Row(
        children: [
          Container(
            height: 5.h,
            width: 5.h,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(icon, color: colorWhite, height: 2.5.h),
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle9(colorText7070)),
              SizedBox(height: 0.5.h),
              Text('₹ $val/-', style: textStyle13Bold(colorBlack)),
            ],
          )
        ],
      ),
    );
  }

  reviews(
      String title, String value, String percentageVal, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 3.w),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          color: colorWhite,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 50.w,
                      child: Text(title, style: textStyle10Bold(colorBlack))),
                  SizedBox(height: 0.7.h),
                  Row(
                    children: [
                      Text('INSTALLMENT: ', style: textStyle8(colorText7070)),
                      Text('₹ $value/-', style: textStyle9(colorText7070)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(percentageVal, style: textStyle10(colorText7070)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
