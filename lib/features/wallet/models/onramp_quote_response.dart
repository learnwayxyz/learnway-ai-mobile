import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/wallet/models/quote_response.dart';

part 'onramp_quote_response.g.dart';

@JsonSerializable()
class OnRampQuoteResponse {
  const OnRampQuoteResponse({
    required this.quoteId,
    required this.quoteExpiresAt,
    required this.deposit,
    required this.payout,
  });

  final String quoteId;
  final String quoteExpiresAt;
  final OnRampQuoteChannel deposit;
  final OnRampQoteCurrencyDetails payout;

  factory OnRampQuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampQuoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQuoteResponseToJson(this);
}

@JsonSerializable()
class OnRampQuoteChannel {
  const OnRampQuoteChannel({
    required this.paymentChannel,
    required this.currencyType,
    required this.currencyCode,
    required this.currencyDetails,
    required this.cashout,
    required this.fieldsToCreateOrder,
  });

  final String paymentChannel;
  final String currencyType;
  final String currencyCode;
  final OnRampQoteCurrencyDetails currencyDetails;
  final OnRampQuoteCashout cashout;
  final List<OnRampQuoteFieldToCreateOrder> fieldsToCreateOrder;

  factory OnRampQuoteChannel.fromJson(Map<String, dynamic> json) =>
      _$OnRampQuoteChannelFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQuoteChannelToJson(this);
}

@JsonSerializable()
class OnRampQoteCurrencyDetails {
  const OnRampQoteCurrencyDetails({
    this.countryIsoCode,
    this.network,
    this.asset,
  });

  final String? countryIsoCode;
  final String? network;
  final String? asset;

  factory OnRampQoteCurrencyDetails.fromJson(Map<String, dynamic> json) =>
      _$OnRampQoteCurrencyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQoteCurrencyDetailsToJson(this);
}

@JsonSerializable()
class OnRampQuoteCashout {
  const OnRampQuoteCashout({
    required this.amountBeforeFees,
    required this.amountAfterFees,
    required this.exchangeRate,
    required this.totalChargedFees,
    this.chargedFees,
  });

  final double amountBeforeFees;
  final double amountAfterFees;
  final double exchangeRate;
  final double totalChargedFees;
  final List<OnRampQuoteChargedFee>? chargedFees;

  factory OnRampQuoteCashout.fromJson(Map<String, dynamic> json) =>
      _$OnRampQuoteCashoutFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQuoteCashoutToJson(this);
}

@JsonSerializable()
class OnRampQuoteChargedFee {
  const OnRampQuoteChargedFee({
    required this.id,
    required this.type,
    required this.recipient,
    required this.amount,
  });

  final String id;
  final String type;
  final String recipient;
  final double amount;

  factory OnRampQuoteChargedFee.fromJson(Map<String, dynamic> json) =>
      _$OnRampQuoteChargedFeeFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQuoteChargedFeeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OnRampQuoteFieldToCreateOrder {
  const OnRampQuoteFieldToCreateOrder({
    required this.key,
    required this.label,
    required this.required,
    required this.type,
    this.options,
  });

  final String key;
  final String label;
  final bool required;
  final String type;
  final List<FieldOption>? options;

  factory OnRampQuoteFieldToCreateOrder.fromJson(Map<String, dynamic> json) =>
      _$OnRampQuoteFieldToCreateOrderFromJson(json);

  Map<String, dynamic> toJson() => _$OnRampQuoteFieldToCreateOrderToJson(this);
}
