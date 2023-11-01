import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:platform/platform.dart' as platform;
import 'package:pro_one/newsblocks_ui/progress_indicator.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import '../ads/ads_retry_policy.dart';

class BannerAdFailedToLoadException implements Exception {
  BannerAdFailedToLoadException(this.error);

  final Object error;
}

class BannerAdFailedToGetSizeException implements Exception {
  BannerAdFailedToGetSizeException();
}

typedef BannerAdBuilder = BannerAd Function(
    {required AdSize size,
    required String adUnitId,
    required BannerAdListener listener,
    required AdRequest request});

typedef AnchoredAdaptiveAdSizeProvider = Future<AnchoredAdaptiveBannerAdSize?>
    Function(
  Orientation orientation,
  int width,
);

class BannerAdContent extends StatefulWidget {
  const BannerAdContent({
    super.key,
    required this.size,
    this.adFailedToLoadTitle,
    this.adsRetryPolicy = const AdsRetryPolicy(),
    this.anchoredAdaptiveWidth,
    this.adUnitId,
    this.adBuilder = BannerAd.new,
    this.anchoredAdaptiveAdSizeProvider =
        AdSize.getAnchoredAdaptiveBannerAdSize,
    this.currentPlatform = const platform.LocalPlatform(),
    this.onAdLoaded,
    this.showProgressIndicator = true,
  });

  final BannerAdSize size;
  final String? adFailedToLoadTitle;
  final AdsRetryPolicy adsRetryPolicy;
  final int? anchoredAdaptiveWidth;
  final String? adUnitId;
  final BannerAdBuilder adBuilder;
  final AnchoredAdaptiveAdSizeProvider anchoredAdaptiveAdSizeProvider;
  final platform.Platform currentPlatform;
  final VoidCallback? onAdLoaded;
  final bool showProgressIndicator;

  static const androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const iosTestUnitAd = 'ca-app-pub-3940256099942544/2934735716';

  static const _sizeValues = <BannerAdSize, AdSize>{
    BannerAdSize.normal: AdSize.banner,
    BannerAdSize.large: AdSize.mediumRectangle,
    BannerAdSize.extraLarge: AdSize(width: 300, height: 600),
  };

  @override
  State<BannerAdContent> createState() => _BannerAdContentState();
}

class _BannerAdContentState extends State<BannerAdContent>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _ad;
  AdSize? _adSize;
  bool _adLoaded = false;
  bool _adFailedToLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_loadAd());
  }

  @override
  void dispose() {
    super.dispose();
    _ad?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adFailedToLoadTitle = widget.adFailedToLoadTitle;
    return SizedBox(
      width: (_adSize?.width ?? 0).toDouble(),
      height: (_adSize?.height ?? 0).toDouble(),
      child: Center(
        child: _adLoaded
            ? AdWidget(ad: _ad!)
            : _adFailedToLoad && adFailedToLoadTitle != null
                ? Text(adFailedToLoadTitle)
                : widget.showProgressIndicator
                    ? const ProgressIndicator(color: AppColors.transparent)
                    : const SizedBox(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadAd() async {
    AdSize? adSize;
    if (widget.size == BannerAdSize.anchoredAdaptive) {
      adSize = await _getAnchoredAdaptiveAdSize();
    } else {
      adSize = BannerAdContent._sizeValues[widget.size];
    }
    setState(() {
      _adSize = adSize;
    });

    if (_adSize == null) {
      return _reportError(
          BannerAdFailedToGetSizeException(), StackTrace.current);
    }

    await _loadAdInstance();
  }

  Future<void> _loadAdInstance({int retry = 0}) async {
    if (!mounted) return;
    try {
      final adCompleter = Completer<Ad>();
      setState(() {
        _ad = widget.adBuilder(
            adUnitId: widget.adUnitId ??
                (widget.currentPlatform.isAndroid
                    ? BannerAdContent.androidTestUnitId
                    : BannerAdContent.iosTestUnitAd),
            request: const AdRequest(),
            size: _adSize!,
            listener: BannerAdListener(
                onAdLoaded: adCompleter.complete,
                onAdFailedToLoad: (_, error) {
                  adCompleter.completeError(error);
                }))
          ..load();
      });
      _onAdLoaded(await adCompleter.future);
    } catch (error, stackTrace) {
      _reportError(BannerAdFailedToLoadException(error), stackTrace);

      if (retry < widget.adsRetryPolicy.maxRetryCount) {
        final nextRetry = retry + 1;
        await Future<void>.delayed(
            widget.adsRetryPolicy.getIntervalForRetry(nextRetry));
        return _loadAdInstance(retry: nextRetry);
      } else {
        if (mounted) {
          setState(() {
            _adFailedToLoad = true;
          });
        }
      }
    }
  }

  void _onAdLoaded(Ad ad) {
    if (mounted) {
      setState(() {
        _ad = ad as BannerAd;
        _adLoaded = true;
      });
      widget.onAdLoaded?.call();
    }
  }

  Future<AnchoredAdaptiveBannerAdSize?> _getAnchoredAdaptiveAdSize() async {
    final adWidth = widget.anchoredAdaptiveWidth ??
        MediaQuery.of(context).size.width.truncate();
    return widget.anchoredAdaptiveAdSizeProvider(
      Orientation.portrait,
      adWidth,
    );
  }

  void _reportError(Object exception, StackTrace stackTrace) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
        ),
      );
}
