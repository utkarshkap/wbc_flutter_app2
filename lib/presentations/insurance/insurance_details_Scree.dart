import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbc_connect_app/models/insurance_investment_model.dart';
import 'package:wbc_connect_app/resources/resource.dart';
import 'package:wbc_connect_app/common_functions.dart';

class InsuranceDetailsData {
  Policy policy;

  InsuranceDetailsData({required this.policy});
}

class InsuranceDetailsScreen extends StatefulWidget {
  static const route = '/Insurance-Details';
  final InsuranceDetailsData insuranceDetailsData;

  const InsuranceDetailsScreen({super.key, required this.insuranceDetailsData});

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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorTextBCBC.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Policy Information',
                          style: textStyle16Bold(colorRed).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        responsiveRowData('Policy No.', 'JGY6552JHGFY'),
                        responsiveRowData('Plan', widget.insuranceDetailsData.policy.plan),
                        responsiveRowData('Sum Insured', 
                          '₹ ${CommonFunction().splitString(widget.insuranceDetailsData.policy.sumAssuredInsured.toString())}'),
                        responsiveRowData('Gross Premium', '₹ 1,500'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 3.h),
                  
                  // Policy Details Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorTextBCBC.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Policy Details',
                          style: textStyle16Bold(colorRedFF6).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        responsiveRowData('Status', 'Not Inforce'),
                        responsiveRowData('Premium Freq', 'SINGLE'),
                        responsiveRowData('Trans Type', 'Fresh'),
                        responsiveRowData('Plan Type', 'CI'),
                        responsiveRowData('Login Date', '01-04-2016'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 3.h),
                  
                  // Additional Information Card (if needed)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorTextBCBC.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Information',
                          style: textStyle16Bold(colorRed).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        responsiveRowData('Policy Holder', 'John Doe'),
                        responsiveRowData('Contact', '+91 98765 43210'),
                        responsiveRowData('Email', 'john.doe@email.com'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget responsiveRowData(String title, String value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        
        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: colorF3F3.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isSmallScreen 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyle12Bold(colorText7070).copyWith(
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: textStyle12Bold(colorBlack).copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: isSmallScreen ? double.infinity : 35.w,
                    child: Text(
                      title,
                      style: textStyle12Bold(colorText7070).copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      value,
                      style: textStyle12Bold(colorBlack).copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }
}
