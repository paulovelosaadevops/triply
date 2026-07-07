import 'package:flutter/material.dart';

class TripHubSection {
  const TripHubSection({
    required this.description,
    required this.icon,
    required this.routeName,
    required this.title,
  });

  final String description;
  final IconData icon;
  final String routeName;
  final String title;
}
