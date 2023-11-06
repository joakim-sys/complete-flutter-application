import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/inline_video.dart';
import 'package:pro_one/newsblocks_ui/post_content.dart';
import 'package:pro_one/newsblocks_ui/progress_indicator.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class VideoIntroduction extends StatelessWidget {
  const VideoIntroduction({super.key, required this.block});

  final VideoIntroductionBlock block;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineVideo(
            videoUrl: block.videoUrl,
            progressIndicator: const ProgressIndicator()),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: PostContent(
            title: block.title,
            isVideoContent: true,
            categoryName: block.category.name,
          ),
        )
      ],
    );
  }
}
