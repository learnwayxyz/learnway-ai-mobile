import 'dart:ui';

import 'package:learnwayv2/app/app_barrel.dart';

class OverlayLoader extends StatelessWidget {
  const OverlayLoader({
    required this.child,
    required this.isLoading,
    super.key,
    this.blurAmount = 5.0,
    this.overlayColor = const Color(0x4D000000),
    this.indicatorBackgroundColor = Colors.white,
    this.loadingIndicator,
    this.indicatorPadding = const EdgeInsets.all(24),
    this.indicatorBorderRadius = const BorderRadius.all(Radius.circular(16)),
    this.loadingText,
  });

  final Widget child;

  final bool isLoading;

  final double blurAmount;

  final Color overlayColor;

  final Color indicatorBackgroundColor;

  final Widget? loadingIndicator;

  final EdgeInsets indicatorPadding;

  final BorderRadius indicatorBorderRadius;
  final Widget? loadingText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(
              color: overlayColor,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Container(
              padding: indicatorPadding,
              decoration: BoxDecoration(
                color: indicatorBackgroundColor,
                borderRadius: indicatorBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: loadingText == null
                  ? loadingIndicator ??
                        const CircularProgressIndicator.adaptive()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        loadingIndicator ??
                            const CircularProgressIndicator.adaptive(),
                        const SizedBox(height: 12),
                        loadingText!,
                      ],
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
