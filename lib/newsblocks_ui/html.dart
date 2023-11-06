import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;

class Html extends StatelessWidget {
  const Html({super.key, required this.block});

  final HtmlBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: flutter_html.Html(
        onLinkTap: null,
        data: block.content,
        style: {
          'p': flutter_html.Style.fromTextStyle(theme.textTheme.bodyLarge!),
          'h1': flutter_html.Style.fromTextStyle(theme.textTheme.displayLarge!),
          'h2':
              flutter_html.Style.fromTextStyle(theme.textTheme.displayMedium!),
          'h3': flutter_html.Style.fromTextStyle(theme.textTheme.displaySmall!),
          'h4':
              flutter_html.Style.fromTextStyle(theme.textTheme.headlineMedium!),
          'h5':
              flutter_html.Style.fromTextStyle(theme.textTheme.headlineSmall!),
          'h6': flutter_html.Style.fromTextStyle(theme.textTheme.titleLarge!),
        },
      ),
    );
  }
}
