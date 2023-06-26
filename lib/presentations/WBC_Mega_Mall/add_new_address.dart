import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:wbc_connect_app/common_functions.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:wbc_connect_app/models/address_model.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/buy_now_screen.dart';
import 'package:wbc_connect_app/presentations/WBC_Mega_Mall/cart_screen.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../blocs/signingbloc/signing_bloc.dart';
import '../../core/handler.dart';
import '../../models/country_model.dart';
import '../../models/expanded_category_model.dart';
import '../../models/state_model.dart';
import '../../resources/resource.dart';

class AddNewAddressData {
  ProductList? product;
  int? quantity;
  final String navigateType;
  final String actionType;
  final int id;

  AddNewAddressData(
      {this.product,
      this.quantity,
      required this.navigateType,
      required this.actionType,
      required this.id});
}

class AddNewAddress extends StatefulWidget {
  final AddNewAddressData data;
  static const route = '/Add-New-Address';

  const AddNewAddress({super.key, required this.data});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  String selectedState = 'Select';
  List<States>? statesList = [];
  String selectedCountry = 'Select';
  List<Country>? countriesList = [];
  String selectedAddressType = 'Select an Address Type';
  MapLatLng? _markerPosition;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool isCountryFieldTap = false;
  bool isFullNameFieldTap = false;
  bool isMobileNumFieldTap = false;
  bool isPinCodeFieldTap = false;
  bool isFlatNoFieldTap = false;
  bool isAreaFieldTap = false;
  bool isLandMarkFieldTap = false;
  bool isCityFieldTap = false;
  bool isStateFieldTap = false;
  bool isAddressTypeFieldTap = false;
  FocusNode nameFocus = FocusNode();
  FocusNode numFocus = FocusNode();
  FocusNode pinCodeFocus = FocusNode();
  FocusNode flatFocus = FocusNode();
  FocusNode landMarkFocus = FocusNode();
  FocusNode areaFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  String nameValidation = '';
  String numValidation = '';
  String pinCodeValidation = '';
  String flatValidation = '';
  String areaValidation = '';
  String cityValidation = '';
  String stateValidation = '';
  String countryValidation = '';
  String addressTypeValidation = '';
  bool isDataLoaded = false;
  DatabaseHelper helper = DatabaseHelper();
  List<ShippingAddress> shippingAddressList = [];

  List<String> addressTypes = ['Home', 'Office/Commercial', 'Other'];

