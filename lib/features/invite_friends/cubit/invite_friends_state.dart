import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/invite_friends/models/invite_friends_model.dart';

class InviteFriendsState extends Equatable {
  final bool isLoading;
  final InviteFriendsModel? inviteData;
  final String? errorMessage;
  final bool isSharing;
  final bool isCopied;
  final bool isApplyingReferralCode;
  final String? referralApplyError;

  const InviteFriendsState({
    this.isLoading = false,
    this.inviteData,
    this.errorMessage,
    this.isSharing = false,
    this.isCopied = false,
    this.isApplyingReferralCode = false,
    this.referralApplyError,
  });

  InviteFriendsState copyWith({
    bool? isLoading,
    InviteFriendsModel? inviteData,
    String? errorMessage,
    bool? isSharing,
    bool? isCopied,
    bool? isApplyingReferralCode,
    String? referralApplyError,
    bool clearReferralApplyError = false,
  }) {
    return InviteFriendsState(
      isLoading: isLoading ?? this.isLoading,
      inviteData: inviteData ?? this.inviteData,
      errorMessage: errorMessage ?? this.errorMessage,
      isSharing: isSharing ?? this.isSharing,
      isCopied: isCopied ?? this.isCopied,
      isApplyingReferralCode: isApplyingReferralCode ?? this.isApplyingReferralCode,
      referralApplyError: clearReferralApplyError ? null : referralApplyError ?? this.referralApplyError,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    inviteData,
    errorMessage,
    isSharing,
    isCopied,
    isApplyingReferralCode,
    referralApplyError,
  ];
}
