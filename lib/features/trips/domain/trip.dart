class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.city,
    required this.country,
    required this.departureDate,
    required this.returnDate,
    required this.travelers,
    required this.currency,
  });

  final String id;
  final String title;
  final String city;
  final String country;
  final DateTime departureDate;
  final DateTime returnDate;
  final int travelers;
  final String currency;

  String get destination => '$city, $country';
}
