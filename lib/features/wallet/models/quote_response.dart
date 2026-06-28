import 'package:json_annotation/json_annotation.dart';

part 'quote_response.g.dart';

@JsonSerializable(explicitToJson: true)
class QuoteResponse {
  final String quoteId;
  final String quoteExpiresAt;
  final QuoteDeposit deposit;
  final QuotePayout payout;

  QuoteResponse({
    required this.quoteId,
    required this.quoteExpiresAt,
    required this.deposit,
    required this.payout,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> json) =>
      _$QuoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QuoteDeposit {
  final String paymentChannel;
  final String currencyType;
  final String currencyCode;
  final DepositCurrencyDetails currencyDetails;
  final Cashout cashout;
  final List<FieldToCreateOrder> fieldsToCreateOrder;
  final String transferType;

  QuoteDeposit({
    required this.paymentChannel,
    required this.currencyType,
    required this.currencyCode,
    required this.currencyDetails,
    required this.cashout,
    required this.fieldsToCreateOrder,
    required this.transferType,
  });

  factory QuoteDeposit.fromJson(Map<String, dynamic> json) =>
      _$QuoteDepositFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteDepositToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QuotePayout {
  final String paymentChannel;
  final String currencyType;
  final String currencyCode;
  final PayoutCurrencyDetails currencyDetails;
  final Cashout cashout;
  final List<FieldToCreateOrder> fieldsToCreateOrder;

  QuotePayout({
    required this.paymentChannel,
    required this.currencyType,
    required this.currencyCode,
    required this.currencyDetails,
    required this.cashout,
    required this.fieldsToCreateOrder,
  });

  factory QuotePayout.fromJson(Map<String, dynamic> json) =>
      _$QuotePayoutFromJson(json);

  Map<String, dynamic> toJson() => _$QuotePayoutToJson(this);
}

@JsonSerializable()
class DepositCurrencyDetails {
  final String? network;
  final String? asset;
  final String? contractAddress;

  DepositCurrencyDetails({
    this.network,
    this.asset,
    this.contractAddress,
  });

  factory DepositCurrencyDetails.fromJson(Map<String, dynamic> json) =>
      _$DepositCurrencyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DepositCurrencyDetailsToJson(this);
}

@JsonSerializable()
class PayoutCurrencyDetails {
  final String? countryIsoCode;

  PayoutCurrencyDetails({
    this.countryIsoCode,
  });

  factory PayoutCurrencyDetails.fromJson(Map<String, dynamic> json) =>
      _$PayoutCurrencyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutCurrencyDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Cashout {
  final double amountBeforeFees;
  final double amountAfterFees;
  final List<ChargedFee> chargedFees;
  final double totalChargedFees;
  final Map<String, double> chargedFeesPerRecipient;
  final double amountBeforeFeesUsd;
  final double amountAfterFeesUsd;
  final List<ChargedFee> chargedFeesUsd;
  final double totalChargedFeesUsd;
  final double exchangeRate;
  final double exchangeRateAfterFees;
  final Map<String, double> chargedFeesPerRecipientUsd;
  final List<FeeSetting> feeSettings;

  Cashout({
    required this.amountBeforeFees,
    required this.amountAfterFees,
    required this.chargedFees,
    required this.totalChargedFees,
    required this.chargedFeesPerRecipient,
    required this.amountBeforeFeesUsd,
    required this.amountAfterFeesUsd,
    required this.chargedFeesUsd,
    required this.totalChargedFeesUsd,
    required this.exchangeRate,
    required this.exchangeRateAfterFees,
    required this.chargedFeesPerRecipientUsd,
    required this.feeSettings,
  });

  factory Cashout.fromJson(Map<String, dynamic> json) =>
      _$CashoutFromJson(json);

  Map<String, dynamic> toJson() => _$CashoutToJson(this);
}

@JsonSerializable()
class ChargedFee {
  final String id;
  final String type;
  final String recipient;
  final double amount;

  ChargedFee({
    required this.id,
    required this.type,
    required this.recipient,
    required this.amount,
  });

  factory ChargedFee.fromJson(Map<String, dynamic> json) =>
      _$ChargedFeeFromJson(json);

  Map<String, dynamic> toJson() => _$ChargedFeeToJson(this);
}

@JsonSerializable()
class FeeSetting {
  final String id;
  final String type;
  final double value;
  final double min;
  final dynamic max;
  final String recipient;

  FeeSetting({
    required this.id,
    required this.type,
    required this.value,
    required this.min,
    required this.max,
    required this.recipient,
  });

  factory FeeSetting.fromJson(Map<String, dynamic> json) =>
      _$FeeSettingFromJson(json);

  Map<String, dynamic> toJson() => _$FeeSettingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FieldToCreateOrder {
  final String key;
  final String type;
  final String label;
  final bool required;
  final String? defaultValue;
  final List<FieldOption>? options;

  FieldToCreateOrder({
    required this.key,
    required this.type,
    required this.label,
    required this.required,
    this.defaultValue,
    this.options,
  });

  factory FieldToCreateOrder.fromJson(Map<String, dynamic> json) =>
      _$FieldToCreateOrderFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToCreateOrderToJson(this);
}

@JsonSerializable()
class FieldOption {
  final String? value;
  final String label;

  FieldOption({
    this.value,
    required this.label,
  });

  factory FieldOption.fromJson(Map<String, dynamic> json) =>
      _$FieldOptionFromJson(json);

  Map<String, dynamic> toJson() => _$FieldOptionToJson(this);
}
