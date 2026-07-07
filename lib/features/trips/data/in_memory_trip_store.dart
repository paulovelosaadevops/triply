import 'package:flutter/foundation.dart';
import 'package:triply/features/trips/domain/trip.dart';

class InMemoryTripStore extends ChangeNotifier {
  InMemoryTripStore._();

  static final InMemoryTripStore instance = InMemoryTripStore._();

  final List<Trip> _trips = <Trip>[];

  List<Trip> get trips => List<Trip>.unmodifiable(_trips);

  Trip? get nextTrip => _trips.isEmpty ? null : _trips.first;

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }
}
