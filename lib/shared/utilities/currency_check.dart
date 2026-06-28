import 'dart:developer' as dev;

class CurrencyCheck {
  static String getLocalCurrencyCode(String country) {
    switch (country) {
      case 'Nigeria':
        return 'NGN';
      case 'Ghana':
        return 'GHS';
      case 'Kenya':
        return 'KES';
      case 'South Africa':
        return 'ZAR';
      case 'Uganda':
        return 'UGX';
      case 'Tanzania':
        return 'TZS';
      case 'Zambia':
        return 'ZMW';
      case 'Rwanda':
        return 'RWF';
      case 'Cameroon':
        return 'XAF';
      case 'Burkina Faso':
        return 'XOF';
      case 'Brasil':
        return 'BRL';
      case 'United Kingdom':
        return 'GBP';
      case 'United States':
        return 'USD';
      default:
        return 'EUR';
    }
  }

  static String getOffRampLocalCurrencyCode(String country) {
    switch (country) {
      case 'Nigeria':
        return 'NGN';
      case 'Ghana':
        return 'GHS';
      case 'Kenya':
        return 'KES';
      case 'South Africa':
        return 'ZAR';
      case 'Uganda':
        return 'UGX';
      case 'Tanzania':
        return 'TZS';
      case 'Zambia':
        return 'ZMW';
      case 'Rwanda':
        return 'RWF';
      case 'Cameroon':
        return 'XAF';
      case 'Burkina Faso':
        return 'XOF';
      case 'Benin':
        return 'XOF';
      case 'Republic of the Congo':
        return 'XAF';
      case 'Ivory Coast':
        return 'XOF';
      case 'Gabon':
        return 'XAF';
      case 'Senegal':
        return 'XOF';
      case 'Brasil':
        return 'BRL';
      case 'United Kingdom':
        return 'GBP';
      case 'United States':
        return 'USD';
      default:
        return 'EUR';
    }
  }

  static String getLocalCurrencyDisplayName(String country) {
    switch (country) {
      case 'Nigeria':
        return 'NGN';
      case 'Ghana':
        return 'GHS';
      case 'Kenya':
        return 'KES';
      case 'South Africa':
        return 'ZAR';
      case 'Tanzania':
        return 'TZS';
      case 'Uganda':
        return 'UGX';
      case 'Zambia':
        return 'ZMW';
      case 'Rwanda':
        return 'RWF';
      case 'Cameroon':
        return 'XAF';
      case 'Burkina Faso':
        return 'XOF';
      case 'Benin':
        return 'XOF';
      case 'Republic of the Congo':
        return 'XAF';
      case 'Ivory Coast':
        return 'XOF';
      case 'Gabon':
        return 'XAF';
      case 'Senegal':
        return 'XOF';
      case 'Brasil':
        return 'BRL';
      case 'United Kingdom':
        return 'GBP';
      case 'United States':
        return 'USD';
      default:
        return 'EUR';
    }
  }

  static String getCountryIsocode(String country) {
    switch (country.trim().toLowerCase()) {
      case 'nigeria':
        return 'NG';
      case 'ghana':
        return 'GH';
      case 'kenya':
        return 'KE';
      case 'south africa':
        return 'ZA';
      case 'tanzania':
        return 'TZ';
      case 'uganda':
        return 'UG';
      case 'zambia':
        return 'ZM';
      case 'rwanda':
        return 'RW';
      case 'cameroon':
        return 'CM';
      case 'burkina faso':
        return 'BF';
      case 'benin':
        return 'BJ';
      case 'republic of the congo':
        return 'CG';
      case 'ivory coast':
        return 'CI';
      case 'gabon':
        return 'GA';
      case 'senegal':
        return 'SN';
      case 'brasil':
      case 'brazil':
        return 'BR';
      case 'united kingdom':
        return 'GB';
      case 'united states':
        return 'US';
      default:
        return '';
    }
  }

  static List<String> getAvailablePaymentChannels(String country) {
    switch (country) {
      case 'Nigeria':
        return ['Bank Transfer'];
      case 'Ghana':
      case 'Kenya':
      case 'Tanzania':
      case 'Uganda':
      case 'Zambia':
      case 'Cameroon':
      case 'Burkina Faso':
      case 'Benin':
      case 'Republic of the Congo':
      case 'Ivory Coast':
      case 'Gabon':
      case 'Rwanda':
      case 'Senegal':
        return ['Mobile money'];
      case 'South Africa':
      case 'Brasil':
        return ['Bank Transfer'];
      default:
        return [];
    }
  }

