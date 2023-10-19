import 'package:flutter/material.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
as contactPermission;
import 'package:pinput/pinput.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:wbc_connect_app/blocs/signingbloc/signing_bloc.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';
import 'package:wbc_connect_app/presentations/home_screen.dart';
import 'package:wbc_connect_app/presentations/sigIn_screen.dart';
import 'package:wbc_connect_app/presentations/splash_screen.dart';
import 'package:wbc_connect_app/presentations/terms_nd_condition.dart';
import '../blocs/fetchingData/fetching_data_bloc.dart';
import '../blocs/mall/mall_bloc.dart';
import '../core/preferences.dart';
import '../models/add_contacts_model.dart';
import '../models/contacts_data.dart';
import '../models/newArrival_data_model.dart';
import '../models/popular_data_model.dart';
import '../models/terms_conditions_model.dart';
import '../models/trending_data_model.dart';
import '../resources/resource.dart';
import '../widgets/country_picker/country.dart';
import '../widgets/country_picker/country_code_picker.dart';

class SocialLoginData {
  final String googleId;
  final String loginType;
  final String name;
  final String email;
  final String phoneNo;
  final bool isHomeContactOpen;
  int selectedContact;

  SocialLoginData(
      {required this.loginType,
        required this.googleId,
        required this.name,
        required this.email,
        required this.phoneNo,
        this.isHomeContactOpen = false,
        required this.selectedContact
      });
}

class SocialLogin extends StatefulWidget {
  static const route = '/Social-Login';
  final SocialLoginData socialLoginData;

  const SocialLogin({super.key, required this.socialLoginData});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  int step = 1;
  int contactCount = 0;

  String dob = 'Select Your Date of Birth';
  FocusNode numNode = FocusNode();
  String countryCode = '+91';
  String validationString = "";
  bool isSendOtp = false;
  bool isVerify = false;
  String resendVerificationId = "";

  bool isDOBFieldTap = false;
  DateTime? selectedDate;
  String pinValidationString = "";
  bool isOtpCompleted = false;
  var sms = "";
  String? verificationId;
  int? resendToken;

