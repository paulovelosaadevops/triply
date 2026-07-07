import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String tripsBoxName = 'triply_trips';
  static const String tripModulesBoxName = 'triply_trip_modules';

  Future<void> initialize() async {
    await Hive.initFlutter();
    await Future.wait(<Future<Box<dynamic>>>[
      Hive.openBox<dynamic>(tripsBoxName),
      Hive.openBox<dynamic>(tripModulesBoxName),
    ]);
  }

  Box<dynamic> get tripsBox => Hive.box<dynamic>(tripsBoxName);

  Box<dynamic> get tripModulesBox => Hive.box<dynamic>(tripModulesBoxName);
}
