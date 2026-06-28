import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:learnwayv2/features/auth/auth_data_source/auth_models/auth_response.dart';
import 'package:learnwayv2/features/auth/auth_data_source/remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/auth_exception.dart';
import 'package:core/core.dart';

class AuthRepository {
  factory AuthRepository() => instance;
  AuthRepository._internal() {
    _remoteDataSource = RemoteDataSource();
  }
  static final AuthRepository instance = AuthRepository._internal();

  late final RemoteDataSource _remoteDataSource;

  Future<Either<Failure, fb.UserCredential>> signInWithGoogle({
    String accountType = '',
  }) async {
    try {
      final result = await _remoteDataSource.signInWithGoogle(
        accountType: accountType,
      );
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, AuthResponse>> loginUser(
    String email,
    AuthProvider authProvider,
  ) async {
    try {
      final result = await _remoteDataSource.loginUser(email, authProvider);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, AuthResponse>> loginWithOtp(
    String email,
    String otp,
  ) async {
    try {
      final result = await _remoteDataSource.loginWithOtp(email, otp);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, fb.UserCredential>> registerwithApple() async {
    try {
      final result = await _remoteDataSource.signInWithApple();
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> verifyEmail(String email) async {
    try {
      final result = await _remoteDataSource.verifyEmail(email);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtp(email: email, otp: otp);
      return Right(result);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  ///signout method
  ///
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Right(0);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message.toString()));
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
