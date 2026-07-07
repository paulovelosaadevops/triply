import 'package:flutter/material.dart';
import 'package:triply/app/router/app_router.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_text_field.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/core/components/secondary_button.dart';
import 'package:triply/features/authentication/presentation/controllers/login_controller.dart';
import 'package:triply/features/authentication/presentation/models/auth_page_copy.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_footer_link.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_page_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const AuthPageCopy _copy = AuthPageCopy(
    title: 'Entre no Triply',
    description: 'Acesse sua conta para continuar organizando suas viagens.',
  );

  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController()..addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _handleSubmit() {
    if (!_controller.validate()) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.homeDashboard);
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;

    return AuthPageShell(
      title: _copy.title,
      description: _copy.description,
      children: <Widget>[
        AppTextField(
          controller: _controller.emailController,
          errorText: _controller.emailError,
          keyboardType: TextInputType.emailAddress,
          labelText: 'E-mail',
          onChanged: (_) => _controller.clearEmailError(),
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: tokens.spacing.lg),
        AppTextField(
          controller: _controller.passwordController,
          errorText: _controller.passwordError,
          labelText: 'Senha',
          obscureText: true,
          onChanged: (_) => _controller.clearPasswordError(),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          textInputAction: TextInputAction.done,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
            },
            child: const Text('Esqueci minha senha'),
          ),
        ),
        SizedBox(height: tokens.spacing.lg),
        PrimaryButton(label: 'Entrar', onPressed: _handleSubmit),
        SizedBox(height: tokens.spacing.md),
        SecondaryButton(
          label: 'Criar conta',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signUp);
          },
        ),
        SizedBox(height: tokens.spacing.xl),
        AuthFooterLink(
          label: 'Ainda não tem uma conta?',
          actionLabel: 'Criar conta',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signUp);
          },
        ),
      ],
    );
  }
}
