import 'package:flutter/foundation.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/models/trip_module_models.dart';

abstract class TripRepository extends ChangeNotifier {
  List<Trip> get trips;

  Trip? get nextTrip;

  List<ItineraryActivity> itinerary(String tripId);

  List<FlightInfo> flights(String tripId);

  List<LodgingInfo> lodgings(String tripId);

  List<TravelDocument> documents(String tripId);

  List<TravelExpense> expenses(String tripId);

  List<ChecklistItem> checklist(String tripId);

  double expensesTotal(String tripId);

  void load();

  Future<void> addTrip(Trip trip);

  Future<void> saveItinerary(String tripId, ItineraryActivity item);

  Future<void> deleteItinerary(String tripId, String id);

  Future<void> saveFlight(String tripId, FlightInfo item);

  Future<void> deleteFlight(String tripId, String id);

  Future<void> saveLodging(String tripId, LodgingInfo item);

  Future<void> deleteLodging(String tripId, String id);

  Future<void> saveDocument(String tripId, TravelDocument item);

  Future<void> deleteDocument(String tripId, String id);

  Future<void> saveExpense(String tripId, TravelExpense item);

  Future<void> deleteExpense(String tripId, String id);

  Future<void> saveChecklistItem(String tripId, ChecklistItem item);

  Future<void> toggleChecklistItem(String tripId, ChecklistItem item);

  Future<void> deleteChecklistItem(String tripId, String id);
}
