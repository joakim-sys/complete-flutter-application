import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/article/article_bloc.dart';
import 'package:pro_one/packages/article_repository.dart';
import 'package:pro_one/packages/share_launcher.dart';
import 'package:pro_one/slideshow/slideshow_view.dart';

class SlideshowPage extends StatelessWidget {
  const SlideshowPage(
      {super.key, required this.slideshow, required this.articleId});

  static Route<void> route(
      {required SlideshowBlock slideshow, required String articleId}) {
    return MaterialPageRoute(
        builder: (_) =>
            SlideshowPage(slideshow: slideshow, articleId: articleId));
  }

  final SlideshowBlock slideshow;
  final String articleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(
          articleId: articleId,
          articleRepository: context.read<ArticleRepository>(),
          shareLauncher: const ShareLauncher()),
      child: SlideshowView(block: slideshow),
    );
  }
}
