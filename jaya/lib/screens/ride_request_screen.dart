import 'package:flutter/material.dart';

import '../models/ride.dart';
import '../services/driver_app_controller.dart';
import 'ride_start_screen.dart';

class RideRequestScreen extends StatelessWidget {
  const RideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Request')),
      body: AnimatedBuilder(
        animation: app,
        builder: (context, _) {
          final currentRide = app.pendingRide;
          if (currentRide == null) {
            return _EmptyRideState(onBack: () => Navigator.of(context).pop());
          }

          return _RideRequestBody(ride: currentRide);
        },
      ),
    );
  }
}

class _RideRequestBody extends StatelessWidget {
  const _RideRequestBody({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1013), Color(0xFF121922), Color(0xFF0B0D10)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6C453),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.person_pin_circle_rounded,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Passenger',
                                  style: TextStyle(color: Colors.white60),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ride.passengerName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            ride.fareLabel,
                            style: const TextStyle(
                              color: Color(0xFFF6C453),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _DetailRow(
                        icon: Icons.schedule_rounded,
                        label: 'ETA',
                        value: ride.etaLabel,
                      ),
                      const SizedBox(height: 14),
                      _DetailRow(
                        icon: Icons.route_rounded,
                        label: 'Trip distance',
                        value: ride.distanceLabel,
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 20),
                      _LocationCard(
                        title: 'Pickup',
                        value: ride.pickupLabel,
                        color: const Color(0xFFFFA53B),
                      ),
                      const SizedBox(height: 12),
                      _LocationCard(
                        title: 'Dropoff',
                        value: ride.dropoffLabel,
                        color: const Color(0xFF4DD0B2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      app.acceptPendingRide();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const RideStartScreen(),
                        ),
                      );
                    },
                    child: const Text('ACCEPT'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(context);
                      app.rejectPendingRide();
                      Navigator.of(context).pop();
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ride rejected. A new request is waiting on the home screen.',
                          ),
                        ),
                      );
                    },
                    child: const Text('REJECT'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF6C453)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white60)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyRideState extends StatelessWidget {
  const _EmptyRideState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty_rounded, size: 52),
            const SizedBox(height: 16),
            const Text(
              'No ride request is active right now.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onBack, child: const Text('BACK')),
          ],
        ),
      ),
    );
  }
}
