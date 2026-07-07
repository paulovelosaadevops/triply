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

class ChecklistModulePage extends StatefulWidget {
  const ChecklistModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<ChecklistModulePage> createState() => _ChecklistModulePageState();
}

class _ChecklistModulePageState extends State<ChecklistModulePage> {
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

  Future<void> _openForm({ChecklistItem? item}) async {
    final title = TextEditingController(text: item?.title);
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
            void save() {
              setSheetState(() {
                error = title.text.trim().isEmpty ? 'Informe o item.' : null;
              });
              if (error != null) return;
              _controller.saveChecklistItem(
                widget.trip.id,
                ChecklistItem(
                  id: item?.id ?? _controller.createId(),
                  title: title.text.trim(),
                  isDone: item?.isDone ?? false,
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
                child: Padding(
                  padding: EdgeInsets.all(tokens.spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        item == null ? 'Adicionar item' : 'Editar item',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: title,
                        errorText: error,
                        labelText: 'Item',
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
  }

  Future<void> _delete(ChecklistItem item) async {
    if (!await confirmDelete(context) || !mounted) return;
    _controller.deleteChecklistItem(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.checklist(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return TripModulePageShell(
      title: 'Checklist',
      subtitle: widget.trip.title,
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.checklist_rounded,
            title: 'Checklist vazio.',
            description: 'Adicione tudo que precisa preparar antes da viagem.',
          )
        else
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.md),
              child: AppCard(
                onTap: () => _openForm(item: item),
                padding: EdgeInsets.all(tokens.spacing.sm),
                child: CheckboxListTile(
                  value: item.isDone,
                  onChanged: (_) {
                    _controller.toggleChecklistItem(widget.trip.id, item);
                  },
                  title: Text(
                    item.title,
                    style: item.isDone
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  secondary: IconButton(
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
