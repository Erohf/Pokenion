# Pokenion — Gemini CLI Prompt (paste this into the CLI)

---

```
You are a Flutter developer implementing screens for the Pokenion app — a Pokémon TCG companion app for tracking physical matches.

## YOUR TASK
Use the Figma MCP to inspect the "Screens" page of the Pokenion Figma file and implement all screens that are marked as "ready to dev" as Flutter widgets. Do NOT reimplment what is already done — see the "What Is Already Implemented" section below.

---

## PROJECT OVERVIEW

- **Stack:** Flutter (Dart), Riverpod for state, GoRouter for navigation, freezed models
- **Target platforms:** iOS and Android (mobile-first)
- **Architecture:** Clean Architecture — Presentation → Domain → Data
- **Design:** Dark mode first. Light-mode variant exists for the battle screen (white/gray card surfaces from Figma).

---

## WHAT IS ALREADY IMPLEMENTED (do NOT recreate these)

### Core / Theme
- `lib/core/theme/app_colors.dart` — full color palette (AppColors class)
- `lib/core/theme/app_text_styles.dart` — full text style system (AppTextStyles class)

### Domain Models (with freezed + generated files)
- `lib/domain/models/status_condition.dart` — StatusCondition enum
- `lib/domain/models/active_pokemon.dart` — ActivePokemon freezed model
- `lib/domain/models/card.dart` — PokemonCard freezed model
- `lib/domain/models/player_state.dart` — PlayerState freezed model

### Presentation / Widgets
- `lib/presentation/widgets/hp_tracker.dart` — HpTracker widget (currentHp, maxHp, onChanged)
- `lib/presentation/widgets/energy_tracker.dart` — EnergyTracker widget (Map<EnergyType, int>)
- `lib/presentation/widgets/status_badge.dart` — StatusBadge widget (icon, label, backgroundColor, onTap)
- `lib/presentation/widgets/battle_menu.dart` — BattleMenu bottom bar widget

### Presentation / Screens
- `lib/presentation/screens/battle/battle_screen.dart` — BattleScreen (the main battle tracking screen, fully implemented)

### Providers
- `lib/presentation/providers/battle_provider.dart` — BattleNotifier (Riverpod AsyncNotifier managing PlayerState)
- `lib/presentation/providers/battle_provider.g.dart` — generated file

### Entry Points
- `lib/main.dart` — app entry with ProviderScope
- `lib/app.dart` — PokenionApp with MaterialApp, dark theme, currently routes to BattleScreen

---

## DESIGN SYSTEM (reuse exactly — do not invent new tokens)

### Colors (AppColors from app_colors.dart)
```dart
// Backgrounds
AppColors.bg           // 0xFF13131F — main screen background
AppColors.surface      // 0xFF1E1E2E — cards / panels
AppColors.surface2     // 0xFF252538 — nested cards
AppColors.surfaceVariant // 0xFFF2F2F3 — light surface (used in battle card)
// Borders
AppColors.border       // 0xFF2E2E45 — subtle border (dark)
AppColors.borderVariant // 0xFFE4E5E7 — light border (used in battle card)
// Primary
AppColors.blue         // 0xFF4D8EFF
AppColors.blueDark     // 0xFF2A5FCC
AppColors.blueLight    // 0xFF6BA3FF
// Text
AppColors.textPrimary  // 0xFFFFFFFF
AppColors.textSecondary // 0xFF9090A8
AppColors.textDim      // 0xFF5A5A72
AppColors.textDark     // 0xFF303236 (base-800, used on light surfaces)
// Semantic
AppColors.green        // 0xFF3DCB8E — success / high HP
AppColors.yellow       // 0xFFF5C542 — warning / mid HP
AppColors.red          // 0xFFE05252 — danger / low HP / KO
// Energy types
AppColors.energyFire, energyWater, energyGrass, energyLightning,
energyPsychic, energyFighting, energyDarkness, energyMetal,
energyDragon, energyColorless
```

### Text Styles (AppTextStyles from app_text_styles.dart)
- `AppTextStyles.h1` — SpaceGrotesk, 28px bold, textPrimary
- `AppTextStyles.h2` — SpaceGrotesk, 22px bold, textPrimary
- `AppTextStyles.h3` — SpaceGrotesk, 18px w600, textPrimary
- `AppTextStyles.body` — Inter, 14px, textSecondary, height 1.5
- `AppTextStyles.bodyBold` — Inter, 14px bold, textSecondary
- `AppTextStyles.bodySmall` — Inter, 12px, textSecondary
- `AppTextStyles.label` — Poppins, 13px w600, textPrimary
- `AppTextStyles.labelBold` — Poppins, 13px bold, textPrimary
- `AppTextStyles.caption` — Inter, 11px, textDim
- `AppTextStyles.lifeLabel` — Poppins, 14px bold, blue, letterSpacing 1.4
- `AppTextStyles.hpValue` — Poppins, 20px bold, textDark, letterSpacing 2.0
- `AppTextStyles.buttonText` — Poppins, 13px bold, textPrimary
- `AppTextStyles.turboTag` — Poppins, 16px bold, blue

---

## STEP-BY-STEP INSTRUCTIONS

### Step 1 — Inspect Figma
Use the Figma MCP to:
1. List all frames/pages in the Pokenion Figma file.
2. Navigate to the "Screens" page.
3. Identify ALL frames that are annotated as "ready to dev" (look for dev-mode annotations, section labels, or frame names indicating ready status).
4. For each ready-to-dev screen, extract:
   - Full layout structure (columns, rows, stacks, padding, spacing)
   - Exact colors (match to AppColors tokens above; if a color doesn't match, use the hex and add a comment)
   - Typography (match to AppTextStyles tokens above)
   - Component names (map to existing widgets where possible)
   - Interactive states (hover, pressed, loading)
   - Navigation targets (what happens on button tap)

### Step 2 — Plan Before Coding
Before writing any Dart code, list each screen you found in Figma and state:
- Screen name
- File path where it will be created (follow the pattern: `lib/presentation/screens/<feature>/<screen>_screen.dart`)
- Existing widgets it will reuse (from the list above)
- New widgets it will need (create in `lib/presentation/widgets/`)
- New providers/state it will need (create in `lib/presentation/providers/`)
- New models it will need (create in `lib/domain/models/`)

### Step 3 — Implement Screens
For each screen, follow these rules:

**File naming:** `snake_case` for files, `PascalCase` for classes.

**Widget structure:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class XxxScreen extends ConsumerWidget {
  const XxxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: ...),
    );
  }
}
```

