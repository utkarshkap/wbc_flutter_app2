import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/resources/icons.dart';

class AppBarButton extends StatelessWidget {
  final Color splashColor;
  final Color bgColor;
  final String icon;
  final Color iconColor;
  final Function() onClick;

  const AppBarButton(
      {super.key,
      required this.splashColor,
      required this.bgColor,
      required this.icon,
      required this.iconColor,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        constraints: BoxConstraints(minWidth: 8.w, minHeight: 8.h),
        padding: EdgeInsets.zero,
        splashRadius: 5.5.w,
        splashColor: splashColor,
        onPressed: onClick,
        icon: Container(
          height: 8.h,
          width: 8.w,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Image.asset(icon,
              width: icon == icNotification || icon == icFlash
                  ? 3.2.w
                  : icon == icDownload
                      ? 7.w
                      : 4.w,
              color: iconColor),
        ));
  }
}
