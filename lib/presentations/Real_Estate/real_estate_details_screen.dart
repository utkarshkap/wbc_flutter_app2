import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/resources/colors.dart';
import 'package:wbc_connect_app/resources/icons.dart';
import 'package:wbc_connect_app/resources/styles.dart';

class RealEstateDetailsScreenData {
  final List? images;
  RealEstateDetailsScreenData({this.images});
}

class RealEstateDetailsScreen extends StatelessWidget {
  static const route = '/Real-Estate-Details';

  final RealEstateDetailsScreenData realEstateDetailsScreenData;

  const RealEstateDetailsScreen(
      {super.key, required this.realEstateDetailsScreenData});

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
          title: Text('Property Images', style: textStyle14Bold(colorBlack)),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(2.w),
          itemCount: realEstateDetailsScreenData.images!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  realEstateDetailsScreenData.images![index],
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
