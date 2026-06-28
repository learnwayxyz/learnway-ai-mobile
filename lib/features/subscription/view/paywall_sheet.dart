import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/features/subscription/bloc/paywall_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@RoutePage()
class PayWallScreen extends StatelessWidget {
  const PayWallScreen({super.key});

  static const List<String> _benefits = [
    'Ad Free Experience',
    'Unlimited Daily Lessons',
    '2x Gems Boost (First Lesson Daily)',
    'Zero Transaction Fees',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaywallBloc()..add(const PaywallLoadOffering()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarFactory.standardAppBar(title: 'Subscription'),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.35,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const VSpace(24),
                            Assets.images.lennyHi.image(
                              width: 120,
                              height: 120,
                            ),
                            const VSpace(16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _benefits.map((benefit) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        const HSpace(14),
                                        Expanded(
                                          child: Text(
                                            benefit,
                                            style: AppTextStyles.baseRegular(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: _OfferingsContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferingsContent extends StatelessWidget {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const VSpace(12),
          BlocBuilder<PaywallBloc, PaywallState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.hasError) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Something went wrong.',
                    style: AppTextStyles.base(
                      context,
                    ).copyWith(color: AppColors.error500),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: state.availablePackages.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key;
                      final package = entry.value;
                      final isSelected = index == state.selectedPackageIndex;
                      return _PackageCard(
                        package: package,
                        isSelected: isSelected,
                        onTap: () => context.read<PaywallBloc>().add(
                          PaywallPackageSelected(index),
                        ),
                      );
                    }).toList(),
                  ),
                  const VSpace(8),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: state.isPurchasing
                          ? () {}
                          : () {
                              final selected = state.selectedPackage;
                              if (selected != null) {
                                context.read<PaywallBloc>().add(
                                  PaywallPurchaseRequested(selected),
                                );
                              }
                            },
                      isLoading: state.isPurchasing,
                      text: 'Subscribe',
                    ),
                  ),
                  BlocBuilder<PaywallBloc, PaywallState>(
                    buildWhen: (prev, curr) =>
                        prev.isRestoring != curr.isRestoring,
                    builder: (context, state) {
                      return TextButton(
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
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Restore Purchases',
                                style: AppTextStyles.base(
                                  context,
                                ).copyWith(color: AppColors.primaryColor),
                              ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  String _packagePeriodLabel(Package package) {
    switch (package.packageType) {
      case PackageType.weekly:
        return 'Weekly';
      case PackageType.monthly:
        return 'Monthly';
      case PackageType.twoMonth:
        return '2 Months';
      case PackageType.threeMonth:
        return '3 Months';
      case PackageType.sixMonth:
        return '6 Months';
      case PackageType.annual:
        return 'Yearly';
      case PackageType.lifetime:
        return 'Lifetime';
      default:
        return package.storeProduct.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceString = package.storeProduct.priceString;
    final periodLabel = _packagePeriodLabel(package);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.gray300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const HSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(periodLabel, style: AppTextStyles.baseBold(context)),
                  if (package.storeProduct.description.isNotEmpty)
                    Text(
                      package.storeProduct.description,
                      style: AppTextStyles.smRegular(
                        context,
                      ).copyWith(color: AppColors.gray500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              priceString,
              style: AppTextStyles.mdBold(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
