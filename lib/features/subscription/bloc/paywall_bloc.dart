import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  final AdService _adService;

  PaywallBloc({AdService? adService})
    : _adService = adService ?? AdService.instance,
      super(const PaywallState()) {
    on<PaywallLoadOffering>(_onLoadOffering);
    on<PaywallPackageSelected>(_onPackageSelected);
    on<PaywallPurchaseRequested>(_onPurchaseRequested);
    on<PaywallRestoreRequested>(_onRestoreRequested);
    on<PaywallSwitchPlan>(_onSwitchPlan);
  }

  Future<void> _onLoadOffering(
    PaywallLoadOffering event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(status: PaywallStatus.loading));

    final offering = await _adService.getCurrentOffering();

    if (offering == null || offering.availablePackages.isEmpty) {
      emit(
        state.copyWith(
          status: PaywallStatus.error,
          errorMessage: 'No subscription plans available at the moment.',
        ),
      );
    } else {
      emit(state.copyWith(status: PaywallStatus.loaded, offering: offering));
    }
  }

  void _onSwitchPlan(
    PaywallSwitchPlan event,
    Emitter<PaywallState> emit,
  ) {
    final packages = state.availablePackages;
    if (event.packageIndex < 0 || event.packageIndex >= packages.length) return;
    emit(state.copyWith(selectedPackageIndex: event.packageIndex));
  }

  void _onPackageSelected(
    PaywallPackageSelected event,
    Emitter<PaywallState> emit,
  ) {
    emit(state.copyWith(selectedPackageIndex: event.index));
  }

  Future<void> _onPurchaseRequested(
    PaywallPurchaseRequested event,
    Emitter<PaywallState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: PaywallActionStatus.purchasing,
        sideEffect: PaywallSideEffect.none,
        actionErrorMessage: null,
      ),
    );

    final result = await _adService.purchase(event.package);

    if (result.success) {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          sideEffect: PaywallSideEffect.purchaseSuccess,
        ),
      );
    } else if (result.userCancelled) {
      // User tapped cancel — just reset the button, no error needed
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          sideEffect: PaywallSideEffect.purchaseCancelled,
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          sideEffect: PaywallSideEffect.purchaseFailed,
          actionErrorMessage:
              result.errorMessage ??
              'Purchase could not be completed. Please try again.',
        ),
      );
    }
  }

  Future<void> _onRestoreRequested(
    PaywallRestoreRequested event,
    Emitter<PaywallState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: PaywallActionStatus.restoring,
        sideEffect: PaywallSideEffect.none,
        actionErrorMessage: null,
      ),
    );

    final result = await _adService.restorePurchases();

    if (result.success) {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          sideEffect: PaywallSideEffect.restoreSuccess,
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          sideEffect: PaywallSideEffect.restoreFailed,
          actionErrorMessage:
              result.errorMessage ?? 'No active subscription found to restore.',
        ),
      );
    }
  }
}
