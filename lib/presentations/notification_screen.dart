import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../resources/resource.dart';

class NotificationScreen extends StatefulWidget {
  static const route = '/Notification-Screen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
              title: Text('Notifications', style: textStyle14Bold(colorBlack)),
              // actions: [
              //   Padding(
              //     padding: EdgeInsets.only(right: 3.h),
              //     child: Center(
              //         child:
              //             Text('Clear All', style: textStyle9Bold(colorBlack))),
              //   ),
              // ],
            ),
            body: Center(
                child: Text('There are no Notifications',
                    style: textStyle13(colorText7070)))
            // SingleChildScrollView(
            //     child: Column(
            //         children: List.generate(10, (index) {
            //   return notificationView();
            // })))
            ));
  }

  notificationView() {
    return Container(
      margin: EdgeInsets.only(top: 0.3.h),
      decoration: BoxDecoration(color: colorWhite, boxShadow: [
        BoxShadow(
            color: colorTextBCBC.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 6))
      ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.5.w),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Container(
                    height: 5.2.h,
                    width: 5.2.h,
                    decoration: const BoxDecoration(
                      color: colorRed,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(icNotification,
                        color: colorWhite, height: 2.2.h),
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Insurance Review", style: textStyle11Bold(colorBlack)),
                  SizedBox(height: 0.7.h),
                  Text('Lorem Ipsum is simply dummy text.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle9(colorText7070)),
                  SizedBox(height: 0.3.h),
                  Text("2 hour ago", style: textStyle8Bold(colorRed)),
                ],
              ),
            ),
            // const Spacer(),
            SizedBox(
              width: 5.w,
            ),
            IconButton(
                constraints: BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                padding: EdgeInsets.zero,
                splashRadius: 5.5.w,
                splashColor: colorWhite,
                onPressed: () {},
                icon: ClipOval(
                  child: Container(
                    color: colorTextBCBC,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(icDelete,
                          width: 4.w, color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