  _getGeoLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
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
    return await location.getLocation();
  }

  void getAddressData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ShippingAddress>?> addressList = helper.getAddressList();
      addressList.then((data) {
        if (data!.isNotEmpty) {
          for (int i = 0; i < data.length; i++) {
            if (data[i].id == widget.data.id) {
              setState(() {
                _nameController.text = data[i].name;
                _numController.text = data[i].num;
                _pinCodeController.text = data[i].pinCode;
                _flatNoController.text = data[i].street;
                _areaController.text = data[i].subLocality;
                _cityController.text = data[i].city;
                selectedState = data[i].state;
                selectedCountry = data[i].country;
                selectedAddressType = data[i].addressType;
              });
            }
          }
          setState(() {
            shippingAddressList = data;
          });
        }
      });
    });
  }

  @override
  void initState() {
    getAddressData();
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
                  if (widget.data.navigateType == 'Cart') {
                    Navigator.of(context)
                        .pushReplacementNamed(CartScreen.route);
                  }
                  if (widget.data.navigateType == 'BuyNow') {
                    Navigator.of(context).pushReplacementNamed(
                        BuyNowScreen.route,
                        arguments: BuyNowData(
                            quantity: widget.data.quantity!,
                            product: widget.data.product!));
                  }
                },
                icon: Image.asset(icBack, color: colorRed, width: 6.w)),
            titleSpacing: 0,
            title: Text(
                widget.data.actionType == 'Add'
                    ? 'Add New Address'
                    : 'Edit Address',
                style: textStyle14Bold(colorBlack)),
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacementNamed(CartScreen.route);
              return false;
            },
            child: BlocConsumer<SigningBloc, SigningState>(
              listener: (context, state) {
                if (state is GetUserLoaded) {
                  setState(() {
                    _nameController.text = state.data!.data!.name;
                    _numController.text = state.data!.data!.mobileNo;
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
                if (state is GetUserLoading) {
                  return Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                            color: colorRed, strokeWidth: 0.7.w)),
                  );
                }
                else if (state is GetUserLoaded) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: InkWell(
                                  onTap: () {
                                    _getGeoLocationPermission();
                                    setState(() {
                                      isDataLoaded = true;
                                    });
                                    _currentLocation().then((value) async {
                                      _markerPosition = MapLatLng(
                                          value!.latitude!, value.longitude!);
                                      setState(() {});
                                      List<geo.Placemark> placeMarks =
                                          await geo.placemarkFromCoordinates(
                                              _markerPosition!.latitude,
                                              _markerPosition!.longitude);
                                      geo.Placemark place = placeMarks[0];
                                      _pinCodeController.text =
                                          '${place.postalCode}';
                                      _flatNoController.text =
                                          '${place.street}, ${place.name}';
                                      _areaController.text =
                                          '${place.subLocality}';
                                      _cityController.text =
                                          '${place.locality}';
                                      selectedState =
                                          '${place.administrativeArea}';
                                      selectedCountry = '${place.country}';
                                      isDataLoaded = false;
                                      pinCodeValidation = '';
                                      flatValidation = '';
                                      areaValidation = '';
                                      cityValidation = '';
                                      stateValidation = '';
                                      countryValidation = '';
                                      addressTypeValidation = '';
                                      setState(() {});
                                    });
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: Container(
                                      height: 6.5.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(icCurrentLocation,
                                              color: colorRed, width: 6.w),
                                          SizedBox(width: 3.w),
                                          Text('Use Current Location',
                                              style: textStyle13Medium(
                                                  colorBlack)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 0.05.h,
                                      width: 15.w,
                                      color: colorTextBCBC,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('OR',
                                        style: textStyle9Bold(colorText4D4D)),
                                    SizedBox(width: 2.w),
                                    Container(
                                      height: 0.05.h,
                                      width: 15.w,
                                      color: colorTextBCBC,
                                    )
                                  ],
                                ),
                              ),
                              textFormFieldContainer('Full Name',
                                  'Enter your name', isFullNameFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = true;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                nameFocus.requestFocus();
                              }, _nameController, TextInputType.name),
                              if (nameValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: nameValidation == 'Empty Name'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text('Please Enter a Name',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer('Mobile Number',
                                  'Enter your number', isMobileNumFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = true;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                numFocus.requestFocus();
                              }, _numController, TextInputType.number),
                              if (numValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: numValidation == 'Empty Number'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter a Number',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer('Pincode',
                                  'Enter your pincode', isPinCodeFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = true;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                pinCodeFocus.requestFocus();
                              }, _pinCodeController, TextInputType.number),
                              if (pinCodeValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: pinCodeValidation == 'Empty PinCode'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter a Pin Code',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer(
                                  'Flat, House no., Building, Company, Apartment',
                                  '',
                                  isFlatNoFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = true;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                flatFocus.requestFocus();
                              }, _flatNoController,
                                  TextInputType.streetAddress),
                              if (flatValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: flatValidation == 'Empty Address'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter an Address',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer(
                                  'Area, Street, Sector, Village',
                                  '',
                                  isAreaFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = true;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                areaFocus.requestFocus();
                              }, _areaController, TextInputType.streetAddress),
                              if (areaValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: areaValidation == 'Empty Address'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter an Address',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              textFormFieldContainer(
                                  'Landmark',
                                  'E.g. near censor hospital',
                                  isLandMarkFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = true;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                landMarkFocus.requestFocus();
                              }, _landMarkController,
                                  TextInputType.streetAddress),
                              textFormFieldContainer(
                                  'Town/City', '', isCityFieldTap, () {
                                setState(() {
                                  isCountryFieldTap = false;
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = true;
                                  isStateFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                cityFocus.requestFocus();
                              }, _cityController, TextInputType.streetAddress),
                              if (cityValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: cityValidation == 'Empty City'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text('Please Enter a City',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              dropDownWidget(
                                  'State', selectedState, isStateFieldTap, () {
                                BlocProvider.of<FetchingDataBloc>(context).add(LoadStatesEvent(states: const []));
                                setState(() {
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = true;
                                  isCountryFieldTap = false;
                                  isAddressTypeFieldTap = false;
                                });
                                nameFocus.unfocus();
                                numFocus.unfocus();
                                pinCodeFocus.unfocus();
                                flatFocus.unfocus();
                                areaFocus.unfocus();
                                landMarkFocus.unfocus();
                                cityFocus.unfocus();
                                CommonFunction().selectFormDialog(context, 'Select State', [], (val) {
                                  setState(() {
                                    selectedState = val;
                                  });
                                  Navigator.of(context).pop();
                                });
                              }),
                              if (stateValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: stateValidation == 'Empty State'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter a State',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              BlocListener<FetchingDataBloc, FetchingDataState>(
                                listener: (context, state) {
                                  countriesList = state is CountriesInitial
                                      ? []
                                      : state is CountriesLoadedState
                                          ? state.countries
                                          : null;
                                },
                                child: dropDownWidget('Country',
                                    selectedCountry, isCountryFieldTap, () {
                                  BlocProvider.of<FetchingDataBloc>(context)
                                      .add(LoadCountriesEvent(
                                          countries: const []));
                                  setState(() {
                                    isFullNameFieldTap = false;
                                    isMobileNumFieldTap = false;
                                    isPinCodeFieldTap = false;
                                    isFlatNoFieldTap = false;
                                    isAreaFieldTap = false;
                                    isLandMarkFieldTap = false;
                                    isCityFieldTap = false;
                                    isStateFieldTap = false;
                                    isCountryFieldTap = true;
                                    isAddressTypeFieldTap = false;
                                  });
                                  nameFocus.unfocus();
                                  numFocus.unfocus();
                                  pinCodeFocus.unfocus();
                                  flatFocus.unfocus();
                                  areaFocus.unfocus();
                                  landMarkFocus.unfocus();
                                  cityFocus.unfocus();
                                  CommonFunction().selectFormDialog(
                                      context, 'Select Country', [], (val) {
                                    setState(() {
                                      selectedCountry = val;
                                    });
                                    Navigator.of(context).pop();
                                  });
                                }),
                              ),
                              if (countryValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: countryValidation == 'Empty Country'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter a Country',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              dropDownWidget(
                                  'Address Type',
                                  selectedAddressType,
                                  isAddressTypeFieldTap, () {
                                setState(() {
                                  isFullNameFieldTap = false;
                                  isMobileNumFieldTap = false;
                                  isPinCodeFieldTap = false;
                                  isFlatNoFieldTap = false;
                                  isAreaFieldTap = false;
                                  isLandMarkFieldTap = false;
                                  isCityFieldTap = false;
                                  isStateFieldTap = false;
                                  isCountryFieldTap = false;
                                  isAddressTypeFieldTap = true;
                                });
                                nameFocus.unfocus();
                                numFocus.unfocus();
                                pinCodeFocus.unfocus();
                                flatFocus.unfocus();
                                areaFocus.unfocus();
                                landMarkFocus.unfocus();
                                cityFocus.unfocus();
                                CommonFunction().selectFormDialog(context,
                                    'Select Address Type', addressTypes, (val) {
                                  setState(() {
                                    selectedAddressType = val;
                                    addressTypeValidation = '';
                                  });
                                  Navigator.of(context).pop();
                                });
                              }),
                              if (addressTypeValidation.isNotEmpty)
                                SizedBox(
                                  height: 0.5.h,
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: addressTypeValidation ==
                                          'Empty Address Type'
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.error,
                                                color: colorRed, size: 13),
                                            const SizedBox(width: 4),
                                            Container(
                                              height: 2.h,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  'Please Enter an Address Type',
                                                  style: textStyle9(
                                                      colorErrorRed)),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              button('SAVE', () async {
                                if (_nameController.text.isEmpty) {
                                  setState(() {
                                    nameValidation = 'Empty Name';
                                  });
                                } else {
                                  setState(() {
                                    nameValidation = '';
                                  });
                                }
                                if (_numController.text.isEmpty) {
                                  setState(() {
                                    numValidation = 'Empty Number';
                                  });
                                } else {
                                  setState(() {
                                    numValidation = '';
                                  });
                                }
                                if (_pinCodeController.text.isEmpty) {
                                  setState(() {
                                    pinCodeValidation = 'Empty PinCode';
                                  });
                                } else {
                                  setState(() {
                                    pinCodeValidation = '';
                                  });
                                }
                                if (_flatNoController.text.isEmpty) {
                                  setState(() {
                                    flatValidation = 'Empty Address';
                                  });
                                } else {
                                  setState(() {
                                    flatValidation = '';
                                  });
                                }
                                if (_areaController.text.isEmpty) {
                                  setState(() {
                                    areaValidation = 'Empty Address';
                                  });
                                } else {
                                  setState(() {
                                    areaValidation = '';
                                  });
                                }
                                if (_cityController.text.isEmpty) {
                                  setState(() {
                                    cityValidation = 'Empty City';
                                  });
                                } else {
                                  setState(() {
                                    cityValidation = '';
                                  });
                                }
                                if (selectedState == 'Select') {
                                  setState(() {
                                    stateValidation = 'Empty State';
                                  });
                                } else {
                                  setState(() {
                                    stateValidation = '';
                                  });
                                }
                                if (selectedCountry == 'Select') {
                                  setState(() {
                                    countryValidation = 'Empty Country';
                                  });
                                } else {
                                  setState(() {
                                    countryValidation = '';
                                  });
                                }
                                if (selectedAddressType ==
                                    'Select an Address Type') {
                                  setState(() {
                                    addressTypeValidation =
                                        'Empty Address Type';
                                  });
                                } else {
                                  setState(() {
                                    addressTypeValidation = '';
                                  });
                                }
                                if (_nameController.text.isNotEmpty &&
                                    _numController.text.isNotEmpty &&
                                    _pinCodeController.text.isNotEmpty &&
                                    _flatNoController.text.isNotEmpty &&
                                    _areaController.text.isNotEmpty &&
                                    _cityController.text.isNotEmpty &&
                                    selectedState != 'Select' &&
                                    selectedCountry != 'Select' &&
                                    selectedAddressType !=
                                        'Select an Address Type') {
                                  for (int i = 0;
                                      i < shippingAddressList.length;
                                      i++) {
                                    helper.updateAddressData(ShippingAddress(
                                        id: shippingAddressList[i].id,
                                        name: shippingAddressList[i].name,
                                        num: shippingAddressList[i].num,
                                        pinCode: shippingAddressList[i].pinCode,
                                        street: shippingAddressList[i].street,
                                        subLocality:
                                            shippingAddressList[i].subLocality,
                                        city: shippingAddressList[i].city,
                                        state: shippingAddressList[i].state,
                                        country: shippingAddressList[i].country,
                                        addressType:
                                            shippingAddressList[i].addressType,
                                        isSelected: 0));
                                  }
                                  if (widget.data.actionType == 'Add') {
                                    await helper
                                        .insertAddress(ShippingAddress(
                                            id: widget.data.id,
                                            name: _nameController.text,
                                            num: _numController.text,
                                            pinCode: _pinCodeController.text
                                                .replaceAll(' ', ''),
                                            street: _flatNoController.text,
                                            subLocality: _areaController.text,
                                            city: _cityController.text,
                                            state: selectedState,
                                            country: selectedCountry,
                                            addressType: selectedAddressType,
                                            isSelected: 1))
                                        .then((value) => widget.data.navigateType == 'BuyNow'
                                            ? Navigator.of(context).pushReplacementNamed(
                                                BuyNowScreen.route,
                                                arguments: BuyNowData(
                                                    quantity:
                                                        widget.data.quantity!,
                                                    product:
                                                        widget.data.product!))
                                            : Navigator.of(context)
                                                .pushReplacementNamed(CartScreen.route));
                                  } else {
                                    await helper
                                        .updateAddressData(ShippingAddress(
                                            id: widget.data.id,
                                            name: _nameController.text,
                                            num: _numController.text,
                                            pinCode: _pinCodeController.text
                                                .replaceAll(' ', ''),
                                            street: _flatNoController.text,
                                            subLocality: _areaController.text,
                                            city: _cityController.text,
                                            state: selectedState,
                                            country: selectedCountry,
                                            addressType: selectedAddressType,
                                            isSelected: 1))
                                        .then((value) => widget.data.navigateType == 'BuyNow'
                                            ? Navigator.of(context).pushReplacementNamed(
                                                BuyNowScreen.route,
                                                arguments: BuyNowData(
                                                    quantity:
                                                        widget.data.quantity!,
                                                    product:
                                                        widget.data.product!))
                                            : Navigator.of(context)
                                                .pushReplacementNamed(CartScreen.route));
                                  }
                                }
                              }),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                      if (isDataLoaded)
                        Center(
                          child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                  color: colorRed, strokeWidth: 0.7.w)),
                        )
                    ],
                  );
                }
                return Center(
                  child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                          color: colorRed, strokeWidth: 0.7.w)),
                );
              },
            ),
          ),
        ));
  }

  button(String text, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        onTap: onClick,
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
                    color: colorRed.withOpacity(0.3))
              ]),
          alignment: Alignment.center,
          child: Text(text, style: textStyle13Bold(colorWhite)),
        ),
      ),
    );
  }

  textFormFieldContainer(
      String labelText, String hintText, bool isSelected, Function() onClick,
      [TextEditingController? controller, TextInputType? keyboardType]) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected ? colorRed : colorDFDF, width: 1)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(labelText, style: textStyle9(colorText8181)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                  child: SizedBox(
                    width: 84.w - 2,
                    child: TextFormField(
                      controller: controller,
                      style: textStyle11Medium(colorText3D3D)
                          .copyWith(height: 1.3),
                      maxLines: 1,
                      decoration: InputDecoration.collapsed(
                          hintText: hintText,
                          hintStyle: textStyle11(colorText3D3D),
                          fillColor: colorWhite,
                          filled: true,
                          border: InputBorder.none),
                      focusNode: controller == _numController
                          ? numFocus
                          : controller == _pinCodeController
                              ? pinCodeFocus
                              : controller == _flatNoController
                                  ? flatFocus
                                  : controller == _areaController
                                      ? areaFocus
                                      : controller == _landMarkController
                                          ? landMarkFocus
                                          : controller == _cityController
                                              ? cityFocus
                                              : nameFocus,
                      onTap: onClick,
                      onFieldSubmitted: (val) {
                        if (controller == _nameController) {
                          setState(() {
                            isFullNameFieldTap = false;
                            isMobileNumFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(numFocus);
                        }
                        if (controller == _numController) {
                          setState(() {
                            isMobileNumFieldTap = false;
                            isPinCodeFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(pinCodeFocus);
                        }
                        if (controller == _pinCodeController) {
                          setState(() {
                            isPinCodeFieldTap = false;
                            isFlatNoFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(flatFocus);
                        }
                        if (controller == _flatNoController) {
                          setState(() {
                            isFlatNoFieldTap = false;
                            isAreaFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(areaFocus);
                        }
                        if (controller == _areaController) {
                          setState(() {
                            isAreaFieldTap = false;
                            isLandMarkFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(landMarkFocus);
                        }
                        if (controller == _landMarkController) {
                          setState(() {
                            isLandMarkFieldTap = false;
                            isCityFieldTap = true;
                          });
                          FocusScope.of(context).requestFocus(cityFocus);
                        }
                        if (controller == _cityController) {
                          setState(() {
                            isCityFieldTap = false;
                            isStateFieldTap = true;
                          });
                          cityFocus.unfocus();
                        }
                      },
                      keyboardType: keyboardType,
                      textInputAction: controller == _flatNoController
                          ? TextInputAction.done
                          : TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dropDownWidget(String title, String selectedType, bool isSelectedField,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelectedField ? colorRed : colorDFDF, width: 1)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(title, style: textStyle9(colorText8181)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                  child: SizedBox(
                    width: 84.w - 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(selectedType,
                              style: textStyle11(colorText3D3D)),
                        ),
                        Image.asset(icDropdown,
                            color: colorText3D3D, width: 5.w)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
