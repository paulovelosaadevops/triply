import 'package:flutter/material.dart';

class AuthenticationPlaceholderPage extends StatelessWidget {
  const AuthenticationPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SizedBox.expand(),
    );
  }
}