  static List<CarrierInfo> getCarriersByCountryAndChannel(
    String country,
    String paymentChannel,
  ) {
    final key = '$country-$paymentChannel';

    dev.log('Looking up carriers for: $key', name: 'CurrencyCheck');

    switch (key) {
      case 'Nigeria-Bank Transfer':
      case 'Nigeria-bank':
        return [];

      case 'Kenya-Mobile money':
      case 'Kenya-mobile_money':
        return [
          CarrierInfo(
            name: 'Safaricom Kenya (M-PESA)',
            code: 'Safaricom Kenya',
          ),
        ];

      case 'Ghana-Mobile money':
      case 'Ghana-mobile_money':
        return [
          CarrierInfo(name: 'AirtelTigo Ghana', code: 'AirtelTigo Ghana'),
          CarrierInfo(name: 'MTN Ghana', code: 'MTN Ghana'),
          CarrierInfo(name: 'Vodafone Ghana', code: 'Vodafone Ghana'),
        ];

      case 'Tanzania-Mobile money':
      case 'Tanzania-mobile_money':
        return [
          CarrierInfo(name: 'Airtel Tanzania', code: 'Airtel Tanzania'),
          CarrierInfo(name: 'Halotel Tanzania', code: 'Halotel Tanzania'),
          CarrierInfo(name: 'Tigo Tanzania', code: 'Tigo Tanzania'),
          CarrierInfo(name: 'Vodacom Tanzania', code: 'Vodacom Tanzania'),
        ];

      case 'Uganda-Mobile money':
      case 'Uganda-mobile_money':
        return [
          CarrierInfo(name: 'Airtel Uganda', code: 'Airtel Uganda'),
          CarrierInfo(name: 'MTN Uganda', code: 'MTN Uganda'),
        ];

      case 'Zambia-Mobile money':
      case 'Zambia-mobile_money':
        return [
          CarrierInfo(name: 'Airtel Zambia', code: 'Airtel Zambia'),
          CarrierInfo(name: 'MTN Zambia', code: 'MTN Zambia'),
          CarrierInfo(name: 'Zamtel Zambia', code: 'Zamtel Zambia'),
        ];

      case 'Cameroon-Mobile money':
      case 'Cameroon-mobile_money':
        return [
          CarrierInfo(name: 'MTN Cameroon', code: 'MTN Cameroon'),
          CarrierInfo(name: 'Orange Cameroon', code: 'Orange Cameroon'),
        ];

      case 'Burkina Faso-Mobile money':
      case 'Burkina Faso-mobile_money':
        return [
          CarrierInfo(name: 'Onatel Burkina Faso', code: 'Onatel Burkina Faso'),
          CarrierInfo(name: 'Orange Burkina Faso', code: 'Orange Burkina Faso'),
        ];

      case 'Benin-Mobile money':
      case 'Benin-mobile_money':
        return [
          CarrierInfo(name: 'MTN Benin', code: 'MTN Benin'),
          CarrierInfo(name: 'Moov Benin', code: 'Moov Benin'),
        ];

      case 'Republic of the Congo-Mobile money':
      case 'Republic of the Congo-mobile_money':
        return [
          CarrierInfo(name: 'Airtel', code: 'Airtel'),
          CarrierInfo(
            name: 'MTN Republic of the Congo',
            code: 'MTN Republic of the Congo',
          ),
        ];

      case 'Ivory Coast-Mobile money':
      case 'Ivory Coast-mobile_money':
        return [
          CarrierInfo(name: 'MTN Ivory Coast', code: 'MTN Ivory Coast'),
          CarrierInfo(name: 'Orange Ivory Coast', code: 'Orange Ivory Coast'),
        ];

      case 'Gabon-Mobile money':
      case 'Gabon-mobile_money':
        return [CarrierInfo(name: 'Airtel Gabon', code: 'Airtel Gabon')];

      case 'Rwanda-Mobile money':
      case 'Rwanda-mobile_money':
        return [
          CarrierInfo(name: 'Airtel Rwanda', code: 'Airtel Rwanda'),
          CarrierInfo(name: 'MTN Rwanda', code: 'MTN Rwanda'),
        ];

      case 'Senegal-Mobile money':
      case 'Senegal-mobile_money':
        return [
          CarrierInfo(name: 'Free Senegal', code: 'Free Senegal'),
          CarrierInfo(name: 'Orange Senegal', code: 'Orange Senegal'),
        ];

      case 'South Africa-Bank Transfer':
      case 'South Africa-bank':
      case 'Brasil-Bank Transfer':
      case 'Brasil-bank':
        return [];

      default:
        dev.log('No carriers found for key: $key', name: 'CurrencyCheck');
        return [];
    }
  }

