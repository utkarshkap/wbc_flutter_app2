import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLocaleHelper {
  static bool _localeSet = false;

  /// Ensures Firebase Auth locale is set to prevent X-Firebase-Locale warning
  static Future<void> ensureLocaleSet() async {
    if (!_localeSet) {
      try {
        await FirebaseAuth.instance.setLanguageCode('en');
        _localeSet = true;
        print('Firebase Auth locale set successfully');
      } catch (e) {
        print('Error setting Firebase Auth locale: $e');
      }
    }
  }

  /// Reset the locale set flag (useful for testing)
  static void resetLocaleFlag() {
    _localeSet = false;
  }
}
