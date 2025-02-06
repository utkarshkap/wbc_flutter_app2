import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const String _isLogin = 'isLogin';
  static const String _email = 'email';
  static const String _isAddContact = 'isAddContact';
  static const String _isShowCase = 'isShowCase';
  static const String _userid = 'userId';
  static const String _mono = 'mono';
  static const String _countryCode = 'countryCode';
  static const String _contactApproveCount = 'approveCount';
  static const String _renewContact = 'renewContact';
  static const String _buyNowProduct = 'buyNowProduct';
  static const String _fastTrackStatus = 'fastTrackStatus';

  /// LoginCheck  preference
  static Future<bool> setIsLogin(bool isBig) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_isLogin, isBig);
  }

  static Future<bool> getIsLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isLogin) ?? false;
  }

  static Future<bool> setIsContact(bool isBig) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_isAddContact, isBig);
  }

  static Future<bool> getIsContact() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isAddContact) ?? false;
  }

  static Future<bool> setShowCase(bool isShowCase) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_isShowCase, isShowCase);
  }

  static Future<bool> getShowCase() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isShowCase) ?? false;
  }

  static setUserid(String isBig) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_userid, isBig);
  }

  static getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_userid) ?? "";
  }

  static setEmail(String email) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_email, email);
  }

  static getEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_email) ?? "";
  }

  static setFastTrackStatus(bool fastTrackStatus) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_fastTrackStatus, fastTrackStatus);
  }

  static getFastTrackStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_fastTrackStatus) ?? "";
  }

  static setApproveContactCount(String isBig) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_contactApproveCount, isBig);
  }

  static getApproveContactCount() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_contactApproveCount) ?? "";
  }

  static Future<bool> setRenewContact(bool isBig) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_renewContact, isBig);
  }

  static Future<bool> getRenewContact() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_renewContact) ?? false;
  }

  static setMobNo(String isBig) async {
    print('ismono------$isBig');

    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_mono, isBig);
  }

  static getMobNo() async {
    final pref = await SharedPreferences.getInstance();
    print('--pref--mobileNumber--=----${pref.getString(_mono)}');
    return pref.getString(_mono) ?? "";
  }

  static setCountryCode(String isBig) async {
    print('isCountryCode------$isBig');

    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_countryCode, isBig);
  }

  static getCountryCode() async {
    final pref = await SharedPreferences.getInstance();
    print('--pref--countrycode--=----${pref.getString(_countryCode)}');
    return pref.getString(_countryCode) ?? "";
  }

  static setWealthScore(double score) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setDouble('WealthScore', score);
  }

  static getWealthScore() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getDouble('WealthScore') ?? 0.0;
  }
// Rate us preference
// static Future<bool> setRateUs(bool rateUs) async {
//   final pref = await SharedPreferences.getInstance();
//   return await pref.setBool(_prefRateUs, rateUs);
// }
//
// static Future<bool> getRateUs() async {
//   final pref = await SharedPreferences.getInstance();
//   return pref.getBool(_prefRateUs) ?? false;
// }
//
// ///  setSplashAd
// static setSplashInterstitialAd(bool isShow) async {
//   final pref = await SharedPreferences.getInstance();
//   await pref.setBool(_prefShowAd, isShow);
//   print("===1534646 ===${Preference.getSplashInterstitialAd()}");
// }
//
// static Future<bool> getSplashInterstitialAd() async {
//   final pref = await SharedPreferences.getInstance();
//   print('getdata========');
//   print(pref.getBool(_prefShowAd));
//   return pref.getBool(_prefShowAd) ?? false;
// }
}
