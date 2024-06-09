import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsService() {
    // デバッグモードでは有効化しない
    if (kDebugMode) {
      _analytics.setAnalyticsCollectionEnabled(false);
    }
  }

  // Getter for Firebase Analytics instance
  FirebaseAnalytics get analytics => _analytics;

  // logEvent のラッパー
  // _analytics が有効でない場合は何もしない
  // _analytics.logEvent で呼び出される
  // 使い方
  // await AnalyticsService.instance.logEvent(
  //   name: 'dice_roll',
  //   parameters: <String, dynamic>{
  //     'color': 'red',
  //     'speed': 1000,
  //   },
  // );

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) {
      debugPrint('logEvent: name=$name, parameters=$parameters');
      return;
    }
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // logPurchase のラッパー
  // _analytics が有効でない場合は何もしない
  Future<void> logPurchase({
    required double price,
    required String currency,
    required String identifer,
  }) async {
    if (kDebugMode) {
      debugPrint(
          'logPurchase: price=$price, currency=$currency, identifer=$identifer');
      return;
    }
    await _analytics.logPurchase(
      currency: currency,
      value: price,
      transactionId: identifer,
    );
  }

  // logScreenView のラッパー
  // _analytics が有効でない場合は何もしない
  Future<void> logScreenView({
    required String screenName,
  }) async {
    if (kDebugMode) {
      debugPrint('logScreenView: screenName=$screenName');
      return;
    }
    await _analytics.logScreenView(screenName: screenName);
  }
}
