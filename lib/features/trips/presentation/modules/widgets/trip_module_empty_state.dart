import 'package:flutter/material.dart';
import 'package:triply/core/components/app_empty_state.dart';

class TripModuleEmptyState extends StatelessWidget {
  const TripModuleEmptyState({
    required this.description,
    required this.icon,
    required this.title,
    super.key,
  });

  final String description;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(description: description, icon: icon, title: title);
  }
}
