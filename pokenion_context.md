# Pokenion — Documento de Contexto para Desenvolvimento

> Este documento serve como fonte de verdade para o desenvolvimento do app Pokenion. Utilize-o para contextualizar qualquer ferramenta de IA ou desenvolvedor entrando no projeto.

---

## 1. Visão Geral

**Nome:** Pokenion  
**Plataforma:** Mobile — iOS e Android  
**Stack:** Flutter (Dart)  
**Paradigma:** Aplicativo companion para jogadores de Pokémon TCG (Trading Card Game) físico  
**Objetivo:** Permitir que jogadores importem seus decks e acompanhem partidas em tempo real, substituindo papel, tokens físicos e memória por uma interface digital intuitiva.

### Proposta de Valor
Não existe hoje um app mobile robusto voltado para acompanhamento de partidas físicas de Pokémon TCG. O Pokenion preenche esse gap com:
- Rastreamento de HP, energia e condições de status em tempo real
- Gestão de múltiplos decks importados
- Histórico automático de jogadas e estatísticas
- Integração com câmera (scan de cartas), GPS (eventos locais) e IA (sugestões)

---

## 2. Arquitetura do Projeto

### 2.1 Stack Técnico

| Camada | Tecnologia | Pacote/Versão |
|--------|-----------|---------------|
| UI | Flutter + Material 3 | `flutter: ^3.x` |
| State Management | Riverpod | `flutter_riverpod: ^2.x` |
| Banco de dados local | SQLite | `sqflite: ^2.x` |
| Cache/preferências rápidas | Hive | `hive_flutter: ^1.x` |
| Câmera | Camera plugin | `camera: ^0.x` |
| OCR (scan de cartas) | Google ML Kit | `google_mlkit_text_recognition: ^0.x` |
| GPS / localização | Geolocator | `geolocator: ^10.x` |
| Notificações locais | Local Notifications | `flutter_local_notifications: ^16.x` |
| Armazenamento seguro | Flutter Secure Storage | `flutter_secure_storage: ^9.x` |
| HTTP client | Dio | `dio: ^5.x` |
| IA / sugestões | OpenAI API ou Google Gemini API | via `dio` |
| Serialização | json_serializable + freezed | `freezed: ^2.x` |
| Roteamento | Go Router | `go_router: ^13.x` |
| Injeção de dependência | Riverpod providers | — |

### 2.2 Estrutura de Pastas

```
lib/
├── main.dart
├── app.dart                        # MaterialApp, tema, roteamento
├── core/
│   ├── theme/
│   │   ├── app_theme.dart          # ThemeData dark mode
│   │   ├── app_colors.dart         # Paleta de cores
│   │   └── app_text_styles.dart
│   ├── router/
│   │   └── app_router.dart         # GoRouter com todas as rotas
│   ├── constants/
│   │   └── api_constants.dart
│   └── utils/
│       ├── damage_calculator.dart
│       └── probability_calculator.dart
├── data/
│   ├── local/
│   │   ├── database/
│   │   │   ├── app_database.dart   # Inicialização do SQLite
│   │   │   └── migrations/
│   │   ├── daos/
│   │   │   ├── deck_dao.dart
│   │   │   ├── card_dao.dart
│   │   │   └── match_dao.dart
│   │   └── hive/
│   │       └── preferences_box.dart
│   ├── remote/
│   │   ├── pokemon_tcg_api.dart    # PokémonTCG.io
│   │   ├── limitless_api.dart      # Limitless TCG
│   │   └── ai_service.dart         # OpenAI / Gemini
│   └── repositories/
│       ├── deck_repository.dart
│       ├── card_repository.dart
│       └── match_repository.dart
├── domain/
│   ├── models/
│   │   ├── card.dart               # Modelo de carta
│   │   ├── deck.dart               # Modelo de deck
│   │   ├── match.dart              # Modelo de partida
│   │   ├── player_state.dart       # Estado de um jogador na partida
│   │   ├── active_pokemon.dart     # Pokémon ativo no campo
│   │   └── status_condition.dart   # Enum: Burned, Poisoned, Asleep, etc.
│   └── usecases/
│       ├── import_deck_usecase.dart
│       ├── scan_card_usecase.dart
│       └── get_play_suggestion_usecase.dart
├── presentation/
│   ├── screens/
│   │   ├── home/                   # Lista de decks
│   │   ├── deck_detail/            # Visualização de deck
│   │   ├── battle/                 # Modo batalha (tela principal)
│   │   ├── scanner/                # Câmera + OCR
│   │   ├── history/                # Histórico de partidas
│   │   ├── events/                 # GPS — eventos locais
│   │   └── profile/                # Perfil e configurações
│   ├── widgets/
│   │   ├── hp_tracker.dart
│   │   ├── energy_tracker.dart
│   │   ├── status_badge.dart
│   │   ├── card_thumbnail.dart
│   │   ├── deck_list_item.dart
│   │   └── vs_badge.dart
│   └── providers/
│       ├── deck_provider.dart
│       ├── battle_provider.dart
│       └── match_history_provider.dart
└── services/
    ├── camera_service.dart
    ├── location_service.dart
    ├── notification_service.dart
    └── ocr_service.dart
```

