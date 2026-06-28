import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/invite_friends/data_source/referral_data_source.dart';
import 'package:learnwayv2/features/invite_friends/models/invite_friends_model.dart';
import 'package:learnwayv2/features/invite_friends/models/referral_reward_response.dart';
import 'package:core/core.dart';

class ReferralFailure extends Failure {
  ReferralFailure(super.message);

  factory ReferralFailure.network() =>
      ReferralFailure('Network error occurred');
  factory ReferralFailure.server(String message) => ReferralFailure(message);
}

class ReferralRepository {
  factory ReferralRepository() => _instance;
  ReferralRepository._internal() {
    _referralDataSource = ReferralDataSource();
  }
  static final ReferralRepository _instance = ReferralRepository._internal();
  late ReferralDataSource _referralDataSource;

  /// Generate referral code for user
  Future<Either<Failure, String>> generateReferralCode() async {
    try {
      final result = await _referralDataSource.generateReferralCode();
      String? referralCode;

      if (result.containsKey('data') && result['data'] is Map) {
        referralCode = result['data']['referralCode'] as String?;
      } else if (result.containsKey('referralCode')) {
        referralCode = result['referralCode'] as String?;
      } else if (result.containsKey('code')) {
        referralCode = result['code'] as String?;
      }

      return Right(referralCode ?? '');
    } catch (e) {
      log('Error in generateReferralCode: $e', name: 'ReferralRepository');
      return Left(ReferralFailure(e.toString()));
    }
  }

  /// Process referral bonus for new user
  Future<Either<Failure, ReferralRewardResponse>> processReferral(
    String referralCode,
  ) async {
    try {
      final result = await _referralDataSource.processReferral(referralCode);
      final reward = ReferralRewardResponse.fromJson(result);
      log(
        'processReferral parsed: isSuccess=${reward.isSuccess}',
        name: 'ReferralRepository',
      );
      return Right(reward);
    } catch (e) {
      log('Error in processReferral: $e', name: 'ReferralRepository');
      final message = e.toString().replaceFirst('Exception: ', '');
      return Left(ReferralFailure.server(message));
    }
  }

  /// Get user referral statistics
  Future<Either<Failure, InviteFriendsModel>> getReferralStats() async {
    try {
      final result = await _referralDataSource.getReferralStats();
      Map<String, dynamic> data;
      if (result.containsKey('data') && result['data'] is Map) {
        data = result['data'] as Map<String, dynamic>;
      } else {
        data = result;
      }

      final inviteData = InviteFriendsModel.fromJson(data);
      log('getReferralStats parsed: ${inviteData.toJson()}');
      return Right(inviteData);
    } catch (e) {
      log('Error in getReferralStats: $e', name: 'ReferralRepository');
      return Left(ReferralFailure(e.toString()));
    }
  }

  /// Generate shareable referral link
  Future<Either<Failure, String>> generateShareLink() async {
    try {
      final result = await _referralDataSource.generateShareLink();
      return Right(result['shareLink'] as String? ?? '');
    } catch (e) {
      return Left(ReferralFailure(e.toString()));
    }
  }
}
