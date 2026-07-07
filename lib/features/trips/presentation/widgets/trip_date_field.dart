import 'package:flutter/material.dart';

class TripDateField extends StatelessWidget {
  const TripDateField({
    required this.label,
    required this.onTap,
    this.errorText,
    this.value,
    super.key,
  });

  final String? errorText;
  final String label;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          errorText: errorText,
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_rounded),
        ),
        child: Text(
          value ?? 'Selecionar data',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: value == null
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