### 2.3 Camadas da Arquitetura

```
Presentation  →  Domain  →  Data
(Flutter UI)     (Models,    (SQLite, APIs,
(Riverpod)       UseCases)   Hive, Services)
```

Seguir **Clean Architecture** com separação clara entre camadas. Riverpod gerencia estado e injeção de dependência em toda a aplicação.

---

## 3. Modelos de Dados

### 3.1 Card (Carta)

```dart
@freezed
class PokemonCard with _$PokemonCard {
  const factory PokemonCard({
    required String id,           // ID da PokémonTCG.io API
    required String name,
    required String set,          // Ex: "Temporal Forces"
    required String number,       // Número na coleção
    required CardType type,       // Pokemon, Trainer, Energy
    String? supertype,
    List<String>? subtypes,
    int? hp,
    List<String>? types,          // Fire, Water, etc.
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<Resistance>? resistances,
    String? retreatCost,
    String? imageUrl,
    String? imageLargeUrl,
    String? rarity,
  }) = _PokemonCard;
}
```

### 3.2 Deck

```dart
@freezed
class Deck with _$Deck {
  const factory Deck({
    required String id,
    required String name,
    required String description,
    required List<DeckCard> cards,  // Lista de cartas com quantidade
    required DateTime createdAt,
    DateTime? updatedAt,
    String? format,                 // Standard, Expanded, Legacy
    String? coverCardId,            // Carta usada como thumbnail
    int totalMatches = 0,
    int wins = 0,
    int losses = 0,
  }) = _Deck;
}

@freezed
class DeckCard with _$DeckCard {
  const factory DeckCard({
    required PokemonCard card,
    required int quantity,          // 1-4 para a maioria, 4 max
  }) = _DeckCard;
}
```

### 3.3 Match (Partida)

```dart
@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String deckId,
    required DateTime startTime,
    DateTime? endTime,
    MatchResult? result,            // Win, Loss, Draw
    required List<MatchAction> actions,  // Log de ações
    String? opponentDeckName,
    String? notes,
    MatchLocation? location,        // GPS data
  }) = _Match;
}

@freezed
class MatchAction with _$MatchAction {
  const factory MatchAction({
    required String id,
    required DateTime timestamp,
    required ActionType type,       // Draw, Play, Attack, Evolve, Retreat, etc.
    required int turn,
    String? cardId,
    String? description,
    Map<String, dynamic>? metadata,
  }) = _MatchAction;
}
```

### 3.4 PlayerState (Estado do Jogador na Partida)

