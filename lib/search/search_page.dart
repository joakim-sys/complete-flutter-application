import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/feed/category_feed_item.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/news_repository.dart';
import 'package:pro_one/search/search_bloc.dart';
import 'package:pro_one/search/search_filter_chip.dart';
import 'package:pro_one/search/search_headline_text.dart';
import 'package:pro_one/search/search_text_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) =>
          SearchBloc(newsRepository: context.read<NewsRepository>())
            ..add(const SearchTermChanged()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => context
        .read<SearchBloc>()
        .add(SearchTermChanged(searchTerm: _controller.text)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(builder: (context, state) {
      return ListView(children: [
        SearchTextField(controller: _controller),
        const Divider(),
        SearchHeadlineText(
            headerText: state.searchType == SearchType.popular
                ? context.l10n!.searchPopularSearches
                : context.l10n!.searchRelevantTopics),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Wrap(
            spacing: AppSpacing.sm,
            children: state.topics
                .map<Widget>((topic) => SearchFilterChip(
                    onSelected: (text) => _controller.text = text,
                    chipText: topic))
                .toList(),
          ),
        ),
        const Divider(),
        SearchHeadlineText(
            headerText: state.searchType == SearchType.popular
                ? context.l10n!.searchPopularArticles
                : context.l10n!.searchRelevantArticles),
        ...state.articles.map((newsBlock) => CategoryFeedItem(block: newsBlock))
      ]);
    }, listener: ((context, state) {
      if (state.status == SearchStatus.failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text(context.l10n!.searchErrorMessage)));
      }
    }));
  }
}
