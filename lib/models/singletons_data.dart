import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  //bool hasCustomizeDice = false;
//  bool isRemoveAds = false;
  String appUserID = '';
  BannerAd? banner;
  bool isSmallScreen = false;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
