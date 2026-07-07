import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/app_text_field.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/features/authentication/presentation/controllers/forgot_password_controller.dart';
import 'package:triply/features/authentication/presentation/models/auth_page_copy.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_page_shell.dart';
import 'package:triply/features/authentication/presentation/widgets/auth_success_message.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const AuthPageCopy _copy = AuthPageCopy(
    title: 'Recupere sua senha',
    description: 'Informe seu e-mail para receber as próximas instruções.',
  );

  late final ForgotPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ForgotPasswordController()
      ..addListener(_handleControllerChanged);
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
          controller: _controller.emailController,
          errorText: _controller.emailError,
          keyboardType: TextInputType.emailAddress,
          labelText: 'E-mail',
          onChanged: (_) => _controller.clearEmailError(),
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: tokens.spacing.xl),
        PrimaryButton(
          label: 'Enviar instruções',
          onPressed: _controller.submit,
        ),
        if (_controller.hasSentInstructions) ...<Widget>[
          SizedBox(height: tokens.spacing.lg),
          const AuthSuccessMessage(
            message:
                'Instruções de recuperação foram preparadas para este e-mail.',
          ),
        ],
      ],
    );
  }
}
