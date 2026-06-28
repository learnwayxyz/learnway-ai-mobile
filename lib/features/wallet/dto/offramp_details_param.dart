import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';

class OffRampDetailsParam {
  OffRampDetailsParam({
    required this.formattedPhoneNumber,
    required this.amountInUsdt,
    required this.amountToReceieve,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.carrierName,
    required this.offRampData,
  });
  final String formattedPhoneNumber;
  final double amountInUsdt;
  final double amountToReceieve;
  final double exchangeRate;
  final String paymentChannel;
  final String localCurrency;
  final String carrierName;
  final StoreOffRampScreenTranscientData offRampData;
}
