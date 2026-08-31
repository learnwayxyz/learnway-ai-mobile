part of 'paywall_bloc.dart';

enum PaywallStatus { loading, loaded, error }

enum PaywallActionStatus { idle, purchasing, restoring }

enum PaywallSideEffect {
  none,
  purchaseSuccess,
  purchaseFailed,
  purchaseCancelled,
  restoreSuccess,
  restoreFailed,
}

class BenefitItem {
  final String title;
  final String description;
  final IconData icon;

  const BenefitItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class PaywallState {
  const PaywallState({
    this.status = PaywallStatus.loading,
    this.actionStatus = PaywallActionStatus.idle,
    this.sideEffect = PaywallSideEffect.none,
    this.offering,
    this.selectedPackageIndex = 0,
    this.errorMessage,
    this.actionErrorMessage,
    this.benefits = PaywallBloc.defaultBenefits,
  });

  final PaywallStatus status;
  final PaywallActionStatus actionStatus;
  final PaywallSideEffect sideEffect;
  final Offering? offering;
  final int selectedPackageIndex;
  final String? errorMessage;
  final String? actionErrorMessage;
  final List<BenefitItem> benefits;

  bool get isLoading => status == PaywallStatus.loading;
  bool get hasError => status == PaywallStatus.error;
  bool get isPurchasing => actionStatus == PaywallActionStatus.purchasing;
  bool get isRestoring => actionStatus == PaywallActionStatus.restoring;

  List<Package> get availablePackages => offering?.availablePackages ?? [];

  Package? get selectedPackage {
    final packages = availablePackages;
    if (packages.isEmpty || selectedPackageIndex >= packages.length) {
      return null;
    }
    return packages[selectedPackageIndex];
  }

  /// Pro = monthly billing, Premium = annual billing.
  static bool _isMonthlyPackage(Package pkg) =>
      pkg.packageType == PackageType.monthly ||
      pkg.identifier.toLowerCase().contains('month') ||
      pkg.storeProduct.identifier.toLowerCase().contains('1m');

  static bool _isAnnualPackage(Package pkg) =>
      pkg.packageType == PackageType.annual ||
      pkg.identifier.toLowerCase().contains('year') ||
      pkg.storeProduct.identifier.toLowerCase().contains('yrly');

  static String _planLabel(Package pkg) {
    if (_isMonthlyPackage(pkg)) return 'Pro';
    if (_isAnnualPackage(pkg)) return 'Premium';
    return pkg.storeProduct.title;
  }

  String? get activePlanName {
    final pkg = selectedPackage;
    if (pkg == null) return null;
    return _planLabel(pkg);
  }

  /// The label + index of the other plan type, or null if there is no
  /// other monthly/annual package to switch to.
  ({String label, int index})? get alternatePlan {
    final packages = availablePackages;
    final currentPkg = selectedPackage;
    if (currentPkg == null) return null;

    final currentIsMonthly = _isMonthlyPackage(currentPkg);
    final currentIsAnnual = _isAnnualPackage(currentPkg);
    if (!currentIsMonthly && !currentIsAnnual) return null;

    for (int i = 0; i < packages.length; i++) {
      if (i == selectedPackageIndex) continue;
      final pkg = packages[i];
      if (currentIsMonthly && _isAnnualPackage(pkg)) {
        return (label: 'Premium', index: i);
      }
      if (currentIsAnnual && _isMonthlyPackage(pkg)) {
        return (label: 'Pro', index: i);
      }
    }
    return null;
  }

  PaywallState copyWith({
    PaywallStatus? status,
    PaywallActionStatus? actionStatus,
    PaywallSideEffect? sideEffect,
    Offering? offering,
    int? selectedPackageIndex,
    String? errorMessage,
    String? actionErrorMessage,
    List<BenefitItem>? benefits,
  }) {
    return PaywallState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      sideEffect: sideEffect ?? this.sideEffect,
      offering: offering ?? this.offering,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: actionErrorMessage,
      benefits: benefits ?? this.benefits,
    );
  }
}
