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

class LodgingModulePage extends StatefulWidget {
  const LodgingModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<LodgingModulePage> createState() => _LodgingModulePageState();
}

class _LodgingModulePageState extends State<LodgingModulePage> {
  final TripModulesController _controller = TripModulesController.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_changed);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  void _changed() => setState(() {});

  Future<void> _openForm({LodgingInfo? item}) async {
    final name = TextEditingController(text: item?.name);
    final address = TextEditingController(text: item?.address);
    DateTime checkIn = item?.checkIn ?? widget.trip.departureDate;
    DateTime checkOut = item?.checkOut ?? widget.trip.returnDate;
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
            Future<void> pick({required bool isCheckIn}) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: isCheckIn ? checkIn : checkOut,
                firstDate: DateTime(widget.trip.departureDate.year - 1),
                lastDate: DateTime(widget.trip.returnDate.year + 1),
              );
              if (picked == null) return;
              setSheetState(() {
                if (isCheckIn) {
                  checkIn = picked;
                  if (checkOut.isBefore(checkIn)) checkOut = checkIn;
                } else {
                  checkOut = picked;
                }
              });
            }

            void save() {
              setSheetState(() {
                error = name.text.trim().isEmpty || address.text.trim().isEmpty
                    ? 'Preencha todos os campos.'
                    : checkOut.isBefore(checkIn)
                    ? 'Check-out deve ser posterior ao check-in.'
                    : null;
              });
              if (error != null) return;
              _controller.saveLodging(
                widget.trip.id,
                LodgingInfo(
                  id: item?.id ?? _controller.createId(),
                  name: name.text.trim(),
                  address: address.text.trim(),
                  checkIn: checkIn,
                  checkOut: checkOut,
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
                            ? 'Adicionar hospedagem'
                            : 'Editar hospedagem',
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
                      AppTextField(controller: name, labelText: 'Nome'),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(controller: address, labelText: 'Endereco'),
                      SizedBox(height: tokens.spacing.lg),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.login_rounded),
                        title: Text(
                          'Check-in: ${TripTextFormatters.date(checkIn)}',
                        ),
                        onTap: () => pick(isCheckIn: true),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.logout_rounded),
                        title: Text(
                          'Check-out: ${TripTextFormatters.date(checkOut)}',
                        ),
                        onTap: () => pick(isCheckIn: false),
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
    name.dispose();
    address.dispose();
  }

  Future<void> _delete(LodgingInfo item) async {
    if (!await confirmDelete(context) || !mounted) return;
    _controller.deleteLodging(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.lodgings(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return TripModulePageShell(
      title: 'Hospedagem',
      subtitle: widget.trip.title,
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.hotel_rounded,
            title: 'Nenhuma hospedagem cadastrada.',
            description: 'Adicione reservas, enderecos e datas da estadia.',
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
                    Icons.hotel_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.address}\n${TripTextFormatters.date(item.checkIn)} - ${TripTextFormatters.date(item.checkOut)}',
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
