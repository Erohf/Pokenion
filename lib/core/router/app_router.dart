import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/onboarding/login_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/deck_detail/deck_detail_screen.dart';
import '../../presentation/screens/battle/battle_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/plans/plans_screen.dart';
import '../../presentation/screens/events/events_screen.dart';

part 'app_router.g.dart';

/// Fade-through: subtle fade + upward drift. The app's default transition.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
              .animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Slide-up: for editor-style screens that "stack" on top of the flow.
CustomTransitionPage<void> _slideUp(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position:
            Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

/// Battle entrance: dramatic zoom-in from the VS action.
CustomTransitionPage<void> _battleZoom(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 460),
    transitionsBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 1.12, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // Rebuild routing when auth status changes (login / logout).
  final notifier = ValueNotifier(ref.read(authProvider).status);
  ref.listen(authProvider, (_, next) => notifier.value = next.status);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final signedOut = ref.read(authProvider).isSignedOut;
      final atLogin = state.matchedLocation == '/login';
      if (signedOut) return atLogin ? null : '/login';
      if (atLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
          path: '/login',
          pageBuilder: (c, s) => _fade(s, const LoginScreen())),
      GoRoute(path: '/', pageBuilder: (c, s) => _fade(s, const HomeScreen())),
      GoRoute(
        path: '/deck/new',
        pageBuilder: (c, s) => _slideUp(
            s, DeckDetailScreen(deckId: null, initialName: s.extra as String?)),
      ),
      GoRoute(
        path: '/deck/:id',
        pageBuilder: (c, s) =>
            _slideUp(s, DeckDetailScreen(deckId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/deck/:id/battle',
        pageBuilder: (c, s) =>
            _battleZoom(s, BattleScreen(deckId: s.pathParameters['id']!)),
      ),
      GoRoute(
          path: '/profile',
          pageBuilder: (c, s) => _fade(s, const ProfileScreen())),
      GoRoute(
          path: '/events',
          pageBuilder: (c, s) => _slideUp(s, const EventsScreen())),
      GoRoute(
          path: '/profile/name',
          pageBuilder: (c, s) => _slideUp(s, const ChangeNameScreen())),
      GoRoute(
          path: '/profile/themes',
          pageBuilder: (c, s) => _slideUp(s, const ThemesScreen())),
      GoRoute(
          path: '/profile/about',
          pageBuilder: (c, s) => _slideUp(s, const AboutScreen())),
      GoRoute(
          path: '/plans',
          pageBuilder: (c, s) => _slideUp(s, const PlansScreen())),
      GoRoute(
          path: '/plans/premium',
          pageBuilder: (c, s) =>
              _slideUp(s, const PlanDetailScreen(premium: true))),
      GoRoute(
          path: '/plans/no-ads',
          pageBuilder: (c, s) =>
              _slideUp(s, const PlanDetailScreen(premium: false))),
    ],
  );
}
