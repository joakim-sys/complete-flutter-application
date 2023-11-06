import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/article/article_bloc.dart';
import 'package:pro_one/article/article_page.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/newsblocks_ui/slideshow.dart';
import 'package:pro_one/packages/app_ui/app_back_button.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/share_button.dart';

import '../packages/app_ui/app_colors.dart';

class SlideshowView extends StatelessWidget {
  const SlideshowView({super.key, required this.block});

  final SlideshowBlock block;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton.light(),
        actions: [
          Row(
            children: [
              if (uri != null && uri.toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.lg),
                  child: ShareButton(
                    shareText: context.l10n!.shareText,
                    color: AppColors.white,
                    onPressed: () {
                      context.read<ArticleBloc>().add(ShareRequested(uri: uri));
                    },
                  ),
                ),
              if (!isSubscriber) const ArticleSubscribeButton()
            ],
          )
        ],
      ),
      backgroundColor: AppColors.darkBackground,
      body: Slideshow(
          block: block,
          categoryTitle: context.l10n!.slideshow,
          navigationLabel: context.l10n!.slideshow_of_title),
    );
  }
}
