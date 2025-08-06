import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:sizer/sizer.dart';
import 'resources/colors.dart';
import 'resources/styles.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print('Current App Version: $currentVersion');

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    await remoteConfig.fetchAndActivate();

    String latestVersion = remoteConfig.getString('app_update');

    print('latestVersion.......$latestVersion')
;    // ApiUser.wbcGp = remoteConfig.getString('wbc_gp');
   
    // Simulate fetching the latest version from server or Firebase Remote Config
    // String latestVersion = "2.0.0"; // example hardcoded

    if (currentVersion != latestVersion) {
      showUpdateDialog(context);
    }
  }

  static String _getStoreUrl() {
    if (Platform.isIOS) {
      // Replace with your iOS App Store URL


      https://apps.apple.com/in/app/your-app-name/id1234567890

      return "https://apps.apple.com/app/your-app-id";
    } else if (Platform.isAndroid) {
      // Replace with your Android Play Store URL
      return "https://play.google.com/store/apps/details?id=in.kagroup.finer";
    } else {
      // Fallback URL
      // https://yourappstorelink.com
      return "";
    }
  }

  static void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // force update if needed
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorBlack.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Update Icon with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        height: 15.h,
                        width: 15.h,
                        decoration: BoxDecoration(
                          color: colorRed.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.system_update_alt,
                          size: 8.h,
                          color: colorRed,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 3.h),
                
                // Title with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          "Update Available",
                          style: textStyle20Bold(colorBlack),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),
                
                // Description with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          "A new version of the app is available. Please update to continue using all features.",
                          style: textStyle12Medium(colorText7070),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
                
                // Update Button with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: InkWell(
                        onTap: () async {
                          final url = _getStoreUrl();
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: Container(
                          height: 6.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [colorRed, colorBoxGradiant3333],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: colorRed.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Update Now",
                              style: textStyle14Bold(colorWhite),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}