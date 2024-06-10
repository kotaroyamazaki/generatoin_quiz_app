import 'package:generation_quiz_app/firebase_options.dart';
import 'package:generation_quiz_app/models/singletons_data.dart';
import 'package:generation_quiz_app/screens/home_screen.dart';
import 'package:generation_quiz_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:generation_quiz_app/widgets/admob_banner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

BannerAd? myBanner;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  loadBannerAd();
  // SEかどうかの判定
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    // iPhone SE の画面幅を基準にする
    appData.isSmallScreen = screenHeight <= 670.0;

    return MaterialApp(
      title: 'あのときなにがあった？クイズ',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}

void loadBannerAd() async {
  final bannerId = getAdBannerUnitId(); // 適切な広告ユニットIDを取得
  myBanner = BannerAd(
    adUnitId: bannerId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose(); // 広告オブジェクトを破棄
      },
    ),
  );
  await myBanner!.load(); // 広告のロードを待機
  appData.banner = myBanner; // 広告オブジェクトをシングルトンに保存
}
