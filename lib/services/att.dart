// ATT(App Tracking Transparency) Service
// This service is used to request permission to track the user or access the IDFA.

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:generation_quiz_app/services/analytics.dart';

class ATTService {
  static Future<void> init() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      var tarackingStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      // 許可したらトラッキングしたい
      AnalyticsService.instance.analytics.logEvent(
        name: 'request_tracking_authorization',
        parameters: <String, Object>{
          'status': tarackingStatus.toString(),
        },
      );
    }
  }
}
