import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pro_one/categories/categories_bloc.dart';
import 'package:pro_one/home/home_cubit.dart';
import 'package:pro_one/l10n/l10n.dart';

import '../packages/app_ui/app_colors.dart';
import '../packages/app_ui/app_spacing.dart';

class NavDrawerSections extends StatelessWidget {
  const NavDrawerSections({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoriesBloc bloc) => bloc.state.categories) ?? [];
    final selectedCategory =
        context.select((CategoriesBloc bloc) => bloc.state.selectedCategory);
    return Column(
      children: [
        const NavDrawerSectionsTitle(),
        ...[
          for (final category in categories)
            NavDrawerSectionItem(
              title: toBeginningOfSentenceCase(category.name) ?? '',
              selected: category == selectedCategory,
              onTap: () {
                Scaffold.of(context).closeDrawer();
                context.read<HomeCubit>().setTab(0);
                context
                    .read<CategoriesBloc>()
                    .add(CategorySelected(category: category));
              },
            )
        ]
      ],
    );
  }
}

class NavDrawerSectionsTitle extends StatelessWidget {
  const NavDrawerSectionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n!.navigationDrawerSectionsTitle,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: AppColors.primaryContainer),
    );
  }
}

class NavDrawerSectionItem extends StatelessWidget {
  const NavDrawerSectionItem(
      {super.key,
      required this.title,
      this.onTap,
      this.leading,
      this.selected = false});

  static const _borderRadius = 100.0;
  final String title;
  final Widget? leading;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
            color: selected
                ? AppColors.highEmphasisPrimary
                : AppColors.mediumEmphasisPrimary),
      ),
      selectedTileColor: AppColors.white.withOpacity(0.08),
      selected: selected,
      onTap: onTap,
      minLeadingWidth: AppSpacing.xlg,
      horizontalTitleGap: AppSpacing.md,
      dense: true,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.symmetric(
          horizontal: selected ? AppSpacing.xlg : AppSpacing.lg,
          vertical: AppSpacing.lg + AppSpacing.xxs),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius))),
    );
  }
}
