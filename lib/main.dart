import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controllers/Features/App Lifecycle/Controllers/app_lifecycle_controller.dart';
import 'controllers/Features/Auto Detect Locale/Controller/init_locale_controller.dart';
import 'controllers/Features/Location/Controller/location_controller.dart';
import 'controllers/Generated/Assets/assets.dart';
import 'controllers/Router/app_router.dart';
import 'controllers/Theme/Controller/theme_controller.dart';
import 'controllers/Theme/Service/theme_update_service.dart';
import 'controllers/Theme/Theme Data/theme.dart';
import 'controllers/configs/size_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await LocationController.init();

  Locale initialLocale = await InitLocaleController.initializeAppLocale();
  final themeController = ThemeController();
  await themeController.loadThemeFromStorage();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: initialLocale,
      path: Assets.translations,
      fallbackLocale: const Locale('en'),
      child: MyApp(themeController: themeController),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late StreamSubscription<ThemeMode> _themeSubscription;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeController.themeMode;

    // Listen to updates from ThemeUpdateService
    _themeSubscription = ThemeUpdateService().themeUpdates.listen((newMode) {
      setState(() {
        _themeMode = newMode;
      });
    });
  }

  @override
  void dispose() {
    _themeSubscription.cancel();
    widget.themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.themeController.saveFirstTime(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return ScreenUtilInit(
      designSize:
          !SizeConfig.isTablet(context)
              ? const Size(448, 997)
              : isLandscape
              ? const Size(1194, 834)
              : const Size(834, 1194),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (_, __) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: MyAppLifecycleController(
              child: MaterialApp.router(
                title: 'Mekhemar',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: _themeMode,
                routerConfig: AppRouter.routerConfig,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
              ),
            ),
          ),
    );
  }
}