```dart
@freezed
class PlayerState with _$PlayerState {
  const factory PlayerState({
    required String playerId,       // "player" ou "opponent"
    required List<ActivePokemon> bench,   // Bancada (máx 5)
    ActivePokemon? activePokemon,
    required int handCount,         // Cartas na mão
    required int deckCount,         // Cartas no deck
    required int discardCount,      // Cartas no descarte
    required int prizeCardsCount,   // Cartas prêmio restantes (começa em 6)
    required List<EnergyType> attachedEnergies,
    int lostZoneCount = 0,
  }) = _PlayerState;
}

@freezed
class ActivePokemon with _$ActivePokemon {
  const factory ActivePokemon({
    required PokemonCard card,
    required int currentHp,
    required int maxHp,
    required List<EnergyType> attachedEnergies,
    StatusCondition? statusCondition,
    List<PokemonCard> evolutionStack = const [],
    bool hasTurboToken = false,
    Map<String, dynamic>? activeEffects,  // Efeitos específicos de ataques/habilidades
  }) = _ActivePokemon;
}
```

### 3.5 Enums

```dart
enum CardType { pokemon, trainer, energy }

enum EnergyType {
  fire, water, grass, lightning, psychic,
  fighting, darkness, metal, fairy, dragon,
  colorless
}

enum StatusCondition {
  burned,     // Queimado — causa dano entre turnos
  poisoned,   // Envenenado — causa dano entre turnos
  paralyzed,  // Paralisado — não pode atacar/recuar
  asleep,     // Dormindo — virar moeda para acordar
  confused,   // Confuso — virar moeda para atacar
}

enum MatchResult { win, loss, draw }

enum ActionType {
  draw, play, attack, evolve, retreat,
  attachEnergy, useAbility, useTrainer,
  applyStatus, removeStatus, takePrize,
  mulligan, setupBench, endTurn
}
```

---

## 4. Schema do Banco de Dados (SQLite)

```sql
-- Cartas
CREATE TABLE cards (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  set_name TEXT NOT NULL,
  number TEXT NOT NULL,
  type TEXT NOT NULL,           -- CardType enum
  hp INTEGER,
  types TEXT,                   -- JSON array: ["Fire", "Colorless"]
  attacks TEXT,                 -- JSON
  weaknesses TEXT,              -- JSON
  resistances TEXT,             -- JSON
  retreat_cost TEXT,
  image_url TEXT,
  image_large_url TEXT,
  rarity TEXT,
  raw_json TEXT NOT NULL        -- JSON completo da API para campos extras
);

-- Decks
CREATE TABLE decks (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  format TEXT,
  cover_card_id TEXT,
  total_matches INTEGER DEFAULT 0,
  wins INTEGER DEFAULT 0,
  losses INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER,
  FOREIGN KEY (cover_card_id) REFERENCES cards(id)
);

-- Cartas do deck (relação N:N com quantidade)
CREATE TABLE deck_cards (
  deck_id TEXT NOT NULL,
  card_id TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (deck_id, card_id),
  FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE,
  FOREIGN KEY (card_id) REFERENCES cards(id)
);

-- Partidas
CREATE TABLE matches (
  id TEXT PRIMARY KEY,
  deck_id TEXT NOT NULL,
  start_time INTEGER NOT NULL,
  end_time INTEGER,
  result TEXT,                  -- win | loss | draw | null
  opponent_deck_name TEXT,
  notes TEXT,
  location_lat REAL,
  location_lng REAL,
  location_name TEXT,
  FOREIGN KEY (deck_id) REFERENCES decks(id)
);

-- Log de ações da partida
CREATE TABLE match_actions (
  id TEXT PRIMARY KEY,
  match_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  type TEXT NOT NULL,           -- ActionType enum
  turn INTEGER NOT NULL,
  card_id TEXT,
  description TEXT,
  metadata TEXT,                -- JSON
  FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE
);
```

---

## 5. Funcionalidades Detalhadas

