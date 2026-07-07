import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/onboarding/login_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/deck_detail/deck_detail_screen.dart';
import '../../presentation/screens/battle/battle_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/plans/plans_screen.dart';

part 'app_router.g.dart';

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
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(
        path: '/deck/:id',
        builder: (c, s) => DeckDetailScreen(deckId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/deck/:id/battle',
        builder: (c, s) => BattleScreen(deckId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      GoRoute(path: '/profile/name', builder: (c, s) => const ChangeNameScreen()),
      GoRoute(path: '/profile/themes', builder: (c, s) => const ThemesScreen()),
      GoRoute(path: '/profile/about', builder: (c, s) => const AboutScreen()),
      GoRoute(path: '/plans', builder: (c, s) => const PlansScreen()),
      GoRoute(path: '/plans/premium', builder: (c, s) => const PlanDetailScreen(premium: true)),
      GoRoute(path: '/plans/no-ads', builder: (c, s) => const PlanDetailScreen(premium: false)),
    ],
  );
}
