import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_store.dart';

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

  /// Mock Google sign-in. Replace with real google_sign_in flow later.
  Future<void> signInWithGoogle() async {
    await _persist(state.copyWith(
      status: AuthStatus.google,
      name: state.name.isEmpty ? 'Treinador' : state.name,
      email: state.email ?? 'treinador@gmail.com',
    ));
  }

  Future<void> continueAsVisitor(String name) async {
    await _persist(AuthState(status: AuthStatus.visitor, name: name.trim()));
  }

  Future<void> updateName(String name) async =>
      _persist(state.copyWith(name: name.trim()));

  Future<void> updatePhoto(String? path) async =>
      _persist(state.copyWith(photoPath: path));

  Future<void> signOut() async => _persist(const AuthState());
}
