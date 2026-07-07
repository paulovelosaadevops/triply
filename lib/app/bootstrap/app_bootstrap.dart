import 'package:flutter/widgets.dart';
import 'package:triply/core/storage/storage.dart';
import 'package:triply/features/trips/data/trip_local_repository.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await StorageService.instance.initialize();
    TripLocalRepository.instance.load();
  }
}
