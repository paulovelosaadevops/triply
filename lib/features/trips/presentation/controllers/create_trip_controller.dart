import 'package:flutter/material.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/models/trip_currency.dart';

class CreateTripController extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  DateTime? departureDate;
  DateTime? returnDate;
  int travelers = 1;
  String currency = TripCurrency.supported.first;

  String? titleError;
  String? cityError;
  String? countryError;
  String? departureDateError;
  String? returnDateError;

  bool validate() {
    final title = titleController.text.trim();
    titleError = title.isEmpty
        ? 'Informe o nome da viagem.'
        : title.length < 3
        ? 'O nome deve ter pelo menos 3 caracteres.'
        : null;
    cityError = cityController.text.trim().isEmpty ? 'Informe a cidade.' : null;
    countryError = countryController.text.trim().isEmpty
        ? 'Informe o país.'
        : null;
    departureDateError = departureDate == null
        ? 'Informe a data de ida.'
        : null;
    returnDateError = returnDate == null
        ? 'Informe a data de volta.'
        : departureDate != null && returnDate!.isBefore(departureDate!)
        ? 'A volta deve ser igual ou posterior à ida.'
        : null;

    notifyListeners();

    return titleError == null &&
        cityError == null &&
        countryError == null &&
        departureDateError == null &&
        returnDateError == null;
  }

  Trip createTrip() {
    return Trip(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      city: cityController.text.trim(),
      country: countryController.text.trim(),
      departureDate: departureDate!,
      returnDate: returnDate!,
      travelers: travelers,
      currency: currency,
    );
  }

  void setDepartureDate(DateTime value) {
    departureDate = value;
    departureDateError = null;
    if (returnDate != null && returnDate!.isBefore(value)) {
      returnDate = value;
    }
    returnDateError = null;
    notifyListeners();
  }

  void setReturnDate(DateTime value) {
    returnDate = value;
    returnDateError = null;
    notifyListeners();
  }

  void incrementTravelers() {
    travelers += 1;
    notifyListeners();
  }

  void decrementTravelers() {
    if (travelers == 1) {
      return;
    }

    travelers -= 1;
    notifyListeners();
  }

  void setCurrency(String value) {
    currency = value;
    notifyListeners();
  }

  void clearTitleError() {
    if (titleError == null) {
      return;
    }

    titleError = null;
    notifyListeners();
  }

  void clearCityError() {
    if (cityError == null) {
      return;
    }

    cityError = null;
    notifyListeners();
  }

  void clearCountryError() {
    if (countryError == null) {
      return;
    }

    countryError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
