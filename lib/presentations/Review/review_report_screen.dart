import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:wbc_connect_app/resources/resource.dart';


class ReviewReportData {
  File pdf;
  ReviewReportData({required this.pdf});
}

class ReviewReportScreen extends StatefulWidget {
    static const route = '/Review-Report-Screen';

  final ReviewReportData reviewReportData;
  const ReviewReportScreen(this.reviewReportData,{super.key,});

  @override
  State<ReviewReportScreen> createState() => _ReviewReportScreenState();
}

class _ReviewReportScreenState extends State<ReviewReportScreen> {
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
          title: Text('Review Report', style: textStyle14Bold(colorBlack)),
        ),
        body: PDFView(
        filePath: widget.reviewReportData.pdf.path,
      )
      ),
    );
  }
}

