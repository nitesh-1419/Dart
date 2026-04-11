import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ride {
  const Ride({
    required this.passengerName,
    required this.pickupLabel,
    required this.dropoffLabel,
    required this.pickup,
    required this.dropoff,
    required this.fare,
    required this.distanceKm,
    required this.eta,
  });

  final String passengerName;
  final String pickupLabel;
  final String dropoffLabel;
  final LatLng pickup;
  final LatLng dropoff;
  final double fare;
  final double distanceKm;
  final Duration eta;

  String get fareLabel => 'INR ${fare.toStringAsFixed(0)}';
  String get etaLabel => '${eta.inMinutes} min away';
  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';
}