### 5.1 Home — Meus Decks

- Listagem de todos os decks salvos localmente
- Card de deck exibe: nome, descrição, formato (Standard/Expanded), thumbnail da carta principal, stats (W/L ratio)
- Botão flutuante para adicionar novo deck
- Swipe para deletar deck
- Tap para abrir detalhe do deck
- Botão de play (▶) para iniciar partida com o deck selecionado

### 5.2 Detalhe do Deck

- Header com nome, formato e stats (partidas, vitórias, derrotas)
- Lista de cartas agrupadas por tipo: Pokémon | Trainer | Energia
- Cada carta exibe: quantidade, thumbnail, nome, set/número
- **Probabilidade de compra**: cálculo de hypergeometric distribution para cada carta
  - "Qual a chance de ter X cópias desta carta na mão inicial?"
- Botão de editar deck
- Botão de iniciar partida

**Cálculo de probabilidade (hypergeometric):**
```dart
double drawProbability(int deckSize, int copiesInDeck, int handSize, int copiesDesired) {
  // P(X >= copiesDesired) usando distribuição hipergeométrica
  // deckSize = 60, handSize = 7 (mão inicial)
}
```

### 5.3 Importação de Decks

**Formatos suportados:**

1. **Texto PTCGO/PTCGL** (formato padrão do jogo oficial):
```
Pokémon: 12
4 Charizard ex OBF 125
2 Charmander OBF 26
...
Trainer: 38
4 Professor's Research SVI 189
...
Energy: 10
6 Basic Fire Energy SVE 2
```

2. **Scan por câmera** (OCR): usuário fotografa a lista escrita ou a tela do jogo

3. **URL do Limitless TCG**: colar link de uma lista pública

**Fluxo de importação:**
1. Parse da lista → extração de nome, set, número
2. Busca na PokémonTCG.io API (`GET /v2/cards?q=name:"Charizard ex" number:125 set.id:obf`)
3. Salvar cartas no banco local
4. Criar deck e associar cartas

### 5.4 Modo Batalha (Tela principal do app)

Esta é a tela mais complexa e central do app.

**Layout da tela:**
```
┌─────────────────────────────┐
│  [End Game]    [New Game]   │ ← botões de controle
├─────────────────────────────┤
│                             │
│   ┌──────────────────────┐  │
│   │  LIFE                │  │
│   │  [ - ]  [ 220 ]  [ + ]  │ ← HP tracker
│   │                      │  │
│   │  [sprite do Pokémon] │  │ ← pixel art / imagem
│   │  "Turbo" tag         │  │ ← condição especial
│   │                      │  │  [Stats]
│   │  [ Evolve ]          │  │  [🩻 x3]   ← status icons
│   │  [ Defeated ]        │  │  [🔥 x2]
│   └──────────────────────┘  │  [🌀 ]
│                             │
│  [🔥][🌿][⚡][🔵][⚪][...] │ ← bench row
│            [ ⬤ ]           │ ← botão de ação central
├─────────────────────────────┤
│  [📖]          [👤]         │ ← bottom nav
└─────────────────────────────┘
```

**Funcionalidades do Modo Batalha:**

- **HP Tracker** (por Pokémon ativo):
  - Botões +/- para incrementar/decrementar HP
  - Suporte a tap longo para input manual de valor
  - HP máximo definido pelo card
  - Visual de barra de HP (verde → amarelo → vermelho)
  
- **Bancada (Bench)**:
  - Até 5 Pokémon na bancada
  - Swipe horizontal para ver todos
  - Tap para tornar ativo (trocar posição)
  - Cada slot mostra thumbnail + HP atual

- **Controle de Energia**:
  - Contador por tipo de energia (Fogo, Água, etc.)
  - Botão + para adicionar, - para remover
  - Visual com ícone colorido de cada tipo

