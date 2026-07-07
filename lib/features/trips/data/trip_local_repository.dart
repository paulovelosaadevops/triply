import 'package:flutter/material.dart';
import 'package:triply/core/storage/storage.dart';
import 'package:triply/features/trips/data/trip_repository.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/models/trip_module_models.dart';

class TripLocalRepository extends TripRepository {
  TripLocalRepository._();

  static final TripLocalRepository instance = TripLocalRepository._();

  static const String _tripsKey = 'trips';
  static const String _itineraryKey = 'itinerary';
  static const String _flightsKey = 'flights';
  static const String _lodgingsKey = 'lodgings';
  static const String _documentsKey = 'documents';
  static const String _expensesKey = 'expenses';
  static const String _checklistKey = 'checklist';

  final List<Trip> _trips = <Trip>[];
  final Map<String, List<ItineraryActivity>> _itinerary = {};
  final Map<String, List<FlightInfo>> _flights = {};
  final Map<String, List<LodgingInfo>> _lodgings = {};
  final Map<String, List<TravelDocument>> _documents = {};
  final Map<String, List<TravelExpense>> _expenses = {};
  final Map<String, List<ChecklistItem>> _checklist = {};

  @override
  List<Trip> get trips => List<Trip>.unmodifiable(_trips);

  @override
  Trip? get nextTrip => _trips.isEmpty ? null : _trips.first;

  @override
  void load() {
    _trips
      ..clear()
      ..addAll(_readList(_tripsKey, _tripFromMap));
    _replaceBucket(_itinerary, _readBucket(_itineraryKey, _itineraryFromMap));
    _replaceBucket(_flights, _readBucket(_flightsKey, _flightFromMap));
    _replaceBucket(_lodgings, _readBucket(_lodgingsKey, _lodgingFromMap));
    _replaceBucket(_documents, _readBucket(_documentsKey, _documentFromMap));
    _replaceBucket(_expenses, _readBucket(_expensesKey, _expenseFromMap));
    _replaceBucket(_checklist, _readBucket(_checklistKey, _checklistFromMap));
  }

  @override
  Future<void> addTrip(Trip trip) async {
    _trips.add(trip);
    await _writeList(_tripsKey, _trips.map(_tripToMap).toList());
    notifyListeners();
  }

  @override
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

  @override
  List<FlightInfo> flights(String tripId) {
    return List<FlightInfo>.unmodifiable(_flights[tripId] ?? []);
  }

  @override
  List<LodgingInfo> lodgings(String tripId) {
    return List<LodgingInfo>.unmodifiable(_lodgings[tripId] ?? []);
  }

  @override
  List<TravelDocument> documents(String tripId) {
    return List<TravelDocument>.unmodifiable(_documents[tripId] ?? []);
  }

  @override
  List<TravelExpense> expenses(String tripId) {
    return List<TravelExpense>.unmodifiable(_expenses[tripId] ?? []);
  }

  @override
  List<ChecklistItem> checklist(String tripId) {
    return List<ChecklistItem>.unmodifiable(_checklist[tripId] ?? []);
  }

  @override
  double expensesTotal(String tripId) {
    return expenses(
      tripId,
    ).fold<double>(0, (total, expense) => total + expense.amount);
  }

  @override
  Future<void> saveItinerary(String tripId, ItineraryActivity item) {
    return _saveModule(
      bucket: _itinerary,
      storageKey: _itineraryKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _itineraryToMap,
    );
  }

  @override
  Future<void> deleteItinerary(String tripId, String id) {
    return _deleteModule(
      bucket: _itinerary,
      storageKey: _itineraryKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _itineraryToMap,
    );
  }

  @override
  Future<void> saveFlight(String tripId, FlightInfo item) {
    return _saveModule(
      bucket: _flights,
      storageKey: _flightsKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _flightToMap,
    );
  }

  @override
  Future<void> deleteFlight(String tripId, String id) {
    return _deleteModule(
      bucket: _flights,
      storageKey: _flightsKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _flightToMap,
    );
  }

  @override
  Future<void> saveLodging(String tripId, LodgingInfo item) {
    return _saveModule(
      bucket: _lodgings,
      storageKey: _lodgingsKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _lodgingToMap,
    );
  }

