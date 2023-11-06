import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/slideshow_category.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

import '../gen/assets.gen.dart';
import '../packages/app_ui/app_colors.dart';

class Slideshow extends StatefulWidget {
  const Slideshow({
    required this.block,
    required this.categoryTitle,
    required this.navigationLabel,
    super.key,
  });

  final SlideshowBlock block;
  final String categoryTitle;
  final String navigationLabel;

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideshowCategoryTitle(
            categoryTitle: widget.categoryTitle,
          ),
          _SlideshowHeaderTitle(title: widget.block.title),
          _SlideshowPageView(
            slides: widget.block.slides,
            controller: _controller,
          ),
          _SlideshowButtons(
            totalPages: widget.block.slides.length,
            controller: _controller,
            navigationLabel: widget.navigationLabel,
          ),
          const SizedBox(height: AppSpacing.lg)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SlideshowCategoryTitle extends StatelessWidget {
  const _SlideshowCategoryTitle({
    required this.categoryTitle,
  });

  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('slideshow_categoryTitle'),
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: SlideshowCategory(
        isIntroduction: false,
        slideshowText: categoryTitle,
      ),
    );
  }
}

class _SlideshowHeaderTitle extends StatelessWidget {
  const _SlideshowHeaderTitle({
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      key: const Key('slideshow_headerTitle'),
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Text(
        title,
        style: theme.headlineMedium?.apply(
          color: AppColors.highEmphasisPrimary,
        ),
      ),
    );
  }
}

class _SlideshowPageView extends StatelessWidget {
  const _SlideshowPageView({
    required this.slides,
    required this.controller,
  });

  final List<SlideBlock> slides;

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        key: const Key('slideshow_pageView'),
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        itemCount: slides.length,
        itemBuilder: (context, index) => SlideshowItem(
          slide: slides[index],
        ),
      ),
    );
  }
}

@visibleForTesting
class SlideshowItem extends StatelessWidget {
  const SlideshowItem({required this.slide, super.key});

  final SlideBlock slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.square(
          key: const Key('slideshow_slideshowItemImage'),
          child: Image.network(slide.imageUrl),
        ),
        Padding(
          key: const Key('slideshow_slideshowItemCaption'),
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Text(
            slide.caption,
            style: theme.titleLarge?.apply(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          key: const Key('slideshow_slideshowItemDescription'),
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Text(
            slide.description,
            style: theme.bodySmall?.apply(
              color: AppColors.mediumHighEmphasisPrimary,
            ),
          ),
        ),
        Padding(
          key: const Key('slideshow_slideshowItemPhotoCredit'),
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.xxxs,
          ),
          child: Text(
            slide.photoCredit,
            style: theme.bodySmall?.apply(
              color: AppColors.mediumEmphasisPrimary,
            ),
          ),
        )
      ],
    );
  }
}

class _SlideshowButtons extends StatefulWidget {
  const _SlideshowButtons({
    required this.totalPages,
    required this.controller,
    required this.navigationLabel,
  });

  final int totalPages;
  final PageController controller;
  final String navigationLabel;

  @override
  State<_SlideshowButtons> createState() => _SlideshowButtonsState();
}

class _SlideshowButtonsState extends State<_SlideshowButtons> {
  int _currentPage = 0;
  static const _pageAnimationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    widget.controller.addListener(_onPageChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationBarLabel =
        '${_currentPage + 1} ${widget.navigationLabel} ${widget.totalPages}';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const Key('slideshow_slideshowButtonsLeft'),
            onPressed: () {
              if (_currentPage >= 1) {
                widget.controller.previousPage(
                  duration: _pageAnimationDuration,
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: _currentPage == 0
                ? Assets.icons.arrowLeftDisable.svg()
                : Assets.icons.arrowLeftEnable.svg(),
          ),
          Text(
            navigationBarLabel,
            style: theme.textTheme.titleLarge?.apply(color: AppColors.white),
          ),
          IconButton(
            key: const Key('slideshow_slideshowButtonsRight'),
            onPressed: () {
              if (_currentPage < widget.totalPages - 1) {
                widget.controller.nextPage(
                  duration: _pageAnimationDuration,
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: _currentPage == widget.totalPages - 1
                ? Assets.icons.arrowRightDisable.svg()
                : Assets.icons.arrowRightEnable.svg(),
          ),
        ],
      ),
    );
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = widget.controller.page?.toInt() ?? 0;
    });
  }
}
