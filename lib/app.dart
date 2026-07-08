import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_palette.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/settings_provider.dart';

class PokenionApp extends ConsumerStatefulWidget {
  const PokenionApp({super.key});

  @override
  ConsumerState<PokenionApp> createState() => _PokenionAppState();
}

class _PokenionAppState extends ConsumerState<PokenionApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(settingsProvider).themeMode;

    return MaterialApp.router(
      title: 'Pokenion',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppPalette.light.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          brightness: Brightness.light,
        ),
        extensions: const [AppPalette.light],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppPalette.dark.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          brightness: Brightness.dark,
        ),
        extensions: const [AppPalette.dark],
      ),
    );
  }
}