- **Condições de Status**:
  - Ícones visuais para: Queimado, Envenenado, Paralisado, Dormindo, Confuso
  - Tap no ícone para aplicar/remover status
  - Alerta automático no início do turno quando há status ativo

- **Evoluir**:
  - Botão "Evolve" abre modal para selecionar a evolução
  - Empilha cartas (cadeia de evolução)
  - Mantém HP atual relativo ao máximo anterior

- **Defeated**:
  - Marca o Pokémon como derrotado
  - Decrementa contador de prêmios do adversário
  - Prompt para escolher próximo Pokémon ativo

- **Cartas Prêmio**:
  - Contador de 0-6 para cada jogador
  - Decrementa ao KO adversário
  - Alerta visual quando chega a 1 prêmio

- **Turno**:
  - Controle de turno atual (Seu turno / Turno adversário)
  - Botão de fim de turno
  - Incrementa contador de turno

- **Log de ações**:
  - Registro automático de cada ação (HP mudou, energia adicionada, etc.)
  - Acessível via botão "History" na tela

### 5.5 Scanner de Cartas (Câmera + OCR)

**Fluxo:**
1. Usuário abre o scanner
2. Câmera abre com overlay de guia (retângulo de posicionamento)
3. Google ML Kit processa o frame e detecta texto
4. Parser extrai: nome da carta, número, set
5. Busca automática na API
6. Preview da carta reconhecida com confirmação
7. Opção: adicionar ao deck atual ou a um deck específico

**Casos de uso:**
- Fotografar carta física para adicionar ao deck
- Fotografar lista de deck escrita em papel
- Confirmar identificação de cartas do adversário durante partida

**Implementação do OCR:**
```dart
class OcrService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  Future<CardScanResult> scanCard(InputImage image) async {
    final recognized = await textRecognizer.processImage(image);
    // Parse do texto para extrair nome e número da carta
    // Regex: /([A-Z][a-z]+ ?[a-z]*) (\d{3}\/\d{3}|\d+)/
  }
}
```

### 5.6 Histórico de Partidas

- Lista cronológica de partidas jogadas
- Filtro por deck, resultado (W/L/D), período
- Cada item: deck usado, adversário, resultado, duração, data, local
- Tap para abrir detalhe da partida:
  - Timeline de ações jogada a jogada
  - Estatísticas: turnos totais, KOs realizados, KOs sofridos
  - Cartas mais jogadas, energias mais usadas
- Stats globais por deck: winrate, média de turnos por vitória

### 5.7 GPS — Eventos Locais

- Solicitar permissão de localização
- Buscar lojas e eventos de Pokémon TCG próximos via API ou dados estáticos
- Exibir no mapa (Google Maps ou Apple Maps via url_launcher)
- Listar eventos com data, local e formato
- Salvar localização da partida ao final de cada match (ranqueados)

### 5.8 Notificações

- **Alertas de turno**: lembrete de aplicar dano de status (veneno/queimadura) entre turnos
- **Lembretes de eventos**: X horas antes de torneios salvos
- **Banimentos**: notificação quando a Pokémon Company atualiza lista de banimentos (via API)
- Notificações são apenas locais (flutter_local_notifications) — sem push server

### 5.9 Perfil e Configurações

- Nome do jogador
- Conta vinculada (auth simples ou via Google Sign-In)
- Seleção de tema (Dark fixo por ora, com expansão futura para temas por tipo de Pokémon)
- Planos (premium para remover banners de aviso de ads futuros)
- Sobre: versão, créditos

---

## 6. Integrações Externas

### 6.1 PokémonTCG.io API

**Base URL:** `https://api.pokemontcg.io/v2`  
**Auth:** Header `X-Api-Key: YOUR_KEY` (tier gratuito: 1000 req/dia)

Endpoints utilizados:
```
GET /cards?q=name:"Charizard ex" number:125 set.id:obf
GET /cards/{id}
GET /sets
GET /sets/{id}
```

