import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/feed/category_feed_loader_item.dart';
import 'package:pro_one/feed/feed_bloc.dart';
import 'package:pro_one/network_error/network_error.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

import '../packages/app_ui/app_spacing.dart';
import 'category_feed_item.dart';

class CategoryFeed extends StatelessWidget {
  const CategoryFeed(
      {super.key, required this.category, this.scrollController});

  final Category category;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final categoryFeed =
        context.select((FeedBloc bloc) => bloc.state.feed[category]) ?? [];
    final hasMoreNews =
        context.select((FeedBloc bloc) => bloc.state.hasMoreNews[category]) ??
            true;
    final isFailure = context
        .select((FeedBloc bloc) => bloc.state.status == FeedStatus.failure);

    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.failure && state.feed.isEmpty) {
          Navigator.of(context).push<void>(NetworkError.route(onRetry: () {
            context
                .read<FeedBloc>()
                .add(FeedRefreshRequested(category: category));
            Navigator.of(context).pop();
          }));
        }
      },
      child: RefreshIndicator(
        displacement: 0,
        color: AppColors.mediumHighEmphasisSurface,
        onRefresh: () async => context
            .read<FeedBloc>()
            .add(FeedRefreshRequested(category: category)),
        child: SelectionArea(
          child: ListView.builder(
            itemCount: categoryFeed.length + 1,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == categoryFeed.length) {
                if (isFailure) {
                  return NetworkError(
                    onRetry: () {
                      context
                          .read<FeedBloc>()
                          .add(FeedRefreshRequested(category: category));
                    },
                  );
                }
                return hasMoreNews
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: categoryFeed.isEmpty ? AppSpacing.xxxlg : 0),
                        child: CategoryFeedLoaderItem(
                          onPresented: () => context
                              .read<FeedBloc>()
                              .add(FeedRequested(category: category)),
                        ),
                      )
                    : const SizedBox();
              }
              final block = categoryFeed[index];
              return CategoryFeedItem(block: block);
            },
          ),
        ),
      ),
    );
  }
}
