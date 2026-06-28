import 'package:learnwayv2/services/defi_service/models/mobile_money_request.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_response.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_withdrawal_request.dart';
import 'package:learnwayv2/services/defi_service/models/mobile_money_withdrawal_response.dart';
import 'package:learnwayv2/services/defi_service/models/offramp_rates_response.dart';
import 'package:learnwayv2/services/defi_service/models/offramp_status_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_best_offer_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_rates_response.dart';
import 'package:learnwayv2/services/defi_service/models/onramp_status_response.dart';

abstract class IMobileMoneyRepository {
  Future<MobileMoneyDepositResponse> depositWithMobileMoney({
    required MobileMoneyDepositRequest request,
  });

  Future<MobileMoneyWithdrawalResponse> withdrawToMobileMoney({
    required MobileMoneyWithdrawalRequest request,
  });

  Future<OnRampStatusResponse> getOnRampStatus({required String referenceId});
  Future<OfframpStatusResponse> getOffRampStatus({required String referenceId});
  Future<OnRampRateResponse> getOnRampRates({
    required String from,
    required String to,
    required int fiatAmount,
  });

  Future<OnRampBestOfferResponse> getOnRampBestOffers({
    required String amount,
    required String countryIsoCode,
    required String paymentChannel,
  });

  Future<OffRampRatesResponse> getOffRampRates({
    required String from,
    required String to,
    required int fiatAmount,
  });

  Future<OfframpStatusResponse> cancelWithdrawal({
    required String referenceId,
  });
}
