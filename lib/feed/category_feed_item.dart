import 'package:api/client.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/newsblocks_ui/banner_ad.dart';
import 'package:pro_one/newsblocks_ui/divider_horizontal.dart';
import 'package:pro_one/newsblocks_ui/post_grid.dart';
import 'package:pro_one/newsblocks_ui/post_large.dart';
import 'package:pro_one/newsblocks_ui/post_medium.dart';
import 'package:pro_one/newsblocks_ui/post_small.dart';
import 'package:pro_one/newsblocks_ui/section_header.dart';
import 'package:pro_one/newsblocks_ui/spacer.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsletter/newsletter.dart';

import '../article/article_page.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({super.key, required this.block});

  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      return SectionHeader(
          block: newsBlock,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is PostLargeBlock) {
      return PostLarge(
          block: newsBlock,
          premiumText: context.l10n!.newsBlockPremiumText,
          isLocked: newsBlock.isPremium && !isUserSubscribed,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is PostMediumBlock) {
      return PostMedium(
          block: newsBlock,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is PostSmallBlock) {
      return PostSmall(
          block: newsBlock,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is PostGridGroupBlock) {
      return PostGrid(
          gridGroupBlock: newsBlock,
          premiumText: context.l10n!.newsBlockPremiumText,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is NewsletterBlock) {
      return const Newsletter();
    } else if (newsBlock is BannerAdBlock) {
      return BannerAd(
          block: newsBlock, adFailedToLoadTitle: context.l10n!.adLoadFailure);
    } else {
      return const SizedBox();
    }
  }
}

Future<void> _onFeedItemAction(BuildContext context, BlockAction action) async {
  if (action is NavigateToArticleAction) {
    await Navigator.of(context)
        .push<void>(ArticlePage.route(id: action.articleId));
  }
}