  @override
  Future<void> deleteLodging(String tripId, String id) {
    return _deleteModule(
      bucket: _lodgings,
      storageKey: _lodgingsKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _lodgingToMap,
    );
  }

  @override
  Future<void> saveDocument(String tripId, TravelDocument item) {
    return _saveModule(
      bucket: _documents,
      storageKey: _documentsKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _documentToMap,
    );
  }

  @override
  Future<void> deleteDocument(String tripId, String id) {
    return _deleteModule(
      bucket: _documents,
      storageKey: _documentsKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _documentToMap,
    );
  }

  @override
  Future<void> saveExpense(String tripId, TravelExpense item) {
    return _saveModule(
      bucket: _expenses,
      storageKey: _expensesKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _expenseToMap,
    );
  }

  @override
  Future<void> deleteExpense(String tripId, String id) {
    return _deleteModule(
      bucket: _expenses,
      storageKey: _expensesKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _expenseToMap,
    );
  }

  @override
  Future<void> saveChecklistItem(String tripId, ChecklistItem item) {
    return _saveModule(
      bucket: _checklist,
      storageKey: _checklistKey,
      tripId: tripId,
      item: item,
      idOf: (value) => value.id,
      toMap: _checklistToMap,
    );
  }

  @override
  Future<void> toggleChecklistItem(String tripId, ChecklistItem item) {
    return saveChecklistItem(tripId, item.copyWith(isDone: !item.isDone));
  }

  @override
  Future<void> deleteChecklistItem(String tripId, String id) {
    return _deleteModule(
      bucket: _checklist,
      storageKey: _checklistKey,
      tripId: tripId,
      id: id,
      idOf: (value) => value.id,
      toMap: _checklistToMap,
    );
  }

  Future<void> _saveModule<T>({
    required Map<String, List<T>> bucket,
    required String storageKey,
    required String tripId,
    required T item,
    required String Function(T item) idOf,
    required Map<String, Object?> Function(T item) toMap,
  }) async {
    final items = bucket.putIfAbsent(tripId, () => <T>[]);
    final index = items.indexWhere((value) => idOf(value) == idOf(item));
    if (index == -1) {
      items.add(item);
    } else {
      items[index] = item;
    }
    await _writeBucket(storageKey, bucket, toMap);
    notifyListeners();
  }

  Future<void> _deleteModule<T>({
    required Map<String, List<T>> bucket,
    required String storageKey,
    required String tripId,
    required String id,
    required String Function(T item) idOf,
    required Map<String, Object?> Function(T item) toMap,
  }) async {
    bucket[tripId]?.removeWhere((value) => idOf(value) == id);
    await _writeBucket(storageKey, bucket, toMap);
    notifyListeners();
  }

  List<T> _readList<T>(
    String key,
    T Function(Map<String, dynamic> map) fromMap,
  ) {
    final value = StorageService.instance.tripsBox.get(key);
    if (value is! List) {
      return <T>[];
    }

    return value
        .whereType<Map<dynamic, dynamic>>()
        .map((map) => fromMap(_stringMap(map)))
        .toList();
  }

  Future<void> _writeList(String key, List<Map<String, Object?>> value) async {
    await StorageService.instance.tripsBox.put(key, value);
  }

  Map<String, List<T>> _readBucket<T>(
    String key,
    T Function(Map<String, dynamic> map) fromMap,
  ) {
    final value = StorageService.instance.tripModulesBox.get(key);
    if (value is! Map) {
      return <String, List<T>>{};
    }

    return value.map((tripId, items) {
      final typedItems = items is List
          ? items
                .whereType<Map<dynamic, dynamic>>()
                .map((map) => fromMap(_stringMap(map)))
                .toList()
          : <T>[];
      return MapEntry(tripId.toString(), typedItems);
    });
  }

  Future<void> _writeBucket<T>(
    String key,
    Map<String, List<T>> bucket,
    Map<String, Object?> Function(T item) toMap,
  ) async {
    final value = bucket.map(
      (tripId, items) => MapEntry(tripId, items.map(toMap).toList()),
    );
    await StorageService.instance.tripModulesBox.put(key, value);
  }

