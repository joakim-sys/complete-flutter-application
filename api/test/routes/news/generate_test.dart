import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

import '../../../routes/api/v1/news/generate.dart' as route;

class _MockNewsDataSource extends Mock implements NewsDataSource {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('POST /api/v1/news/generate', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = _MockNewsDataSource();
    });

    test('responds with 201 and generated metadata.', () async {
      const category = Category.technology;
      const prompt = 'AI update';
      final post = PostSmallBlock(
        id: 'generated-id',
        category: PostCategory.technology,
        author: 'AI Tech Desk',
        publishedAt: DateTime(2023, 1, 1),
        title: 'AI update: New tools redefine daily workflows',
      );
      final newsItem = NewsItem(
        post: post,
        content: const [],
        contentPreview: const [],
        url: Uri.parse('https://example.com/news/generated-id'),
      );
      when(
        () => newsDataSource.generateNews(
          category: category,
          prompt: prompt,
        ),
      ).thenAnswer((_) async => newsItem);

      final request = Request(
        'POST',
        Uri.parse('http://127.0.0.1/'),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode({'category': category.name, 'prompt': prompt}),
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      expect(
        await response.json(),
        equals({
          'id': post.id,
          'title': post.title,
          'category': category.name,
          'url': newsItem.url.toString(),
        }),
      );
    });

    test('defaults to top category when missing.', () async {
      final post = PostSmallBlock(
        id: 'generated-id',
        category: PostCategory.technology,
        author: 'AI News Desk',
        publishedAt: DateTime(2023, 1, 1),
        title: 'Breaking updates: Developing story draws global attention',
      );
      final newsItem = NewsItem(
        post: post,
        content: const [],
        contentPreview: const [],
        url: Uri.parse('https://example.com/news/generated-id'),
      );
      when(
        () => newsDataSource.generateNews(
          category: Category.top,
          prompt: null,
        ),
      ).thenAnswer((_) async => newsItem);

      final request = Request(
        'POST',
        Uri.parse('http://127.0.0.1/'),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        body: jsonEncode(<String, String>{}),
      );
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<NewsDataSource>()).thenReturn(newsDataSource);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      verify(
        () => newsDataSource.generateNews(
          category: Category.top,
          prompt: null,
        ),
      ).called(1);
    });
  });

  test('responds with 400 when body is invalid JSON.', () async {
    final request = Request(
      'POST',
      Uri.parse('http://127.0.0.1/'),
      body: 'not-json',
    );
    final context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    final response = await route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.badRequest));
  });

  test('responds with 405 when method is not POST.', () async {
    final request = Request('GET', Uri.parse('http://127.0.0.1/'));
    final context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    final response = await route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
  });
}
