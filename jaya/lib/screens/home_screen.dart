import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride.dart';
import '../services/driver_app_controller.dart';
import 'ride_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  bool _didInitLocation = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitLocation) {
      return;
    }

    _didInitLocation = true;
    DriverAppScope.of(context).initializeLocation();
  }

  Future<void> _toggleAvailability() async {
    final app = DriverAppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (app.isOnline) {
      app.goOffline();
      return;
    }

    final message = await app.goOnline();
    _focusMap(app.mapFocus);

    if (!mounted) {
      return;
    }

    if (message != null) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }

    if (app.pendingRide != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const RideRequestScreen()),
      );
    }
  }

  Future<void> _reviewRequest() async {
    final app = DriverAppScope.of(context);
    if (app.pendingRide == null) {
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RideRequestScreen()));
  }

  Future<void> _recenterMap() async {
    final app = DriverAppScope.of(context);
    await app.initializeLocation();
    _focusMap(app.mapFocus);
  }

  void _focusMap(LatLng target) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 13.6));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);

    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final ride = app.activeRide ?? app.pendingRide;

        return Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton.small(
            onPressed: _recenterMap,
            child: const Icon(Icons.my_location_rounded),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: app.mapFocus,
                  zoom: 13.2,
                ),
                myLocationEnabled: app.hasLiveLocation,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: _buildMarkers(app, ride),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _focusMap(app.mapFocus);
                },
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x33000000),
                      Color(0x22000000),
                      Color(0xCC0B0D10),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _HeaderCard(
                        driverName: app.driverName,
                        title: app.dashboardTitle,
                        subtitle: app.statusSummary,
                      ),
                      const Spacer(),
                      _DashboardPanel(
                        title: app.dashboardTitle,
                        locationStatus: app.locationStatus,
                        totalEarnings: app.totalEarnings,
                        completedTrips: app.completedTrips,
                        isOnline: app.isOnline,
                        isBusy: app.isBusy,
                        pendingRide: app.pendingRide,
                        activeRide: app.activeRide,
                        onToggleAvailability: _toggleAvailability,
                        onReviewRequest: app.pendingRide == null
                            ? null
                            : _reviewRequest,
                        availabilityLabel: app.availabilityLabel,
                      ),
                    ],
                  ),
                ),
              ),
              if (ride != null)
                Positioned(
                  top: 132,
                  left: 18,
                  right: 18,
                  child: _RideBadge(ride: ride, phase: app.phase),
                ),
            ],
          ),
        );
      },
    );
  }

  Set<Marker> _buildMarkers(DriverAppController app, Ride? ride) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('driver'),
        position: app.currentMapPosition,
        infoWindow: const InfoWindow(title: 'Driver'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    if (ride != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: ride.pickup,
          infoWindow: InfoWindow(title: ride.pickupLabel, snippet: 'Pickup'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: ride.dropoff,
          infoWindow: InfoWindow(title: ride.dropoffLabel, snippet: 'Dropoff'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    return markers;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.driverName,
    required this.title,
    required this.subtitle,
  });

  final String driverName;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF6C453),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $driverName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({
    required this.title,
    required this.locationStatus,
    required this.totalEarnings,
    required this.completedTrips,
    required this.isOnline,
    required this.isBusy,
    required this.pendingRide,
    required this.activeRide,
    required this.onToggleAvailability,
    required this.availabilityLabel,
    this.onReviewRequest,
  });

  final String title;
  final String locationStatus;
  final double totalEarnings;
  final int completedTrips;
  final bool isOnline;
  final bool isBusy;
  final Ride? pendingRide;
  final Ride? activeRide;
  final VoidCallback onToggleAvailability;
  final VoidCallback? onReviewRequest;
  final String availabilityLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isOnline
        ? const Color(0xFF4DD0B2)
        : const Color(0xFFF6C453);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1318),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 28,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _PanelPill(
                label: isOnline ? 'ONLINE' : 'OFFLINE',
                color: statusColor,
              ),
              const SizedBox(width: 10),
              if (pendingRide != null)
                const _PanelPill(
                  label: 'REQUEST READY',
                  color: Color(0xFF4F8BFF),
                ),
              if (activeRide != null) ...[
                if (pendingRide != null) const SizedBox(width: 10),
                const _PanelPill(
                  label: 'ACTIVE TRIP',
                  color: Color(0xFFFF8A4F),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            locationStatus,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Today',
                  value: 'INR ${totalEarnings.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(label: 'Trips', value: '$completedTrips'),
              ),
            ],
          ),
          if (pendingRide != null || activeRide != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeRide != null
                        ? activeRide!.passengerName
                        : pendingRide!.passengerName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pickup: ${activeRide?.pickupLabel ?? pendingRide?.pickupLabel ?? ''}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dropoff: ${activeRide?.dropoffLabel ?? pendingRide?.dropoffLabel ?? ''}',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isBusy ? null : onToggleAvailability,
              child: Text(availabilityLabel),
            ),
          ),
          if (onReviewRequest != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onReviewRequest,
                child: const Text('OPEN CURRENT REQUEST'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RideBadge extends StatelessWidget {
  const _RideBadge({required this.ride, required this.phase});

  final Ride ride;
  final RidePhase phase;

  @override
  Widget build(BuildContext context) {
    String label;
    switch (phase) {
      case RidePhase.headingToPickup:
        label = 'Heading to pickup';
      case RidePhase.onTrip:
        label = 'Passenger onboard';
      case RidePhase.requestPending:
        label = 'Incoming request';
      case RidePhase.completed:
        label = 'Trip complete';
      case RidePhase.idle:
        label = 'Offline';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.route_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ride.pickupLabel} -> ${ride.dropoffLabel}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Text(
            ride.fareLabel,
            style: const TextStyle(
              color: Color(0xFFF6C453),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelPill extends StatelessWidget {
  const _PanelPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
