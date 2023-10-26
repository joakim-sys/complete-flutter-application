import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/block_action_callback.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:pro_one/newsblocks_ui/post_medium_description_layout.dart';
import 'package:pro_one/newsblocks_ui/post_medium_overlaid_layout.dart';

class PostMedium extends StatelessWidget {
  const PostMedium({super.key, required this.block, this.onPressed});

  final PostMediumBlock block;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          block.hasNavigationAction ? onPressed?.call(block.action!) : null,
      child: block.isContentOverlaid
          ? PostMediumOverlaidLayout(
              title: block.title, imageUrl: block.imageUrl!)
          : PostMediumDescriptionLayout(
              title: block.author,
              imageUrl: block.imageUrl!,
              publishedAt: block.publishedAt,
              description: block.description,
              author: block.author,
            ),
    );
  }
}
