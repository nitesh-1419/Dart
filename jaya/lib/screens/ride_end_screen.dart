import 'package:flutter/material.dart';

import '../models/ride.dart';
import '../services/driver_app_controller.dart';

class RideEndScreen extends StatelessWidget {
  const RideEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ride Completed'),
      ),
      body: AnimatedBuilder(
        animation: app,
        builder: (context, _) {
          final ride = app.lastCompletedRide;
          if (ride == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No completed ride is available yet.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('BACK'),
                    ),
                  ],
                ),
              ),
            );
          }

          return _RideEndBody(ride: ride);
        },
      ),
    );
  }
}

class _RideEndBody extends StatelessWidget {
  const _RideEndBody({required this.ride});

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
          colors: [Color(0xFF0C0E12), Color(0xFF121822), Color(0xFF0B0D10)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
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
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DD0B2).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF4DD0B2),
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Trip finished successfully',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You earned ${ride.fareLabel} from ${ride.passengerName}.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _EarningsTile(title: 'Ride fare', value: ride.fareLabel),
                      const SizedBox(height: 12),
                      _EarningsTile(
                        title: 'Total today',
                        value: 'INR ${app.totalEarnings.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: 12),
                      _EarningsTile(
                        title: 'Completed trips',
                        value: '${app.completedTrips}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('BACK TO HOME'),
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

class _EarningsTile extends StatelessWidget {
  const _EarningsTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
