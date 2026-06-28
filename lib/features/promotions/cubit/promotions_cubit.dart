import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_state.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';
import 'package:learnwayv2/features/promotions/repository/promotions_repository.dart';
import 'package:core/core.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  PromotionsCubit({required PromotionsRepository promotionsRepository})
      : _repository = promotionsRepository,
        super(const PromotionsInitial());

  final PromotionsRepository _repository;

  Future<void> fetchPromotions({String? country, String? language}) async {
    dev.log(
      'fetchPromotions called — country: $country language: $language',
      name: 'PromotionsCubit',
    );
    emit(const PromotionsLoading());
    final result = await _repository.fetchActivePromotions(
      country: country,
      language: language,
    );
    result.fold(
      (failure) {
        dev.log('fetchPromotions error — ${failure.message}', name: 'PromotionsCubit');
        emit(PromotionsError(failure.message));
      },
      (response) {
        dev.log(
          'fetchPromotions success — popup: ${response.popup?.id}, '
          'banners: ${response.banners.length}',
          name: 'PromotionsCubit',
        );
        emit(PromotionsLoaded(popup: response.popup, banners: response.banners));
      },
    );
  }

  Future<bool> shouldShowPopup(PromotionModel popup) async {
    if (popup.displayFrequencyHours == 0) {
      final sessionSeen = await SharedPreferencesStore.getPromoPopupSessionSeen(
        popup.id,
      );
      dev.log(
        'shouldShowPopup (session-once) — id: ${popup.id} sessionSeen: $sessionSeen → show: ${!sessionSeen}',
        name: 'PromotionsCubit',
      );
      return !sessionSeen;
    }

    final lastSeen = await SharedPreferencesStore.getPromoPopupTimestamp(
      popup.id,
    );
    if (lastSeen == null) {
      dev.log(
        'shouldShowPopup — id: ${popup.id} never seen before → show: true',
        name: 'PromotionsCubit',
      );
      return true;
    }

    final hoursSince =
        (DateTime.now().millisecondsSinceEpoch - lastSeen) / 3600000;
    final eligible = hoursSince >= popup.displayFrequencyHours;
    dev.log(
      'shouldShowPopup — id: ${popup.id} hoursSince: ${hoursSince.toStringAsFixed(1)} '
      'frequencyHours: ${popup.displayFrequencyHours} → show: $eligible',
      name: 'PromotionsCubit',
    );
    return eligible;
  }

  Future<void> markPopupSeen(PromotionModel popup) async {
    if (popup.displayFrequencyHours == 0) {
      await SharedPreferencesStore.savePromoPopupSessionSeen(popup.id);
    } else {
      await SharedPreferencesStore.savePromoPopupTimestamp(
        popup.id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void trackEvent(
    String campaignId,
    String eventType, {
    String? country,
  }) {
    _repository.trackEvent(
      campaignId: campaignId,
      eventType: eventType,
      country: country,
    );
  }
}
