import 'package:flutter/material.dart';
import 'package:triply/app/router/app_router.dart';
import 'package:triply/app/theme/design_tokens.dart';
import 'package:triply/core/components/primary_button.dart';
import 'package:triply/features/onboarding/presentation/models/onboarding_item.dart';
import 'package:triply/features/onboarding/presentation/widgets/onboarding_page_content.dart';
import 'package:triply/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const Duration _pageTransitionDuration = Duration(milliseconds: 360);
  static const Curve _pageTransitionCurve = Curves.easeOutCubic;

  static const List<OnboardingItem> _items = <OnboardingItem>[
    OnboardingItem(
      icon: Icons.luggage_rounded,
      title: 'Organize toda a sua viagem',
      description:
          'Centralize voos, hotéis, reservas, documentos e roteiros em um único lugar.',
    ),
    OnboardingItem(
      icon: Icons.route_rounded,
      title: 'Planeje com facilidade',
      description:
          'Monte roteiros inteligentes, acompanhe gastos e mantenha tudo organizado.',
    ),
    OnboardingItem(
      icon: Icons.flight_takeoff_rounded,
      title: 'Viaje com tranquilidade',
      description:
          'Tenha todas as informações importantes sempre disponíveis durante a viagem.',
    ),
  ];

  late final PageController _pageController;
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == _items.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _handleNextPressed() async {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: _pageTransitionDuration,
      curve: _pageTransitionCurve,
    );
  }

  void _finishOnboarding() {
    Navigator.of(
      context,
    ).pushReplacementNamed(AppRoutes.authenticationPlaceholder);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<DesignTokens>() ?? DesignTokens.base;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.xl),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Pular'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(
                      item: _items[index],
                      isActive: index == _currentIndex,
                    );
                  },
                ),
              ),
              OnboardingPageIndicator(
                currentIndex: _currentIndex,
                itemCount: _items.length,
              ),
              SizedBox(height: tokens.spacing.xl),
              AnimatedSwitcher(
                duration: _pageTransitionDuration,
                switchInCurve: _pageTransitionCurve,
                switchOutCurve: Curves.easeInCubic,
                child: SizedBox(
                  key: ValueKey<bool>(_isLastPage),
                  width: double.infinity,
                  child: PrimaryButton(
                    label: _isLastPage ? 'Começar' : 'Próximo',
                    onPressed: _handleNextPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