  bool isCheckedPrivacyPolicy = true;
  String tmcValidation = '';

  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 30);
  String notificationToken = "";

  MapLatLng? _markerPosition;
  final MapZoomPanBehavior _mapZoomPanBehavior =
  MapZoomPanBehavior(zoomLevel: 10);
  final MapTileLayerController _controller = MapTileLayerController();

  bool isEmptyContacts = false;
  bool isContactPermission = false;
  bool isContactPermissionDenied = false;
  List<ContactsData> contactsList = [];
  List<ContactsData> contactsData = [];
  List<ContactData> selectedContacts = [];
  String filteredContacts = '';

  int pinCode = 0;
  String area = '';
  String approveContactCount = "0";

  FocusNode locationFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode countryFocus = FocusNode();

  bool isLocationFieldTap = true;
  bool isCityFieldTap = false;
  bool isCountryFieldTap = false;

  int count = 0;

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  void setUserData() {
    setState(() {
      _nameController.text = widget.socialLoginData.name;
      _emailController.text = widget.socialLoginData.email;
    });
    /*if(widget.socialLoginData.phoneNo!=null && widget.socialLoginData.phoneNo!="null" && widget.socialLoginData.phoneNo!=""){
      _numController.text = widget.socialLoginData.phoneNo;
    }*/
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  resetTimer() {
    reSendOtp();
    setState(() => myDuration = const Duration(seconds: 30));
    startTimer();
  }

  sendOtp() async {
    setState(() {
      isSendOtp = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    Preference.setMobNo(_numController.text);
    Preference.setCountryCode(countryCode);

    print('Submitted your Number: $countryCode${_numController.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + _numController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');

        setState(() {
          validationString = 'Invalid Number';
          isSendOtp = false;
        });
      },
      codeSent: (String VerificationId, int? ResendToken) {
        setState(() {
          verificationId=VerificationId;
          resendToken=ResendToken;
        });
       /* Navigator.of(context).pushReplacementNamed(VerificationScreen.route,
            arguments: VerificationScreenData(
                getNumber: _numController.text.replaceAll(' ', ''),
                number: "$countryCode ${_numController.text}",
                verificationId: verificationId,
                selectedContact: 0));*/
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerPage();
    if (country != null) {
      setState(() {
        countryCode = country.isdcode;
      });
    }
  }

  Future<Country?> showCountryPickerPage({
    Widget? title,
    double cornerRadius = 35,
    bool focusSearchBox = false,
  }) {
    return showDialog<Country?>(
        context: context,
        barrierDismissible: true,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cornerRadius),
              )),
          child: SizedBox(
            height: 55.h,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Stack(
                  children: <Widget>[
                    Center(
                      child: title ??
                          const Text(
                            'Choose region',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CountryPickerWidget(
                    onSelected: (country) =>
                        Navigator.of(context).pop(country),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  dateOfBirth() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1951, 1, 1),
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

  verifyOtp() async {
    try {
      setState(() {
        isVerify = true;
      });
      print('verificationId-----${verificationId}');
      print(resendVerificationId);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendVerificationId.isNotEmpty
              ? resendVerificationId
              : verificationId!,
          smsCode: sms);

      await auth.signInWithCredential(credential);
      getToken();

      BlocProvider.of<SigningBloc>(context).add(GetUserData(mobileNo:_numController.text));

    } catch (e) {
      print('exception------');
      setState(() {
        isVerify = false;
        pinValidationString = 'The Code Is Incorrect';
      });
    }
  }

  step2Button() {
    setState(() {});
    _getGeoLocationPermission();
    _currentLocation().then((value) async {
      print('----location----${value!}');
      _markerPosition = MapLatLng(value.latitude!, value.longitude!);
      setState(() {});
      List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(_markerPosition!.latitude, _markerPosition!.longitude);
      print(placeMarks);
      geo.Placemark place = placeMarks[0];
      _locationController.text =
      '${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      _locationController.selection = TextSelection.fromPosition(TextPosition(offset: _locationController.text.length));
      _cityController.text = '${place.locality}';
      _countryController.text = '${place.country}';
      isLocationFieldTap = true;
      isCityFieldTap = false;
      isCountryFieldTap = false;
      setState(() {});
      locationFocus.requestFocus();
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        notificationToken = token!;
      });
    });
  }

  reSendOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    print('Submitted your Number: ${_numController.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$countryCode ${_numController.text}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed exception------$e');
        setState(() {
          isVerify = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          resendVerificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void getContactPermission() async {
    Preference.setIsLogin(true);
    if (await contactPermission.Permission.contacts.request().isGranted) {
      setState(() {
        isContactPermission = true;
      });
      await getContacts();
    } else if (await contactPermission.Permission.contacts.request().isDenied) {
      setState(() {
        isContactPermission = false;
        isContactPermissionDenied = true;
      });
    } else if (await contactPermission.Permission.contacts.request().isPermanentlyDenied) {
      await contactPermission.openAppSettings();
    }
  }

  getContacts() async {
    contactsList = [];
    contactsList =
    await FlutterContacts.getContacts(withProperties: true, withPhoto: true).then((value) {
      print('-----contacts--all-----$value');
      print('-----phones------${value[6].phones}');
      if (value.isEmpty) {
        Timer(const Duration(seconds: 2), () {
          setState(() {
            isEmptyContacts = true;
          });
        });
      } else {
        count = 0;
        contactCount = 0;
        for (int i = 0; i < value.length; i++) {
          if (i > 0) {
            print('---xxxx------$i---xxx----${value[i].name.first}');
            if (value[i].name.first.isNotEmpty) {
              if (value[i - 1].name.first.isEmpty) {
                setState(() {
                  if (value[i].name.first.substring(0, 1).toUpperCase() ==
                      value[i - 2].name.first.substring(0, 1).toUpperCase()) {
                    print('----isMatched----$i--${value[i - 2].name.first}--${value[i - 2].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count;
                  } else {
                    print('----unMatched----$i--${value[i - 2].name.first}--${value[i - 2].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count + 1;
                  }
                  print('------count11---$count');
                });
              } else {
                setState(() {
                  if (value[i].name.first.substring(0, 1).toUpperCase() ==
                      value[i - 1].name.first.substring(0, 1).toUpperCase()) {
                    print(
                        '----isMatched----$i--${value[i - 1].name.first}--${value[i - 1].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count;
                  } else {
                    print(
                        '----unMatched----$i--${value[i - 1].name.first}--${value[i - 1].name.first.substring(0, 1)}--=--${value[i].name.first}--${value[i].name.first.substring(0, 1)}');
                    count = count + 1;
                  }
                  print('------count11---$count');
                });
              }
            }
          }
          if (count == 4) {
            print('-----is--4---$count');
            setState(() {
              count = 0;
            });
          }
          if (value[i].phones.isNotEmpty) {
            if (value[i].phones.first.number.length >= 10) {
              contactsList.add(ContactsData(
                  contact: value[i],
                  isAdd: false,
                  color: colorContacts[count]));
            }
          }
        }   
      }
      return contactsList;
    });
    setState(() {
      contactsData = contactsList;
    });
    print('--=---contacts----${contactsData.length}');
    setState(() {});
  }

  _getGeoLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      print("-------openLocationSettings--------");
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always) {
      _currentLocation();
      print("Granted.......");
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    print("location-->"+location.getLocation().toString());
    return await location.getLocation();
  }

  Future<void> updateMarkerChange(Offset position) async {
    _markerPosition = _controller.pixelToLatLng(position);
    if (_controller.markersCount > 0) {
      _controller.clearMarkers();
    }
    _controller.insertMarker(0);
    List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(_markerPosition!.latitude, _markerPosition!.longitude);
    print(placeMarks);
    geo.Placemark place = placeMarks[0];
    _locationController.text = '${place.street}, ${place.subLocality}';
    _cityController.text = '${place.locality}';
    _countryController.text = '${place.country}';
    pinCode = int.parse(place.postalCode!);
    area = '${place.subLocality}';
    setState(() {});
  }

  onSubmitData() {
    print('name--------${_nameController.text.trim()}');
    print('mobileNo--------${'$countryCode${_numController.text}'.trim()}');
    print('email--------${_emailController.text.trim()}');
    print('address--------${_locationController.text.trim()}');
    print('city--------${_cityController.text.trim()}');
    print('country--------${_countryController.text.trim()}');
    print('pinCode--------$pinCode');
    print('area--------${area.trim()}');
    print('dob--------$dob');
    print('deviceId--------$notificationToken');

    BlocProvider.of<SigningBloc>(context).add(CreateUser(
        name: _nameController.text.trim(),
        mobileNo: _numController.text,
        email: _emailController.text.trim(),
        address: _locationController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        pincode: pinCode,
        area: area.trim(),
        deviceId: notificationToken,
        dob: selectedDate,
        tnc: isCheckedPrivacyPolicy));
    setState(() {
      ApiUser.termNdCondition = isCheckedPrivacyPolicy;
    });
  }

  saveAndEarn() async {
    String mono = await Preference.getMobNo();
    print('selectedcontact--------${selectedContacts.length}');
    print('selectedmono--------$mono');

    String formattedDate = DateFormat('dd-MM-yy').format(selectedDate ?? DateTime.now());
    print('dob--------$formattedDate');

    BlocProvider.of<SigningBloc>(context).add(AddContactList(
        mobileNo: mono.trim(),
        date: formattedDate,
        contacts: selectedContacts));

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     HomeScreen.route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    final defaultPinTheme = PinTheme(
      height: 6.h,
      width: 13.w,
      textStyle: textStyle18Bold(colorBlack),
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: colorDFDF, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
        border: Border.all(color: colorRed, width: 1),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colorWhite,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colorWhite,
        body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacementNamed(SigInPage.route);
              if (step == 1) {
                Navigator.of(context).pushReplacementNamed(SigInPage.route);
              }
              if(step == 2){
                setState(() {
                  step--;
                });
              }
              if (step == 3) {
                setState(() {
                  step--;
                  tmcValidation = '';
                });
              }
              if (step == 4) {
                setState(() {
                  isEmptyContacts = false;
                });
                widget.socialLoginData.isHomeContactOpen
                    ? Navigator.of(context).pop()
                    : Navigator.of(context).pushReplacementNamed(SplashScreen.route);
              }
              return false;
            },
            child: BlocConsumer<SigningBloc, SigningState>(
              listener: (context, state) {
                if (state is SigningFailed ||
                    state is AddContactFailed ||
                    state is GetUserFailed) {
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

                if (state is SigningDataAdded) {
                  step++;
                  getContactPermission();
                  BlocProvider.of<SigningBloc>(context).add(UserIdData(
                      mobileNo: _numController.text.replaceAll(' ', '')));
                  print('signadded------');
                } else if (state is AddContactLoaded) {
                  print('contactadd successfully--------');
                  print(state.userId);
                  print(state.myContacts);

                  Preference.setIsContact(true);
                  // Preference.setUserid(state.userId);
                  // ApiUser.userId = state.userId;
                  ApiUser.myContactsList = state.myContacts;

                  BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                      popular: Popular(code: 0, message: '', products: []),
                      newArrival:
                      NewArrival(code: 0, message: '', products: []),
                      trending: Trending(code: 0, message: '', products: [])));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.route, (route) => false,
                      arguments: HomeScreenData(
                          rewardPopUpShow: true,
                          acceptedContacts: state.acceptedContacts));
                } else if (state is UserIdLoaded) {
                  print('useridloaded---------${state.data!.data}');

                  Preference.setUserid(state.data!.data == null
                      ? ""
                      : state.data!.data!.uid.toString());

                  Preference.setEmail(state.data!.data == null
                      ? ""
                      : state.data!.data!.email.toString());

                  Preference.setFastTrackStatus(state.data!.data!.fastTrack);

                  ApiUser.userId = state.data!.data == null
                      ? ""
                      : state.data!.data!.uid.toString();

                  ApiUser.userName = state.data!.data == null
                      ? ""
                      : state.data!.data!.name.toString();

                  ApiUser.emailId = state.data!.data == null
                      ? ""
                      : state.data!.data!.email.toString();

                  ApiUser.mobileNo = state.data!.data == null
                      ? ""
                      : state.data!.data!.mobileNo.toString();

                  widget.socialLoginData.selectedContact = state.data!.data!.availableContacts;
                } else if (state is GetUserLoaded) {
                  pinValidationString = "";
                  ApiUser.myContactsList = state.data!.goldReferrals;

                  Preference.setEmail(state.data!.data == null
                      ? ""
                      : state.data!.data!.email.toString());

                  Preference.setFastTrackStatus(state.data!.data!.fastTrack);

                  Preference.setUserid(state.data!.data == null
                      ? ""
                      : state.data!.data!.uid.toString());

                  ApiUser.userId = state.data!.data == null
                      ? ""
                      : state.data!.data!.uid.toString();

                  ApiUser.userName = state.data!.data == null
                      ? ""
                      : state.data!.data!.name.toString();

                  ApiUser.emailId = state.data!.data == null
                      ? ""
                      : state.data!.data!.email.toString();

                  ApiUser.mobileNo = state.data!.data == null
                      ? ""
                      : state.data!.data!.mobileNo.toString();

                  if (state.data!.data == null) {
                    step++;
                    step2Button();
                  } else {
                    Preference.setIsLogin(true);
                    ApiUser.myContactsList = state.data!.goldReferrals;
                    BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                        popular: Popular(code: 0, message: '', products: []),
                        newArrival: NewArrival(code: 0, message: '', products: []),
                        trending: Trending(code: 0, message: '', products: [])));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (route) => false,
                        arguments: HomeScreenData());
                    /*if (state.data!.data!.availableContacts != 0) {
                      widget.socialLoginData.selectedContact = state.data!.data!.availableContacts;
                      getContactPermission();
                      step = 4;
                    } else {
                      Preference.setIsLogin(true);
                      ApiUser.myContactsList = state.data!.goldReferrals;
                      BlocProvider.of<MallBloc>(context).add(LoadMallDataEvent(
                          popular: Popular(code: 0, message: '', products: []),
                          newArrival: NewArrival(code: 0, message: '', products: []),
                          trending: Trending(code: 0, message: '', products: [])));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomeScreen.route, (route) => false,
                          arguments: HomeScreenData());
                    }*/
                  }
                }
              },
              builder: (context, state) {
                return SafeArea(
                  top: true,
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: colorWhite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: IconButton(
                                  constraints: BoxConstraints.loose(Size(5.w, 5.h)),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    if (step == 1 || step == 2) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                          SigInPage.route);
                                    }
                                    if (step == 3) {
                                      setState(() {
                                        step--;
                                        tmcValidation = '';
                                      });
                                    }
                                    if (step == 4) {
                                      setState(() {
                                        isEmptyContacts = false;
                                      });
                                      widget.socialLoginData
                                          .isHomeContactOpen
                                          ? Navigator.of(context).pop()
                                          : Navigator.of(context)
                                          .pushReplacementNamed(
                                          SplashScreen.route);
                                    }
                                  },
                                  icon: SizedBox(
                                      height: 5.h,
                                      width: 5.w,
                                      child: Image.asset(icBack, color: colorRed))),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    step == 1
                                        ?'Profile'
                                        : step == 2
                                        ? 'Enter Verification Code'
                                        : step == 3
                                        ? 'Location'
                                        : 'Add 10 Contacts',
                                    style: textStyle14Bold(colorBlack)
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                    step == 4
                                        ? 'And Get 1000 Gold Points (GP)'
                                        : 'Step $step',
                                    style: textStyle8(colorText7070)),
                              ],
                            ),
                            const Spacer(),
                            if (step != 4) SizedBox(height: 8.h, width: 8.w),
                            if (step == 4)
                              GestureDetector(
                                onTap: () {
                                  CommonFunction().errorDialog(context, 'Adding contacts will let you earn more points as well as a chance to form your base');
                                },
                                child: Container(
                                  height: 8.h,
                                  width: 8.w,
                                  decoration: const BoxDecoration(
                                      color: colorF3F3, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Image.asset(icQuestionMark, width: 3.w),
                                ),
                              ),
                            SizedBox(width: 5.w)
                          ],
                        ),
                      ),
                      Stack(children: [
                        Container(
                            height: 0.6.h, width: 100.w, color: colorRedFFC),
                        Container(
                            height: 0.6.h,
                            width: step == 1
                                ? 100.w / 4
                                : step == 2
                                ? (100.w / 4) * 2
                                : step == 3
                                ? (100.w / 4) * 3
                                : step == 4
                                ? contactCount > 0
                                ? (100.w / 4) * 3 +
                                (((100.w / 4) / 10) *
                                    contactCount)
                                : (100.w / 4) * 3
                                : (100.w / 4) * 3,
                            color: colorRed)
                      ]),
                      if (step == 1) step1(),
                      if (step == 2)
                        Expanded(
                          child: Container(
                            width: 100.w,
                            color: colorBG,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text('Verify Account',
                                      style: textStyle22Bold(colorBlack)),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                      'Enter 6-digit Code code we have sent to at',
                                      style: textStyle10(colorText3D3D)),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(_numController.text,
                                      style: textStyle10Bold(colorText7070)
                                          .copyWith(
                                        decoration: TextDecoration.underline,
                                      )),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Pinput(
                                    length: 6,
                                    defaultPinTheme:
                                    pinValidationString.isNotEmpty
                                        ? focusedPinTheme
                                        : defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    submittedPinTheme:
                                    pinValidationString.isNotEmpty
                                        ? focusedPinTheme
                                        : submittedPinTheme,
                                    showCursor: true,
                                    onCompleted: (pin) {
                                      setState(() {
                                        isOtpCompleted = true;
                                      });
                                      verifyOtp();
                                    },
                                    onChanged: (val) {
                                      sms = val;
                                    },
                                  ),
                                  if (pinValidationString.isNotEmpty)
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        if (pinValidationString ==
                                            'The Code Is Incorrect')
                                          SizedBox(
                                            height: 2.h,
                                            child: Text(
                                                ' The Code Is Incorrect',
                                                style:
                                                textStyle9(colorErrorRed)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text('Didn’t received the code?',
                                      style: textStyle10(colorText3D3D)),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  myDuration.inSeconds > 0
                                      ? Text(
                                    '$minutes:$seconds',
                                    style: textStyle11Medium(colorBlack)
                                        .copyWith(letterSpacing: 0.5.sp),
                                  )
                                      : InkWell(
                                    onTap: resetTimer,
                                    child: Text('Resend Code',
                                        style: textStyle11Medium(colorRed)
                                            .copyWith(
                                          decoration:
                                          TextDecoration.underline,
                                        )),
                                  ),
                                  const Spacer(),
                                  button('NEXT',
                                      isOtpCompleted ? null : verifyOtp, state),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'by clicking next, you agree to our ',
                                          style: textStyle9(colorText7070)),
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<FetchingDataBloc>(
                                              context)
                                              .add(LoadTermsConditionsEvent(
                                              termsConditions:
                                              TermsConditions(
                                                  code: 0,
                                                  message: '',
                                                  terms: [])));
                                          Navigator.of(context).pushNamed(
                                              TermsNdConditions.route);
                                        },
                                        child: Text('Privacy Policy',
                                            style: textStyle9Bold(colorText3D3D)
                                                .copyWith(
                                              decoration:
                                              TextDecoration.underline,
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 0.7.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('and our ',
                                          style: textStyle9(colorText7070)),
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<FetchingDataBloc>(
                                              context)
                                              .add(LoadTermsConditionsEvent(
                                              termsConditions:
                                              TermsConditions(
                                                  code: 0,
                                                  message: '',
                                                  terms: [])));
                                          Navigator.of(context).pushNamed(
                                              TermsNdConditions.route);
                                        },
                                        child: Text('Terms and Conditions',
                                            style: textStyle9Bold(colorText3D3D)
                                                .copyWith(
                                              decoration:
                                              TextDecoration.underline,
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (step == 3) step3(state),
                      if (step == 4) step4(state),
                    ],
                  ),
                );
              },
            )
        ),
      ),
    );
  }

  step1() {
    return Expanded(
        child: Container(
          width: 100.w,
          color: colorBG,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                textFormFieldContainer(
                    'Full Name',
                    'Enter Your Full Name',
                    _nameController),
                  SizedBox(
                    height: 0.5.h,
                  ),
                textFormFieldContainer('Email Id', 'Enter Your Email ID', _emailController),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 9.h,
                  decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: validationString.isEmpty
                              ? colorDFDF
                              : colorErrorRed,
                          width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mobile Number',
                                style: textStyle8(colorTextBCBC)),
                            SizedBox(height: 0.5.h),
                            SizedBox(
                              height: 5.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: _showCountryPicker,
                                    child: Container(
                                      height: 4.5.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                          color: colorTextBCBC.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(5)),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 1.w),
                                            child: Text(
                                              countryCode,
                                              style: textStyle13Bold(colorBlack),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  SizedBox(
                                      width: 60.w,
                                      child: TextFormField(
                                        controller: _numController,
                                        style: textStyle14Bold(colorBlack),
                                        focusNode: numNode,
                                        maxLength: countryCode == '+91' ? 10 : 15,
                                        decoration: InputDecoration(
                                            hintText:
                                            'Enter Your Mobile Number',
                                            hintStyle:
                                            textStyle11(colorText7070),
                                            border: InputBorder.none,
                                            counter:
                                            const SizedBox.shrink(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 1.4.h)),
                                        onChanged: (val) {
                                          setState(() {
                                            validationString = '';
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (validationString.isNotEmpty)
                  SizedBox(
                    height: 1.h,
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Column(
                      children: [
                        if (validationString == 'Empty String')
                          SizedBox(
                            height: 2.h,
                            child: Text('Please Enter a Number',
                                style: textStyle8Medium(colorErrorRed)),
                          ),
                        if (validationString == 'Invalid String')
                          SizedBox(
                            height: 2.h,
                            child: Text('Please Enter a valid Number',
                                style: textStyle8Medium(colorErrorRed)),
                          ),
                        if (validationString == 'Invalid Number')
                          SizedBox(
                            height: 2.h,
                            child: Text('Invalid Number',
                                style: textStyle8Medium(colorErrorRed)),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                textFormTextFieldContainer2(
                    'Select DOB', dob, isDOBFieldTap, () {
                  dateOfBirth();
                  setState(() {
                    isDOBFieldTap = true;
                  });
                }),

                const Spacer(),
                button('CONTINUE', () {
                  if (_numController.text.isEmpty) {
                    setState(() {
                      validationString = 'Empty String';
                    });
                  } else {
                    print('--==-----num------${_numController.text.length}');
                    if (_numController.text.replaceAll(' ', '').length < 10 || _numController.text.replaceAll(' ', '').length > 10) {
                      setState(() {
                        validationString = 'Invalid String';
                      });
                    } else {
                      print('Submitted your Number: ${_numController.text.trim()}');
                      setState(() {
                        validationString = '';
                      });
                      sendOtp();
                      startTimer();
                      step++;
                      print("step-->"+step.toString());
                    }
                  }
                }),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ));
  }

  step3(SigningState state) {
    return Expanded(
        child: Container(
          width: 100.w,
          color: colorBG,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLocationFieldTap = true;
                      isCityFieldTap = false;
                      isCountryFieldTap = false;
                    });
                    locationFocus.requestFocus();
                  },
                  child: Container(
                    height: 32.h,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isLocationFieldTap ? colorRed : colorDFDF,
                            width: 1)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location', style: textStyle10(colorText8181)),
                          TextFormField(
                            controller: _locationController,
                            style: textStyle12(colorText3D3D).copyWith(height: 1.3),
                            maxLines: 2,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Enter Your Location',
                                hintStyle: textStyle12(colorText3D3D),
                                fillColor: colorWhite,
                                filled: true,
                                border: InputBorder.none),
                            onTap: () {
                              setState(() {
                                isLocationFieldTap = true;
                                isCityFieldTap = false;
                                isCountryFieldTap = false;
                              });
                              locationFocus.requestFocus();
                            },
                            autofocus: isLocationFieldTap,
                            focusNode: locationFocus,
                            onFieldSubmitted: (val) {
                              setState(() {
                                isCityFieldTap = true;
                                isLocationFieldTap = false;
                                isCountryFieldTap = false;
                              });
                              FocusScope.of(context).requestFocus(cityFocus);
                            },
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(1.w, 0, 1.w, 0.5.h),
                              child: Container(
                                height: 20.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: colorDFDF, width: 1)),
                                child: _markerPosition == null
                                    ? Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: colorRed,
                                            strokeWidth: 0.7.w)))
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                                      updateMarkerChange(details.localPosition);
                                    },
                                    child: SfMaps(
                                      layers: [
                                        MapTileLayer(
                                          controller: _controller,
                                          zoomPanBehavior:
                                          _mapZoomPanBehavior,
                                          initialFocalLatLng: MapLatLng(
                                              _markerPosition!.latitude,
                                              _markerPosition!.longitude),
                                          initialZoomLevel: 10,
                                          initialMarkersCount: 1,
                                          urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          markerBuilder:
                                              (BuildContext context,
                                              int index) {
                                            return MapMarker(
                                              latitude:
                                              _markerPosition!.latitude,
                                              longitude:
                                              _markerPosition!.longitude,
                                              size: const Size(20, 20),
                                              child: const Icon(
                                                Icons.location_on,
                                                color: colorErrorRed,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                textFormTextFieldContainer2('City', 'Enter City', isCityFieldTap, () {
                  setState(() {
                    isCityFieldTap = true;
                    isLocationFieldTap = false;
                    isCountryFieldTap = false;
                  });
                  cityFocus.requestFocus();
                }, _cityController, (p0) => null, TextInputType.streetAddress),
                SizedBox(height: 2.h),
                textFormTextFieldContainer2(
                    'Country', 'Enter Country', isCountryFieldTap, () {
                  setState(() {
                    isCountryFieldTap = true;
                    isLocationFieldTap = false;
                    isCityFieldTap = false;
                  });
                  countryFocus.requestFocus();
                }, _countryController, (p0) => null, TextInputType.streetAddress),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCheckedPrivacyPolicy = !isCheckedPrivacyPolicy;
                      });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 1.w, right: 3.w),
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Checkbox(
                                value: isCheckedPrivacyPolicy,
                                focusColor: colorWhite,
                                activeColor: colorRedFFC,
                                checkColor: colorRed,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                    color: tmcValidation.isEmpty
                                        ? colorDFDF
                                        : colorErrorRed),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (val) {
                                  setState(() {
                                    isCheckedPrivacyPolicy =
                                    !isCheckedPrivacyPolicy;
                                  });
                                }),
                          ),
                        ),
                        Text('Terms & Conditions',
                            style: textStyle11(colorText7070))
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                button('CONTINUE', () {
                  setState(() {
                    if (!isCheckedPrivacyPolicy) {
                      tmcValidation = 'Check Terms & Conditions';
                    } else {
                      onSubmitData();
                    }
                  });
                  print('----==tmcValidation---- $tmcValidation');
                }, state),
                SizedBox(height: 2.h),
                // button('SKIP', () {
                //   setState(() {
                //     step++;
                //   });
                //   getContactPermission();
                // }),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ));
  }

  step4(SigningState state) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Container(
              height: 6.h,
              width: 85.w,
              decoration: BoxDecoration(
                  color: colorF3F3, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Image.asset(icSearch, width: 5.w),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: TextFormField(
                        controller: _searchController,
                        style: textStyle12(colorText7070),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search Contacts',
                          hintStyle: textStyle12(colorText7070),
                          fillColor: colorF3F3,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (val) {
                          contactsData = contactsList;
                          filteredContacts = val;
                          setState(() {});
                        },
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 0.4.h,
            decoration: const BoxDecoration(color: colorF3F3, boxShadow: [
              BoxShadow(color: colorF3F3, offset: Offset(3, 4), blurRadius: 5)
            ]),
          ),
          Expanded(
            flex: widget.socialLoginData.isHomeContactOpen ? 4 : 5,
            child: contactsData.isEmpty
                ? Center(
                child: isEmptyContacts
                    ? Text('No Contacts Available',
                    style: textStyle12(colorText7070))
                    : isContactPermission
                    ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w))
                    : isContactPermissionDenied
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Please Allow Contacts Permission',
                        style: textStyle12(colorText7070)),
                    SizedBox(height: 1.5.h),
                    InkWell(
                      onTap: getContactPermission,
                      child: Container(
                        height: 6.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                            color: colorRed,
                            borderRadius:
                            BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: Text('Give Permission',
                            style:
                            textStyle13Bold(colorWhite)),
                      ),
                    ),
                  ],
                )
                    : SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)))
                : ListView.builder(
              itemCount: contactsData.length,
              itemBuilder: (BuildContext context, int index) {
                Uint8List? image = contactsData[index].contact.photo;
                String num = contactsData[index]
                    .contact
                    .phones
                    .first
                    .number
                    .replaceAll(' ', '')
                    .replaceAll('-', '')
                    .replaceAll('(', '')
                    .replaceAll(')', '');
                num = '${num.substring(0, 5)} ${num.substring(5, 10)}';

                return contactsData[index]
                    .contact
                    .name
                    .first
                    .toLowerCase()
                    .contains(filteredContacts.toLowerCase())
                    ? contactsData[index].contact.name.first.isEmpty
                    ? Container()
                    : Padding(
                  padding: EdgeInsets.only(bottom: 0.3.h),
                  child: Container(
                    height: 9.h,
                    decoration: const BoxDecoration(
                        color: colorWhite,
                        boxShadow: [
                          BoxShadow(
                              color: colorF3F3,
                              offset: Offset(3, 4),
                              blurRadius: 5)
                        ]),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: (contactsData[index]
                                .contact
                                .photo ==
                                null)
                                ? CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                contactsData[index]
                                    .color
                                    .withOpacity(0.3),
                                child: Text(
                                  contactsData[index]
                                      .contact
                                      .name
                                      .first
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: textStyle16Bold(
                                      contactsData[index]
                                          .color),
                                ))
                                : CircleAvatar(
                              radius: 22,
                              backgroundImage:
                              MemoryImage(image!),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            flex: 10,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${contactsData[index].contact.name.first} ${contactsData[index].contact.name.middle} ${contactsData[index].contact.name.last}",
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: textStyle10Medium(
                                      colorBlack)
                                      .copyWith(
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 0.8.h,
                                ),
                                Text(num,
                                    style: textStyle12(
                                        colorText7070))
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: CupertinoSwitch(
                                value: contactsData[index].isAdd,
                                activeColor: colorRed,
                                trackColor: colorE5E5,
                                onChanged: (val) {

                                  if (contactsData[index].isAdd) {
                                    setState(() {
                                      contactsData[index].isAdd = !contactsData[index].isAdd;
                                      contactCount--;
                                    });
                                  }else{
                                    contactCount++;
                                    final selectedContactName = contactsData[index].contact.name.first + contactsData[index].contact.name.middle + contactsData[index].contact.name.last;
                                    final selectedContactMono = contactsData[index].contact.phones.first.number.replaceAll('-', '');
                                    setState(() {
                                      contactsData[index].isAdd=true;
                                    });
                                    selectedContacts.add(
                                        ContactData(
                                            name: selectedContactName,
                                            mobileNo: selectedContactMono,
                                        ));
                                  }
                                  print("contactCount-->"+contactCount.toString());
                                  print("selectedContact-->"+widget.socialLoginData.selectedContact.toString());
                                  /*if (contactCount < widget.socialLoginData.selectedContact) {
                                    setState(() {
                                      contactsData[index].isAdd = !contactsData[index].isAdd;
                                    });
                                    setState(() {
                                      if (contactsData[index].isAdd) {
                                        contactCount++;
                                        final selectedContactName = contactsData[index].contact.name.first + contactsData[index].contact.name.middle + contactsData[index].contact.name.last;
                                        final selectedContactMono = contactsData[index].contact.phones.first.number.replaceAll('-', '');
                                        selectedContacts.add(
                                            ContactData(
                                                name:
                                                selectedContactName,
                                                mobileNo:
                                                selectedContactMono));
                                      } else {
                                        final selectedContactMono =
                                        contactsData[index].contact.phones.first.number.replaceAll('-', '');
                                        contactCount--;
                                        selectedContacts.removeWhere((element) => element.mobileNo == selectedContactMono);
                                        print('removeselecteddata--------$selectedContacts');
                                      }
                                    });
                                  }
                                  else if (contactCount == widget.socialLoginData.selectedContact) {
                                    if (contactsData[index].isAdd) {
                                      setState(() {
                                        contactsData[index].isAdd = !contactsData[index].isAdd;
                                        contactCount--;
                                      });
                                    }else{
                                      print("Ssss");

                                    }
                                  }*/
                                  print('selecteddata-------ff-----$selectedContacts');
                                }),
                          ),
                          SizedBox(width: 1.5.w),
                        ],
                      ),
                    ),
                  ),
                )
                    : Container();
              },
            ),
          ),
          Container(
            height: 0.5.h,
            decoration: const BoxDecoration(color: colorF3F3, boxShadow: [
              BoxShadow(color: colorF3F3, offset: Offset(3, 4), blurRadius: 5)
            ]),
          ),
          Expanded(
              flex: widget.socialLoginData.isHomeContactOpen ? 1 : 2,
              child: Container(
                  color: colorBG,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(icCheckContact, width: 4.w),
                            SizedBox(width: 2.w),
                            Text(
                                '$contactCount/${widget.socialLoginData.selectedContact} Selected ',
                                style: textStyle11Bold(colorText3D3D)),
                            Text(
                                '- ${widget.socialLoginData.selectedContact - contactCount} More',
                                style: textStyle10(colorText3D3D)),
                          ],
                        ),
                      ),
                      button('SAVE & EARN GP', () {
                        if (contactCount == 0) {
                          CommonFunction().errorDialog(context, 'Please Select ${widget.socialLoginData.selectedContact} Contacts');
                        }
                        //else if (contactCount <
                        //     widget.verificationScreenData.selectedContact) {
                        //   print('listdata-------$selectedContacts');
                        //   CommonFunction().errorDialog(context,
                        //       'Please Select ${widget.verificationScreenData.selectedContact - contactCount} Contacts More');
                        // }
                        else {
                          saveAndEarn();
                        }
                      }, state),
                      SizedBox(height: 2.h),
                      widget.socialLoginData.isHomeContactOpen
                          ? Container()
                          : button('SKIP', () {
                        BlocProvider.of<MallBloc>(context).add(
                            LoadMallDataEvent(
                                popular: Popular(
                                    code: 0, message: '', products: []),
                                newArrival: NewArrival(
                                    code: 0, message: '', products: []),
                                trending: Trending(
                                    code: 0, message: '', products: [])));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.route, (route) => false,
                            arguments: HomeScreenData());
                      }),
                      // SizedBox(height: 2.h),
                    ],
                  ))),
        ],
      ),
    );
  }

  textFormFieldContainer(
      String labelText, String hintText,
      [TextEditingController? controller]) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: colorDFDF, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(labelText, style: textStyle10(colorText8181)),
                    SizedBox(
                      width: 84.w - 2,
                      child: TextFormField(
                        controller: controller,
                        readOnly: true,
                        style: textStyle12(colorText3D3D).copyWith(height: 1.3),
                        maxLines: 1,
                        decoration: InputDecoration.collapsed(
                            hintText: hintText,
                            hintStyle: textStyle12(colorText3D3D),
                            fillColor: colorWhite,
                            filled: true,
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    textFormTextFieldContainer2(
      String labelText, String hintText, bool isSelected, Function() onClick,
      [TextEditingController? controller,
        String? Function(String?)? validator,
        TextInputType? keyboardType]) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected ? colorRed : colorDFDF, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(labelText, style: textStyle10(colorText8181)),
                    SizedBox(
                      width: labelText == 'Select DOB' ? 70.w : 84.w - 2,
                      child: labelText == 'Select DOB'
                          ? Text(dob,
                          style: textStyle12(colorText3D3D).copyWith(
                              letterSpacing: dob == "Select Your Date of Birth"
                                  ? 0
                                  : 0.7))
                          : TextFormField(
                        controller: controller,
                        validator: validator,
                        style: textStyle12(colorText3D3D)
                            .copyWith(height: 1.3),
                        maxLines: 1,
                        autofocus: isSelected,
                        decoration: InputDecoration.collapsed(
                            hintText: hintText,
                            hintStyle: textStyle12(colorText3D3D),
                            fillColor: colorWhite,
                            filled: true,
                            border: InputBorder.none),
                        onTap: onClick,
                        keyboardType: keyboardType,
                        textInputAction: labelText == 'Select DOB' ? TextInputAction.done : TextInputAction.next,
                      ),
                    ),
                  ],
                ),
              ),
              if (labelText == 'Select DOB')
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Image.asset(icCalendar, width: 6.w),
                )
            ],
          ),
        ),
      ),
    );
  }

  button(String text, Function()? onClick, [SigningState? state]) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 6.5.h,
        width: 90.w,
        decoration: BoxDecoration(
            color: text == 'SKIP' ? colorRed.withOpacity(0.17) : colorRed,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (text != 'SKIP')
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    color: colorTextBCBC.withOpacity(0.3))
            ]),
        alignment: Alignment.center,
        child: text == 'NEXT'
            ? isVerify || state is GetUserLoading
            ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                color: colorWhite, strokeWidth: 0.7.w))
            : Text(text,
            style:
            textStyle13Bold(text == 'SKIP' ? colorRed : colorWhite))
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            text == 'CONTINUE'
                ? state is SigningDataAdding
                ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                    color: colorWhite, strokeWidth: 0.7.w))
                : Text(text,
                style: textStyle13Bold(
                    text == 'SKIP' ? colorRed : colorWhite))
                : state is AddContactLoading
                ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                    color: colorWhite, strokeWidth: 0.7.w))
                : Text(text,
                style: textStyle13Bold(
                    text == 'SKIP' ? colorRed : colorWhite)),
            /*if (text == 'SAVE & EARN')
              state is AddContactLoading
                  ? Container()
                  : Text(' 1000 GP',
                  style: textStyle13Bold(colorTextFFC1)),*/
          ],
        ),
      ),
    );
  }

}