part of 'paywall_bloc.dart';

sealed class PaywallEvent {
  const PaywallEvent();
}

final class PaywallLoadOffering extends PaywallEvent {
  const PaywallLoadOffering();
}

final class PaywallPackageSelected extends PaywallEvent {
  final int index;
  const PaywallPackageSelected(this.index);
}

final class PaywallPurchaseRequested extends PaywallEvent {
  final Package package;
  const PaywallPurchaseRequested(this.package);
}

final class PaywallRestoreRequested extends PaywallEvent {
  const PaywallRestoreRequested();
}

final class PaywallSwitchPlan extends PaywallEvent {
  final int packageIndex;
  const PaywallSwitchPlan(this.packageIndex);
}
