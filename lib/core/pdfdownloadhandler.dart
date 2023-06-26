import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper {
  static final i = FileHelper._();

  FileHelper._();

  getDirectoryPath() async {
    Directory filePath = await getApplicationDocumentsDirectory();
    return filePath.path;
  }
}

class PermissionClass {
  static final i = PermissionClass._();

  PermissionClass._();

  Future<bool> getStoragePermission() async {
    if (Platform.isAndroid) {
      return true;
      PermissionStatus storage;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      if (deviceInfo.version.sdkInt >= 30) {
        storage = await Permission.manageExternalStorage.request();
        log("External Stoarge ${storage.isGranted}");
      } else {
        storage = await Permission.storage.request();
      }
      if (storage.isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    } else {
      return true;
    }
  }
}
