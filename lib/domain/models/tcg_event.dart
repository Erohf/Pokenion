import 'dart:math';

/// Kind of Pokémon TCG meetup shown on the events map.
enum EventType {
  tournament,
  trade,
  both;

  String get label => switch (this) {
        EventType.tournament => 'Torneio',
        EventType.trade => 'Troca',
        EventType.both => 'Torneio e Troca',
      };
}

/// A (mocked) nearby Pokémon TCG event pinned on the map.
class TcgEvent {
  final String id;
  final String name;
  final EventType type;
  final double lat;
  final double lng;
  final DateTime date;
  final String organizer;
  final String venue;
  final int entryFee; // in BRL; 0 = free
  final int capacity;

  const TcgEvent({
    required this.id,
    required this.name,
    required this.type,
    required this.lat,
    required this.lng,
    required this.date,
    required this.organizer,
    required this.venue,
    required this.entryFee,
    required this.capacity,
  });
}

/// Generates mock events near a given point. This stands in for a real
/// events API until one is available.
class MockEventGenerator {
  MockEventGenerator([Random? random]) : _r = random ?? Random();
  final Random _r;

  static const _names = [
    'Liga Pokémon Local',
    'Copa Kanto TCG',
    'Torneio Cidade Cerulean',
    'Encontro de Treinadores',
    'Pré-release Regional',
    'Troca da Comunidade',
    'Challenge Pokémon TCG',
    'Battle Night TCG',
  ];
  static const _venues = [
    'Card Shop Central',
    'Centro de Convenções',
    'Biblioteca Municipal',
    'Shopping Kanto',
    'Espaço Geek',
    'Clube dos Treinadores',
  ];
  static const _organizers = [
    'Pokénion Community',
    'Liga Oficial TCG',
    'Grupo Cartas & Cia',
    'Associação de Treinadores',
  ];

  /// A random event within roughly [radiusKm] of ([lat], [lng]).
  TcgEvent nearby(double lat, double lng, {double radiusKm = 2.5}) {
    // ~0.009 degrees ≈ 1 km. Pick a random offset within the radius.
    final deg = radiusKm * 0.009;
    final dLat = (_r.nextDouble() * 2 - 1) * deg;
    final dLng = (_r.nextDouble() * 2 - 1) * deg;
    final daysAhead = 1 + _r.nextInt(30);
    final hour = 9 + _r.nextInt(10);
    return TcgEvent(
      id: '${DateTime.now().microsecondsSinceEpoch}-${_r.nextInt(9999)}',
      name: _names[_r.nextInt(_names.length)],
      type: EventType.values[_r.nextInt(EventType.values.length)],
      lat: lat + dLat,
      lng: lng + dLng,
      date: DateTime.now().add(Duration(days: daysAhead)).copyWith(hour: hour, minute: 0),
      organizer: _organizers[_r.nextInt(_organizers.length)],
      venue: _venues[_r.nextInt(_venues.length)],
      entryFee: _r.nextBool() ? 0 : (10 + _r.nextInt(6) * 5),
      capacity: 16 + _r.nextInt(11) * 4,
    );
  }
}
