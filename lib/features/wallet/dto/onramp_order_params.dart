import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

class OnRampOrderParams {
  const OnRampOrderParams({
    required this.fiatCurrency,
    required this.fiatAmount,
    required this.depositChannel,
    required this.cryptoCurrency,
    required this.cryptoNetwork,
    required this.countryCode,
    required this.userEmail,
    required this.quoteId,
    this.phoneNumber,
    this.fullName,
    this.carrierCode,
    this.bankCode,
    this.bankAccountNumber,
    this.metadata,
  });

  final String fiatCurrency;
  final double fiatAmount;
  final String depositChannel;
  final String cryptoCurrency;
  final String cryptoNetwork;
  final String countryCode;
  final String userEmail;
  final String quoteId;
  final String? phoneNumber;
  final String? fullName;
  final String? carrierCode;
  final String? bankCode;
  final String? bankAccountNumber;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
    'fiatCurrency': fiatCurrency,
    'fiatAmount': fiatAmount,
    'depositChannel': depositChannel,
    'cryptoCurrency': cryptoCurrency,
    'cryptoNetwork': cryptoNetwork,
    'countryCode': countryCode,
    'userEmail': userEmail,
    'blockchainWalletAddress': LocalStorageService.getUserSync()?.walletAddress,
    'quoteId': quoteId,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (fullName != null) 'fullName': fullName,
    if (carrierCode != null) 'carrierCode': carrierCode,
    if (bankCode != null) 'bankCode': bankCode,
    if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
    if (metadata != null) 'metadata': metadata,
  };
}
