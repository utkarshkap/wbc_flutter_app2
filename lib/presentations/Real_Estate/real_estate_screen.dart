import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:wbc_connect_app/blocs/review/review_bloc.dart';
import 'package:wbc_connect_app/core/api/api_consts.dart';

import '../../common_functions.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../../widgets/imageCard.dart';
import '../home_screen.dart';
import '../profile_screen.dart';

class RealEstateScreen extends StatefulWidget {
  static const route = '/Real-Estate-Screen';

  const RealEstateScreen({Key? key}) : super(key: key);

  @override
  State<RealEstateScreen> createState() => _RealEstateScreenState();
}

class _RealEstateScreenState extends State<RealEstateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime oldDate = DateTime(2000, 1, 1);
  String selectedPropertyType = 'Select Type';
  String selectedParkingType = 'Yes';
  String selectedYear = '2025';
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _buildupAreaController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _facingController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<String> propertyImages = [];
  bool isPropertyFieldTap = true;
  bool isCarpetAreaFieldTap = false;
  bool isBuildupAreaFieldTap = false;
  bool isLocationFieldTap = false;
  bool isProjectNameFieldTap = false;
  bool isParkingFieldTap = false;
  bool isFacingFieldTap = false;
  bool isYearFieldTap = false;
  bool isPriceFieldTap = false;
  FocusNode carpetAreaFocus = FocusNode();
  FocusNode buildAreaFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode projectNameFocus = FocusNode();
  FocusNode facingFocus = FocusNode();
  FocusNode priceFocus = FocusNode();

  String propertyValidation = '';
  String carpetAreaValidation = '';
  String buildupAreaValidation = '';
  String locationValidation = '';
  String projectNameValidation = '';
  String facingValidation = '';
  String priceValidation = '';
  String imgValidation = '';
  int step = 1;
  final imageController = MultiImagePickerController(
    maxImages: 10,
    allowedImageTypes: ['png', 'jpg', 'jpeg', 'heic'],
  );

  List<String> propertyTypes = [
    'Commercial',
    'Residential',
    'Industrial',
    'Investing',
  ];

  List<String> parkingTypes = ['Yes', 'No'];

  List<String> yearList = [];
  bool isSubmit = false;

  @override
  void initState() {
    print('----differ--==----${DateTime.now().year - oldDate.year}');
    int length = DateTime.now().year - oldDate.year;
    for (int i = 0; i <= length; i++) {
      var date = oldDate.add(const Duration(days: 365));
      yearList.add(date.year.toString());
      oldDate = date;
    }
    print('----selectedYear--==----$selectedYear');
    print('----yearList--==----$yearList');
    super.initState();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colorBG,
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: colorWhite,
          elevation: 0,
          leadingWidth: 15.w,
          leading: IconButton(
            onPressed: () {
              if (step == 1) {
                Navigator.of(context).pop();
              }
              if (step == 2) {
                setState(() {
                  step--;
                });
              }
            },
            icon: Image.asset(icBack, color: colorRed, width: 6.w),
          ),
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step == 1 ? 'Add Real Estate' : 'Add Real Estate',
                style: textStyle12Bold(colorBlack),
              ),
              SizedBox(height: 0.5.h),
              Text('Step $step', style: textStyle8(colorText7070)),
            ],
          ),
          actions: [
            AppBarButton(
              splashColor: colorWhite,
              bgColor: colorF3F3,
              icon: icNotification,
              iconColor: colorText7070,
              onClick: () {},
            ),
            SizedBox(width: 2.w),
            AppBarButton(
              splashColor: colorWhite,
              bgColor: colorF3F3,
              icon: icProfile,
              iconColor: colorText7070,
              onClick: () {
                Navigator.of(context).pushNamed(ProfileScreen.route);
              },
            ),
            SizedBox(width: 5.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size(100.w, 0.6.h),
            child: Stack(
              children: [
                Container(height: 0.6.h, width: 100.w, color: colorRedFFC),
                Container(
                  height: 0.6.h,
                  width: step == 1
                      ? 100.w / 2
                      : step == 2
                      ? (100.w / 2) * 2
                      : (100.w / 2) * 2,
                  color: colorRed,
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (step == 1) {
              Navigator.of(context).pop();
            }
            if (step == 2) {
              setState(() {
                step--;
              });
            }
            return false;
          },
          child: SafeArea(
            top: true,
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [if (step == 1) step1(), if (step == 2) step2()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  step1() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    'What kind of place are\nyour listing?',
                    textAlign: TextAlign.center,
                    style: textStyle20Bold(colorBlack).copyWith(height: 1.33),
                  ),
                ),
                dropDownWidget(
                  'Choose a property type',
                  selectedPropertyType,
                  isPropertyFieldTap,
                  () {
                    setState(() {
                      isPropertyFieldTap = true;
                      isCarpetAreaFieldTap = false;
                      isBuildupAreaFieldTap = false;
                      isLocationFieldTap = false;
                      isProjectNameFieldTap = false;
                      isParkingFieldTap = false;
                      isFacingFieldTap = false;
                      isYearFieldTap = false;
                      isPriceFieldTap = false;
                    });
                    carpetAreaFocus.unfocus();
                    buildAreaFocus.unfocus();
                    locationFocus.unfocus();
                    projectNameFocus.unfocus();
                    facingFocus.unfocus();
                    priceFocus.unfocus();
                    CommonFunction().selectFormDialog(
                      context,
                      'Select Property Type',
                      propertyTypes,
                      (val) {
                        setState(() {
                          selectedPropertyType = val;
                          isPropertyFieldTap = false;
                          isCarpetAreaFieldTap = true;
                          isBuildupAreaFieldTap = false;
                          isLocationFieldTap = false;
                          isProjectNameFieldTap = false;
                          isParkingFieldTap = false;
                          isFacingFieldTap = false;
                          isYearFieldTap = false;
                          isPriceFieldTap = false;
                        });
                        carpetAreaFocus.requestFocus();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                if (propertyValidation.isNotEmpty) SizedBox(height: 0.5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: propertyValidation == 'Empty Property'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: colorRed,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                height: 2.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'Please Select Property Type',
                                  style: textStyle9(colorErrorRed),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormFieldContainer(
                          'Carpet Area Sq. Ft',
                          'Enter Sq. Ft Area',
                          isCarpetAreaFieldTap,
                          () {
                            setState(() {
                              isPropertyFieldTap = false;
                              isCarpetAreaFieldTap = true;
                              isBuildupAreaFieldTap = false;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = false;
                              isFacingFieldTap = false;
                              isYearFieldTap = false;
                              isPriceFieldTap = false;
                            });
                            carpetAreaFocus.requestFocus();
                          },
                          _carpetAreaController,
                          TextInputType.number,
                        ),
                        if (carpetAreaValidation.isNotEmpty)
                          SizedBox(height: 0.5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: carpetAreaValidation == 'Empty Carpet Area'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        color: colorRed,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Please Enter a Value',
                                          style: textStyle9(colorErrorRed),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormFieldContainer(
                          'Super Builtup Area Sq. Ft',
                          'Enter Sq. Ft Area',
                          isBuildupAreaFieldTap,
                          () {
                            setState(() {
                              isPropertyFieldTap = false;
                              isCarpetAreaFieldTap = false;
                              isBuildupAreaFieldTap = true;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = false;
                              isFacingFieldTap = false;
                              isYearFieldTap = false;
                              isPriceFieldTap = false;
                            });
                            buildAreaFocus.requestFocus();
                          },
                          _buildupAreaController,
                          TextInputType.number,
                        ),
                        if (buildupAreaValidation.isNotEmpty)
                          SizedBox(height: 0.5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: buildupAreaValidation == 'Empty Buildup Area'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        color: colorRed,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Please Enter a Value',
                                          style: textStyle9(colorErrorRed),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                textFormFieldContainer(
                  'Location',
                  'Enter your location',
                  isLocationFieldTap,
                  () {
                    setState(() {
                      isPropertyFieldTap = false;
                      isCarpetAreaFieldTap = false;
                      isBuildupAreaFieldTap = false;
                      isLocationFieldTap = true;
                      isProjectNameFieldTap = false;
                      isParkingFieldTap = false;
                      isFacingFieldTap = false;
                      isYearFieldTap = false;
                      isPriceFieldTap = false;
                    });
                    locationFocus.requestFocus();
                  },
                  _locationController,
                  TextInputType.streetAddress,
                ),
                if (locationValidation.isNotEmpty) SizedBox(height: 0.5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: locationValidation == 'Empty Location'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: colorRed,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                height: 2.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'Please Enter a Location',
                                  style: textStyle9(colorErrorRed),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ),
                textFormFieldContainer(
                  'Project Name',
                  'Enter your Project Name',
                  isProjectNameFieldTap,
                  () {
                    setState(() {
                      isPropertyFieldTap = false;
                      isCarpetAreaFieldTap = false;
                      isBuildupAreaFieldTap = false;
                      isLocationFieldTap = false;
                      isProjectNameFieldTap = true;
                      isParkingFieldTap = false;
                      isFacingFieldTap = false;
                      isYearFieldTap = false;
                      isPriceFieldTap = false;
                    });
                    projectNameFocus.requestFocus();
                  },
                  _projectNameController,
                  TextInputType.name,
                ),
                if (projectNameValidation.isNotEmpty) SizedBox(height: 0.5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: projectNameValidation == 'Empty Project Name'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: colorRed,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                height: 2.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'Please Enter a Project Name',
                                  style: textStyle9(colorErrorRed),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        dropDownWidget(
                          'Car Parking',
                          selectedParkingType,
                          isParkingFieldTap,
                          () {
                            setState(() {
                              isPropertyFieldTap = false;
                              isCarpetAreaFieldTap = false;
                              isBuildupAreaFieldTap = false;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = true;
                              isFacingFieldTap = false;
                              isYearFieldTap = false;
                              isPriceFieldTap = false;
                            });
                            carpetAreaFocus.unfocus();
                            buildAreaFocus.unfocus();
                            locationFocus.unfocus();
                            projectNameFocus.unfocus();
                            facingFocus.unfocus();
                            priceFocus.unfocus();
                            CommonFunction().selectFormDialog(
                              context,
                              'Select Parking Type',
                              parkingTypes,
                              (val) {
                                setState(() {
                                  selectedParkingType = val;
                                  isPropertyFieldTap = false;
                                  isCarpetAreaFieldTap = false;
                                  isBuildupAreaFieldTap = false;
                                  isLocationFieldTap = false;
                                  isProjectNameFieldTap = false;
                                  isParkingFieldTap = false;
                                  isFacingFieldTap = true;
                                  isYearFieldTap = false;
                                  isPriceFieldTap = false;
                                });
                                facingFocus.requestFocus();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormFieldContainer(
                          'Facing',
                          'Enter Facing',
                          isFacingFieldTap,
                          () {
                            setState(() {
                              isCarpetAreaFieldTap = false;
                              isPropertyFieldTap = false;
                              isBuildupAreaFieldTap = false;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = false;
                              isFacingFieldTap = true;
                              isYearFieldTap = false;
                              isPriceFieldTap = false;
                            });
                            facingFocus.requestFocus();
                          },
                          _facingController,
                          TextInputType.text,
                        ),
                        if (facingValidation.isNotEmpty)
                          SizedBox(height: 0.5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: facingValidation == 'Empty Facing'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        color: colorRed,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Please Enter a Facing',
                                          style: textStyle9(colorErrorRed),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        dropDownWidget(
                          'Select Year',
                          selectedYear,
                          isYearFieldTap,
                          () {
                            setState(() {
                              isPropertyFieldTap = false;
                              isCarpetAreaFieldTap = false;
                              isBuildupAreaFieldTap = false;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = false;
                              isFacingFieldTap = false;
                              isYearFieldTap = true;
                              isPriceFieldTap = false;
                            });
                            carpetAreaFocus.unfocus();
                            buildAreaFocus.unfocus();
                            locationFocus.unfocus();
                            projectNameFocus.unfocus();
                            facingFocus.unfocus();
                            priceFocus.unfocus();
                            CommonFunction().selectFormDialog(
                              context,
                              'Select Year',
                              yearList,
                              (val) {
                                setState(() {
                                  selectedYear = val;
                                  isPropertyFieldTap = false;
                                  isCarpetAreaFieldTap = false;
                                  isBuildupAreaFieldTap = false;
                                  isLocationFieldTap = false;
                                  isProjectNameFieldTap = false;
                                  isParkingFieldTap = false;
                                  isFacingFieldTap = false;
                                  isYearFieldTap = false;
                                  isPriceFieldTap = true;
                                });
                                priceFocus.requestFocus();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormFieldContainer(
                          'Price',
                          'Enter Price',
                          isPriceFieldTap,
                          () {
                            setState(() {
                              isPropertyFieldTap = false;
                              isCarpetAreaFieldTap = false;
                              isBuildupAreaFieldTap = false;
                              isLocationFieldTap = false;
                              isProjectNameFieldTap = false;
                              isParkingFieldTap = false;
                              isFacingFieldTap = false;
                              isYearFieldTap = false;
                              isPriceFieldTap = true;
                            });
                            priceFocus.requestFocus();
                          },
                          _priceController,
                          TextInputType.number,
                        ),
                        if (priceValidation.isNotEmpty) SizedBox(height: 0.5.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: priceValidation == 'Empty Price'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        color: colorRed,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 2.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Please Enter a Price',
                                          style: textStyle9(colorErrorRed),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.5.h),
            child: button('NEXT', () {
              if (selectedPropertyType == 'Select Type') {
                setState(() {
                  propertyValidation = 'Empty Property';
                });
              } else {
                setState(() {
                  propertyValidation = '';
                });
              }
              if (_carpetAreaController.text.isEmpty) {
                setState(() {
                  carpetAreaValidation = 'Empty Carpet Area';
                });
              } else {
                setState(() {
                  carpetAreaValidation = '';
                });
              }
              if (_buildupAreaController.text.isEmpty) {
                setState(() {
                  buildupAreaValidation = 'Empty Buildup Area';
                });
              } else {
                setState(() {
                  buildupAreaValidation = '';
                });
              }
              if (_locationController.text.isEmpty) {
                setState(() {
                  locationValidation = 'Empty Location';
                });
              } else {
                setState(() {
                  locationValidation = '';
                });
              }
              if (_projectNameController.text.isEmpty) {
                setState(() {
                  projectNameValidation = 'Empty Project Name';
                });
              } else {
                setState(() {
                  projectNameValidation = '';
                });
              }
              if (_facingController.text.isEmpty) {
                setState(() {
                  facingValidation = 'Empty Facing';
                });
              } else {
                setState(() {
                  facingValidation = '';
                });
              }
              if (_priceController.text.isEmpty) {
                setState(() {
                  priceValidation = 'Empty Price';
                });
              } else {
                setState(() {
                  priceValidation = '';
                });
              }
              if (selectedPropertyType != 'Select Type' &&
                  _carpetAreaController.text.isNotEmpty &&
                  _buildupAreaController.text.isNotEmpty &&
                  _locationController.text.isNotEmpty &&
                  _projectNameController.text.isNotEmpty &&
                  _facingController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                setState(() {
                  step++;
                });
              }
            }),
          ),
        ],
      ),
    );
  }

  step2() {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        print('------islistner----$state');

        if (state is UploadRealEstateDataFailed) {
          isSubmit = false;
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
        } else if (state is UploadRealEstateDataAdded) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.route,
            (route) => false,
            arguments: HomeScreenData(
              acceptedContacts: '',
              isSendReview: 'SubmitRealEstate',
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  'Upload listing photo',
                  textAlign: TextAlign.center,
                  style: textStyle20Bold(colorBlack).copyWith(height: 1.33),
                ),
              ),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                color: colorTextBCBC.withOpacity(0.36),
                padding: EdgeInsets.zero,
                strokeWidth: 3,
                dashPattern: const [5, 5],
                child: Container(
                  height: (20.h * 2) + 40,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: MultiImagePickerView(
                      controller: imageController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      initialContainerBuilder: (context, pickerCallback) {
                        return GestureDetector(
                          onTap: pickerCallback,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            color: colorTextBCBC.withOpacity(0.36),
                            padding: EdgeInsets.zero,
                            strokeWidth: 5,
                            dashPattern: const [5, 5],
                            child: Container(
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    icUpload,
                                    color: colorRed,
                                    width: 5.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Upload Photos',
                                    style: textStyle11Bold(colorText7070),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, image, removeCallback) {
                        return ImageCard(
                          file: image,
                          deleteCallback: removeCallback,
                        );
                      },
                      addMoreBuilder: (context, pickerCallback) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onTap: pickerCallback,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              color: colorTextBCBC.withOpacity(0.36),
                              padding: EdgeInsets.zero,
                              strokeWidth: 5,
                              dashPattern: const [5, 5],
                              child: Container(
                                // height: 6.h,
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      icUpload,
                                      color: colorRed,
                                      width: 5.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Upload Photos',
                                      style: textStyle11Bold(colorText7070),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onDragBoxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChange: (images) {
                        if (images.isNotEmpty) {
                          setState(() {
                            imgValidation = '';
                          });
                        }
                        // callback to update images
                      },
                    ),
                  ),
                ),
              ),
              if (imgValidation.isNotEmpty) SizedBox(height: 0.5.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: imgValidation == 'Empty Images'
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: colorRed, size: 13),
                            const SizedBox(width: 4),
                            Container(
                              height: 2.h,
                              alignment: Alignment.center,
                              child: Text(
                                'Please Select an Images',
                                style: textStyle9(colorErrorRed),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 2.5.h),
                child: button('SUBMIT', () {
                  for (var image in imageController.images) {
                    propertyImages.add(image.path!);
                  }
                  if (propertyImages.isEmpty) {
                    setState(() {
                      imgValidation = 'Empty Images';
                    });
                  } else {
                    setState(() {
                      imgValidation = '';
                    });
                  }
                  if (propertyImages.isNotEmpty) {
                    setState(() {
                      isSubmit = true;
                    });
                    print('----==----pathList-=---$propertyImages');
                    BlocProvider.of<ReviewBloc>(context).add(
                      UploadRealEstateData(
                        propertyType: selectedPropertyType,
                        carpetArea: _carpetAreaController.text.trim(),
                        BuiltUpArea: _buildupAreaController.text.trim(),
                        Location: _locationController.text.trim(),
                        ProjectName: _projectNameController.text.trim(),
                        carParking: selectedParkingType,
                        enterFacing: _facingController.text.trim(),
                        Price: _priceController.text.trim(),
                        userId: ApiUser.userId,
                        imgPath: propertyImages,
                        Year: selectedYear,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  button(String title, Function() onClick) {
    print('issubmit=======$isSubmit$title');
    return InkWell(
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
              color: colorRed.withOpacity(0.35),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: title == 'SUBMIT'
            ? isSubmit
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: colorWhite,
                        strokeWidth: 0.6.w,
                      ),
                    )
                  : Text(title, style: textStyle12Bold(colorWhite))
            : Text(title, style: textStyle12Bold(colorWhite)),
      ),
    );
  }

  textFormFieldContainer(
    String labelText,
    String hintText,
    bool isSelected,
    Function() onClick, [
    TextEditingController? controller,
    TextInputType? keyboardType,
  ]) {
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
              color: isSelected ? colorRed : colorDFDF,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labelText, style: textStyle9(colorText8181)),
                SizedBox(
                  width:
                      controller == _locationController ||
                          controller == _projectNameController
                      ? 84.w - 2
                      : 37.5.w - 2,
                  child: TextFormField(
                    controller: controller,
                    style: textStyle11(colorText3D3D).copyWith(height: 1.3),
                    maxLines: 1,
                    // autofocus: isSelected,
                    decoration: InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: textStyle11(colorText3D3D),
                      fillColor: colorWhite,
                      filled: true,
                      border: InputBorder.none,
                    ),
                    focusNode: controller == _buildupAreaController
                        ? buildAreaFocus
                        : controller == _locationController
                        ? locationFocus
                        : controller == _projectNameController
                        ? projectNameFocus
                        : controller == _facingController
                        ? facingFocus
                        : controller == _priceController
                        ? priceFocus
                        : carpetAreaFocus,
                    onTap: onClick,
                    onFieldSubmitted: (val) {
                      if (controller == _carpetAreaController) {
                        setState(() {
                          isCarpetAreaFieldTap = false;
                          isBuildupAreaFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(buildAreaFocus);
                      }
                      if (controller == _buildupAreaController) {
                        setState(() {
                          isBuildupAreaFieldTap = false;
                          isLocationFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(locationFocus);
                      }
                      if (controller == _locationController) {
                        setState(() {
                          isLocationFieldTap = false;
                          isProjectNameFieldTap = true;
                        });
                        FocusScope.of(context).requestFocus(projectNameFocus);
                      }
                      if (controller == _projectNameController) {
                        setState(() {
                          isLocationFieldTap = false;
                          isParkingFieldTap = true;
                        });
                        projectNameFocus.unfocus();
                      }
                      if (controller == _facingController) {
                        setState(() {
                          isFacingFieldTap = false;
                          isYearFieldTap = true;
                        });
                        facingFocus.unfocus();
                      }
                    },
                    keyboardType: keyboardType,
                    textInputAction: controller == _priceController
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dropDownWidget(
    String title,
    String selectedType,
    bool isSelectedField,
    Function() onClick,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: InkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelectedField ? colorRed : colorDFDF,
              width: 1,
            ),
          ),
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
                    width: title == 'Car Parking' || title == 'Select Year'
                        ? 37.5.w - 2
                        : 84.w - 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedType,
                            style: textStyle11(colorText3D3D),
                          ),
                        ),
                        Image.asset(
                          icDropdown,
                          color: colorText3D3D,
                          width: 5.w,
                        ),
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
