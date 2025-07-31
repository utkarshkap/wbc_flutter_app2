import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wbc_connect_app/blocs/fetchingData/fetching_data_bloc.dart';
import 'package:wbc_connect_app/presentations/Real_Estate/real_estate_details_screen.dart';
import 'package:wbc_connect_app/presentations/notification_screen.dart';
import 'package:wbc_connect_app/presentations/profile_screen.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import 'package:wbc_connect_app/widgets/appbarButton.dart';

class RealEstateProperty extends StatefulWidget {
  static const route = '/Real-Estate-Property';

  const RealEstateProperty({super.key});

  @override
  State<RealEstateProperty> createState() => _RealEstatePropertyState();
}

class _RealEstatePropertyState extends State<RealEstateProperty> {
  final TextEditingController _searchController = TextEditingController();

  List images = [
    'assets/images/img/image1.png',
    'assets/images/img/image2.png',
    'assets/images/img/image3.jpg',
    'assets/images/img/image4.jpeg',
    'assets/images/img/image5.jpeg',
  ];

  List<bool> _expandedCards = [];

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
          title: Text('Real Estate', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {
                  // Navigator.of(context).pushNamed(RealEstateDetailsScreen.route,
                  //     arguments: RealEstateDetailsScreenData(images: images));
                  Navigator.of(context).pushNamed(NotificationScreen.route);
                }),
            SizedBox(width: 2.w),
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icProfile,
                iconColor: colorText7070,
                onClick: () {
                  Navigator.of(context).pushNamed(ProfileScreen.route);
                }),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is RealEstatePropertyErrorState) {
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
            return BlocBuilder<FetchingDataBloc, FetchingDataState>(
              builder: (context, state) {
                if (state is RealEstatePropertyInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RealEstatePropertyLoadedState) {
                  final realties = state.realEstatePropertyModel.realty;

                  if (_expandedCards.length != realties.length) {
                    _expandedCards =
                        List.generate(realties.length, (_) => false);
                  }

                  return realties.isEmpty
                      ? Center(
                          child: Text('No Data',
                              style: textStyle13(colorText7070)))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              children: List.generate(realties.length, (index) {
                                final data = realties[index];
                                final isExpanded = _expandedCards[index];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _expandedCards[index] =
                                          !_expandedCards[index];
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    padding: EdgeInsets.all(3.w),
                                    decoration: decoration(colorWhite),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (isExpanded) ...[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CarouselSlider(
                                              options: CarouselOptions(
                                                height: 22.h,
                                                viewportFraction: 1.0,
                                                autoPlay: true,
                                                autoPlayInterval:
                                                    const Duration(seconds: 2),
                                                enableInfiniteScroll: true,
                                              ),
                                              items: images.map((imgPath) {
                                                return Image.asset(
                                                  imgPath,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 1.h),
                                        Text(data.projectName.trim(),
                                            style: textStyle13Bold(colorBlack)),
                                        SizedBox(height: 0.5.h),
                                        Text("Plot No: ${data.plotNo}",
                                            style:
                                                textStyle10Bold(colorText8181)),
                                        SizedBox(height: 0.5.h),
                                        Text(data.address.trim(),
                                            style:
                                                textStyle9Bold(colorText8181)),
                                        SizedBox(height: 0.5.h),
                                        Row(
                                          children: [
                                            Image.asset(
                                              icSqft,
                                              height: 2.h,
                                              width: 2.h,
                                              color: colorText8181,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text("${data.sqFt} sqft",
                                                style: textStyle8Bold(
                                                    colorText8181)),
                                            SizedBox(width: 2.w),
                                            Image.asset(
                                              icSqft,
                                              height: 2.h,
                                              width: 2.h,
                                              color: colorText8181,
                                            ),
                                            SizedBox(width: 1.w),
                                            Text("${data.yard} yard",
                                                style: textStyle8Bold(
                                                    colorText8181)),
                                          ],
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          'Purchase Date: ${DateFormat('dd MMM yy').format(data.salesDate)}',
                                          style: textStyle10(colorText7070),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          '₹ ${data.totalAmount.toStringAsFixed(0)}/-',
                                          style: textStyle15Bold(colorRed),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  BoxDecoration decoration(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 6),
          blurRadius: 8,
          color: colorTextBCBC.withOpacity(0.3),
        ),
      ],
    );
  }
}
