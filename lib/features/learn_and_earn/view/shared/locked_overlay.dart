import 'package:learnwayv2/app/app_barrel.dart';

/// Lock badge + title + subtitle shown over dimmed content, with an optional
/// action button (e.g. a subscribe CTA). Shared by the certificate claim lock
/// and the premium gates.
class LockedOverlay extends StatelessWidget {
  const LockedOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

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
          title,
          style: AppTextStyles.mdBold(
            context,
          ).copyWith(color: AppColors.gray900),
        ),
        const VSpace(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            subtitle,
            style: AppTextStyles.baseMedium(
              context,
            ).copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
        ),
        if (action != null) ...[
          const VSpace(24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: action!,
          ),
        ],
      ],
    );
  }
}
