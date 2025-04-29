import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added import

import 'controllers/Generated/Assets/assets.dart';
import 'controllers/Router/app_router.dart';
import 'controllers/Theme/theme.dart';
import 'controllers/configs/size_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options:
        Firebase.apps.any((app) => app.name.isNotEmpty)
            ? DefaultFirebaseOptions.currentPlatform
            : null,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: const Locale('en'),
      path: Assets.translations,
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return ScreenUtilInit(
      designSize: !SizeConfig.isTablet(context)
              ? const Size(448, 997)
              : isLandscape
              ? const Size(1194, 834)
              : const Size(834, 1194),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => AnnotatedRegion<Future<void>>(
            value: SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
            child: MaterialApp.router(
              title: 'Mekhemar',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              routerConfig: AppRouter.routerConfig,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
            ),
          ),
    );
  }
}