import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerHelper {
  static final InAppReview _inAppReview = InAppReview.instance;

  // URLを定数化
  static const String _urlAppStore = 'AppStoreURL';
  static const String _urlPlayStore = 'PlayStoreURL';

  static void launchStoreReview(BuildContext context) async {
    try {
      if (await _inAppReview.isAvailable()) {
        // _inAppReview.requestReview();
        _inAppReview.openStoreListing(appStoreId: 'App Store ID');
      } else {
        // ストアのURLにフォールバック
        final url = Platform.isIOS ? _urlAppStore : _urlPlayStore;

        if (!await launchUrl(Uri.parse(url))) {
          throw 'Cannot launch the store URL';
        }
        // AnalyticsService.instance.analytics.logEvent(
        //   name: 'navigate_to_store_url',
        // );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ストアページを開けませんでした')),
      );
    }
  }
}
