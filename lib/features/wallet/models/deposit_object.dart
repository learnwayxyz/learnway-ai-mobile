class DepositObject {
  DepositObject({
    required this.address,
    required this.network,
    required this.asset,
    required this.amount,
    required this.currency,
    required this.countryIsoCode,
    required this.paymentChannel,
    this.currencyIsoCode,
    this.carierCode,
  });

  final String address;
  final String network;
  final String asset;
  final String amount;
  final String currency;
  final String countryIsoCode;
  final String paymentChannel;
  final String? currencyIsoCode;
  final String? carierCode;

  Map<String, String> toJson() => {
    'address': address,
    'network': network,
    'asset': asset,
    'amount': amount,
    'currency': currency,
    'countryIsoCode': countryIsoCode,
    'currencyIsoCode': currencyIsoCode ?? '',
    'paymentChannel': paymentChannel,
    'carierCode': carierCode ?? '',
  };

  factory DepositObject.fromJson(Map<String, dynamic> json) => DepositObject(
    address: json['address'] as String? ?? '',
    network: json['network'] as String,
    asset: json['asset'] as String,
    amount: json['amount']?.toString() ?? '',
    currency: json['currency'] as String,
    countryIsoCode: json['countryIsoCode'] as String,
    paymentChannel: json['paymentChannel'] as String,
    currencyIsoCode: json['currencyIsoCode'] as String? ?? '',
    carierCode: json['carierCode'] as String? ?? '',
  );

  @override
  String toString() =>
      'address: $address network: $network asset: $asset amount: $amount currency: $currency countryIsoCode: $countryIsoCode paymentChannel: $paymentChannel';
}
