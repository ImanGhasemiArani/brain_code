import 'package:tapsell_plus/tapsell_plus.dart';

class AdController {
  static final AdController _instance = AdController._internal();
  factory AdController() => _instance;
  AdController._internal() {
    _init();
  }

  static const String _appId =
      'psmqkmlsrljnkeoanreejqsgannghgcqpirdsqdhglabfkmscgieedpjgfeclmmjpnjecg';
  static const String _rewardedAdZoneId = '64259ea6e6bdca53d1a867ad';
  static const String _bannerAdZoneId = '6425ab8583087c3a3e860dd3';

  Future<void> _init() async {
    await TapsellPlus.instance.initialize(_appId);
    await TapsellPlus.instance.setGDPRConsent(true);
  }

  Future<bool> showRewardedAd(void Function() onRewarded) async {
    try {
      final resId =
          await TapsellPlus.instance.requestRewardedVideoAd(_rewardedAdZoneId);
      return await TapsellPlus.instance.showRewardedVideoAd(
        resId,
        onRewarded: (_) => onRewarded(),
      );
    } catch (e) {
      return false;
    }
  }

  Future<String?> getBannerAd() async {
    try {
      return await TapsellPlus.instance.requestStandardBannerAd(
        _bannerAdZoneId,
        TapsellPlusBannerType.BANNER_320x50,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> showBannerAd(String resId) async {
    try {
      return await TapsellPlus.instance.showStandardBannerAd(
        resId,
        TapsellPlusHorizontalGravity.BOTTOM,
        TapsellPlusVerticalGravity.CENTER,
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> destroyBannerAd(String resId) async {
    try {
      await TapsellPlus.instance.hideStandardBanner();
      return await TapsellPlus.instance.destroyStandardBanner(resId);
    } catch (e) {
      return false;
    }
  }
}