Response relevante de uma carta:
```json
{
  "id": "obf-125",
  "name": "Charizard ex",
  "supertype": "Pokémon",
  "subtypes": ["Basic", "ex"],
  "hp": "330",
  "types": ["Fire"],
  "attacks": [
    {
      "name": "Burning Darkness",
      "cost": ["Fire", "Fire"],
      "damage": "180+",
      "text": "..."
    }
  ],
  "weaknesses": [{ "type": "Water", "value": "×2" }],
  "set": { "id": "obf", "name": "Obsidian Flames" },
  "number": "125",
  "images": {
    "small": "https://images.pokemontcg.io/obf/125.png",
    "large": "https://images.pokemontcg.io/obf/125_hires.png"
  }
}
```

**Estratégia de cache:** Salvar cartas consultadas no SQLite local. Verificar banco antes de chamar API.

### 6.2 Limitless TCG (Importação de Listas)

**URL de lista pública:** `https://limitlesstcg.com/decks/{id}`  
Fazer scraping/parse do HTML ou usar o formato de exportação de texto quando disponível.

### 6.3 Google ML Kit (OCR)

Pacote: `google_mlkit_text_recognition`  
Processamento 100% on-device (sem envio para servidor).  
Latin script cobre nomes de cartas em inglês e português.

### 6.4 OpenAI / Gemini (Sugestões de IA)

**Caso de uso:** Sugestões de jogada baseadas no estado atual do campo.

**Prompt template:**
```
Você é um especialista em Pokémon TCG. 
Estado atual da partida:
- Meu Pokémon ativo: {name}, HP: {current}/{max}, Energias: {energies}
- Minha bancada: {bench}
- Cartas na mão: {hand_count}
- Cartas no deck: {deck_count}
- Minhas cartas prêmio: {prizes}
- Pokémon ativo do adversário: {opp_name}, HP estimado: {opp_hp}
- Turno: {turn_number}

Formato do meu deck: Standard. 
Meu deck: {deck_name} ({deck_archetype}).

Sugira a melhor jogada para este turno e explique brevemente o raciocínio.
```

**Controle de custo:** Só chamar IA quando usuário pressionar "Sugestão" explicitamente. Não chamadas automáticas.

---

## 7. Design System

### 7.1 Paleta de Cores

```dart
class AppColors {
  // Backgrounds
  static const bg        = Color(0xFF13131F);  // Fundo principal (quase preto)
  static const surface   = Color(0xFF1E1E2E);  // Cards/painéis
  static const surface2  = Color(0xFF252538);  // Cards aninhados
  
  // Borders
  static const border    = Color(0xFF2E2E45);  // Bordas sutis
  
  // Primary
  static const blue      = Color(0xFF4D8EFF);  // Azul primário (botões, ícones, destaque)
  static const blueDark  = Color(0xFF2A5FCC);  // Azul escuro (hover/press states)
  static const blueLight = Color(0xFF6BA3FF);  // Azul claro (texto highlight)
  
  // Text
  static const textPrimary   = Color(0xFFFFFFFF);  // Texto principal
  static const textSecondary = Color(0xFF9090A8);  // Texto secundário
  static const textDim       = Color(0xFF5A5A72);  // Texto muito sutil
  
  // Semantic
  static const green   = Color(0xFF3DCB8E);  // Sucesso / HP alto
  static const yellow  = Color(0xFFF5C542);  // Aviso / HP médio
  static const red     = Color(0xFFE05252);  // Perigo / HP baixo / KO
  
  // Energy types
  static const energyFire       = Color(0xFFE05252);
  static const energyWater      = Color(0xFF4D9EFF);
  static const energyGrass      = Color(0xFF4DBF7A);
  static const energyLightning  = Color(0xFFF5C542);
  static const energyPsychic    = Color(0xFFB06DDD);
  static const energyFighting   = Color(0xFFCC8844);
  static const energyDarkness   = Color(0xFF5A5A8A);
  static const energyMetal      = Color(0xFF9090B8);
  static const energyDragon     = Color(0xFF6A8FDD);
  static const energyColorless  = Color(0xFFAAAAAA);
}
```

