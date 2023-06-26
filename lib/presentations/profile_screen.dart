import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import '../blocs/signingbloc/signing_bloc.dart';
import '../core/preferences.dart';
import '../resources/resource.dart';
import '../widgets/appbarButton.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/Profile-Screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String mobNo = '';
  String dob = '';
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode pinFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  bool isSave = false;
  DateTime initialDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String notificationToken = "";

  dateOfBirth() {
    nameFocus.unfocus();
    emailFocus.unfocus();
    pinFocus.unfocus();
    countryFocus.unfocus();
    stateFocus.unfocus();
    cityFocus.unfocus();
    addressFocus.unfocus();
    showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: colorRed,
                  onPrimary: colorWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    textStyle: textStyle14Bold(colorRed),
                    // primary: colorRed, // button text color
                  ),
                ),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print('-------pickedDate---$pickedDate');
      setState(() {
        selectedDate = pickedDate;
        dob = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  getUserData() async {
    mobNo = await Preference.getMobNo();
    BlocProvider.of<SigningBloc>(context).add(GetUserData(mobileNo: mobNo));
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
          title: Text('Profile', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {}),
            SizedBox(width: 2.w),
            if (!isSave)
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icEdit,
                  iconColor: colorText7070,
                  onClick: () {
                    setState(() {
                      isSave = true;
                    });
                    print("isSave..."+isSave.toString());
                  }),
            if (isSave)
              AppBarButton(
                  splashColor: colorWhite,
                  bgColor: colorF3F3,
                  icon: icSave,
                  iconColor: colorText7070,
                  onClick: () {
                    setState(() {
                      isSave = false;
                    });
                    print('name--------${_nameController.text.trim()}');
                    print('mobileNo--------$mobNo');
                    print('email--------${_emailController.text.trim()}');
                    print('address--------${_addressController.text.trim()}');
                    print('city--------${_cityController.text.trim()}');
                    print('state--------${_stateController.text.trim()}');
                    print('country--------${_countryController.text.trim()}');
                    print('pinCode--------${_pinController.text}');
                    print('dob--------$dob');
                    print('notificationToken--------$notificationToken');
                    print('tnc--------${ApiUser.termNdCondition}');

                    BlocProvider.of<SigningBloc>(context).add(CreateUser(
                        name: _nameController.text.trim(),
                        mobileNo: mobNo,
                        email: _emailController.text.trim(),
                        address: _addressController.text.trim(),
                        city: _cityController.text.trim(),
                        country: _countryController.text.trim(),
                        pincode: _pinController.text.isEmpty?0:int.parse(_pinController.text.trim()),
                        area: '',
                        // area: _stateController.text.trim(),
                        deviceId: notificationToken,
                        dob: selectedDate,
                        tnc: ApiUser.termNdCondition));
                  }),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<SigningBloc, SigningState>(
          listener: (context, state) {
            if(state is SigningDataAdded){
              print('----state-=-----$state');
              print('----userLoaded-=-----${state.data.body}');
              BlocProvider.of<SigningBloc>(context).add(GetUserData(mobileNo: mobNo));
            }
            if (state is GetUserLoaded) {
              if(state.data!.data!.dob!=null && state.data!.data!.dob!=""){
                setState(() {
                  initialDate = state.data!.data!.dob!;
                  dob = DateFormat('dd/MM/yyyy').format(state.data!.data!.dob!);
                });
              }
              setState(() {
                notificationToken = state.data!.data!.deviceid;
              });
            }
            if (state is GetUserFailed) {
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
            print('----userState--=---$state');
            if (state is GetUserLoading) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            } else if (state is GetUserLoaded) {
              print('----userData--=---${state.data!.data}');
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: colorTextBCBC.withOpacity(0.8),
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.data!.data!.name.trim().isNotEmpty || isSave)
                          userDetail('Username', state.data!.data!.name,
                              _nameController, TextInputType.name),
                        if (state.data!.data!.email.trim().isNotEmpty || isSave)
                          userDetail('Email id', state.data!.data!.email,
                              _emailController, TextInputType.emailAddress),
                        userDetail('Mobile No.', state.data!.data!.mobileNo),
                        if (state.data!.data!.dob.toString().trim().isNotEmpty || isSave)
                          userDetail(
                              'Date of Birth',
                              state.data!.data!.dob!="" && state.data!.data!.dob!=null ? DateFormat('dd/MM/yyyy').format(state.data!.data!.dob!) : ""),
                        if (state.data!.data!.pincode != 0 || isSave)
                          userDetail(
                              'Pincode',
                              state.data!.data!.pincode == 0
                                  ? ''
                                  : state.data!.data!.pincode.toString(),
                              _pinController,
                              TextInputType.number),
                        if (state.data!.data!.country!.trim().isNotEmpty ||
                            isSave)
                          userDetail('Country', state.data!.data!.country!,
                              _countryController, TextInputType.streetAddress),
                        if (state.data!.data!.area.trim().isNotEmpty || isSave)
                          userDetail('State', state.data!.data!.area, _stateController, TextInputType.streetAddress),
                        if (state.data!.data!.city!.trim().isNotEmpty || isSave)
                          userDetail('City', state.data!.data!.city!, _cityController, TextInputType.streetAddress),
                        if (state.data!.data!.address!.trim().isNotEmpty || isSave)
                          userDetail('Address', state.data!.data!.address!,
                              _addressController, TextInputType.streetAddress),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(color: colorRed, strokeWidth: 0.7.w)
              ),
            );
          },
        ),
      ),
    );
  }

  userDetail(String title, String value,
      [TextEditingController? controller, TextInputType? keyboardType]) {
    if (value.isNotEmpty && title != 'Mobile No.' && title != 'Date of Birth') {
      controller!.text = value;
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyle11Medium(colorRed)),
          isSave && title != 'Mobile No.' && title != 'Date of Birth'
              ? Container(
                  width: 84.w,
                  padding: EdgeInsets.only(top: 1.5.h, bottom: 2.5),
                  child: TextFormField(
                    controller: controller,
                    style: textStyle13Bold(colorText8181),
                    maxLines: 1,
                    decoration: InputDecoration.collapsed(
                        hintText: '',
                        hintStyle: textStyle13Bold(colorText8181),
                        fillColor: colorWhite,
                        filled: true),
                    autofocus: true,
                    focusNode: controller == _emailController
                        ? emailFocus
                        : controller == _pinController
                            ? pinFocus
                            : controller == _countryController
                                ? countryFocus
                                : controller == _stateController
                                    ? stateFocus
                                    : controller == _cityController
                                        ? cityFocus
                                        : controller == _addressController
                                            ? addressFocus
                                            : nameFocus,
                    onFieldSubmitted: (val) {
                      if (controller == _nameController) {
                        FocusScope.of(context).requestFocus(emailFocus);
                      }
                      if (controller == _emailController) {
                        emailFocus.unfocus();
                      }
                      if (controller == _pinController) {
                        FocusScope.of(context).requestFocus(countryFocus);
                      }
                      if (controller == _countryController) {
                        FocusScope.of(context).requestFocus(stateFocus);
                      }
                      if (controller == _stateController) {
                        FocusScope.of(context).requestFocus(cityFocus);
                      }
                      if (controller == _cityController) {
                        FocusScope.of(context).requestFocus(addressFocus);
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: controller == _addressController
                        ? TextInputAction.done
                        : TextInputAction.next,
                  ),
                )
              : title == 'Date of Birth' && isSave
                  ? GestureDetector(
                      onTap:dateOfBirth,
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.5.h, bottom: 2.5),
                        child: Text(dob!="null" && dob!="" ? dob.toString(): "Enter Date of Birth", style: textStyle13Bold(colorText8181)),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 1.5.h, bottom: 2.5),
                      child: Text(value, style: textStyle13Bold(colorText8181)),
                    ),
          title!="Address"?Container(height: 1, color: colorTextBCBC.withOpacity(0.36)):Container()
        ],
      ),
    );
  }
}