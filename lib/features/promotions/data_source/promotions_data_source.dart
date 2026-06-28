import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/promotions/model/promotions_response.dart';
import 'package:learnwayv2/features/promotions/promotions_exception.dart';

class PromotionsDataSource {
  final _client = locator<BaseApiClients>();

  Future<PromotionsResponse> fetchActivePromotions({
    String? country,
    String? language,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (country != null && country.isNotEmpty) {
        queryParams['country'] = country;
      }
      if (language != null && language.isNotEmpty) {
        queryParams['language'] = language;
      }

      dev.log(
        'Fetching promotions — params: $queryParams',
        name: 'PromotionsDataSource',
      );

      final response = await _client.get(
        Endpoints.getActivePromotions,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      dev.log(
        'Promotions response — status: ${response.statusCode} body: ${response.body}',
        name: 'PromotionsDataSource',
      );

      if (response.statusCode != 200) {
        throw PromotionsFailure(
          'Failed to load promotions: ${response.statusCode}',
        );
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final result = PromotionsResponse.fromJson(decoded);

      dev.log(
        'Parsed promotions — popup: ${result.popup?.id} (${result.popup?.title}), '
        'banners: ${result.banners.length} item(s) '
        '${result.banners.map((b) => b.id).toList()}',
        name: 'PromotionsDataSource',
      );

      return result;
    } on SocketException {
      dev.log(
        'Promotions fetch failed — no internet',
        name: 'PromotionsDataSource',
      );
      throw PromotionsFailure('No internet connection');
    } on PromotionsFailure {
      rethrow;
    } catch (e, st) {
      dev.log(
        'Promotions fetch failed — $e',
        stackTrace: st,
        name: 'PromotionsDataSource',
      );
      throw PromotionsFailure('Unexpected error: $e');
    }
  }

  Future<void> trackEvent({
    required String campaignId,
    required String eventType,
    String? country,
  }) async {
    try {
      final body = <String, dynamic>{'eventType': eventType};
      if (country != null && country.isNotEmpty) {
        body['country'] = country;
      }

      dev.log(
        'Tracking promo event — campaign: $campaignId type: $eventType country: $country',
        name: 'PromotionsDataSource',
      );

      final response = await _client.post(
        '${Endpoints.promotionEvent}/$campaignId/event',
        body: body,
      );

      dev.log(
        'Promo event response — status: ${response.statusCode}',
        name: 'PromotionsDataSource',
      );
    } catch (e) {
      dev.log('Promo event tracking failed: $e', name: 'PromotionsDataSource');
    }
  }
}
