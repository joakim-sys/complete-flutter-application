import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:api/client.dart';
import 'storage.dart';

part 'article_storage.dart';

abstract class ArticleFailure with EquatableMixin implements Exception {
  const ArticleFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class GetArticleFailure extends ArticleFailure {
  const GetArticleFailure(super.error);
}

class GetRelatedArticlesFailure extends ArticleFailure {
  const GetRelatedArticlesFailure(super.error);
}

class IncrementArticleViewsFailure extends ArticleFailure {
  const IncrementArticleViewsFailure(super.error);
}

class DecrementArticleViewsFailure extends ArticleFailure {
  const DecrementArticleViewsFailure(super.error);
}

class ResetArticleViewsFailure extends ArticleFailure {
  const ResetArticleViewsFailure(super.error);
}

class FetchArticleViewsFailure extends ArticleFailure {
  const FetchArticleViewsFailure(super.error);
}

class IncrementTotalArticleViewsFailure extends ArticleFailure {
  const IncrementTotalArticleViewsFailure(super.error);
}

class FetchTotalArticleViewsFailure extends ArticleFailure {
  const FetchTotalArticleViewsFailure(super.error);
}

class ArticleViews {
  ArticleViews(this.views, this.resetAt);
  final int views;
  final DateTime? resetAt;
}

class ArticleRepository {
  const ArticleRepository({
    required TrcApiClient apiClient,
    required ArticleStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final TrcApiClient _apiClient;
  final ArticleStorage _storage;

  Future<ArticleResponse> getArticle({
    required String id,
    int? limit,
    int? offset,
    bool preview = false,
  }) async {
    try {
      return await _apiClient.getArticle(
        id: id,
        limit: limit,
        offset: offset,
        preview: preview,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetArticleFailure(error), stackTrace);
    }
  }

  Future<RelatedArticlesResponse> getRelatedArticles({
    required String id,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getRelatedArticles(
        id: id,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetRelatedArticlesFailure(error), stackTrace);
    }
  }

  Future<void> incrementArticleViews() async {
    try {
      final currentArticleViews = await _storage.fetchArticleViews();
      await _storage.setArticleViews(currentArticleViews + 1);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> decrementArticleViews() async {
    try {
      final currentArticleViews = await _storage.fetchArticleViews();
      await _storage.setArticleViews(currentArticleViews - 1);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        DecrementArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> resetArticleViews() async {
    try {
      await Future.wait([
        _storage.setArticleViews(0),
        _storage.setArticleViewsResetDate(clock.now()),
      ]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ResetArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  Future<ArticleViews> fetchArticleViews() async {
    try {
      late int views;
      late DateTime? resetAt;
      await Future.wait([
        (() async => views = await _storage.fetchArticleViews())(),
        (() async => resetAt = await _storage.fetchArticleViewsResetDate())(),
      ]);
      return ArticleViews(views, resetAt);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> incrementTotalArticleViews() async {
    try {
      final totalArticleViews = await _storage.fetchTotalArticleViews();
      await _storage.setTotalArticleViews(totalArticleViews + 1);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementTotalArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  Future<int> fetchTotalArticleViews() async {
    try {
      return await _storage.fetchTotalArticleViews();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchTotalArticleViewsFailure(error),
        stackTrace,
      );
    }
  }
}
