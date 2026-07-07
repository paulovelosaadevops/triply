import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_card.dart';
import 'package:triply/core/components/app_text_field.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/features/trips/domain/trip.dart';
import 'package:triply/features/trips/presentation/controllers/trip_modules_controller.dart';
import 'package:triply/features/trips/presentation/models/trip_module_models.dart';
import 'package:triply/features/trips/presentation/modules/widgets/module_actions.dart';
import 'package:triply/features/trips/presentation/modules/widgets/trip_module_empty_state.dart';
import 'package:triply/features/trips/presentation/modules/widgets/trip_module_page_shell.dart';
import 'package:triply/features/trips/presentation/widgets/trip_text_formatters.dart';

class FlightsModulePage extends StatefulWidget {
  const FlightsModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<FlightsModulePage> createState() => _FlightsModulePageState();
}

class _FlightsModulePageState extends State<FlightsModulePage> {
  final TripModulesController _controller = TripModulesController.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() => setState(() {});

  Future<void> _openForm({FlightInfo? item}) async {
    final airline = TextEditingController(text: item?.airline);
    final number = TextEditingController(text: item?.flightNumber);
    final origin = TextEditingController(text: item?.originAirport);
    final destination = TextEditingController(text: item?.destinationAirport);
    DateTime date = item?.date ?? widget.trip.departureDate;
    TimeOfDay time = item?.time ?? TimeOfDay.now();
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final tokens =
            Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(widget.trip.departureDate.year - 1),
                lastDate: DateTime(widget.trip.returnDate.year + 1),
              );
              if (picked != null) setSheetState(() => date = picked);
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (picked != null) setSheetState(() => time = picked);
            }

            void save() {
              final values = <String>[
                airline.text,
                number.text,
                origin.text,
                destination.text,
              ];
              setSheetState(() {
                error = values.any((value) => value.trim().isEmpty)
                    ? 'Preencha todos os campos.'
                    : null;
              });
              if (error != null) return;

              _controller.saveFlight(
                widget.trip.id,
                FlightInfo(
                  id: item?.id ?? _controller.createId(),
                  airline: airline.text.trim(),
                  flightNumber: number.text.trim(),
                  originAirport: origin.text.trim(),
                  destinationAirport: destination.text.trim(),
                  date: date,
                  time: time,
                ),
              );
              Navigator.of(context).pop();
              showSavedSnackBar(this.context);
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(tokens.spacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        item == null ? 'Adicionar voo' : 'Editar voo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (error != null) ...<Widget>[
                        SizedBox(height: tokens.spacing.md),
                        Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: airline,
                        labelText: 'Companhia aerea',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: number,
                        labelText: 'Numero do voo',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: origin,
                        labelText: 'Aeroporto origem',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: destination,
                        labelText: 'Aeroporto destino',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_rounded),
                        title: Text(TripTextFormatters.date(date)),
                        onTap: pickDate,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule_rounded),
                        title: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatTimeOfDay(time),
                        ),
                        onTap: pickTime,
                      ),
                      SizedBox(height: tokens.spacing.xl),
                      PrimaryButton(label: 'Salvar', onPressed: save),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    airline.dispose();
    number.dispose();
    origin.dispose();
    destination.dispose();
  }

  Future<void> _delete(FlightInfo item) async {
    if (!await confirmDelete(context) || !mounted) return;
    _controller.deleteFlight(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.flights(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return TripModulePageShell(
      title: 'Voos',
      subtitle: widget.trip.title,
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.flight_rounded,
            title: 'Nenhum voo cadastrado.',
            description: 'Adicione passagens e horarios importantes.',
          )
        else
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.md),
              child: AppCard(
                onTap: () => _openForm(item: item),
                padding: EdgeInsets.all(tokens.spacing.lg),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.flight_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text('${item.airline} ${item.flightNumber}'),
                  subtitle: Text(
                    '${item.originAirport} -> ${item.destinationAirport}\n${TripTextFormatters.date(item.date)} • ${MaterialLocalizations.of(context).formatTimeOfDay(item.time)}',
                  ),
                  trailing: IconButton(
                    onPressed: () => _delete(item),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
