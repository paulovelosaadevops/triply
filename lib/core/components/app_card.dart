import 'package:flutter/material.dart';
import 'package:triply/app/theme/design_tokens.dart';

class AppCard extends StatefulWidget {
  const AppCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  static const Duration _pressDuration = Duration(milliseconds: 120);

  bool _isPressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens =
        Theme.of(context).extension<DesignTokens>() ?? DesignTokens.base;
    final radius = BorderRadius.circular(tokens.radius.lg);

    return AnimatedScale(
      duration: _pressDuration,
      curve: Curves.easeOutCubic,
      scale: _isPressed ? 0.99 : 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: radius,
          onHighlightChanged: _setPressed,
          onTap: widget.onTap,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(tokens.spacing.lg),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
