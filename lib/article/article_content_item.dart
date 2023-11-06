import 'package:flutter/material.dart' hide Spacer, Image;
import 'package:pro_one/article/article_theme_override.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/newsblocks_ui/article_introduction.dart';
import 'package:pro_one/newsblocks_ui/banner_ad.dart';
import 'package:pro_one/newsblocks_ui/divider_horizontal.dart';
import 'package:pro_one/newsblocks_ui/html.dart';
import 'package:pro_one/newsblocks_ui/slideshow_introduction.dart';
import 'package:pro_one/newsblocks_ui/text_caption.dart';
import 'package:pro_one/newsblocks_ui/text_headline.dart';
import 'package:pro_one/newsblocks_ui/text_lead_paragraph.dart';
import 'package:pro_one/newsblocks_ui/text_paragraph.dart';
import 'package:pro_one/newsblocks_ui/trending_story.dart';
import 'package:pro_one/newsblocks_ui/video.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/video_introduction.dart';
import 'package:pro_one/newsletter/newsletter.dart';
import 'package:pro_one/slideshow/slideshow_page.dart';

import '../newsblocks_ui/image.dart';
import '../newsblocks_ui/spacer.dart';

class ArticleContentItem extends StatelessWidget {
  const ArticleContentItem(
      {super.key, required this.block, this.onSharePressed});

  final NewsBlock block;
  final VoidCallback? onSharePressed;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is ImageBlock) {
      return Image(block: newsBlock);
    } else if (newsBlock is VideoBlock) {
      return Video(block: newsBlock);
    } else if (newsBlock is TextCaptionBlock) {
      final articleThemeColors =
          Theme.of(context).extension<ArticleThemeColors>()!;
      return TextCaption(
        block: newsBlock,
        colorValues: {
          TextCaptionColor.normal: articleThemeColors.captionNormal,
          TextCaptionColor.light: articleThemeColors.captionLight
        },
      );
    } else if (newsBlock is TextHeadlineBlock) {
      return TextHeadline(block: newsBlock);
    } else if (newsBlock is TextLeadParagraphBlock) {
      return TextLeadParagraph(block: newsBlock);
    } else if (newsBlock is TextParagraphBlock) {
      return TextParagraph(block: newsBlock);
    } else if (newsBlock is ArticleIntroductionBlock) {
      return ArticleIntroduction(
          block: newsBlock, premiumText: context.l10n!.newsBlockPremiumText);
    } else if (newsBlock is VideoIntroductionBlock) {
      return VideoIntroduction(block: newsBlock);
    } else if (newsBlock is BannerAdBlock) {
      return BannerAd(
          block: newsBlock, adFailedToLoadTitle: context.l10n!.adLoadFailure);
    } else if (newsBlock is NewsletterBlock) {
      return const Newsletter();
    } else if (newsBlock is HtmlBlock) {
      return Html(block: newsBlock);
    } else if (newsBlock is TrendingStoryBlock) {
      return TrendingStory(
          title: context.l10n!.trendingStoryTitle, block: newsBlock);
    } else if (newsBlock is SlideshowIntroductionBlock) {
      return SlideshowIntroduction(
        block: newsBlock,
        slideshowText: context.l10n!.slideshow,
        onPressed: (action) => _onContentItemAction(context, action),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> _onContentItemAction(
      BuildContext context, BlockAction action) async {
    if (action is NavigateToSlideshowAction) {
      await Navigator.of(context).push<void>(SlideshowPage.route(
          slideshow: action.slideshow, articleId: action.articleId));
    }
  }
}