### 7.2 Tipografia

```dart
// Usar Google Fonts: 'Space Grotesk' para títulos, 'Inter' para corpo
// Ou equivalente nativo

class AppTextStyles {
  static const h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const body = TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5);
  static const bodySmall = TextStyle(fontSize: 12, color: AppColors.textSecondary);
  static const label = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const caption = TextStyle(fontSize: 11, color: AppColors.textDim);
}
```

### 7.3 Componentes Reutilizáveis

**AppCard** — base de todos os painéis:
```dart
AppCard({
  color: AppColors.surface,
  border: AppColors.border,
  borderRadius: 14,
  padding: EdgeInsets.all(16),
  child: ...,
})
```

**HpTracker** — controle de HP:
```dart
HpTracker({
  currentHp: int,
  maxHp: int,
  onChanged: (int newHp) {},
})
// Exibe: [ - ] [ 220 ] [ + ] com barra de progresso colorida
```

**EnergyBadge** — badge de tipo de energia:
```dart
EnergyBadge(type: EnergyType.fire, count: 2)
// Exibe: 🔥 ×2 em badge colorido
```

**StatusBadge** — indicador de condição:
```dart
StatusBadge(condition: StatusCondition.burned)
// Ícone + label, cor semantica
```

**CardThumbnail** — thumbnail de carta:
```dart
CardThumbnail(card: PokemonCard, size: ThumbnailSize.small)
// Cached network image com fallback placeholder
```

**VsBadge** — logo VS do app:
```dart
VsBadge(size: 48)
// Círculo azul escuro com "VS" em azul brilhante
```

### 7.4 Navegação (Bottom Nav)

```
[📖 Decks]          [👤 Perfil]
```

Duas abas principais. O Modo Batalha é acessado a partir do Deck (não é aba própria). O histórico é acessível a partir do Perfil ou de dentro do Modo Batalha.

**GoRouter:**
```dart
/                    → HomeScreen (Meus Decks)
/deck/:id            → DeckDetailScreen
/deck/:id/battle     → BattleScreen
/scanner             → ScannerScreen
/history             → HistoryScreen
/history/:matchId    → MatchDetailScreen
/events              → EventsScreen
/profile             → ProfileScreen
/profile/settings    → SettingsScreen
```

---

## 8. Fluxos de Usuário Principais

### Fluxo 1: Adicionar Deck

```
Home → [ + Adicionar Deck ] → Modal de importação
  → Opção A: Colar texto PTCGL → Parse → Preview → Salvar
  → Opção B: Scanner → Câmera → OCR → Preview → Salvar
  → Opção C: URL Limitless → Fetch → Preview → Salvar
→ Deck aparece na lista
```

### Fluxo 2: Iniciar Partida

```
Home → Selecionar deck → Tap no botão [ ▶ ]
→ BattleScreen inicializa com estado padrão:
  - PlayerState: HP máximo da carta inicial
  - Prêmios: 6
  - Turno: 1
  - Bench: vazia
→ Usuário joga (atualiza HP, energias, status)
→ [ End Game ] → Dialog: resultado (W/L/D) + notas
→ Salva partida no histórico
→ Retorna para Home
```

### Fluxo 3: Scan de Carta

```
Battle ou Deck → [ 📷 Scanner ]
→ Câmera abre com overlay
→ Posicionar carta no frame
→ OCR detecta texto → extrai nome + número
→ Busca API → mostra preview da carta
→ [ Confirmar ] → adiciona ao deck / uso na batalha
```

---

## 9. Regras de Negócio Importantes (Pokémon TCG)

