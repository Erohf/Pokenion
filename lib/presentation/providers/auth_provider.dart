import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_store.dart';
import '../../data/repositories/sync_repository.dart';
import 'deck_provider.dart';
import 'settings_provider.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

/// How the current user is authenticated.
///
/// NOTE: This is a local mock. When wiring real Google auth, replace the
/// [Auth] methods with firebase_auth/google_sign_in calls and cloud sync,
/// keeping this same public API so the UI doesn't change.
enum AuthStatus { signedOut, google, visitor }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.signedOut) AuthStatus status,
    @Default('') String name,
    String? email,
    String? photoPath,
  }) = _AuthState;

  const AuthState._();

  bool get isSignedOut => status == AuthStatus.signedOut;
  bool get isVisitor => status == AuthStatus.visitor;
  bool get isGoogleLinked => status == AuthStatus.google;
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const _kStatus = 'auth.status';
  static const _kName = 'auth.name';
  static const _kEmail = 'auth.email';
  static const _kPhoto = 'auth.photo';

  @override
  AuthState build() {
    final store = LocalStore.instance;
    final statusIndex = store.read<int>(_kStatus) ?? AuthStatus.signedOut.index;
    return AuthState(
      status: AuthStatus.values[statusIndex],
      name: store.read<String>(_kName) ?? '',
      email: store.read<String>(_kEmail),
      photoPath: store.read<String>(_kPhoto),
    );
  }

  Future<void> _persist(AuthState s) async {
    final store = LocalStore.instance;
    await store.write(_kStatus, s.status.index);
    await store.write(_kName, s.name);
    await store.write(_kEmail, s.email);
    await store.write(_kPhoto, s.photoPath);
    state = s;
  }

  /// Google sign-in using Firebase Auth.
  Future<void> signInWithGoogle() async {
    final auth = FirebaseAuth.instance;
    User? firebaseUser;

    if (kIsWeb) {
      try {
        final googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        final userCredential = await auth.signInWithPopup(googleProvider);
        firebaseUser = userCredential.user;
      } on FirebaseAuthException catch (_) {
        // Usuário fechou o popup ou cancelou (popup-closed-by-user /
        // cancelled-popup-request), ou houve erro de configuração.
        return;
      } catch (_) {
        // Qualquer outra falha do popup (ex.: bloqueado pelo navegador).
        return;
      }
    } else {
      try {
        final googleSignIn = GoogleSignIn.instance;
        await googleSignIn.initialize();
        final googleUser = await googleSignIn.authenticate();
        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        final userCredential = await auth.signInWithCredential(credential);
        firebaseUser = userCredential.user;
      } catch (e) {
        // Usuário cancelou ou ocorreu um erro de configuração
        return;
      }
    }

    if (firebaseUser != null) {
      final syncRepo = ref.read(syncRepositoryProvider);

      // Resolve the profile (name + photo):
      // - If this Google account already has a profile saved in the cloud,
      //   it overrides the current (visitor) profile.
      // - Otherwise keep the current local (visitor) name/photo when present,
      //   falling back to the Google account's own display name / photo, and
      //   upload it so the account now "owns" that data.
      final localName = state.name;
      final localPhoto = state.photoPath;
      final cloudProfile = await syncRepo.downloadProfile();

      final String finalName;
      final String? finalPhoto;
      if (cloudProfile != null) {
        finalName = cloudProfile.name.isNotEmpty
            ? cloudProfile.name
            : (firebaseUser.displayName ?? 'Treinador');
        finalPhoto = cloudProfile.photoPath;
      } else {
        finalName =
            localName.isNotEmpty ? localName : (firebaseUser.displayName ?? 'Treinador');
        finalPhoto = localPhoto ?? firebaseUser.photoURL;
        await syncRepo.uploadProfile(name: finalName, photoPath: finalPhoto);
      }

      await _persist(AuthState(
        status: AuthStatus.google,
        name: finalName,
        email: firebaseUser.email ?? '',
        photoPath: finalPhoto,
      ));

      // Sync decks after login
      final localDecks = ref.read(deckNotifierProvider);
      final syncedDecks = await syncRepo.syncOnLogin(localDecks);
      ref.read(deckNotifierProvider.notifier).setDecks(syncedDecks);

      // Sync settings after login
      final settings = ref.read(settingsProvider);
      final cloudSettings = await syncRepo.syncSettingsOnLogin(
        localPlan: settings.plan.index,
        localVisitorWarn: settings.visitorWarningDismissed,
      );
      if (cloudSettings != null) {
        final planIndex = cloudSettings['plan'] as int;
        final visitorWarn = cloudSettings['visitorWarningDismissed'] as bool? ?? false;
        ref.read(settingsProvider.notifier).setSettings(
          PlanType.values[planIndex],
          visitorWarn,
        );
      }
    }
  }

  Future<void> continueAsVisitor(String name) async {
    await _persist(AuthState(status: AuthStatus.visitor, name: name.trim()));
  }

  Future<void> updateName(String name) async {
    final next = state.copyWith(name: name.trim());
    await _persist(next);
    await _syncProfileIfGoogle(next);
  }

  Future<void> updatePhoto(String? path) async {
    final next = state.copyWith(photoPath: path);
    await _persist(next);
    await _syncProfileIfGoogle(next);
  }

  /// Persists profile changes (name/photo) to the cloud for Google users, so
  /// they follow the account across devices.
  Future<void> _syncProfileIfGoogle(AuthState s) async {
    if (s.status != AuthStatus.google) return;
    await ref
        .read(syncRepositoryProvider)
        .uploadProfile(name: s.name, photoPath: s.photoPath);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}
    await _persist(const AuthState());
    await ref.read(deckNotifierProvider.notifier).clearDecks();
  }
}
