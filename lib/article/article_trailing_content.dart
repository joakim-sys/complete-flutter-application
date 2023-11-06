import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/article/article_bloc.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles =
        context.select((ArticleBloc bloc) => bloc.state.relatedArticles);
    final hasReachedArticleViewsLimit = context
        .select((ArticleBloc bloc) => bloc.state.hasReachedArticleViewsLimit);
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);
    final isArticlePreview =
        context.select((ArticleBloc bloc) => bloc.state.isPreview);
    final isArticlePremium =
        context.select((ArticleBloc bloc) => bloc.state.isPremium);
    final showSubscribeWithArticleLimitModal =
        hasReachedArticleViewsLimit && !isUserSubscribed;
    return const Text('Trailing content here');
  }
}
