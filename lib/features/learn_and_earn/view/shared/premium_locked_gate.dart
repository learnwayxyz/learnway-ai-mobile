import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/locked_overlay.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

/// Gates [child] behind an active premium subscription. Free users see the
/// content faded and non-interactive with a lock overlay and a subscribe CTA.
class PremiumLockedGate extends StatelessWidget {
  const PremiumLockedGate({
    super.key,
    required this.lockedTitle,
    required this.lockedSubtitle,
    required this.buttonText,
    required this.child,
  });

  final String lockedTitle;
  final String lockedSubtitle;
  final String buttonText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: RevenueCatService.instance.premiumStatusNotifier,
      builder: (context, isPremium, _) {
        if (isPremium || RevenueCatService.instance.isPremiumUser) {
          return child;
        }
        return Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(child: Opacity(opacity: 0.05, child: child)),
            ),
            Positioned.fill(
              child: Center(
                child: LockedOverlay(
                  title: lockedTitle,
                  subtitle: lockedSubtitle,
                  action: ButtonFactory.gradientButton(
                    text: buttonText,
                    onPressed: () => context.router.push(const PayWallRoute()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
