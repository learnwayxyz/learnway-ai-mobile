import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/container_extension.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class CertificateTab extends StatelessWidget {
  const CertificateTab({super.key, this.isLocked = true});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _CertificateCard(isLocked: isLocked),
          const VSpace(24),
          Row(
            children: [
              Expanded(
                child: _GradientButton(text: 'Download Pdf', onPressed: () {}),
              ),
              const HSpace(16),
              Expanded(
                child: ButtonFactory.blackButton(
                  text: 'Share',
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const VSpace(24),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  // LearnWay gradient: #215AEB (AppColors.primaryMain) → #133385 (no
  // AppColors match).
  static final Gradient _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryMain, const Color(0xFF133385)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.buttonText(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.isLocked});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final certificate = Image.asset(
      Assets.images.learnwayCert.path,
      width: double.infinity,
      fit: BoxFit.contain,
    );

    if (!isLocked) {
      return certificate.cardStyle();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.2, child: certificate),
        const _LockedOverlay(),
      ],
    ).cardStyle();
  }
}

class _LockedOverlay extends StatelessWidget {
  const _LockedOverlay();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gray900,
          ),
          // TODO: replace with the exact lock icon asset when available
          child: const Icon(Icons.lock_outline, color: Colors.white, size: 22),
        ),
        const VSpace(12),
        Text(
          'Certificate Locked',
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Subscribe to Premium to unlock certificate',
            style: AppTextStyles.baseMedium(
              context,
            ).copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
