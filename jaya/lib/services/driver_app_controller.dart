import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride.dart';
import 'mock_ride_service.dart';

enum RidePhase { idle, requestPending, headingToPickup, onTrip, completed }

class DriverAppController extends ChangeNotifier {
  DriverAppController({MockRideService? rideService})
    : _rideService = rideService ?? MockRideService();

  static const LatLng fallbackCenter = LatLng(19.0760, 72.8777);

  final MockRideService _rideService;

  String driverName = 'Driver';
  String driverEmail = '';
  bool isOnline = false;
  bool isBusy = false;
  bool hasLiveLocation = false;
  LatLng currentMapPosition = fallbackCenter;
  String locationStatus = 'Using demo city center until location is ready.';
  Ride? pendingRide;
  Ride? activeRide;
  Ride? lastCompletedRide;
  RidePhase phase = RidePhase.idle;
  double totalEarnings = 0;
  int completedTrips = 0;

  String get availabilityLabel {
    if (isBusy) {
      return 'Connecting...';
    }
    return isOnline ? 'GO OFFLINE' : 'GO ONLINE';
  }

  String get dashboardTitle {
    switch (phase) {
      case RidePhase.requestPending:
        return 'New ride request waiting';
      case RidePhase.headingToPickup:
        return 'Head to pickup';
      case RidePhase.onTrip:
        return 'Trip in progress';
      case RidePhase.completed:
        return 'Trip completed';
      case RidePhase.idle:
        return 'You are offline';
    }
  }

  String get statusSummary {
    if (activeRide != null && phase == RidePhase.onTrip) {
      return 'Passenger onboard. Follow the route to ${activeRide!.dropoffLabel}.';
    }
    if (activeRide != null) {
      return 'Pickup ${activeRide!.passengerName} at ${activeRide!.pickupLabel}.';
    }
    if (pendingRide != null) {
      return 'Open the request card to accept ${pendingRide!.passengerName}.';
    }
    return isOnline
        ? 'Waiting for the next rider near your current area.'
        : 'Go online when you are ready to start accepting trips.';
  }

  LatLng get mapFocus {
    if (phase == RidePhase.onTrip && activeRide != null) {
      return activeRide!.dropoff;
    }
    if (activeRide != null) {
      return activeRide!.pickup;
    }
    if (pendingRide != null) {
      return pendingRide!.pickup;
    }
    return currentMapPosition;
  }

  Future<void> initializeLocation() async {
    if (isBusy) {
      return;
    }
    await _refreshLocation(requestPermission: false);
  }

  Future<void> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    driverEmail = email;
    driverName = _displayNameFromEmail(email);
    notifyListeners();
  }

  Future<String?> goOnline() async {
    if (isOnline) {
      goOffline();
      return null;
    }

    isBusy = true;
    notifyListeners();

    final locationMessage = await _refreshLocation(requestPermission: true);

    pendingRide = _rideService.nextRide();
    activeRide = null;
    phase = RidePhase.requestPending;
    isOnline = true;
    isBusy = false;
    notifyListeners();

    return locationMessage;
  }

  void goOffline() {
    isOnline = false;
    isBusy = false;
    pendingRide = null;
    activeRide = null;
    phase = RidePhase.idle;
    notifyListeners();
  }

  void rejectPendingRide() {
    if (pendingRide == null) {
      return;
    }
    pendingRide = _rideService.nextRide();
    phase = RidePhase.requestPending;
    notifyListeners();
  }

  void acceptPendingRide() {
    if (pendingRide == null) {
      return;
    }
    activeRide = pendingRide;
    pendingRide = null;
    phase = RidePhase.headingToPickup;
    notifyListeners();
  }

  void startRide() {
    if (activeRide == null) {
      return;
    }
    phase = RidePhase.onTrip;
    notifyListeners();
  }

  Ride? finishRide() {
    final ride = activeRide;
    if (ride == null) {
      return null;
    }

    completedTrips += 1;
    totalEarnings += ride.fare;
    lastCompletedRide = ride;
    activeRide = null;
    isOnline = false;
    phase = RidePhase.completed;
    notifyListeners();
    return ride;
  }

  Future<String?> _refreshLocation({required bool requestPermission}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        hasLiveLocation = false;
        currentMapPosition = fallbackCenter;
        locationStatus =
            'Location services are off, so the app is using demo city center.';
        notifyListeners();
        return locationStatus;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        hasLiveLocation = false;
        currentMapPosition = fallbackCenter;
        locationStatus = permission == LocationPermission.deniedForever
            ? 'Location permission is permanently denied, so demo city center is active.'
            : 'Location permission was denied, so demo city center is active.';
        notifyListeners();
        return locationStatus;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      hasLiveLocation = true;
      currentMapPosition = LatLng(position.latitude, position.longitude);
      locationStatus = 'Live location connected.';
      notifyListeners();
      return null;
    } catch (_) {
      hasLiveLocation = false;
      currentMapPosition = fallbackCenter;
      locationStatus =
          'Live location is unavailable on this device. Demo city center is active.';
      notifyListeners();
      return locationStatus;
    }
  }

  String _displayNameFromEmail(String email) {
    final localPart = email.split('@').first.trim();
    if (localPart.isEmpty) {
      return 'Driver';
    }

    final normalized = localPart.replaceAll(RegExp(r'[._-]+'), ' ');
    return normalized
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class DriverAppScope extends InheritedNotifier<DriverAppController> {
  const DriverAppScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static DriverAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DriverAppScope>();
    assert(scope != null, 'DriverAppScope is missing above this widget tree.');
    return scope!.notifier!;
  }
}
