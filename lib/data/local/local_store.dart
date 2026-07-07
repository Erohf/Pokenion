import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/deck.dart';

/// Thin wrapper around Hive providing typed access to the app's local data.
///
/// Freezed models are stored as encoded JSON strings so we don't need to
/// hand-write Hive TypeAdapters. This layer is intentionally simple and can be
/// swapped for a cloud-backed implementation (Firestore) later.
class LocalStore {
  LocalStore._(this._decks, this._app);

  final Box<String> _decks; // id -> deck json
  final Box _app; // misc key/value (profile, settings)

  static const _decksBox = 'decks_v1';
  static const _appBox = 'app_v1';

  static LocalStore? _instance;
  static LocalStore get instance => _instance!;

  static Future<LocalStore> init() async {
    if (_instance != null) return _instance!;
    await Hive.initFlutter();
    final decks = await Hive.openBox<String>(_decksBox);
    final app = await Hive.openBox(_appBox);
    _instance = LocalStore._(decks, app);
    return _instance!;
  }

  // ── Decks ──────────────────────────────────────────────────────────────
  List<Deck> readDecks() {
    final list = _decks.values
        .map((s) => Deck.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  Future<void> saveDeck(Deck deck) =>
      _decks.put(deck.id, jsonEncode(deck.toJson()));

  Future<void> saveAllDecks(List<Deck> decks) async {
    await _decks.clear();
    await _decks.putAll({for (final d in decks) d.id: jsonEncode(d.toJson())});
  }

  Future<void> deleteDeck(String id) => _decks.delete(id);

  // ── Key/value (profile & settings) ─────────────────────────────────────
  T? read<T>(String key) => _app.get(key) as T?;
  Future<void> write(String key, Object? value) => _app.put(key, value);
}
