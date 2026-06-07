import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'presentation/screens/battle/battle_screen.dart';

class PokenionApp extends StatelessWidget {
  const PokenionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokenion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const BattleScreen(),
    );
  }
}
