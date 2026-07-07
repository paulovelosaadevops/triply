import 'package:flutter/material.dart';
import 'package:triply/features/trips/presentation/models/trip_module_models.dart';

class TripModulesController extends ChangeNotifier {
  TripModulesController._();

  static final TripModulesController instance = TripModulesController._();

  final Map<String, List<ItineraryActivity>> _itinerary = {};
  final Map<String, List<FlightInfo>> _flights = {};
  final Map<String, List<LodgingInfo>> _lodgings = {};
  final Map<String, List<TravelDocument>> _documents = {};
  final Map<String, List<TravelExpense>> _expenses = {};
  final Map<String, List<ChecklistItem>> _checklist = {};

  List<ItineraryActivity> itinerary(String tripId) {
    final items = List<ItineraryActivity>.from(_itinerary[tripId] ?? []);
    items.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return _minutes(a.time).compareTo(_minutes(b.time));
    });
    return List<ItineraryActivity>.unmodifiable(items);
  }

  List<FlightInfo> flights(String tripId) {
    return List<FlightInfo>.unmodifiable(_flights[tripId] ?? []);
  }

  List<LodgingInfo> lodgings(String tripId) {
    return List<LodgingInfo>.unmodifiable(_lodgings[tripId] ?? []);
  }

  List<TravelDocument> documents(String tripId) {
    return List<TravelDocument>.unmodifiable(_documents[tripId] ?? []);
  }

  List<TravelExpense> expenses(String tripId) {
    return List<TravelExpense>.unmodifiable(_expenses[tripId] ?? []);
  }

  List<ChecklistItem> checklist(String tripId) {
    return List<ChecklistItem>.unmodifiable(_checklist[tripId] ?? []);
  }

  double expensesTotal(String tripId) {
    return expenses(
      tripId,
    ).fold<double>(0, (total, expense) => total + expense.amount);
  }

  void saveItinerary(String tripId, ItineraryActivity item) {
    _save(_itinerary, tripId, item.id, item, (value) => value.id);
  }

  void deleteItinerary(String tripId, String id) {
    _delete(_itinerary, tripId, id, (value) => value.id);
  }

  void saveFlight(String tripId, FlightInfo item) {
    _save(_flights, tripId, item.id, item, (value) => value.id);
  }

  void deleteFlight(String tripId, String id) {
    _delete(_flights, tripId, id, (value) => value.id);
  }

  void saveLodging(String tripId, LodgingInfo item) {
    _save(_lodgings, tripId, item.id, item, (value) => value.id);
  }

  void deleteLodging(String tripId, String id) {
    _delete(_lodgings, tripId, id, (value) => value.id);
  }

  void saveDocument(String tripId, TravelDocument item) {
    _save(_documents, tripId, item.id, item, (value) => value.id);
  }

  void deleteDocument(String tripId, String id) {
    _delete(_documents, tripId, id, (value) => value.id);
  }

  void saveExpense(String tripId, TravelExpense item) {
    _save(_expenses, tripId, item.id, item, (value) => value.id);
  }

  void deleteExpense(String tripId, String id) {
    _delete(_expenses, tripId, id, (value) => value.id);
  }

  void saveChecklistItem(String tripId, ChecklistItem item) {
    _save(_checklist, tripId, item.id, item, (value) => value.id);
  }

  void toggleChecklistItem(String tripId, ChecklistItem item) {
    saveChecklistItem(tripId, item.copyWith(isDone: !item.isDone));
  }

  void deleteChecklistItem(String tripId, String id) {
    _delete(_checklist, tripId, id, (value) => value.id);
  }

  String createId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  void _save<T>(
    Map<String, List<T>> bucket,
    String tripId,
    String id,
    T item,
    String Function(T item) idOf,
  ) {
    final items = bucket.putIfAbsent(tripId, () => <T>[]);
    final index = items.indexWhere((value) => idOf(value) == id);
    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }
    notifyListeners();
  }

  void _delete<T>(
    Map<String, List<T>> bucket,
    String tripId,
    String id,
    String Function(T item) idOf,
  ) {
    bucket[tripId]?.removeWhere((value) => idOf(value) == id);
    notifyListeners();
  }

  static int _minutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
