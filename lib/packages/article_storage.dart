part of 'article_repository.dart';

abstract class ArticleStorageKeys {
  static const articleViews = '__article_views_storage_key__';
  static const articleViewsResetAt = '__article_views_reset_at_storage_key__';
  static const totalArticleViews = '__total_article_views_key__';
}

class ArticleStorage {
  const ArticleStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  Future<void> setArticleViews(int views) => _storage.write(
        key: ArticleStorageKeys.articleViews,
        value: views.toString(),
      );

  Future<int> fetchArticleViews() async {
    final articleViews =
        await _storage.read(key: ArticleStorageKeys.articleViews);
    return articleViews != null ? int.parse(articleViews) : 0;
  }

  Future<void> setArticleViewsResetDate(DateTime date) => _storage.write(
        key: ArticleStorageKeys.articleViewsResetAt,
        value: date.toIso8601String(),
      );

  Future<DateTime?> fetchArticleViewsResetDate() async {
    final resetDate =
        await _storage.read(key: ArticleStorageKeys.articleViewsResetAt);
    return resetDate != null ? DateTime.parse(resetDate) : null;
  }

  Future<void> setTotalArticleViews(int count) => _storage.write(
        key: ArticleStorageKeys.totalArticleViews,
        value: count.toString(),
      );

  Future<int> fetchTotalArticleViews() async {
    final count =
        await _storage.read(key: ArticleStorageKeys.totalArticleViews);
    return int.tryParse(count ?? '') ?? 0;
  }
}