  void _replaceBucket<T>(
    Map<String, List<T>> target,
    Map<String, List<T>> source,
  ) {
    target
      ..clear()
      ..addAll(source);
  }

  static Map<String, dynamic> _stringMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  static Map<String, Object?> _tripToMap(Trip trip) {
    return <String, Object?>{
      'id': trip.id,
      'title': trip.title,
      'city': trip.city,
      'country': trip.country,
      'departureDate': trip.departureDate.toIso8601String(),
      'returnDate': trip.returnDate.toIso8601String(),
      'travelers': trip.travelers,
      'currency': trip.currency,
    };
  }

  static Trip _tripFromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String,
      title: map['title'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      departureDate: DateTime.parse(map['departureDate'] as String),
      returnDate: DateTime.parse(map['returnDate'] as String),
      travelers: map['travelers'] as int,
      currency: map['currency'] as String,
    );
  }

  static Map<String, Object?> _itineraryToMap(ItineraryActivity item) {
    return <String, Object?>{
      'id': item.id,
      'title': item.title,
      'description': item.description,
      'date': item.date.toIso8601String(),
      'time': _timeToMap(item.time),
      'location': item.location,
    };
  }

  static ItineraryActivity _itineraryFromMap(Map<String, dynamic> map) {
    return ItineraryActivity(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      time: _timeFromMap(map['time']),
      location: map['location'] as String,
    );
  }

  static Map<String, Object?> _flightToMap(FlightInfo item) {
    return <String, Object?>{
      'id': item.id,
      'airline': item.airline,
      'flightNumber': item.flightNumber,
      'originAirport': item.originAirport,
      'destinationAirport': item.destinationAirport,
      'date': item.date.toIso8601String(),
      'time': _timeToMap(item.time),
    };
  }

  static FlightInfo _flightFromMap(Map<String, dynamic> map) {
    return FlightInfo(
      id: map['id'] as String,
      airline: map['airline'] as String,
      flightNumber: map['flightNumber'] as String,
      originAirport: map['originAirport'] as String,
      destinationAirport: map['destinationAirport'] as String,
      date: DateTime.parse(map['date'] as String),
      time: _timeFromMap(map['time']),
    );
  }

  static Map<String, Object?> _lodgingToMap(LodgingInfo item) {
    return <String, Object?>{
      'id': item.id,
      'name': item.name,
      'address': item.address,
      'checkIn': item.checkIn.toIso8601String(),
      'checkOut': item.checkOut.toIso8601String(),
    };
  }

  static LodgingInfo _lodgingFromMap(Map<String, dynamic> map) {
    return LodgingInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      checkIn: DateTime.parse(map['checkIn'] as String),
      checkOut: DateTime.parse(map['checkOut'] as String),
    );
  }

  static Map<String, Object?> _documentToMap(TravelDocument item) {
    return <String, Object?>{
      'id': item.id,
      'name': item.name,
      'type': item.type,
    };
  }

  static TravelDocument _documentFromMap(Map<String, dynamic> map) {
    return TravelDocument(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  static Map<String, Object?> _expenseToMap(TravelExpense item) {
    return <String, Object?>{
      'id': item.id,
      'description': item.description,
      'amount': item.amount,
      'category': item.category,
    };
  }

  static TravelExpense _expenseFromMap(Map<String, dynamic> map) {
    return TravelExpense(
      id: map['id'] as String,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
    );
  }

  static Map<String, Object?> _checklistToMap(ChecklistItem item) {
    return <String, Object?>{
      'id': item.id,
      'title': item.title,
      'isDone': item.isDone,
    };
  }

  static ChecklistItem _checklistFromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as String,
      title: map['title'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  static Map<String, int> _timeToMap(TimeOfDay time) {
    return <String, int>{'hour': time.hour, 'minute': time.minute};
  }

  static TimeOfDay _timeFromMap(Object? value) {
    final map = value is Map<dynamic, dynamic>
        ? _stringMap(value)
        : <String, dynamic>{};
    return TimeOfDay(
      hour: map['hour'] as int? ?? 0,
      minute: map['minute'] as int? ?? 0,
    );
  }

  static int _minutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
