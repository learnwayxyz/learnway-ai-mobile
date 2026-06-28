import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_state.dart';
import 'package:learnwayv2/features/invite_friends/repository/referral_repository.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsCubit extends Cubit<InviteFriendsState> {
  InviteFriendsCubit() : super(const InviteFriendsState()) {
    _referralRepository = ReferralRepository();
  }

  late ReferralRepository _referralRepository;

  Future<void> loadInviteData({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        state.inviteData != null &&
        state.inviteData!.referralCode.isNotEmpty) {
      log('Data already cached, skipping reload', name: 'InviteFriendsCubit');
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final statsResult = await _referralRepository.getReferralStats();

    await statsResult.fold(
      (failure) {
        log(
          'Failed to load referral stats: ${failure.message}',
          name: 'InviteFriendsCubit',
        );
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Unable to load referral data: ${failure.message}',
          ),
        );
      },
      (inviteData) async {
        if (inviteData.referralCode.isEmpty) {
          log(
            'Stats returned but no referral code found, generating one...',
            name: 'InviteFriendsCubit',
          );

          // Generate a referral code if none exists
          final generateResult = await _referralRepository
              .generateReferralCode();

          await generateResult.fold(
            (failure) {
              log(
                'Failed to generate referral code: ${failure.message}',
                name: 'InviteFriendsCubit',
              );
              emit(
                state.copyWith(
                  isLoading: false,
                  errorMessage:
                      'Failed to generate referral code. Please try again.',
                ),
              );
            },
            (newCode) async {
              if (newCode.isNotEmpty) {
                log(
                  'Generated new referral code: $newCode',
                  name: 'InviteFriendsCubit',
                );
                // Reload stats to get full data with the new code
                final refreshedStats = await _referralRepository
                    .getReferralStats();
                log(
                  'getReferralStats() $refreshedStats',
                  name: 'InviteFriendsCubit',
                );
                refreshedStats.fold(
                  (failure) {
                    emit(
                      state.copyWith(
                        isLoading: false,
                        errorMessage:
                            'Failed to load referral data after generating code.',
                      ),
                    );
                  },
                  (refreshedData) {
                    emit(
                      state.copyWith(
                        isLoading: false,
                        inviteData: refreshedData,
                        errorMessage: null,
                      ),
                    );
                  },
                );
              } else {
                emit(
                  state.copyWith(
                    isLoading: false,
                    errorMessage:
                        'Failed to generate referral code. Please try again.',
                  ),
                );
              }
            },
          );
        } else {
          log(
            'Successfully loaded referral data: ${inviteData.referralCode}',
            name: 'InviteFriendsCubit',
          );
          emit(
            state.copyWith(
              isLoading: false,
              inviteData: inviteData,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  void copyReferralCode() {
    if (state.inviteData?.referralCode != null) {
      Clipboard.setData(ClipboardData(text: state.inviteData!.referralCode));
      emit(state.copyWith(isCopied: true));
      Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(isCopied: false));
      });
    }
  }

  Future<void> shareReferralCode() async {
    if (state.inviteData?.referralCode != null) {
      final shareText = _buildShareText();

      try {
        await SharePlus.instance.share(
          ShareParams(text: shareText, subject: 'Join me on LearnWay!'),
        );
      } catch (error) {
        log(
          'Failed to share referral code: $error',
          name: 'InviteFriendsCubit',
        );
      }
    }
  }

  void resetState() => emit(const InviteFriendsState());

  Future<bool> applyReferralCode(String code) async {
    emit(
      state.copyWith(
        isApplyingReferralCode: true,
        clearReferralApplyError: true,
      ),
    );
    final result = await _referralRepository.processReferral(code.trim());
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isApplyingReferralCode: false,
            referralApplyError: failure.message,
          ),
        );
        return false;
      },
      (data) {
        if (!data.isSuccess) {
          emit(
            state.copyWith(
              isApplyingReferralCode: false,
              referralApplyError: 'Referral code could not be applied.',
            ),
          );
          return false;
        }
        final updated = state.inviteData?.copyWith(hasUsedReferralCode: true);
        emit(
          state.copyWith(
            isApplyingReferralCode: false,
            inviteData: updated,
            clearReferralApplyError: true,
          ),
        );
        return true;
      },
    );
  }

  String _buildShareText() {
    final data = state.inviteData!;
    return '''
🎉 Join me on LearnWay and earn ${data.gemsForReferee} Gems!

Use my referral code: ${data.referralCode}

Download the app and start learning today

👉 https://onelink.to/q3ypvq
#LearnWay #Learning #Education
''';
  }
}
