import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account_setup/set_up_data_source/set_up_data_source.dart';
import 'package:learnwayv2/features/account_setup/set_up_repository/set_up_user_model.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/auth_exception.dart';
import 'package:core/core.dart';
import 'package:variance_dart/variance_dart.dart';

class SetUpRepository {
  factory SetUpRepository() => _instance;
  SetUpRepository._internal() {
    _setUpDataSource = SetUpDataSource();
  }
  static final SetUpRepository _instance = SetUpRepository._internal();
  late SetUpDataSource _setUpDataSource;

  Future<Either<Failure, (SetUpUserModel, SmartWallet?)>> setUpWallet({
    String? userName,
    String? country,
    AuthProvider? authProvider,
    String? userEmail,
    String? referralCode,
    String? profileImage,
    String? userPassphrase,
  }) async {
    try {
      final result = await _setUpDataSource.setUpAccount(
        userName: userName ?? '',
        country: country ?? '',
        authProvider: authProvider,
        userEmail: userEmail ?? '',
        referralCode: referralCode,
        profileImagePath: profileImage ?? '',
      );
      return Right((SetUpUserModel.fromJson(result.$1.toJson()), result.$2));
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  Future<Either<Failure, bool>> checkUserNames(String userName) async {
    try {
      final result = await _setUpDataSource.checkUserNames(userName);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  Future<Either<Failure, UserAccountModel>> fetchUserData() async {
    try {
      final result = await _setUpDataSource.fetchUserData();
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
