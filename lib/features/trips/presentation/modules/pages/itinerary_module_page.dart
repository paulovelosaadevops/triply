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

class ItineraryModulePage extends StatefulWidget {
  const ItineraryModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<ItineraryModulePage> createState() => _ItineraryModulePageState();
}

class _ItineraryModulePageState extends State<ItineraryModulePage> {
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

  void _handleChanged() {
    setState(() {});
  }

  Future<void> _openForm({ItineraryActivity? item}) async {
    final title = TextEditingController(text: item?.title);
    final description = TextEditingController(text: item?.description);
    final location = TextEditingController(text: item?.location);
    DateTime date = item?.date ?? widget.trip.departureDate;
    TimeOfDay time = item?.time ?? TimeOfDay.now();
    String? titleError;
    String? locationError;

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
              if (picked != null) {
                setSheetState(() => date = picked);
              }
            }

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (picked != null) {
                setSheetState(() => time = picked);
              }
            }

            void save() {
              setSheetState(() {
                titleError = title.text.trim().isEmpty
                    ? 'Informe o titulo.'
                    : null;
                locationError = location.text.trim().isEmpty
                    ? 'Informe a localizacao.'
                    : null;
              });
              if (titleError != null || locationError != null) {
                return;
              }

              _controller.saveItinerary(
                widget.trip.id,
                ItineraryActivity(
                  id: item?.id ?? _controller.createId(),
                  title: title.text.trim(),
                  description: description.text.trim(),
                  date: date,
                  time: time,
                  location: location.text.trim(),
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
                        item == null
                            ? 'Adicionar atividade'
                            : 'Editar atividade',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: title,
                        errorText: titleError,
                        labelText: 'Titulo',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: description,
                        labelText: 'Descricao',
                        maxLines: 3,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: location,
                        errorText: locationError,
                        labelText: 'Localizacao',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      _PickerTile(
                        icon: Icons.calendar_today_rounded,
                        label: TripTextFormatters.date(date),
                        onTap: pickDate,
                      ),
                      SizedBox(height: tokens.spacing.md),
                      _PickerTile(
                        icon: Icons.schedule_rounded,
                        label: MaterialLocalizations.of(
                          context,
                        ).formatTimeOfDay(time),
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

    title.dispose();
    description.dispose();
    location.dispose();
  }

  Future<void> _delete(ItineraryActivity item) async {
    if (!await confirmDelete(context) || !mounted) {
      return;
    }
    _controller.deleteItinerary(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.itinerary(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return TripModulePageShell(
      title: 'Itinerario',
      subtitle: widget.trip.title,
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.map_rounded,
            title: 'Nenhuma atividade ainda.',
            description: 'Adicione os principais momentos da sua viagem.',
          )
        else
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.md),
              child: AppCard(
                onTap: () => _openForm(item: item),
                padding: EdgeInsets.all(tokens.spacing.lg),
                child: _ItineraryTile(
                  item: item,
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ItineraryTile extends StatelessWidget {
  const _ItineraryTile({required this.item, required this.onDelete});

  final ItineraryActivity item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.title),
      subtitle: Text(
        '${TripTextFormatters.date(item.date)} • ${MaterialLocalizations.of(context).formatTimeOfDay(item.time)}\n${item.location}',
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline_rounded),
      ),
      leading: Icon(Icons.place_rounded, color: theme.colorScheme.primary),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
}
