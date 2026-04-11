import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride.dart';

class MockRideService {
  final List<Ride> _rides = const [
    Ride(
      passengerName: 'Rahul Sharma',
      pickupLabel: 'Bandra Station',
      dropoffLabel: 'Andheri West',
      pickup: LatLng(19.0544, 72.8406),
      dropoff: LatLng(19.1363, 72.8278),
      fare: 170,
      distanceKm: 7.8,
      eta: Duration(minutes: 4),
    ),
    Ride(
      passengerName: 'Sneha Patel',
      pickupLabel: 'Juhu Circle',
      dropoffLabel: 'Powai Lake',
      pickup: LatLng(19.1075, 72.8263),
      dropoff: LatLng(19.1176, 72.9060),
      fare: 240,
      distanceKm: 10.4,
      eta: Duration(minutes: 6),
    ),
    Ride(
      passengerName: 'Aman Verma',
      pickupLabel: 'Lower Parel',
      dropoffLabel: 'BKC',
      pickup: LatLng(18.9985, 72.8300),
      dropoff: LatLng(19.0679, 72.8693),
      fare: 210,
      distanceKm: 8.6,
      eta: Duration(minutes: 5),
    ),
  ];

  int _rideIndex = 0;

  Ride nextRide() {
    final ride = _rides[_rideIndex % _rides.length];
    _rideIndex += 1;
    return ride;
  }
}
