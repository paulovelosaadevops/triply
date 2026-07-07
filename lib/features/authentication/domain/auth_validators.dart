class AuthValidators {
  const AuthValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? name(String value) {
    if (value.trim().isEmpty) {
      return 'Informe seu nome.';
    }

    return null;
  }

  static String? email(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }

    if (!_emailPattern.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) {
      return 'Informe sua senha.';
    }

    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }

    return null;
  }

  static String? confirmPassword(String value, String password) {
    final passwordError = AuthValidators.password(value);
    if (passwordError != null) {
      return passwordError;
    }

    if (value != password) {
      return 'As senhas devem ser iguais.';
    }

    return null;
  }
}