  static String getCarrierCodeByCountryAndChannel(
    String country,
    String paymentChannel,
  ) {
    final key = '$country-$paymentChannel';

    dev.log(
      'Getting carrier code for: $key',
      name: 'CurrencyCheck.getCarrierCode',
    );

    switch (key) {
      case 'Kenya-mobile_money':
      case 'Kenya-Mobile money':
        return 'ke_safaricom';

      case 'Ghana-mobile_money':
      case 'Ghana-Mobile money':
        return 'gh_mtn';

      case 'Uganda-mobile_money':
      case 'Uganda-Mobile money':
        return 'ug_mtn';

      case 'Tanzania-mobile_money':
      case 'Tanzania-Mobile money':
        return 'tz_vodacom';

      case 'Cameroon-mobile_money':
      case 'Cameroon-Mobile money':
        return 'cm_mtn';

      case 'Burkina Faso-mobile_money':
      case 'Burkina Faso-Mobile money':
        return 'bf_orange';

      case 'Benin-mobile_money':
      case 'Benin-Mobile money':
        return 'bj_mtn';

      case 'Republic of the Congo-mobile_money':
      case 'Republic of the Congo-Mobile money':
        return 'cg_mtn';

      case 'Ivory Coast-mobile_money':
      case 'Ivory Coast-Mobile money':
        return 'ci_mtn';

      case 'Gabon-mobile_money':
      case 'Gabon-Mobile money':
        return 'gb_airtel';

      case 'Rwanda-mobile_money':
      case 'Rwanda-Mobile money':
        return 'rw_mtn';

      case 'Senegal-mobile_money':
      case 'Senegal-Mobile money':
        return 'sn_orange';

      case 'Zambia-mobile_money':
      case 'Zambia-Mobile money':
        return 'zm_mtn';

      case 'Nigeria-bank':
      case 'Nigeria-Bank Transfer':
      case 'South Africa-bank':
      case 'South Africa-Bank Transfer':
      case 'Brasil-bank':
      case 'Brasil-Bank Transfer':
        return '';

      default:
        dev.log(
          'No carrier code found for: $key, returning empty string',
          name: 'CurrencyCheck.getCarrierCode',
        );
        return '';
    }
  }

  static String getSpecificCarrierCode(
    String country,
    String paymentChannel,
    String carrierName,
  ) {
    final key = '$country-$paymentChannel-$carrierName';

    dev.log(
      'Getting specific carrier code for: $key',
      name: 'CurrencyCheck.getSpecificCarrierCode',
    );

    switch (key) {
      case 'Kenya-mobile_money-Safaricom Kenya':
      case 'Kenya-Mobile money-Safaricom Kenya':
      case 'Kenya-mobile_money-Safaricom Kenya (M-PESA)':
      case 'Kenya-Mobile money-Safaricom Kenya (M-PESA)':
        return 'ke_safaricom';

      case 'Ghana-mobile_money-AirtelTigo Ghana':
      case 'Ghana-Mobile money-AirtelTigo Ghana':
        return 'gh_airtel_tigo';
      case 'Ghana-mobile_money-MTN Ghana':
      case 'Ghana-Mobile money-MTN Ghana':
        return 'gh_mtn';
      case 'Ghana-mobile_money-Vodafone Ghana':
      case 'Ghana-Mobile money-Vodafone Ghana':
        return 'gh_vodafone';

      case 'Uganda-mobile_money-Airtel Uganda':
      case 'Uganda-Mobile money-Airtel Uganda':
        return 'ug_airtel';
      case 'Uganda-mobile_money-MTN Uganda':
      case 'Uganda-Mobile money-MTN Uganda':
        return 'ug_mtn';

      case 'Tanzania-mobile_money-Airtel Tanzania':
      case 'Tanzania-Mobile money-Airtel Tanzania':
        return 'tz_airtel';
      case 'Tanzania-mobile_money-Halotel Tanzania':
      case 'Tanzania-Mobile money-Halotel Tanzania':
        return 'tz_halotel';
      case 'Tanzania-mobile_money-Tigo Tanzania':
      case 'Tanzania-Mobile money-Tigo Tanzania':
        return 'tz_tigo';
      case 'Tanzania-mobile_money-Vodacom Tanzania':
      case 'Tanzania-Mobile money-Vodacom Tanzania':
        return 'tz_vodacom';

      case 'Cameroon-mobile_money-MTN Cameroon':
      case 'Cameroon-Mobile money-MTN Cameroon':
        return 'cm_mtn';
      case 'Cameroon-mobile_money-Orange Cameroon':
      case 'Cameroon-Mobile money-Orange Cameroon':
        return 'cm_orange';

      case 'Burkina Faso-mobile_money-Onatel Burkina Faso':
      case 'Burkina Faso-Mobile money-Onatel Burkina Faso':
        return 'bf_onatel';
      case 'Burkina Faso-mobile_money-Orange Burkina Faso':
      case 'Burkina Faso-Mobile money-Orange Burkina Faso':
        return 'bf_orange';

      case 'Benin-mobile_money-BJ MTN Benin':
      case 'Benin-Mobile money-BJ MTN Benin':
      case 'Benin-mobile_money-MTN Benin':
      case 'Benin-Mobile money-MTN Benin':
        return 'bj_mtn';
      case 'Benin-mobile_money-Moov Benin':
      case 'Benin-Mobile money-Moov Benin':
        return 'bj_moov';

      case 'Republic of the Congo-mobile_money-CG Bharti Airtel':
      case 'Republic of the Congo-Mobile money-CG Bharti Airtel':
      case 'Republic of the Congo-mobile_money-Airtel':
      case 'Republic of the Congo-Mobile money-Airtel':
        return 'cg_airtel';
      case 'Republic of the Congo-mobile_money-MTN Republic of the Congo':
      case 'Republic of the Congo-Mobile money-MTN Republic of the Congo':
        return 'cg_mtn';

      case 'Ivory Coast-mobile_money-MTN Ivory Coast':
      case 'Ivory Coast-Mobile money-MTN Ivory Coast':
        return 'ci_mtn';
      case 'Ivory Coast-mobile_money-Orange Ivory Coast':
      case 'Ivory Coast-Mobile money-Orange Ivory Coast':
        return 'ci_orange';

      case 'Gabon-mobile_money-Airtel Gabon':
      case 'Gabon-Mobile money-Airtel Gabon':
        return 'gb_airtel';

      case 'Rwanda-mobile_money-Airtel Rwanda':
      case 'Rwanda-Mobile money-Airtel Rwanda':
        return 'rw_airtel';
      case 'Rwanda-mobile_money-MTN Rwanda':
      case 'Rwanda-Mobile money-MTN Rwanda':
        return 'rw_mtn';

      case 'Senegal-mobile_money-Free Senegal':
      case 'Senegal-Mobile money-Free Senegal':
        return 'sn_free';
      case 'Senegal-mobile_money-Orange Senegal':
      case 'Senegal-Mobile money-Orange Senegal':
        return 'sn_orange';

      case 'Zambia-mobile_money-Airtel Zambia':
      case 'Zambia-Mobile money-Airtel Zambia':
        return 'zm_airtel';
      case 'Zambia-mobile_money-MTN Zambia':
      case 'Zambia-Mobile money-MTN Zambia':
        return 'zm_mtn';
      case 'Zambia-mobile_money-Zamtel Zambia':
      case 'Zambia-Mobile money-Zamtel Zambia':
        return 'zm_zamtel';

      default:
        dev.log(
          'No specific carrier code found for: $key, returning empty string',
          name: 'CurrencyCheck.getSpecificCarrierCode',
        );
        return '';
    }
  }
}