- **Deck válido:** exatamente 60 cartas, máximo 4 cópias de qualquer carta (exceto energia básica — ilimitado)
- **Mão inicial:** 7 cartas
- **Cartas prêmio:** começa com 6; cada KO do adversário = pega 1 prêmio; quem pegar todos os 6 vence
- **Bench:** máximo 5 Pokémon na bancada
- **Energia:** 1 energia por turno (regra geral), exceto cartas de treinador especiais
- **Condições de status:**
  - Queimado: 20 dano entre turnos (virar moeda para curar)
  - Envenenado: 10 dano entre turnos (ou 20 com veneno especial)
  - Paralisado: não pode atacar nem recuar, cura no início do próximo turno
  - Dormindo: virar moeda no início do turno — cara = acorda, coroa = continua dormindo
  - Confuso: virar moeda para atacar — coroa = causa 30 de dano a si mesmo
- **Vitória por condições alternativas:**
  - Adversário não tem Pokémon para colocar no ativo
  - Adversário não tem cartas no deck para comprar
  - Pegar todos os prêmios

---

## 10. Diferenciais e Funcionalidades Futuras (Roadmap)

### MVP (Sprint 1-4)
- [ ] Import de decks por texto
- [ ] Modo batalha básico (HP, energia, bench)
- [ ] Histórico de partidas
- [ ] Tema dark mode

### V1.0 (Sprint 5-6)
- [ ] Scanner de cartas (OCR)
- [ ] Integração PokémonTCG.io API
- [ ] GPS — eventos locais
- [ ] Notificações locais

### V1.1 (Futuro)
- [ ] Sugestões de jogada por IA
- [ ] Mini-jogo quiz de regras TCG
- [ ] Modo multiplayer (dois jogadores no mesmo app via Bluetooth/NFC)
- [ ] Scan do campo do adversário
- [ ] Timer de torneio (rounds de 50 min)
- [ ] Export de stats como imagem para compartilhar

---

## 11. Configuração do Projeto

### pubspec.yaml (principais dependências)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Database
  sqflite: ^2.3.2
  hive_flutter: ^1.1.0

  # Network
  dio: ^5.4.3
  cached_network_image: ^3.3.1

  # Camera & ML
  camera: ^0.10.5
  google_mlkit_text_recognition: ^0.13.0

  # Location
  geolocator: ^11.0.0
  permission_handler: ^11.3.0

  # Notifications
  flutter_local_notifications: ^17.1.2

  # Security
  flutter_secure_storage: ^9.0.0

  # Serialization
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # Utils
  uuid: ^4.3.3
  intl: ^0.19.0
  url_launcher: ^6.2.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.0
  freezed: ^2.5.2
  json_serializable: ^6.7.1
  build_runner: ^2.4.9
```

### Configurações necessárias

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**iOS (Info.plist):**
```xml
<key>NSCameraUsageDescription</key>
<string>Para escanear cartas de Pokémon TCG</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Para encontrar eventos de TCG próximos</string>
```

**Variáveis de ambiente (.env / flutter_dotenv):**
```
POKEMON_TCG_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
```

---

## 12. Convenções de Código

- **Linguagem:** Dart, sempre tipado (sem `dynamic` desnecessário)
- **Nomenclatura:** `camelCase` para variáveis/métodos, `PascalCase` para classes, `snake_case` para arquivos
- **State:** Riverpod com `@riverpod` annotation e `AsyncNotifier` para dados assíncronos
- **Models:** `@freezed` para imutabilidade e copyWith
- **Database:** DAOs para toda interação com SQLite
- **Async:** sempre `async/await`, nunca `.then()` aninhado
- **Erros:** `Either<Failure, Success>` ou `AsyncValue` do Riverpod para tratamento
- **Testes:** unit tests para UseCases e DAOs; widget tests para componentes críticos (HP tracker)
- **Comentários:** em português, explicando *por quê*, não *o quê*

---

*Documento gerado em: junho de 2025 — Pokenion v0.1 Planning*
