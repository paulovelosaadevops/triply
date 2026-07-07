import 'package:flutter/material.dart';
import 'package:triply/app/router/app_router.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_text_field.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/features/authentication/presentation/controllers/sign_up_controller.dart';
import 'package:triply/features/authentication/presentation/models/auth_page_copy.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_footer_link.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_page_shell.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const AuthPageCopy _copy = AuthPageCopy(
    title: 'Crie sua conta',
    description: 'Prepare seu espaço pessoal para organizar cada viagem.',
  );

  late final SignUpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignUpController()..addListener(_handleControllerChanged);
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
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).maybePop();
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      children: <Widget>[
        AppTextField(
          controller: _controller.nameController,
          errorText: _controller.nameError,
          keyboardType: TextInputType.name,
          labelText: 'Nome',
          onChanged: (_) => _controller.clearNameError(),
          prefixIcon: const Icon(Icons.person_outline_rounded),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: tokens.spacing.lg),
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
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: tokens.spacing.lg),
        AppTextField(
          controller: _controller.confirmPasswordController,
          errorText: _controller.confirmPasswordError,
          labelText: 'Confirmar senha',
          obscureText: true,
          onChanged: (_) => _controller.clearConfirmPasswordError(),
          prefixIcon: const Icon(Icons.lock_reset_rounded),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: tokens.spacing.xl),
        PrimaryButton(label: 'Criar conta', onPressed: _handleSubmit),
        SizedBox(height: tokens.spacing.xl),
        AuthFooterLink(
          label: 'Já possui uma conta?',
          actionLabel: 'Entrar',
          onPressed: () {
            Navigator.of(
              context,
            ).popUntil(ModalRoute.withName(AppRoutes.login));
          },
        ),
      ],
    );
  }
}
