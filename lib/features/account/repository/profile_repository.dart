import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/account/data/profile_data_source.dart';
import 'package:learnwayv2/features/account/exceptions/account_exceptions.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account/model/supported_language_response.dart';
import 'package:core/core.dart';

///
class ProfileRepository {
  ProfileRepository._() {
    profileDataSource = ProfileDataSource();
  }
  factory ProfileRepository() => _instance;
  static final ProfileRepository _instance = ProfileRepository._();
  late ProfileDataSource profileDataSource;
  Future<Either<AccountExceptions, bool>> deleteMyAccount() async {
    try {
      final result = await profileDataSource.deleteMyAccount();
      return Right(result);
    } catch (e) {
      return Left(AccountExceptions(e.toString()));
    }
  }

  Future<Either<AccountExceptions, UserAccountModel>> fetchUserData() async {
    try {
      final result = await profileDataSource.fetchUserData();
      return Right(result);
    } catch (e) {
      return Left(AccountExceptions(e.toString()));
    }
  }

  Future<Either<AccountExceptions, UserAccountModel>> updateUserProfile({
    String? username,
    String? email,
    String? phoneNumber,
    String? country,
    String? profileImagePath,
  }) async {
    try {
      final result = await profileDataSource.updateProfile(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        profileImagePath: profileImagePath,
      );
      return Right(result);
    } catch (e) {
      return Left(AccountExceptions(e.toString()));
    }
  }

  Future<Either<Failure, bool>> checkUserNames(String userName) async {
    try {
      final result = await profileDataSource.checkUserNames(userName);
      return Right(result);
    } on AccountExceptions catch (e) {
      return Left(AccountExceptions(e.message));
    }
  }

  Future<Either<Failure, String>> updateLanguagePref(String langPref) async {
    try {
      final result = await profileDataSource.updateUserLanguage(langPref);
      return Right(result.preferredLanguage);
    } on AccountExceptions catch (e) {
      return Left(AccountExceptions(e.message));
    }
  }

  Future<Either<Failure, List<Language>>> getSupportedLanguages() async {
    try {
      final result = await profileDataSource.fetchSupportedLanguages();
      return Right(result.data);
    } on AccountExceptions catch (e) {
      return Left(AccountExceptions(e.message));
    }
  }

  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await profileDataSource.logOut();
      return Right(result);
    } on AccountExceptions catch (e) {
      return Left(AccountExceptions(e.message));
    }
  }
}
