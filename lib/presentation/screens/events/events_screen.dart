import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/tcg_event.dart';

/// Nearby Pokémon TCG events on a real map centered on the user's location.
/// Events are mocked (see [MockEventGenerator]) until a real data source exists.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Fallback center used when location is unavailable (São Paulo).
  static const _fallback = LatLng(-23.5505, -46.6333);

  final _mapController = MapController();
  final _generator = MockEventGenerator();
  final List<TcgEvent> _events = [];

  LatLng? _userLocation;
  bool _locating = true;
  bool _locationDenied = false;
  bool _showSearchHere = false;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  Future<void> _locate() async {
    LatLng center = _fallback;
    bool denied = false;
    try {
      final serviceOn = await Geolocator.isLocationServiceEnabled();
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      final allowed = perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse;
      if (serviceOn && allowed) {
        final pos = await Geolocator.getCurrentPosition();
        center = LatLng(pos.latitude, pos.longitude);
      } else {
        denied = true;
      }
    } catch (_) {
      denied = true;
    }

    if (!mounted) return;
    setState(() {
      _userLocation = denied ? null : center;
      _locationDenied = denied;
      _locating = false;
      // Seed the first mock event near the initial center.
      _events.add(_generator.nearby(center.latitude, center.longitude));
    });
    _mapController.move(center, 14);
  }

  void _searchHere() {
    final center = _mapController.camera.center;
    setState(() {
      _events.add(_generator.nearby(center.latitude, center.longitude, radiusKm: 1.5));
      _showSearchHere = false;
    });
  }

  double? _distanceKm(TcgEvent e) {
    final u = _userLocation;
    if (u == null) return null;
    return Geolocator.distanceBetween(u.latitude, u.longitude, e.lat, e.lng) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: context.palette.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Eventos próximos', style: AppTextStyles.h3),
      ),
      body: _locating
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userLocation ?? _fallback,
                    initialZoom: 14,
                    onPositionChanged: (camera, hasGesture) {
                      if (hasGesture && !_showSearchHere) {
                        setState(() => _showSearchHere = true);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.pokenion.app',
                    ),
                    MarkerLayer(
                      markers: [
                        if (_userLocation != null)
                          Marker(
                            point: _userLocation!,
                            width: 24,
                            height: 24,
                            child: const _UserDot(),
                          ),
                        for (final e in _events)
                          Marker(
                            point: LatLng(e.lat, e.lng),
                            width: 44,
                            height: 44,
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () => _showEvent(e),
                              child: const Icon(Icons.location_on,
                                  color: AppColors.blue, size: 40),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (_locationDenied)
                  const Positioned(
                    top: 12,
                    left: 16,
                    right: 16,
                    child: _Banner(
                      text: 'Localização indisponível. Mostrando uma região padrão.',
                    ),
                  ),
                if (_showSearchHere)
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _SearchHereButton(onTap: _searchHere),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showEvent(TcgEvent e) {
    final distance = _distanceKm(e);
    showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: context.palette.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              // Photo placeholder (Street View not enabled).
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.palette.surface2,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.map_outlined, color: AppColors.textDim, size: 48),
                ),
              ),
              const SizedBox(height: 16),
              Text(e.name, style: AppTextStyles.h3),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e.type.label,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.blue, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              _InfoLine(icon: Icons.event, text: DateFormat("d 'de' MMM • HH:mm", 'pt_BR').format(e.date)),
              _InfoLine(icon: Icons.place_outlined, text: e.venue),
              if (distance != null)
                _InfoLine(
                    icon: Icons.near_me_outlined,
                    text: '${distance.toStringAsFixed(distance < 10 ? 1 : 0)} km de você'),
              _InfoLine(icon: Icons.groups_outlined, text: 'Organizado por ${e.organizer}'),
              _InfoLine(
                  icon: Icons.confirmation_number_outlined,
                  text: e.entryFee == 0 ? 'Entrada gratuita' : 'Inscrição: R\$ ${e.entryFee}'),
              _InfoLine(icon: Icons.people_outline, text: 'Até ${e.capacity} participantes'),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.body.copyWith(color: context.palette.textPrimary))),
        ],
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: AppColors.blue.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  const _Banner({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: AppColors.yellow, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}

class _SearchHereButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchHereButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blue,
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text('Procurar eventos nesta região',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
