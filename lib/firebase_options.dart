// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUk50_FvGFaxTmcqbd6ujFpi3ngAwMewk',
    appId: '1:217717536609:android:1874486d1773432cbcb720',
    messagingSenderId: '217717536609',
    projectId: 'wbcconnect-8cd0a',
    storageBucket: 'wbcconnect-8cd0a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCONabpCVKA9VkPYoOUqLPE0UILYkiXloI',
    appId: '1:217717536609:ios:61d0d4ba7f7ab442bcb720',
    messagingSenderId: '217717536609',
    projectId: 'wbcconnect-8cd0a',
    storageBucket: 'wbcconnect-8cd0a.appspot.com',
    androidClientId:
        '217717536609-16pqq20jvr3210sp8sntcehkbgja7pfb.apps.googleusercontent.com',
    iosClientId:
        '217717536609-gabiqf0e9b8t3807qbmeg7uhc73p8co5.apps.googleusercontent.com',
    iosBundleId: 'in.kagroup.finer',
  );
}
