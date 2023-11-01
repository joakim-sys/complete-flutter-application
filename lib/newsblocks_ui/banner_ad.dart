import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/banner_ad_content.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class BannerAd extends StatelessWidget {
  const BannerAd(
      {super.key, required this.block, required this.adFailedToLoadTitle});

  final BannerAdBlock block;
  final String adFailedToLoadTitle;

  @override
  Widget build(BuildContext context) {
    return BannerAdContainer(
        size: block.size,
        child: BannerAdContent(
            size: block.size, adFailedToLoadTitle: adFailedToLoadTitle));
  }
}

class BannerAdContainer extends StatelessWidget {
  const BannerAdContainer({super.key, required this.size, required this.child});

  final BannerAdSize size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = size == BannerAdSize.normal
        ? AppSpacing.lg + AppSpacing.xs
        : AppSpacing.xlg + AppSpacing.xs + AppSpacing.xxs;

    final verticalPadding = size == BannerAdSize.normal
        ? AppSpacing.lg
        : AppSpacing.xlg + AppSpacing.sm;

    return ColoredBox(
        color: AppColors.brightGrey,
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: child));
  }
}
