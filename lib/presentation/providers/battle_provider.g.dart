// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$battleHash() => r'210f908e0a846232d06c573f6324a49c53bc23b4';

/// Holds the current battle session. `keepAlive` so it survives navigation to
/// other tabs; only [endGame]/[startBattle] reset it.
///
/// Copied from [Battle].
@ProviderFor(Battle)
final battleProvider = NotifierProvider<Battle, BattleState>.internal(
  Battle.new,
  name: r'battleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$battleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Battle = Notifier<BattleState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
