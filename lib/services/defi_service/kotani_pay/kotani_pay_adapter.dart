import 'dart:convert';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:learnwayv2/core/di/locator.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/services/defi_service/api_helper.dart';
import 'package:learnwayv2/services/defi_service/interfaces/mobile_interface.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_request.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_response.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_withdrawal_request.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_withdrawal_response.dart';
import 'package:learnwayv2/services/defi_service/models/offramp_rates_response.dart';
import 'package:learnwayv2/services/defi_service/models/offramp_status_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_best_offer_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_rates_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_status_response.dart';
import 'package:learnwayv2/services/defi_service/defi_service_exception.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/src/config/env/env.dart';

class KotaniPayAdapter implements IMobileMoneyRepository {
  KotaniPayAdapter({required this.apiClient});
  final BaseApiClients apiClient;
  final apiConfig = locator.get<ApiConfigResponse>();
  @override
  Future<MobileMoneyDepositResponse> depositWithMobileMoney({
    required MobileMoneyDepositRequest request,
  }) async {
    return await safeApiCall(() async {
      final header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${apiConfig.kotaniPayKey}',
      };
      final body = {
        "mobileMoney": {
          "phoneNumber": request.mobileMoneyObjects?.phoneNumber,
          "accountName": request.mobileMoneyObjects?.accountName,
          "providerNetwork": request.mobileMoneyObjects?.networkProvider,
        },
        "currency": request.currency.name.toUpperCase(),
        "chain": request.chain.name.toUpperCase(),
        "token": request.token.name.toUpperCase(),
        "fiatAmount": request.fiatAmount,
        "receiverAddress": request.receiverAddress,
        "referenceId": request.referenceId,
      };
      final url = Uri.parse('${Env.kotanBaseUrl}onramp');
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: header,
      );

      log(
        'Mobile money deposit response: ${"header: ${header.toString()}, response: ${response.body} url: $url body: ${request.toJson()}"}',
      );
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Mobile money deposit successful: ${response.body}');
        return MobileMoneyDepositResponse.fromJson(decoded);
      } else {
        throw OnRampFailure.server(
          decoded['message'] ??
              'Failed to process mobile money deposit: ${response.statusCode}',
        );
      }
    });
  }

  @override
  Future<OnRampStatusResponse> getOnRampStatus({
    required String referenceId,
  }) async {
    return await safeApiCall(() async {
      final response = await http.get(
        Uri.parse('${Env.kotanBaseUrl}onramp/crypto/$referenceId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiConfig.kotaniPayKey}',
        },
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        log('OnRamp status retrieved: ${response.body}');
        return OnRampStatusResponse.fromJson(decoded);
      }

      throw OnRampFailure.server(
        decoded['message'] ??
            'Failed to get onramp status: ${response.statusCode}',
      );
    });
  }

  @override
  Future<OnRampRateResponse> getOnRampRates({
    required String from,
    required String to,
    required int fiatAmount,
  }) {
    return safeApiCall(() async {
      final response = await http.post(
        Uri.parse('${Env.kotanBaseUrl}rate/onramp'),
        body: json.encode({'from': from, 'to': to, 'fiatAmount': fiatAmount}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiConfig.kotaniPayKey}',
        },
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('OnRamp rates retrieved: ${response.body}');
        return OnRampRateResponse.fromJson(decoded);
      }

      throw OnRampFailure.server(
        decoded['message'] ??
            'Failed to get onramp rates: ${response.statusCode}',
      );
    });
  }

  @override
  Future<OnRampBestOfferResponse> getOnRampBestOffers({
    required String amount,
    required String countryIsoCode,
    required String paymentChannel,
  }) async {
    throw UnimplementedError(
      'getOnRampBestOffers is not supported by KotaniPay adapter.',
    );
  }

  @override
  Future<OffRampRatesResponse> getOffRampRates({
    required String from,
    required String to,
    required int fiatAmount,
  }) {
    return safeApiCall(() async {
      final data = json.encode({
        'from': from,
        'to': to,
        'fiatAmount': fiatAmount,
      });
      final response = await http.post(
        Uri.parse('${Env.kotanBaseUrl}rate/offramp'),
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Env.kotanApiKey}',
        },
      );
      final decoded = json.decode(response.body);
      log('OffRamp rates before decoding: ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        log('OffRamp rates retrieved: ${response.body}');
        return OffRampRatesResponse.fromJson(decoded);
      }

      throw OnRampFailure.server(
        decoded['message'] ??
            'Failed to get OffRamp rates: ${response.statusCode}',
      );
    });
  }

  @override
  Future<MobileMoneyWithdrawalResponse> withdrawToMobileMoney({
    required MobileMoneyWithdrawalRequest request,
  }) {
    return safeApiCall(() async {
      final body = {
        "mobileMoneyReceiver": {
          "phoneNumber": request.mobileMoneyObjects.phoneNumber,
          "accountName": request.mobileMoneyObjects.accountName,
          "networkProvider": request.mobileMoneyObjects.networkProvider,
        },
        "currency": request.currency.name.toUpperCase(),
        "chain": request.chain.name.toUpperCase(),
        "token": request.token.name.toUpperCase(),
        "cryptoAmount": request.cryptoAmount,
        "referenceId": request.referenceId,
        "senderAddress": LocalStorageService.getUserSync()!.walletAddress,
      };
      log('Withdrawal request: ${json.encode(body)}');
      final response = await http.post(
        Uri.parse('${Env.kotanBaseUrl}offramp'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${apiConfig.kotaniPayKey}',
        },
      );

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        log('Mobile money withdrawal successful: ${response.body}');
        return MobileMoneyWithdrawalResponse.fromJson(decoded);
      } else {
        final decoded = json.decode(response.body);
        log('Mobile money withdrawal failed: ${response.body}');
        throw OnRampFailure.server(
          decoded['message'] ??
              'Failed to process mobile money withdrawal: ${response.statusCode}',
        );
      }
    });
  }

  @override
  Future<OfframpStatusResponse> getOffRampStatus({
    required String referenceId,
  }) async {
    return await safeApiCall(() async {
      final response = await http.get(
        Uri.parse('${Env.kotanBaseUrl}offramp/$referenceId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Env.kotanApiKey}',
        },
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        log('OnRamp status retrieved: ${response.body}');
        return OfframpStatusResponse.fromJson(decoded);
      }

      throw OnRampFailure.server(
        decoded['message'] ??
            'Failed to get onramp status: ${response.statusCode}',
      );
    });
  }

  @override
  Future<OfframpStatusResponse> cancelWithdrawal({
    required String referenceId,
  }) async {
    return await safeApiCall(() async {
      final response = await http.get(
        Uri.parse('${Env.mainnetKotaniBaseUrl}offramp/cancel/$referenceId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiConfig.kotaniPayKey}',
        },
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        log('OnRamp status retrieved: ${response.body}');
        return OfframpStatusResponse.fromJson(decoded);
      }

      throw OnRampFailure.server(
        decoded['message'] ??
            'Failed to get onramp status: ${response.statusCode}',
      );
    });
  }
}
