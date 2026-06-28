import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/promotions/data_source/promotions_data_source.dart';
import 'package:learnwayv2/features/promotions/model/promotions_response.dart';
import 'package:learnwayv2/features/promotions/promotions_exception.dart';

class PromotionsRepository {
  PromotionsRepository._internal() {
    _dataSource = PromotionsDataSource();
  }

  factory PromotionsRepository() => _instance;

  static final PromotionsRepository _instance =
      PromotionsRepository._internal();

  late final PromotionsDataSource _dataSource;

  Future<Either<PromotionsFailure, PromotionsResponse>> fetchActivePromotions({
    String? country,
    String? language,
  }) async {
    try {
      final result = await _dataSource.fetchActivePromotions(
        country: country,
        language: language,
      );
      return Right(result);
    } on PromotionsFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(PromotionsFailure(e.toString()));
    }
  }

  void trackEvent({
    required String campaignId,
    required String eventType,
    String? country,
  }) {
    _dataSource.trackEvent(
      campaignId: campaignId,
      eventType: eventType,
      country: country,
    );
  }
}
