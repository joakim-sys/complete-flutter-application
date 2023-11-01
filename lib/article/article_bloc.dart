import 'dart:async';

import 'package:api/client.dart';

import '../packages/analytics_repository.dart';
import '../packages/article_repository.dart';
import '../packages/ntg_event.dart';
import '../packages/share_launcher.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_event.dart';
part 'article_state.dart';
part 'article_bloc.g.dart';

class ArticleBloc extends HydratedBloc<ArticleEvent, ArticleState> {
  ArticleBloc({
    required String articleId,
    required ArticleRepository articleRepository,
    required ShareLauncher shareLauncher,
  })  : _articleId = articleId,
        _articleRepository = articleRepository,
        _shareLauncher = shareLauncher,
        super(const ArticleState.initial()) {
    on<ArticleRequested>(_onArticleRequested, transformer: sequential());
    on<ArticleContentSeen>(_onArticleContentSeen);
    on<ArticleRewardedAdWatched>(_onArticleRewardedAdWatched);
    on<ArticleCommented>(_onArticleCommented);
    on<ShareRequested>(_onShareRequested);
  }

  final String _articleId;
  final ShareLauncher _shareLauncher;
  final ArticleRepository _articleRepository;

  static const _articleViewsLimit = 4;
  static const _resetArticleViewsAfterDuration = Duration(days: 1);
  static const _relatedArticlesLimit = 5;
  static const _numberOfArticleViewsForNewInterstitialAd = 4;

  @override
  String get id => _articleId;

  FutureOr<void> _onArticleRequested(
    ArticleRequested event,
    Emitter<ArticleState> emit,
  ) async {
    final isInitialRequest = state.status == ArticleStatus.initial;

    try {
      emit(state.copyWith(status: ArticleStatus.loading));

      final totalArticleViews = await _updateTotalArticleViews();

      final showInterstitialAd = _shouldShowInterstitialAd(totalArticleViews);

      emit(state.copyWith(showInterstitialAd: showInterstitialAd));

      if (isInitialRequest) {
        await _updateArticleViews();
      }

      final hasReachedArticleViewsLimit = await _hasReachedArticleViewsLimit();

      final response = await _articleRepository.getArticle(
        id: _articleId,
        offset: state.content.length,
        preview: hasReachedArticleViewsLimit,
      );

      // Append fetched article content blocks to the list of content blocks.
      final updatedContent = [...state.content, ...response.content];
      final hasMoreContent = response.totalCount > updatedContent.length;

      RelatedArticlesResponse? relatedArticlesResponse;
      if (!hasMoreContent && state.relatedArticles.isEmpty) {
        relatedArticlesResponse = await _articleRepository.getRelatedArticles(
          id: _articleId,
          limit: _relatedArticlesLimit,
        );
      }

      emit(
        state.copyWith(
          status: ArticleStatus.populated,
          title: response.title,
          content: updatedContent,
          contentTotalCount: response.totalCount,
          relatedArticles: relatedArticlesResponse?.relatedArticles ?? [],
          hasMoreContent: hasMoreContent,
          uri: response.url,
          hasReachedArticleViewsLimit: hasReachedArticleViewsLimit,
          isPreview: response.isPreview,
          isPremium: response.isPremium,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ArticleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onArticleContentSeen(
    ArticleContentSeen event,
    Emitter<ArticleState> emit,
  ) async {
    final contentSeenCount = event.contentIndex + 1;
    if (contentSeenCount > state.contentSeenCount) {
      emit(state.copyWith(contentSeenCount: contentSeenCount));
    }
  }

  FutureOr<void> _onArticleRewardedAdWatched(
    ArticleRewardedAdWatched event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      await _articleRepository.decrementArticleViews();
      final hasReachedArticleViewsLimit = await _hasReachedArticleViewsLimit();

      emit(
        state.copyWith(
          hasReachedArticleViewsLimit: hasReachedArticleViewsLimit,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ArticleStatus.rewardedAdWatchedFailure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onArticleCommented(
    ArticleCommented event,
    Emitter<ArticleState> emit,
  ) =>
      Future.value();

  FutureOr<void> _onShareRequested(
    ShareRequested event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      await _shareLauncher.share(text: event.uri.toString());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ArticleStatus.shareFailure));
      addError(error, stackTrace);
    }
  }

  Future<void> _updateArticleViews() async {
    final currentArticleViews = await _articleRepository.fetchArticleViews();
    final resetAt = currentArticleViews.resetAt;

    final now = clock.now();
    final shouldResetArticleViews = resetAt == null ||
        now.isAfter(resetAt.add(_resetArticleViewsAfterDuration));

    if (shouldResetArticleViews) {
      await _articleRepository.resetArticleViews();
      await _articleRepository.incrementArticleViews();
    } else if (currentArticleViews.views < _articleViewsLimit) {
      await _articleRepository.incrementArticleViews();
    }
  }

  Future<int> _updateTotalArticleViews() async {
    await _articleRepository.incrementTotalArticleViews();
    return _articleRepository.fetchTotalArticleViews();
  }

  bool _shouldShowInterstitialAd(int totalArticleViews) =>
      (totalArticleViews != 0) &&
      totalArticleViews % _numberOfArticleViewsForNewInterstitialAd == 0;

  Future<bool> _hasReachedArticleViewsLimit() async {
    final currentArticleViews = await _articleRepository.fetchArticleViews();
    return currentArticleViews.views >= _articleViewsLimit;
  }

  @override
  ArticleState? fromJson(Map<String, dynamic> json) =>
      ArticleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ArticleState state) => state.toJson();
}
