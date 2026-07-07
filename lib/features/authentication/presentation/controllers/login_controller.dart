import 'package:flutter/material.dart';
import 'package:triply/features/authentication/domain/auth_validators.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool validate() {
    emailError = AuthValidators.email(emailController.text);
    passwordError = AuthValidators.password(passwordController.text);
    notifyListeners();

    return emailError == null && passwordError == null;
  }

  void clearEmailError() {
    if (emailError == null) {
      return;
    }

    emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    if (passwordError == null) {
      return;
    }

    passwordError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
