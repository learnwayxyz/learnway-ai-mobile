import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  final AdService _adService;

  static const List<BenefitItem> defaultBenefits = [
    BenefitItem(
      title: 'Capstone Projects',
      description: 'Build real projects and apply your skills.',
      icon: Icons.rocket_launch_rounded,
    ),
    BenefitItem(
      title: 'AI Assessment',
      description: 'Get AI evaluation and personalized feedback.',
      icon: Icons.assignment_turned_in_rounded,
    ),
    BenefitItem(
      title: 'Verified Certificate',
      description: 'Earn a verifiable certificate for your achievement.',
      icon: Icons.shield_rounded,
    ),
    BenefitItem(
      title: 'Advanced AI Mentor',
      description: 'Receive personalized guidance and insights.',
      icon: Icons.smart_toy_rounded,
    ),
    BenefitItem(
      title: 'Advanced AI Tutor',
      description: 'Get deeper explanations and instant help.',
      icon: Icons.chat_bubble_rounded,
    ),
    BenefitItem(
      title: 'Unlimited Lessons',
      description: 'Learn without daily lesson limits.',
      icon: Icons.all_inclusive_rounded,
    ),
    BenefitItem(
      title: '2x Gems Boost',
      description: 'Earn double gems on your first lesson daily.',
      icon: Icons.diamond_rounded,
    ),
    BenefitItem(
      title: 'Ad-Free Learning',
      description: 'Enjoy a focused, ad-free learning experience.',
      icon: Icons.block_rounded,
    ),
  ];

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

  void _onSwitchPlan(PaywallSwitchPlan event, Emitter<PaywallState> emit) {
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
