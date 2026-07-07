import 'package:triply/features/trips/domain/trip.dart';

class TripTextFormatters {
  const TripTextFormatters._();

  static String date(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  static String dateRange(Trip trip) {
    return '${date(trip.departureDate)} - ${date(trip.returnDate)}';
  }

  static String travelers(int count) {
    return count == 1 ? '1 viajante' : '$count viajantes';
  }
}
