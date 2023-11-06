import 'package:flutter/widgets.dart';
import 'package:pro_one/newsblocks_ui/inline_video.dart';
import 'package:pro_one/newsblocks_ui/progress_indicator.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:api/client.dart';

class Video extends StatelessWidget {
  const Video({super.key, required this.block});

  final VideoBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InlineVideo(
          videoUrl: block.videoUrl,
          progressIndicator: const ProgressIndicator()),
    );
  }
}
