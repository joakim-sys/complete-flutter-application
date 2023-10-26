import 'package:api/client.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/newsblocks_ui/divider_horizontal.dart';
import 'package:pro_one/newsblocks_ui/post_large.dart';
import 'package:pro_one/newsblocks_ui/section_header.dart';
import 'package:pro_one/newsblocks_ui/spacer.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({super.key, required this.block});

  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      return SectionHeader(
          block: newsBlock,
          onPressed: (action) => _onFeedItemAction(context, action));
    } else if (newsBlock is PostLargeBlock) {
      return PostLarge(
        block: newsBlock,
        premiumText: context.l10n!.newsBlockPremiumText,
        isLocked: newsBlock.isPremium && !isUserSubscribed,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    }
    return const Text('Newsblock here');
  }
}

Future<void> _onFeedItemAction(BuildContext context, BlockAction action) async {
  // TODO: Add functionality
}
