import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/deck_detail/deck_detail_screen.dart';
import '../../presentation/screens/battle/battle_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/plans/plans_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/deck/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DeckDetailScreen(deckId: id);
      },
    ),
    GoRoute(
      path: '/deck/:id/battle',
      builder: (context, state) {
        // In a real app, we'd pass the deckId to the provider before navigating
        return const BattleScreen();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/plans',
      builder: (context, state) => const PlansScreen(),
    ),
  ],
);
