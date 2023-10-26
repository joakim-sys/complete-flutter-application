import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/date_time_extension.dart';

class PostFooter extends StatelessWidget {
  const PostFooter(
      {super.key,
      this.publishedAt,
      this.author,
      this.onShare,
      this.isContentOverlaid = false});

  final String? author;
  final DateTime? publishedAt;
  final VoidCallback? onShare;
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = isContentOverlaid
        ? AppColors.mediumEmphasisPrimary
        : AppColors.mediumEmphasisSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
          style: textTheme.bodySmall?.copyWith(color: textColor),
          children: [
            if (author != null) ...[
              TextSpan(text: author),
              const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
              const TextSpan(text: '•'),
              const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
            ],
            if (publishedAt != null) TextSpan(text: publishedAt!.mDY)
          ],
        )),
        if (onShare != null)
          IconButton(
              onPressed: onShare, icon: Icon(Icons.share, color: textColor))
      ],
    );
  }
}
