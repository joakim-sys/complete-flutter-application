import 'package:api/client.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/newsblocks_ui/inline_image.dart';
import 'package:pro_one/newsblocks_ui/progress_indicator.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class Image extends StatelessWidget {
  const Image({super.key, required this.block});

  final ImageBlock block;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InlineImage(
        imageUrl: block.imageUrl,
        progressIndicatorBuilder: (context, url, progress) => ProgressIndicator(
          progress: progress.progress,
        ),
      ),
    );
  }
}
