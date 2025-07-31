import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wbc_connect_app/resources/colors.dart';
import 'package:wbc_connect_app/resources/resource.dart';

class InsuranceDetailsScreen extends StatefulWidget {
  static const route = '/Insurance-Details';

  const InsuranceDetailsScreen({super.key});

  @override
  State<InsuranceDetailsScreen> createState() => _InsuranceDetailsScreenState();
}

class _InsuranceDetailsScreenState extends State<InsuranceDetailsScreen> {
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
          title: Text('Insurance Details', style: textStyle14Bold(colorBlack)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rowData('Policy No.', 'JGY6552JHGFY'),
              rowData('Plan', 'JGY6552JHGFY'),
              rowData('Sum Insured', '15,00,000'),
              rowData('Gross Premium', '₹ 1,500'),
               Padding(
                 padding:  EdgeInsets.only(top: 0.5.h,bottom: 1.5.h),
                 child: Text('Policy Details', style: textStyle13Bold(colorRedFF6)),
               ),
              rowData('Status', 'Not Inforce'),
              rowData('Premim Freq', 'SINGLE'),
              rowData('Trans Type', 'Fresh'),
              rowData('Plan Type', 'CI'),
              rowData('Login Date', '01-04-2016'),
              // rowData('Login Date', '01-04-2016'), 
            ],
          ),
        ),
      ),
    );
  }

  Widget rowData(String title, String value) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          SizedBox(
              width: 35.w,
              child: Text(
                title,
                style: textStyle12Bold(colorText7070),
              )),
          Text(':  $value', style: textStyle12Bold(colorBlack)),
        ],
      ),
    );
  }
}
