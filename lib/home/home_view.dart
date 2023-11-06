import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/feed/feed_view.dart';
import 'package:pro_one/home/home_cubit.dart';
import 'package:pro_one/login/login_modal.dart';
import 'package:pro_one/navigation/bottom_nav_bar.dart';
import 'package:pro_one/navigation/nav_drawer_subscribe.dart';
import 'package:pro_one/packages/app_ui/app_logo.dart';
import 'package:pro_one/packages/app_ui/show_app_modal.dart';
import 'package:pro_one/search/search_page.dart';
import 'package:pro_one/user_profile/user_profile_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(listener: ((context, state) {
          if (state.showLoginOverlay) {
            showAppModal(
                context: context,
                builder: (context) => const LoginModal(),
                routeSettings: const RouteSettings(name: LoginModal.name));
          }
        })),
        BlocListener<HomeCubit, HomeState>(listener: ((context, state) {
          FocusManager.instance.primaryFocus?.unfocus();
        }))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.dark(),
          centerTitle: true,
          actions: const [UserProfileButton()],
        ),
        drawer: const NavDrawer(),
        body: IndexedStack(
          index: selectedTab,
          children: const [FeedView(), SearchPage()],
        ),
        bottomNavigationBar: BottomNavBar(
            currentIndex: selectedTab,
            onTap: (value) => context.read<HomeCubit>().setTab(value)),
      ),
    );
  }
}
