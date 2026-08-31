import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/features/subscription/bloc/paywall_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@RoutePage()
class PayWallScreen extends StatelessWidget {
  const PayWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaywallBloc()..add(const PaywallLoadOffering()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: BlocBuilder<PaywallBloc, PaywallState>(
              buildWhen: (prev, curr) => prev.benefits != curr.benefits,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderSection(),
                    const VSpace(6),
                    ...state.benefits.map(
                      (benefit) => _BenefitCard(benefit: benefit),
                    ),
                    const VSpace(10),
                    const _OfferingsSection(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.router.pop(),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.chevron_left_rounded,
                size: 26,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Assets.images.lennyHi.image(
              width: 84,
              height: 84,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 8,
              left: -12,
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xFF93C5FD).withValues(alpha: 0.7),
                size: 14,
              ),
            ),
            Positioned(
              top: 6,
              right: -10,
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xFF93C5FD).withValues(alpha: 0.7),
                size: 12,
              ),
            ),
            Positioned(
              bottom: 12,
              right: -8,
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xFF93C5FD).withValues(alpha: 0.7),
                size: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final BenefitItem benefit;

  const _BenefitCard({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                benefit.icon,
                size: 18,
                color: const Color(0xFF0066FF),
              ),
            ),
          ),
          const HSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.smBold(context).copyWith(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const VSpace(1),
                Text(
                  benefit.description,
                  style: AppTextStyles.xsRegular(context).copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 10.5,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const HSpace(8),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF0066FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _OfferingsSection extends StatelessWidget {
  const _OfferingsSection();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaywallBloc, PaywallState>(
      listenWhen: (prev, curr) => prev.sideEffect != curr.sideEffect,
      listener: (context, state) {
        switch (state.sideEffect) {
          case PaywallSideEffect.purchaseSuccess:
          case PaywallSideEffect.restoreSuccess:
            context.router.pop(true);
            break;
          case PaywallSideEffect.purchaseFailed:
          case PaywallSideEffect.restoreFailed:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.actionErrorMessage ??
                      'Something went wrong. Please try again.',
                ),
              ),
            );
            break;
          case PaywallSideEffect.purchaseCancelled:
          case PaywallSideEffect.none:
            break;
        }
      },
      child: BlocBuilder<PaywallBloc, PaywallState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  state.errorMessage ?? 'Something went wrong.',
                  style: AppTextStyles.base(
                    context,
                  ).copyWith(color: AppColors.error500),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final packages = state.availablePackages;
          Package? monthlyPackage;
          for (final pkg in packages) {
            if (pkg.packageType == PackageType.monthly ||
                pkg.identifier.toLowerCase().contains('month') ||
                pkg.storeProduct.identifier.toLowerCase().contains('1m')) {
              monthlyPackage = pkg;
              break;
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...packages.asMap().entries.map((entry) {
                final index = entry.key;
                final package = entry.value;
                final isSelected = index == state.selectedPackageIndex;
                return _PackageCard(
                  package: package,
                  isSelected: isSelected,
                  monthlyPackage: monthlyPackage,
                  onTap: () => context.read<PaywallBloc>().add(
                    PaywallPackageSelected(index),
                  ),
                );
              }),
              const VSpace(8),
              _ContinueButton(state: state),
              const VSpace(4),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: state.isRestoring
                    ? null
                    : () => context.read<PaywallBloc>().add(
                        const PaywallRestoreRequested(),
                      ),
                child: state.isRestoring
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF0066FF),
                        ),
                      )
                    : Text(
                        'Restore Purchases',
                        style: AppTextStyles.smSemiBold(context).copyWith(
                          color: const Color(0xFF0066FF),
                          fontSize: 13,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final Package? monthlyPackage;
  final VoidCallback onTap;

  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
    this.monthlyPackage,
  });

  bool get _isAnnual =>
      package.packageType == PackageType.annual ||
      package.identifier.toLowerCase().contains('year') ||
      package.storeProduct.identifier.toLowerCase().contains('yrly');

  bool get _isMonthly =>
      package.packageType == PackageType.monthly ||
      package.identifier.toLowerCase().contains('month') ||
      package.storeProduct.identifier.toLowerCase().contains('1m');

  String _periodTitle() {
    if (_isMonthly) return 'Monthly';
    if (_isAnnual) return 'Yearly';
    switch (package.packageType) {
      case PackageType.weekly:
        return 'Weekly';
      case PackageType.twoMonth:
        return '2 Months';
      case PackageType.threeMonth:
        return '3 Months';
      case PackageType.sixMonth:
        return '6 Months';
      case PackageType.lifetime:
        return 'Lifetime';
      default:
        return package.storeProduct.title;
    }
  }

  String _periodSubtitle() {
    if (_isMonthly) return '/ month';
    if (_isAnnual) return '/ year';
    if (package.packageType == PackageType.weekly) return '/ week';
    return '';
  }

  String? _savingsPercent() {
    if (!_isAnnual) return null;
    if (monthlyPackage != null) {
      final monthlyPrice = monthlyPackage!.storeProduct.price;
      final annualPrice = package.storeProduct.price;
      if (monthlyPrice > 0 && annualPrice > 0) {
        final percent = ((1.0 - (annualPrice / (monthlyPrice * 12.0))) * 100)
            .round();
        if (percent > 0) return 'Save $percent%';
      }
    }
    return 'Save 12%';
  }

  String? _monthlyEquivalentPrice() {
    if (!_isAnnual) return null;
    final annualPrice = package.storeProduct.price;
    if (annualPrice <= 0) return null;
    final monthlyEquiv = annualPrice / 12.0;
    final priceStr = package.storeProduct.priceString;
    final match = RegExp(r'^[^\d.,\s]+').firstMatch(priceStr);
    final prefix = match != null ? match.group(0)! : '';

    return 'Only $prefix${monthlyEquiv.toStringAsFixed(2)}/month';
  }

  @override
  Widget build(BuildContext context) {
    final priceString = package.storeProduct.priceString;
    final title = _periodTitle();
    final periodSubtitle = _periodSubtitle();
    final savings = _savingsPercent();
    final monthlyEquiv = _monthlyEquivalentPrice();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0066FF)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio Circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0066FF)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0066FF),
                        ),
                      ),
                    )
                  : null,
            ),
            const HSpace(12),

            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.baseBold(context).copyWith(
                      color: const Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (savings != null) ...[
                    const HSpace(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        savings,
                        style: AppTextStyles.xsSemiBold(context).copyWith(
                          color: const Color(0xFF16A34A),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  priceString,
                  style: AppTextStyles.baseBold(context).copyWith(
                    color: const Color(0xFF0066FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (periodSubtitle.isNotEmpty)
                  Text(
                    periodSubtitle,
                    style: AppTextStyles.xsRegular(
                      context,
                    ).copyWith(color: const Color(0xFF64748B), fontSize: 11),
                  ),
                if (monthlyEquiv != null)
                  Text(
                    monthlyEquiv,
                    style: AppTextStyles.xsMedium(context).copyWith(
                      color: const Color(0xFF16A34A),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final PaywallState state;

  const _ContinueButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state.isPurchasing
          ? null
          : () {
              final selected = state.selectedPackage;
              if (selected != null) {
                context.read<PaywallBloc>().add(
                  PaywallPurchaseRequested(selected),
                );
              }
            },
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0066FF),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0066FF).withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: state.isPurchasing
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.string(
                      '''<svg width="20" height="20" viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
                        <path d="M5 16L3 5L8.5 10L12 4L15.5 10L21 5L19 16H5ZM5 19C5 19.5523 5.44772 20 6 20H18C18.5523 20 19 19.5523 19 19V18H5V19Z"/>
                      </svg>''',
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      'Continue to Premium',
                      style: AppTextStyles.baseBold(context).copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
