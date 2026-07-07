import 'package:flutter/material.dart';
import 'package:triply/features/authentication/domain/auth_validators.dart';

class SignUpController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool validate() {
    nameError = AuthValidators.name(nameController.text);
    emailError = AuthValidators.email(emailController.text);
    passwordError = AuthValidators.password(passwordController.text);
    confirmPasswordError = AuthValidators.confirmPassword(
      confirmPasswordController.text,
      passwordController.text,
    );
    notifyListeners();

    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  void clearNameError() {
    if (nameError == null) {
      return;
    }

    nameError = null;
    notifyListeners();
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

  void clearConfirmPasswordError() {
    if (confirmPasswordError == null) {
      return;
    }

    confirmPasswordError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
