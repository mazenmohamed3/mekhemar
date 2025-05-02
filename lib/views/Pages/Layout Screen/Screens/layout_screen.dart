import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../controllers/Pages/Layout/Controllers/layout_controller.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({
    super.key,
    required this.layoutController,
    required this.navigationShell,
  });

  final LayoutController layoutController;
  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.r,
          ), // Set the radius of the indicator
        ),
        onDestinationSelected:
            (value) => widget.layoutController.onDestinationSelected(
              navigationShell: widget.navigationShell,
              value: value,
            ),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}