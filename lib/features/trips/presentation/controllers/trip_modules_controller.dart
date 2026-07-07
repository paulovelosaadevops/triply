import 'package:flutter/material.dart';
import 'package:triply/features/trips/data/trip_local_repository.dart';
import 'package:triply/features/trips/presentation/models/trip_module_models.dart';

class TripModulesController extends ChangeNotifier {
  TripModulesController._() {
    _repository.addListener(notifyListeners);
  }

  static final TripModulesController instance = TripModulesController._();

  final TripLocalRepository _repository = TripLocalRepository.instance;

  List<ItineraryActivity> itinerary(String tripId) {
    return _repository.itinerary(tripId);
  }

  List<FlightInfo> flights(String tripId) {
    return _repository.flights(tripId);
  }

  List<LodgingInfo> lodgings(String tripId) {
    return _repository.lodgings(tripId);
  }

  List<TravelDocument> documents(String tripId) {
    return _repository.documents(tripId);
  }

  List<TravelExpense> expenses(String tripId) {
    return _repository.expenses(tripId);
  }

  List<ChecklistItem> checklist(String tripId) {
    return _repository.checklist(tripId);
  }

  double expensesTotal(String tripId) {
    return _repository.expensesTotal(tripId);
  }

  Future<void> saveItinerary(String tripId, ItineraryActivity item) {
    return _repository.saveItinerary(tripId, item);
  }

  Future<void> deleteItinerary(String tripId, String id) {
    return _repository.deleteItinerary(tripId, id);
  }

  Future<void> saveFlight(String tripId, FlightInfo item) {
    return _repository.saveFlight(tripId, item);
  }

  Future<void> deleteFlight(String tripId, String id) {
    return _repository.deleteFlight(tripId, id);
  }

  Future<void> saveLodging(String tripId, LodgingInfo item) {
    return _repository.saveLodging(tripId, item);
  }

  Future<void> deleteLodging(String tripId, String id) {
    return _repository.deleteLodging(tripId, id);
  }

  Future<void> saveDocument(String tripId, TravelDocument item) {
    return _repository.saveDocument(tripId, item);
  }

  Future<void> deleteDocument(String tripId, String id) {
    return _repository.deleteDocument(tripId, id);
  }

  Future<void> saveExpense(String tripId, TravelExpense item) {
    return _repository.saveExpense(tripId, item);
  }

  Future<void> deleteExpense(String tripId, String id) {
    return _repository.deleteExpense(tripId, id);
  }

  Future<void> saveChecklistItem(String tripId, ChecklistItem item) {
    return _repository.saveChecklistItem(tripId, item);
  }

  Future<void> toggleChecklistItem(String tripId, ChecklistItem item) {
    return _repository.toggleChecklistItem(tripId, item);
  }

  Future<void> deleteChecklistItem(String tripId, String id) {
    return _repository.deleteChecklistItem(tripId, id);
  }

  String createId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
