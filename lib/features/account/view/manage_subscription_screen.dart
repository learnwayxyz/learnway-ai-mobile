import 'dart:io';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/subscription/bloc/paywall_bloc.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ManageSubscriptionScreen extends StatefulWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  State<ManageSubscriptionScreen> createState() =>
      _ManageSubscriptionScreenState();
}

class _ManageSubscriptionScreenState extends State<ManageSubscriptionScreen> {
  static const List<BenefitItem> _benefits = PaywallBloc.defaultBenefits;

  CustomerInfo? _customerInfo;
  String? _priceString;
  bool _loading = true;
  bool _isSwitching = false;

  String? _activeProductId;

  Package? _alternatePackage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        Purchases.getCustomerInfo(),
        Purchases.getOfferings(),
      ]);

      final info = results[0] as CustomerInfo;
      final offerings = results[1] as Offerings;
      final packages = offerings.current?.availablePackages ?? [];
      final activeProductIds = info.activeSubscriptions;

      String? price;
      String? activeProductId;
      Package? alternatePackage;

      for (final pkg in packages) {
        if (activeProductIds.contains(pkg.storeProduct.identifier)) {
          price = pkg.storeProduct.priceString;
          activeProductId = pkg.storeProduct.identifier;
          break;
        }
      }

      if (activeProductId != null) {
        final activeIsMonthly = _isMonthlyProduct(activeProductId);
        final activeIsAnnual = _isAnnualProduct(activeProductId);
        for (final pkg in packages) {
          if (pkg.storeProduct.identifier == activeProductId) continue;
          final id = pkg.storeProduct.identifier;
          if (activeIsMonthly && _isAnnualProduct(id)) {
            alternatePackage = pkg;
            break;
          }
          if (activeIsAnnual && _isMonthlyProduct(id)) {
            alternatePackage = pkg;
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          _customerInfo = info;
          _priceString = price;
          _activeProductId = activeProductId;
          _alternatePackage = alternatePackage;
          _loading = false;
        });

        final hasActive = info.entitlements.all.values.any((e) => e.isActive);
        if (!hasActive) {
          _redirectToPaywall();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _redirectToPaywall() async {
    await AdService.instance.refreshPremiumStatus();
    if (!mounted) return;
    final purchased = await context.router.push<bool>(const PayWallRoute());
    if (!mounted) return;
    if (purchased == true) {
      _load();
    } else {
      context.router.pop();
    }
  }

  static bool _isMonthlyProduct(String id) =>
      id.toLowerCase().contains('month') || id.toLowerCase().contains('1m');

  static bool _isAnnualProduct(String id) =>
      id.toLowerCase().contains('year') || id.toLowerCase().contains('yrly');

  String _alternatePlanLabel(String alternateProductId) {
    if (_isMonthlyProduct(alternateProductId)) return 'Pro';
    if (_isAnnualProduct(alternateProductId)) return 'Premium';
    return _alternatePackage?.storeProduct.title ?? 'other plan';
  }

  Future<void> _changePlan() async {
    final alternate = _alternatePackage;
    if (alternate == null) return;
    setState(() => _isSwitching = true);
    final result = await AdService.instance.changePlan(
      alternate.storeProduct,
      oldProductId: _activeProductId,
    );
    if (!mounted) return;
    if (result.success) {
      await _load();
    } else if (!result.userCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'Plan change failed. Please try again.',
          ),
        ),
      );
    }
    setState(() => _isSwitching = false);
  }

  EntitlementInfo? get _activeEntitlement {
    final active = _customerInfo?.entitlements.all.values
        .where((e) => e.isActive)
        .toList();
    return (active?.isNotEmpty == true) ? active!.first : null;
  }

  DateTime? get _endDate {
    final exp = _activeEntitlement?.expirationDate;
    return exp != null ? DateTime.tryParse(exp) : null;
  }

  int? get _daysRemaining {
    final end = _endDate;
    if (end == null) return null;
    final hours = end.difference(DateTime.now()).inHours;
    if (hours <= 0) return 0;
    return ((hours / 24)).ceil().clamp(1, 9999);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: 'Manage Subscription'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  String _activePlanLabel() {
    final id = _activeProductId ?? '';
    if (_isMonthlyProduct(id)) return 'Pro';
    if (_isAnnualProduct(id)) return 'Premium';
    return 'Subscription';
  }

  static bool _isGooglePlayProduct(String id) => id.contains(':');

  Future<void> _cancelSubscription() async {
    if (Platform.isAndroid) {
      final productId = _activeProductId ?? '';
      // Google Play product IDs may include a plan suffix after ':' — strip it for the URL
      final sku = productId.contains(':')
          ? productId.split(':').first
          : productId;
      final uri = Uri.parse(
        'https://play.google.com/store/account/subscriptions'
        '?sku=$sku&package=${Env.androidPackageName}',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      await RevenueCatUI.presentCustomerCenter();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildSubscriptionCard() {
    final label = _activePlanLabel();
    final renewDate = _endDate;
    final store = _isGooglePlayProduct(_activeProductId ?? '')
        ? 'Google Play Store'
        : 'App Store';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subs ($label)', style: AppTextStyles.baseBold(context)),
                const VSpace(4),
                if (renewDate != null && _priceString != null)
                  Text(
                    'Your next charge is $_priceString on ${_formatDate(renewDate)}.',
                    style: AppTextStyles.smRegular(
                      context,
                    ).copyWith(color: AppColors.gray500),
                  ),
                const VSpace(2),
                Text(
                  store,
                  style: AppTextStyles.smRegular(
                    context,
                  ).copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
          const HSpace(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success500,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Active',
              style: AppTextStyles.smBold(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final entitlement = _activeEntitlement;
    final hasActive = entitlement?.isActive == true;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(20),
                if (hasActive) ...[_buildSubscriptionCard(), const VSpace(10)],
                Text('Details', style: AppTextStyles.baseBold(context)),
                const VSpace(10),
                if (hasActive)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _benefits.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.gray200,
                      ),
                      itemBuilder: (_, i) => _BenefitCard(
                        benefit: _benefits[i],
                        daysRemaining: _daysRemaining,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: _buildActions(hasActive),
        ),
      ],
    );
  }

  Widget _buildActions(bool hasActive) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      child: Column(
        children: [
          if (hasActive) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.brandError),
                  foregroundColor: AppColors.brandError,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _cancelSubscription,
                child: Text(
                  'Cancel Subscription',
                  style: AppTextStyles.baseBold(
                    context,
                  ).copyWith(color: AppColors.brandError),
                ),
              ),
            ),
            const VSpace(10),
          ],
          ButtonFactory.blackButton(
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: () {
              if (hasActive && _alternatePackage != null) {
                if (!_isSwitching) _changePlan();
              } else {
                AdService.instance.refreshPremiumStatus().then((_) {
                  if (!mounted) return;
                  context.router.push<bool>(const PayWallRoute()).then((
                    purchased,
                  ) {
                    if (mounted) _load();
                  });
                });
              }
            },
            text: hasActive && _alternatePackage != null
                ? 'Switch to ${_alternatePlanLabel(_alternatePackage!.storeProduct.identifier)}'
                : (hasActive ? 'Renew Subscription' : 'Subscribe'),
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final BenefitItem benefit;
  final int? daysRemaining;

  const _BenefitCard({required this.benefit, required this.daysRemaining});

  String _daysLabel() {
    final days = daysRemaining;
    if (days == null) return 'Active';
    if (days == 0) return 'Expires today';
    return '$days days left';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                benefit.icon,
                size: 16,
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
          Text(
            _daysLabel(),
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: AppColors.gray400),
          ),
        ],
      ),
    );
  }
}
