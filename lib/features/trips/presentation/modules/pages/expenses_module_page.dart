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

class ExpensesModulePage extends StatefulWidget {
  const ExpensesModulePage({required this.trip, super.key});

  final Trip trip;

  @override
  State<ExpensesModulePage> createState() => _ExpensesModulePageState();
}

class _ExpensesModulePageState extends State<ExpensesModulePage> {
  static const List<String> _categories = <String>[
    'Alimentacao',
    'Transporte',
    'Hospedagem',
    'Passeios',
    'Compras',
    'Outros',
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

  Future<void> _openForm({TravelExpense? item}) async {
    final description = TextEditingController(text: item?.description);
    final amount = TextEditingController(text: item?.amount.toStringAsFixed(2));
    String category = item?.category ?? _categories.first;
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
              final parsed = double.tryParse(amount.text.replaceAll(',', '.'));
              setSheetState(() {
                error = description.text.trim().isEmpty
                    ? 'Informe a descricao.'
                    : parsed == null || parsed <= 0
                    ? 'Informe um valor valido.'
                    : null;
              });
              if (error != null || parsed == null) return;
              _controller.saveExpense(
                widget.trip.id,
                TravelExpense(
                  id: item?.id ?? _controller.createId(),
                  description: description.text.trim(),
                  amount: parsed,
                  category: category,
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
                        item == null ? 'Adicionar gasto' : 'Editar gasto',
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
                        controller: description,
                        labelText: 'Descricao',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      AppTextField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        labelText: 'Valor',
                      ),
                      SizedBox(height: tokens.spacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                        items: _categories
                            .map(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setSheetState(() => category = value);
                          }
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
    description.dispose();
    amount.dispose();
  }

  Future<void> _delete(TravelExpense item) async {
    if (!await confirmDelete(context) || !mounted) return;
    _controller.deleteExpense(widget.trip.id, item.id);
    showDeletedSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.expenses(widget.trip.id);
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;
    final total = _controller.expensesTotal(widget.trip.id);

    return TripModulePageShell(
      title: 'Gastos',
      subtitle: 'Total: ${widget.trip.currency} ${total.toStringAsFixed(2)}',
      onAdd: _openForm,
      children: <Widget>[
        if (items.isEmpty)
          const TripModuleEmptyState(
            icon: Icons.payments_rounded,
            title: 'Nenhum gasto registrado.',
            description: 'Registre custos para acompanhar o total da viagem.',
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
                    Icons.payments_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(item.description),
                  subtitle: Text(item.category),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        '${widget.trip.currency} ${item.amount.toStringAsFixed(2)}',
                      ),
                      IconButton(
                        onPressed: () => _delete(item),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
