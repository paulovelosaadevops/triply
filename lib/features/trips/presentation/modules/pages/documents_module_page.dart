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

class DocumentsModulePage extends StatefulWidget {
  const DocumentsModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<DocumentsModulePage> createState() => _DocumentsModulePageState();
}

class _DocumentsModulePageState extends State<DocumentsModulePage> {
  static const List<String> _types = <String>[
    'Passaporte',
    'RG',
    'Visto',
    'Seguro',
    'Outro',
  ];

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

  Future<void> _openForm({TravelDocument? item}) async {
    final name = TextEditingController(text: item?.name);
    String type = item?.type ?? _types.first;
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
                error = name.text.trim().isEmpty ? 'Informe o nome.' : null;
              });
              if (error != null) return;
              _controller.saveDocument(
                widget.trip.id,
                TravelDocument(
                  id: item?.id ?? _controller.createId(),
                  name: name.text.trim(),
                  type: type,
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
                        item == null
                            ? 'Adicionar documento'
                            : 'Editar documento',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: name,
                        errorText: error,
                        labelText: 'Nome',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Tipo'),
                        items: _types
                            .map(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setSheetState(() => type = value);
                        },
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
  }

  Future<void> _delete(TravelDocument item) async {
    if (!await confirmDelete(context) || !mounted) return;
    _controller.deleteDocument(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.documents(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return TripModulePageShell(
      title: 'Documentos',
      subtitle: widget.trip.title,
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.description_rounded,
            title: 'Nenhum documento cadastrado.',
            description: 'Registre os documentos importantes da viagem.',
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
                    Icons.description_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.type),
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
