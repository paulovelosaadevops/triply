import 'package:flutter/material.dart';
import 'package:triply/features/authentication/domain/auth_validators.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  String? emailError;
  bool hasSentInstructions = false;

  bool submit() {
    emailError = AuthValidators.email(emailController.text);
    hasSentInstructions = emailError == null;
    notifyListeners();

    return hasSentInstructions;
  }

  void clearEmailError() {
    if (emailError == null && !hasSentInstructions) {
      return;
    }

    emailError = null;
    hasSentInstructions = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
