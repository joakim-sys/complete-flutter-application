import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  Object? body;
  try {
    body = await context.request.json();
  } catch (_) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  if (body is! Map<String, dynamic>) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final promptValue = body['prompt'];
  final categoryValue = body['category'];
  final prompt = promptValue is String ? promptValue : null;
  final category = categoryValue is String
      ? Category.values.firstWhere(
          (value) => value.name == categoryValue,
          orElse: () => Category.top,
        )
      : Category.top;

  final newsItem = await context
      .read<NewsDataSource>()
      .generateNews(category: category, prompt: prompt);

  return Response.json(
    statusCode: HttpStatus.created,
    body: {
      'id': newsItem.post.id,
      'title': newsItem.post.title,
      'category': category.name,
      'url': newsItem.url.toString(),
    },
  );
}
