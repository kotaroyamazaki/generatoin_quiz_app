import 'package:flutter/material.dart';
import 'package:generation_quiz_app/widgets/admob_banner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdInterstitial {
  InterstitialAd? _interstitialAd;
  int loadAttemptCount = 0;
  bool? ready;

  // create interstitial ads
  void init() {
    InterstitialAd.load(
      adUnitId: getAdInterstitialUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // 広告が正常にロードされたときに呼ばれます。
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('add loaded');
          _interstitialAd = ad;
          loadAttemptCount = 0;
          ready = true;
        },
        // 広告のロードが失敗した際に呼ばれます。
        onAdFailedToLoad: (LoadAdError error) {
          loadAttemptCount++;
          _interstitialAd = null;
          // 失敗ログ
          debugPrint("広告表示に失敗");
          if (loadAttemptCount <= 2) {
            init();
          }
        },
      ),
    );
  }

  // show interstitial ads to user
  // onDissmiss を引数で受け取る
  Future<void> showAd({
    void Function()? onDismiss,
  }) async {
    ready = false;
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint("ad onAdshowedFullscreen");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint("ad dismissed");
        if (onDismiss != null) {
          onDismiss();
        }
        init();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
        debugPrint('$ad OnAdFailed $aderror');
        ad.dispose();
        init();
      },
    );

    // 広告の表示には.show()を使う
    await _interstitialAd!.show();
    _interstitialAd = null;
  }
}