class CarrierInfo {
  CarrierInfo({required this.name, required this.code});

  final String name;
  final String code;
}

class PhoneNumberUtils {
  static String getCountryPhoneCode(String country) {
    switch (country.trim().toLowerCase()) {
      case 'nigeria':
        return '234';
      case 'ghana':
        return '233';
      case 'kenya':
        return '254';
      case 'south africa':
        return '27';
      case 'tanzania':
        return '255';
      case 'uganda':
        return '256';
      case 'zambia':
        return '260';
      case 'rwanda':
        return '250';
      case 'cameroon':
        return '237';
      case 'burkina faso':
        return '226';
      case 'benin':
        return '229';
      case 'republic of the congo':
        return '242';
      case 'ivory coast':
        return '225';
      case 'gabon':
        return '241';
      case 'senegal':
        return '221';
      case 'brazil':
      case 'brasil':
        return '55';
      case 'united kingdom':
        return '44';
      case 'united states':
        return '1';
      default:
        return '';
    }
  }

  static String formatWithCountryCode(String phoneNumber, String country) {
    final countryCode = getCountryPhoneCode(country);
    if (countryCode.isEmpty) return phoneNumber;

    String cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    if (cleaned.startsWith(countryCode)) {
      return cleaned;
    }

    if (cleaned.startsWith('00$countryCode')) {
      return cleaned.substring(2);
    }

    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    return '$countryCode$cleaned';
  }

  static String? validatePhoneNumber(String? value, String country) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final countryCode = getCountryPhoneCode(country);

    if (!RegExp(r'^[\d\+]+$').hasMatch(cleaned)) {
      return 'Phone number can only contain digits';
    }
    String localNumber = cleaned;
    if (cleaned.startsWith('+$countryCode')) {
      localNumber = cleaned.substring(countryCode.length + 1);
    } else if (cleaned.startsWith(countryCode)) {
      localNumber = cleaned.substring(countryCode.length);
    } else if (cleaned.startsWith('0')) {
      localNumber = cleaned.substring(1);
    }

    if (localNumber.length < 8 || localNumber.length > 12) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
