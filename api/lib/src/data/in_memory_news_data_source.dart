import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:api/api.dart';
import 'package:api/src/data/models/models.dart';
import 'package:news_blocks/news_blocks.dart';

part 'static_news_data.dart';

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryNewsDataSource implements NewsDataSource {
  /// {@macro in_memory_news_data_store}
  InMemoryNewsDataSource()
      : _userSubscriptions = <String, String>{},
        _generatedNewsItems = <NewsItem>[];

  final Map<String, String> _userSubscriptions;
  final List<NewsItem> _generatedNewsItems;

  @override
  Future<void> createSubscription({
    required String userId,
    required String subscriptionId,
  }) async {
    final subscriptionPlan = subscriptions
        .firstWhereOrNull((subscription) => subscription.id == subscriptionId)
        ?.name;

    if (subscriptionPlan != null) {
      _userSubscriptions[userId] = subscriptionPlan.name;
    }
  }

  @override
  Future<List<Subscription>> getSubscriptions() async => subscriptions;

  @override
  Future<Article?> getArticle({
    required String id,
    int limit = 20,
    int offset = 0,
    bool preview = false,
  }) async {
    final result = _allNewsItems().where((item) => item.post.id == id);
    if (result.isEmpty) return null;
    final articleNewsItem = result.first;
    final article = (preview
            ? articleNewsItem.contentPreview
            : articleNewsItem.content)
        .toArticle(title: articleNewsItem.post.title, url: articleNewsItem.url);
    final totalBlocks = article.totalBlocks;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks =
        article.blocks.sublist(normalizedOffset).take(limit).toList();
    return Article(
      title: article.title,
      blocks: blocks,
      totalBlocks: totalBlocks,
      url: article.url,
    );
  }

  @override
  Future<bool?> isPremiumArticle({required String id}) async {
    final result = _allNewsItems().where((item) => item.post.id == id);
    if (result.isEmpty) return null;
    return result.first.post.isPremium;
  }

  @override
  Future<List<NewsBlock>> getPopularArticles() async {
    return popularArticles.map((item) => item.post).toList();
  }

  @override
  Future<List<NewsBlock>> getRelevantArticles({required String term}) async {
    return relevantArticles.map((item) => item.post).toList();
  }

  @override
  Future<List<String>> getRelevantTopics({required String term}) async {
    return relevantTopics;
  }

  @override
  Future<List<String>> getPopularTopics() async => popularTopics;

  @override
  Future<RelatedArticles> getRelatedArticles({
    required String id,
    int limit = 20,
    int offset = 0,
  }) async {
    final result = _allNewsItems().where((item) => item.post.id == id);
    if (result.isEmpty) return const RelatedArticles.empty();
    final articles = result.first.relatedArticles;
    final totalBlocks = articles.length;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks = articles.sublist(normalizedOffset).take(limit).toList();
    return RelatedArticles(blocks: blocks, totalBlocks: totalBlocks);
  }

  @override
  Future<Feed> getFeed({
    Category category = Category.top,
    int limit = 20,
    int offset = 0,
  }) async {
    final feed =
        _newsFeedData[category] ?? const Feed(blocks: [], totalBlocks: 0);
    final generatedBlocks = _generatedBlocksForCategory(category);
    final combinedBlocks = [...generatedBlocks, ...feed.blocks];
    final combinedFeed =
        Feed(blocks: combinedBlocks, totalBlocks: combinedBlocks.length);
    final normalizedOffset = math.min(offset, combinedFeed.totalBlocks);
    final blocks =
        combinedFeed.blocks.sublist(normalizedOffset).take(limit).toList();
    return Feed(blocks: blocks, totalBlocks: combinedFeed.totalBlocks);
  }

  @override
  Future<List<Category>> getCategories() async => _newsFeedData.keys.toList();

  @override
  Future<NewsItem> generateNews({
    Category category = Category.top,
    String? prompt,
  }) async {
    final seed = (prompt == null || prompt.trim().isEmpty)
        ? 'Breaking updates'
        : prompt.trim();
    final id =
        '${DateTime.now().millisecondsSinceEpoch}-${_generatedNewsItems.length}';
    final now = DateTime.now();
    final title = '$seed: ${_headlineSuffix(category)}';
    final description = _summaryFor(seed, category);
    final author = _authorFor(category);
    final imageUrl = _imageFor(category);

    final post = PostSmallBlock(
      id: id,
      category: _postCategoryFor(category),
      author: author,
      publishedAt: now,
      imageUrl: imageUrl,
      title: title,
      description: description,
      action: NavigateToArticleAction(articleId: id),
    );

    final content = <NewsBlock>[
      ArticleIntroductionBlock(
        category: _postCategoryFor(category),
        author: author,
        publishedAt: now,
        title: title,
        imageUrl: imageUrl,
      ),
      TextLeadParagraphBlock(text: description),
      const SpacerBlock(spacing: Spacing.large),
      TextParagraphBlock(
        text: _bodyFor(seed, category),
      ),
    ];

    final newsItem = NewsItem(
      post: post,
      content: content,
      contentPreview: content.take(2).toList(),
      url: Uri.parse('https://example.com/news/$id'),
    );

    _generatedNewsItems.insert(0, newsItem);
    return newsItem;
  }

  @override
  Future<User> getUser({required String userId}) async {
    final subscription = _userSubscriptions[userId];
    if (subscription == null) {
      return User(id: userId, subscription: SubscriptionPlan.none);
    }
    return User(
      id: userId,
      subscription: SubscriptionPlan.values.firstWhere(
        (e) => e.name == subscription,
      ),
    );
  }

  List<NewsItem> _allNewsItems() => [..._generatedNewsItems, ..._newsItems];

  List<NewsBlock> _generatedBlocksForCategory(Category category) {
    return _generatedNewsItems
        .where((item) => _categoryMatches(category, item.post))
        .map((item) => item.post)
        .toList();
  }

  bool _categoryMatches(Category category, PostBlock post) {
    if (category == Category.top) {
      return true;
    }
    if (post is PostLargeBlock) {
      return post.category.name == category.name;
    }
    if (post is PostMediumBlock) {
      return post.category.name == category.name;
    }
    if (post is PostSmallBlock) {
      return post.category.name == category.name;
    }
    if (post is PostGridTileBlock) {
      return post.category.name == category.name;
    }
    return false;
  }

  PostCategory _postCategoryFor(Category category) {
    switch (category) {
      case Category.business:
        return PostCategory.business;
      case Category.entertainment:
        return PostCategory.entertainment;
      case Category.health:
        return PostCategory.health;
      case Category.science:
        return PostCategory.science;
      case Category.sports:
        return PostCategory.sports;
      case Category.technology:
        return PostCategory.technology;
      case Category.top:
        return PostCategory.technology;
    }
  }

  String _authorFor(Category category) {
    switch (category) {
      case Category.business:
        return 'AI Business Desk';
      case Category.entertainment:
        return 'AI Culture Desk';
      case Category.health:
        return 'AI Health Desk';
      case Category.science:
        return 'AI Science Desk';
      case Category.sports:
        return 'AI Sports Desk';
      case Category.technology:
        return 'AI Tech Desk';
      case Category.top:
        return 'AI News Desk';
    }
  }

  String _imageFor(Category category) {
    switch (category) {
      case Category.business:
        return 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40';
      case Category.entertainment:
        return 'https://images.unsplash.com/photo-1489515217757-5fd1be406fef';
      case Category.health:
        return 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528';
      case Category.science:
        return 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee';
      case Category.sports:
        return 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211';
      case Category.technology:
        return 'https://images.unsplash.com/photo-1518770660439-4636190af475';
      case Category.top:
        return 'https://images.unsplash.com/photo-1504711434969-e33886168f5c';
    }
  }

  String _headlineSuffix(Category category) {
    switch (category) {
      case Category.business:
        return 'Market signals shift as investors react';
      case Category.entertainment:
        return 'Studios tease what comes next';
      case Category.health:
        return 'Experts share the latest guidance';
      case Category.science:
        return 'Researchers reveal a new milestone';
      case Category.sports:
        return 'A surprise result shakes the standings';
      case Category.technology:
        return 'New tools redefine daily workflows';
      case Category.top:
        return 'Developing story draws global attention';
    }
  }

  String _summaryFor(String seed, Category category) {
    return '$seed: ${_headlineSuffix(category)}. '
        'Analysts say the momentum could continue through the week.';
  }

  String _bodyFor(String seed, Category category) {
    return 'In today\'s update, $seed dominates headlines as '
        'stakeholders monitor rapid developments across the sector. '
        'The AI news engine synthesized context from recent activity '
        'and produced this summary to keep readers informed.';
  }
}
