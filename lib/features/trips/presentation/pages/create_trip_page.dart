import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_text_field.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/core/components/secondary_button.dart';
import 'package:triply/features/trips/data/in_memory_trip_store.dart';
import 'package:triply/features/trips/presentation/controllers/create_trip_controller.dart';
import 'package:triply/features/trips/presentation/models/trip_currency.dart';
import 'package:triply/features/trips/presentation/widgets/travelers_stepper.dart';
import 'package:triply/features/trips/presentation/widgets/trip_date_field.dart';
import 'package:triply/features/trips/presentation/widgets/trip_photo_placeholder.dart';
import 'package:triply/features/trips/presentation/widgets/trip_text_formatters.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  late final CreateTripController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CreateTripController()..addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  Future<void> _pickDepartureDate() async {
    final date = await _pickDate(initialDate: _controller.departureDate);
    if (date == null) {
      return;
    }

    _controller.setDepartureDate(date);
  }

  Future<void> _pickReturnDate() async {
    final initialDate = _controller.returnDate ?? _controller.departureDate;
    final date = await _pickDate(initialDate: initialDate);
    if (date == null) {
      return;
    }

    _controller.setReturnDate(date);
  }

  Future<DateTime?> _pickDate({DateTime? initialDate}) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);
    final lastDate = DateTime(now.year + 5);

    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  void _saveTrip() {
    if (!_controller.validate()) {
      return;
    }

    InMemoryTripStore.instance.addTrip(_controller.createTrip());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(tokens.spacing.xl),
              sliver: SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          SizedBox(width: tokens.spacing.sm),
                          Expanded(
                            child: Text(
                              'Nova Viagem',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.xxl),
                      AppTextField(
                        controller: _controller.titleController,
                        errorText: _controller.titleError,
                        hintText: 'Férias em Portugal',
                        labelText: 'Nome da viagem',
                        onChanged: (_) => _controller.clearTitleError(),
                        prefixIcon: const Icon(Icons.luggage_rounded),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: _controller.cityController,
                        errorText: _controller.cityError,
                        hintText: 'Lisboa',
                        labelText: 'Destino',
                        onChanged: (_) => _controller.clearCityError(),
                        prefixIcon: const Icon(Icons.location_city_rounded),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: _controller.countryController,
                        errorText: _controller.countryError,
                        hintText: 'Portugal',
                        labelText: 'País',
                        onChanged: (_) => _controller.clearCountryError(),
                        prefixIcon: const Icon(Icons.public_rounded),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 640;
                          final fields = <Widget>[
                            TripDateField(
                              errorText: _controller.departureDateError,
                              label: 'Data de ida',
                              onTap: _pickDepartureDate,
                              value: _controller.departureDate == null
                                  ? null
                                  : TripTextFormatters.date(
                                      _controller.departureDate!,
                                    ),
                            ),
                            TripDateField(
                              errorText: _controller.returnDateError,
                              label: 'Data de volta',
                              onTap: _pickReturnDate,
                              value: _controller.returnDate == null
                                  ? null
                                  : TripTextFormatters.date(
                                      _controller.returnDate!,
                                    ),
                            ),
                          ];

                          if (!isWide) {
                            return Column(
                              children: <Widget>[
                                fields.first,
                                SizedBox(height: tokens.spacing.lg),
                                fields.last,
                              ],
                            );
                          }

                          return Row(
                            children: <Widget>[
                              Expanded(child: fields.first),
                              SizedBox(width: tokens.spacing.lg),
                              Expanded(child: fields.last),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      TravelersStepper(
                        value: _controller.travelers,
                        onDecrement: _controller.decrementTravelers,
                        onIncrement: _controller.incrementTravelers,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: _controller.currency,
                        decoration: const InputDecoration(
                          labelText: 'Moeda',
                          prefixIcon: Icon(Icons.payments_rounded),
                        ),
                        items: TripCurrency.supported.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _controller.setCurrency(value);
                          }
                        },
                      ),
                      SizedBox(height: tokens.spacing.xl),
                      const TripPhotoPlaceholder(),
                      SizedBox(height: tokens.spacing.xxl),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SecondaryButton(
                              label: 'Cancelar',
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                          ),
                          SizedBox(width: tokens.spacing.md),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Salvar viagem',
                              onPressed: _saveTrip,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
