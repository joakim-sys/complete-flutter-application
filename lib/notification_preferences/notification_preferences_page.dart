import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/notification_preferences/notification_category_tile.dart';
import 'package:pro_one/notification_preferences/notification_preferences_bloc.dart';
import 'package:pro_one/packages/app_ui/app_back_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/app_switch.dart';
import 'package:pro_one/packages/news_repository.dart';
import 'package:pro_one/packages/notifications_repository.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
        builder: (_) => const NotificationPreferencesPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationPreferencesBloc>(
      create: (_) => NotificationPreferencesBloc(
          newsRepository: context.read<NewsRepository>(),
          notificationsRepository: context.read<NotificationsRepository>())
        ..add(InitialCategoriesPreferencesRequested()),
      child: const NotificationPreferencesView(),
    );
  }
}

class NotificationPreferencesView extends StatelessWidget {
  const NotificationPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.notificationPreferencesTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.notificationPreferencesCategoriesSubtitle,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppColors.mediumEmphasisSurface),
            ),
            const SizedBox(height: AppSpacing.lg),
            BlocBuilder<NotificationPreferencesBloc,
                NotificationPreferencesState>(
              builder: (context, state) => Expanded(
                  child: ListView(
                children: state.categories
                    .map((category) => NotificationCategoryTile(
                        title: category.name,
                        trailing: AppSwitch(
                            value: state.selectedCategories.contains(category),
                            onChanged: ((value) => context
                                .read<NotificationPreferencesBloc>()
                                .add(CategoriesPreferenceToggled(
                                    category: category))))))
                    .toList(),
              )),
            )
          ],
        ),
      )),
    );
  }
}
