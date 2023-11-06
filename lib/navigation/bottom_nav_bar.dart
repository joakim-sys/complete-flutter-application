import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/l10n/l10n.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueSetter<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: context.l10n!.bottomNavBarTopStories),
        BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: context.l10n!.bottomNavBarSearch)
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
