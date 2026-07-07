import 'package:flutter/material.dart';

class ItineraryActivity {
  const ItineraryActivity({
    required this.date,
    required this.description,
    required this.id,
    required this.location,
    required this.time,
    required this.title,
  });

  final DateTime date;
  final String description;
  final String id;
  final String location;
  final TimeOfDay time;
  final String title;

  ItineraryActivity copyWith({
    DateTime? date,
    String? description,
    String? id,
    String? location,
    TimeOfDay? time,
    String? title,
  }) {
    return ItineraryActivity(
      date: date ?? this.date,
      description: description ?? this.description,
      id: id ?? this.id,
      location: location ?? this.location,
      time: time ?? this.time,
      title: title ?? this.title,
    );
  }
}

class FlightInfo {
  const FlightInfo({
    required this.airline,
    required this.date,
    required this.destinationAirport,
    required this.flightNumber,
    required this.id,
    required this.originAirport,
    required this.time,
  });

  final String airline;
  final DateTime date;
  final String destinationAirport;
  final String flightNumber;
  final String id;
  final String originAirport;
  final TimeOfDay time;
}

class LodgingInfo {
  const LodgingInfo({
    required this.address,
    required this.checkIn,
    required this.checkOut,
    required this.id,
    required this.name,
  });

  final String address;
  final DateTime checkIn;
  final DateTime checkOut;
  final String id;
  final String name;
}

class TravelDocument {
  const TravelDocument({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;
}

class TravelExpense {
  const TravelExpense({
    required this.amount,
    required this.category,
    required this.description,
    required this.id,
  });

  final double amount;
  final String category;
  final String description;
  final String id;
}

class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.isDone,
    required this.title,
  });

  final String id;
  final bool isDone;
  final String title;

  ChecklistItem copyWith({String? id, bool? isDone, String? title}) {
    return ChecklistItem(
      id: id ?? this.id,
      isDone: isDone ?? this.isDone,
      title: title ?? this.title,
    );
  }
}
