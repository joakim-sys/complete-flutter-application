import 'package:flutter/material.dart';

class CategoriesTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoriesTabBar(
      {super.key, required this.controller, required this.tabs});

  final TabController controller;
  final List<Widget> tabs;

  @override
  Size get preferredSize => const Size(double.infinity, 48);

  @override
  Widget build(BuildContext context) {
    return TabBar(tabs: tabs, controller: controller, isScrollable: true);
  }
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.categoryName, this.onDoubleTap});

  final String categoryName;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Text(categoryName.toUpperCase()),
    );
  }
}
