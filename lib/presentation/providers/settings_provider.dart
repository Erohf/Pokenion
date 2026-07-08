import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_store.dart';
import '../../data/repositories/sync_repository.dart';
import 'auth_provider.dart';

part 'settings_provider.g.dart';

enum PlanType { freemium, premium, noAds }

extension PlanTypeX on PlanType {
  String get label => switch (this) {
        PlanType.freemium => 'Plano Freemium',
        PlanType.premium => 'Plano Premium',
        PlanType.noAds => 'Plano No-Ads',
      };

  /// Maximum number of decks allowed by this plan.
  int get maxDecks => this == PlanType.premium ? 10 : 5;

  /// Whether ads are shown for this plan.
  bool get showsAds => this == PlanType.freemium;
}

/// App-wide preferences: theme, subscription plan and one-off flags.
@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  static const _kTheme = 'settings.themeDark';
  static const _kPlan = 'settings.plan';
  static const _kVisitorWarn = 'settings.visitorWarningDismissed';

  @override
  SettingsState build() {
    final store = LocalStore.instance;
    return SettingsState(
      themeMode:
          (store.read<bool>(_kTheme) ?? true) ? ThemeMode.dark : ThemeMode.light,
      plan: PlanType.values[store.read<int>(_kPlan) ?? PlanType.freemium.index],
      visitorWarningDismissed: store.read<bool>(_kVisitorWarn) ?? false,
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    await LocalStore.instance.write(_kTheme, mode == ThemeMode.dark);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> _syncSettingsToCloud() async {
    final auth = ref.read(authProvider);
    if (auth.status == AuthStatus.google) {
      await ref.read(syncRepositoryProvider).uploadSettings(
        planIndex: state.plan.index,
        visitorWarningDismissed: state.visitorWarningDismissed,
      );
    }
  }

  Future<void> setPlan(PlanType plan) async {
    await LocalStore.instance.write(_kPlan, plan.index);
    state = state.copyWith(plan: plan);
    await _syncSettingsToCloud();
  }

  Future<void> dismissVisitorWarning() async {
    await LocalStore.instance.write(_kVisitorWarn, true);
    state = state.copyWith(visitorWarningDismissed: true);
    await _syncSettingsToCloud();
  }

  void setSettings(PlanType plan, bool visitorWarningDismissed) {
    state = state.copyWith(
      plan: plan,
      visitorWarningDismissed: visitorWarningDismissed,
    );
  }
}

class SettingsState {
  final ThemeMode themeMode;
  final PlanType plan;
  final bool visitorWarningDismissed;

  const SettingsState({
    required this.themeMode,
    required this.plan,
    required this.visitorWarningDismissed,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    PlanType? plan,
    bool? visitorWarningDismissed,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        plan: plan ?? this.plan,
        visitorWarningDismissed:
            visitorWarningDismissed ?? this.visitorWarningDismissed,
      );
}
