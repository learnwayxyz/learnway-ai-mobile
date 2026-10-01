import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/features/wallet/fonbnk_config.dart';

class CreateOrderParams extends Equatable {
  const CreateOrderParams({
    required this.cryptoCurrency,
    required this.fiatCurrency,
    required this.cryptoAmount,
    required this.payoutDetails,
    required this.countryCode,
    required this.userEmail,
    required this.quoteId,
  });

  final String cryptoCurrency;
  final String fiatCurrency;
  final double cryptoAmount;
  final PayoutDetails payoutDetails;
  final String countryCode;
  final String userEmail;
  final String quoteId;

  Map<String, dynamic> toJson() {
    return {
      'cryptoCurrency': cryptoCurrency,
      'cryptoNetwork': FonbnkConfig.network,
      'fiatCurrency': fiatCurrency,
      'cryptoAmount': cryptoAmount,
      'countryCode': countryCode,
      'userEmail': userEmail,
      'blockchainWalletAddress':
          LocalStorageService.getUserSync()?.walletAddress,
      ...toPayoutDetailsJson(),
      'quoteId': quoteId,
    };
  }

  Map<String, dynamic> toPayoutDetailsJson() {
    return switch (payoutDetails) {
      MobileMoneyPayoutDetails details => {
        'phoneNumber': details.phoneNumber,
        'carrierCode': details.carrierCode,
        'payoutChannel': details.channelType,
        'fullName': details.fullName,
      },
      BankPayoutDetails details => {
        'phoneNumber': details.phoneNumber,
        'bankAccountNumber': details.accountNumber,
        'bankCode': details.bankCode,
        'payoutChannel': details.channelType,
      },

      AirtimePayoutDetails details => {
        'phoneNumber': details.phoneNumber,
        'carrierCode': details.carrierCode,
        'payoutChannel': details.channelType,
      },
    };
  }

  @override
  List<Object?> get props => [
    cryptoCurrency,
    fiatCurrency,
    cryptoAmount,
    payoutDetails,
    countryCode,
    userEmail,
  ];
}
