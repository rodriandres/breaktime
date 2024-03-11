import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationBar extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const CustomNavigationBar({
    super.key,
    required this.navigationShell,
  });

    void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
      destinations: const [
        NavigationDestination(
          icon: Icon( Icons.home_max ),
          label: 'Home'
        ),

        NavigationDestination(
          icon: Icon( Icons.label_outline ),
          label: 'Categories'
        ),

        NavigationDestination(
          icon: Icon( Icons.favorite_outline ),
          label: 'Favorites'
        ),
      ],
    );
  }
}