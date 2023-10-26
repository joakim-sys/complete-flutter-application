import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/categories/categories_bloc.dart';
import 'package:pro_one/feed/feed_bloc.dart';
import 'package:pro_one/home/home_cubit.dart';
import 'package:pro_one/home/home_view.dart';
import 'package:pro_one/packages/news_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                CategoriesBloc(newsRepository: context.read<NewsRepository>())
                  ..add(const CategoriesRequested())),
        BlocProvider(
            create: ((context) =>
                FeedBloc(newsRepository: context.read<NewsRepository>()))),
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: const HomeView(),
    );
  }
}
