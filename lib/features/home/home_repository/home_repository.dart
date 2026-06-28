import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/home/home_data_source/home_data_source.dart';
import 'package:learnwayv2/features/home/home_exception.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';

class HomeRepository {
  factory HomeRepository() => _instance;
  HomeRepository._internal() {
    _homeDataSource = HomeDataSource();
  }
  static final HomeRepository _instance = HomeRepository._internal();
  late final HomeDataSource _homeDataSource;
  Future<Either<HomeFailure, UserProfileModel>> fetchHomeData() async {
    try {
      final result = await _homeDataSource.fetchHomeData();
      return Right(result);
    } on HomeFailure catch (e) {
      return Left(HomeFailure(e.message));
    } on Exception catch (e) {
      return Left(HomeFailure(e.toString()));
    }
  }
}
