import 'package:flutter/material.dart';

import '../models/ride.dart';
import '../services/driver_app_controller.dart';
import 'ride_end_screen.dart';

class RideStartScreen extends StatelessWidget {
  const RideStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Active Ride')),
      body: AnimatedBuilder(
        animation: app,
        builder: (context, _) {
          final ride = app.activeRide;
          if (ride == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'There is no accepted ride to start right now.',
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

          return _RideStartBody(ride: ride);
        },
      ),
    );
  }
}

class _RideStartBody extends StatelessWidget {
  const _RideStartBody({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    final app = DriverAppScope.of(context);
    final isOnTrip = app.phase == RidePhase.onTrip;
    final primaryLabel = isOnTrip ? 'END RIDE' : 'START RIDE';
    final helperText = isOnTrip
        ? 'Passenger onboard. Complete the trip when you reach ${ride.dropoffLabel}.'
        : 'Drive to ${ride.pickupLabel}, confirm pickup, then start the trip.';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0C0F13), Color(0xFF141A22), Color(0xFF0B0D10)],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnTrip ? 'Trip in progress' : 'Ready for pickup',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        helperText,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ProgressSteps(isOnTrip: isOnTrip),
                      const SizedBox(height: 24),
                      _TripSummaryCard(ride: ride),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isOnTrip) {
                        app.startRide();
                        return;
                      }

                      app.finishRide();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const RideEndScreen(),
                        ),
                      );
                    },
                    child: Text(primaryLabel),
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

class _TripSummaryCard extends StatelessWidget {
  const _TripSummaryCard({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Passenger', value: ride.passengerName),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Pickup', value: ride.pickupLabel),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Dropoff', value: ride.dropoffLabel),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Fare', value: ride.fareLabel),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white60)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ProgressSteps extends StatelessWidget {
  const _ProgressSteps({required this.isOnTrip});

  final bool isOnTrip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StepNode(title: 'Accepted', active: true)),
        const Expanded(child: Divider()),
        Expanded(child: _StepNode(title: 'Pickup', active: true)),
        const Expanded(child: Divider()),
        Expanded(
          child: _StepNode(title: 'On trip', active: isOnTrip),
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({required this.title, required this.active});

  final String title;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFF6C453) : Colors.white24;
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: active ? Colors.white : Colors.white60,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
