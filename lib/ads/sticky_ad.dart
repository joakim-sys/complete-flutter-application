import 'package:flutter/widgets.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/newsblocks_ui/banner_ad_content.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:news_blocks/news_blocks.dart';

import '../packages/app_ui/app_spacing.dart';

class StickyAd extends StatefulWidget {
  const StickyAd({super.key});

  static const padding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg + AppSpacing.xs, vertical: AppSpacing.lg);

  @override
  State<StickyAd> createState() => _StickyAdState();
}

class _StickyAdState extends State<StickyAd> {
  var _adLoaded = false;
  var _adClosed = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final adWidth =
        (deviceWidth - StickyAd.padding.left - StickyAd.padding.right)
            .truncate();
    return !_adClosed
        ? Stack(children: [
            if (_adLoaded) const StickyAdCloseIconBackground(),
            StickyAdContainer(
                shadowEnabled: _adLoaded,
                child: BannerAdContent(
                  size: BannerAdSize.anchoredAdaptive,
                  anchoredAdaptiveWidth: adWidth,
                  onAdLoaded: () => setState(() {
                    _adLoaded = true;
                  }),
                  showProgressIndicator: false,
                )),
            if (_adLoaded)
              StickyAdCloseIcon(
                  onAdClosed: () => setState(() {
                        _adClosed = true;
                      }))
          ])
        : const SizedBox();
  }
}

class StickyAdCloseIcon extends StatelessWidget {
  const StickyAdCloseIcon({super.key, required this.onAdClosed});

  final VoidCallback onAdClosed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: AppSpacing.lg,
        child: GestureDetector(
          onTap: onAdClosed,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: Assets.icons.closeCircleFilled.svg(),
            ),
          ),
        ));
  }
}

class StickyAdContainer extends StatelessWidget {
  const StickyAdContainer(
      {super.key, required this.child, required this.shadowEnabled});

  final Widget child;
  final bool shadowEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md + AppSpacing.xxs),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: shadowEnabled ? AppColors.white : AppColors.transparent,
            boxShadow: [
              if (shadowEnabled)
                BoxShadow(
                    color: AppColors.black.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(0, 1))
            ]),
        child: SafeArea(
            left: false,
            top: false,
            right: false,
            child: Padding(padding: StickyAd.padding, child: child)),
      ),
    );
  }
}

class StickyAdCloseIconBackground extends StatelessWidget {
  const StickyAdCloseIconBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: AppSpacing.lg,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(0, 1))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: Assets.icons.closeCircleFilled.svg(),
          ),
        ));
  }
}
