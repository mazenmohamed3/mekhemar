import 'package:flutter/material.dart';

class MyAppLifecycleController extends StatefulWidget {
  final Widget child;

  const MyAppLifecycleController({super.key, required this.child});

  @override
  State<MyAppLifecycleController> createState() => _MyAppLifecycleControllerState();
}

class _MyAppLifecycleControllerState extends State<MyAppLifecycleController>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// This is the key lifecycle callback
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('App is in foreground');
        //TODO: Add Biometric
        break;
      case AppLifecycleState.inactive:
        print('App is inactive (e.g. receiving call)');
        break;
      case AppLifecycleState.paused:
        print('App is in background');
        break;
      case AppLifecycleState.detached:
        print('App is detached (still running but not visible)');
        break;
      case AppLifecycleState.hidden:
        print('App is hidden (used on desktop/web when minimized or obscured)');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}