import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaya/services/driver_app_controller.dart';

void main() {
  group('DriverAppController', () {
    late DriverAppController controller;

    setUp(() {
      controller = DriverAppController();
    });

    test('initial state', () {
      expect(controller.driverName, 'Driver');
      expect(controller.isOnline, false);
      expect(controller.phase, RidePhase.idle);
    });
  });
}
