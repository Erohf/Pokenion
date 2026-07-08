import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../local/local_store.dart';
import '../../domain/models/deck.dart';

part 'sync_repository.g.dart';

class SyncRepository {
  SyncRepository(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _userId => _auth.currentUser?.uid;

  /// Uploads all decks to Firestore for the currently logged-in user.
  Future<void> uploadDecks(List<Deck> decks) async {
    final uid = _userId;
    if (uid == null) return;

    final batch = _firestore.batch();
    
    for (final deck in decks) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('decks')
          .doc(deck.id);
      batch.set(docRef, deck.toJson());
    }
    
    await batch.commit();
  }

  /// Deletes a specific deck from Firestore.
  Future<void> deleteDeck(String deckId) async {
    final uid = _userId;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('decks')
        .doc(deckId)
        .delete();
  }

  /// Downloads all decks from Firestore and saves them to local Hive storage.
  Future<List<Deck>> downloadDecks() async {
    final uid = _userId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('decks')
        .get();
    
    final decks = snapshot.docs
        .map((doc) => Deck.fromJson(doc.data()))
        .toList();
    
    await LocalStore.instance.saveAllDecks(decks);
    return decks;
  }

  /// Performs initial sync when the user signs in with Google.
  /// If the cloud Firestore has decks, it downloads them to overwrite local.
  /// If Firestore is empty but the user had local decks (from visitor flow),
  /// it uploads those local decks to Firestore.
  Future<List<Deck>> syncOnLogin(List<Deck> localDecks) async {
    final uid = _userId;
    if (uid == null) return localDecks;

    // Check if Firestore has decks
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('decks')
        .get();
    
    if (snapshot.docs.isEmpty && localDecks.isNotEmpty) {
      // Cloud is empty, but we have local decks (visitor flow). Upload them!
      await uploadDecks(localDecks);
      return localDecks;
    } else {
      // Cloud is not empty (or local is empty). Download cloud decks to local.
      final cloudDecks = snapshot.docs
          .map((doc) => Deck.fromJson(doc.data()))
          .toList();
      await LocalStore.instance.saveAllDecks(cloudDecks);
      return cloudDecks;
    }
  }

  /// Uploads user settings to Firestore.
  Future<void> uploadSettings({
    required int planIndex,
    required bool visitorWarningDismissed,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'plan': planIndex,
      'visitorWarningDismissed': visitorWarningDismissed,
    }, SetOptions(merge: true));
  }

  /// Downloads user settings from Firestore. Returns a Map if found.
  Future<Map<String, dynamic>?> downloadSettings() async {
    final uid = _userId;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  /// Performs initial settings sync when the user signs in.
  /// If the cloud has settings, downloads them. If not, uploads local.
  Future<Map<String, dynamic>?> syncSettingsOnLogin({
    required int localPlan,
    required bool localVisitorWarn,
  }) async {
    final uid = _userId;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null || !data.containsKey('plan')) {
      // Cloud is empty. Upload local settings.
      await uploadSettings(
        planIndex: localPlan,
        visitorWarningDismissed: localVisitorWarn,
      );
      return null;
    } else {
      // Cloud has settings. Update local Hive.
      final cloudPlan = data['plan'] as int;
      final cloudVisitorWarn = data['visitorWarningDismissed'] as bool? ?? false;
      await LocalStore.instance.write('settings.plan', cloudPlan);
      await LocalStore.instance.write('settings.visitorWarningDismissed', cloudVisitorWarn);
      return data;
    }
  }
}

@Riverpod(keepAlive: true)
SyncRepository syncRepository(SyncRepositoryRef ref) {
  return SyncRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
}
