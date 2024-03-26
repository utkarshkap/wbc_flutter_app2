import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper {
  static final i = FileHelper._();

  FileHelper._();

  getDirectoryPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        // directory = Directory('/storage/emulated/0/Download');
        // if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
        // }
      }
    } catch (err) {
      print("Cannot get download folder path::::::");
    }
    return directory?.path;

    // final directory = await getDownloadsDirectory();
    // print("FILE PATH::::::::::::::::${directory!.path}");

    // String fullPath = '${storageInfo[0].rootDir}' + '/Download' + '/boo2.pdf';
    // /storage/emulated/0/Download
    // Directory? documents = await getExternalStorageDirectory();

    // final filePath = await getExternalStorageDirectory();
    // if (!await filePath!.exists())
    //   directory = await getExternalStorageDirectory();
    // getApplicationDocumentsDirectory();

    // print(
    // "PATH****************************${documents!.path}=======${filePath.path}");

    // return '/storage/emulated/0/Download';
    // return filePath!.path;
  }
}

class PermissionClass {
  static final i = PermissionClass._();

  PermissionClass._();

  Future<bool> getStoragePermission() async {
    if (Platform.isAndroid) {
      // return true;
      // PermissionStatus storage;
      bool storage;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;

      if (deviceInfo.version.sdkInt >= 32) {
        // storage = await Permission.manageExternalStorage.request();

        storage = await Permission.photos.request().isGranted;
      } else {
        storage = await Permission.storage.request().isGranted;
      }
      if (storage) {
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