**Reuse existing widgets:**
- For HP display → `HpTracker(currentHp: x, maxHp: y, onChanged: ...)`
- For energy display → `EnergyTracker(energies: Map<EnergyType, int>)`
- For status icons → `StatusBadge(icon: ..., label: '...', backgroundColor: ...)`
- For bottom battle navigation → `BattleMenu()`

**New shared widgets** (create in `lib/presentation/widgets/`):
- `AppCard` — a reusable container with `AppColors.surface` background, `AppColors.border` border, borderRadius 14, padding 16
- `DeckListItem` — deck card for home screen list
- `CardThumbnail` — cached network image with rounded corners and placeholder

**State management** — use Riverpod:
```dart
// For simple local state
final myProvider = StateProvider<MyModel>((ref) => MyModel());

// For async data
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  FutureOr<MyState> build() async { ... }
}
```

**Navigation** — use GoRouter. Add routes to `lib/core/router/app_router.dart` (create it if not present):
```dart
// Routes to implement based on pokenion_context.md:
// /                    → HomeScreen (Meus Decks)
// /deck/:id            → DeckDetailScreen
// /deck/:id/battle     → BattleScreen (already exists)
// /scanner             → ScannerScreen
// /history             → HistoryScreen
// /history/:matchId    → MatchDetailScreen
// /events              → EventsScreen
// /profile             → ProfileScreen
// /profile/settings    → SettingsScreen
```

**Update `lib/app.dart`** to use GoRouter instead of `home: BattleScreen()` once routing is wired.

### Step 4 — Add Missing Widgets Needed by Multiple Screens
Only create these if they appear in the Figma-ready screens:
- `VsBadge` — circle with "VS" in blue
- `DeckListItem` — deck name, format badge, W/L stats, cover image, play button
- `CardThumbnail` — card image from URL with loading state

### Step 5 — Verify
After implementing each screen, confirm:
- No `dynamic` types without justification
- No hardcoded colors outside AppColors
- No hardcoded text styles outside AppTextStyles
- All Pokémon images use `CachedNetworkImage` (already in pubspec.lock)
- All interactable elements have `onTap` / `onPressed` wired (even if to empty lambdas for now)
- Dark theme consistency: `Scaffold(backgroundColor: AppColors.bg, ...)`

---

## ARCHITECTURE RULES (from pokenion_context.md)

- **Language:** Dart, always typed — no `dynamic` without a good reason
- **Naming:** `camelCase` variables/methods, `PascalCase` classes, `snake_case` files
- **State:** Riverpod with `@riverpod` annotation; `AsyncNotifier` for async data
- **Models:** `@freezed` for immutability and copyWith — do NOT create plain classes for domain models
- **Async:** always `async/await`, never nested `.then()`
- **Comments:** in Portuguese, explaining *why* not *what*

---

## KEY BUSINESS LOGIC (implement in UI as needed)

- Deck is valid: exactly 60 cards, max 4 copies of any card (unlimited basic energy)
- Hand size: 7 cards initially
- Prize cards: starts at 6; each KO = opponent takes 1 prize; who takes all 6 wins
- Bench: max 5 Pokémon
- HP bar color: green (>50%), yellow (25-50%), red (<25%) — use AppColors.green/yellow/red
- Status conditions: burned, poisoned, paralyzed, asleep, confused — already in StatusCondition enum

---

## IMPORTANT NOTES

- The `pubspec.yaml` already includes all required packages (`flutter_riverpod`, `go_router`, `sqflite`, `hive_flutter`, `cached_network_image`, `freezed_annotation`, `uuid`, `intl`, etc.). Do NOT add new packages without checking pubspec.yaml first.
- Figma MCP assets (images) use the `https://www.figma.com/api/mcp/asset/...` URL pattern — this is how the existing battle screen loads Pokémon images. Use the same pattern for any Figma-sourced images.
- When you see a frame in Figma with Pokémon card art, use `CachedNetworkImage` with the Figma MCP asset URL.
- The existing BattleScreen uses a light-surface card style (`AppColors.surfaceVariant`, `AppColors.borderVariant`). Match whatever the Figma design specifies — don't force dark mode on screens that are designed light.

Start by inspecting the Figma file now.
```
