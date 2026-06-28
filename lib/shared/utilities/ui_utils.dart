import 'dart:developer';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';

final screenHeight = MediaQuery.of(
  appRouter.navigatorKey.currentState!.context,
).size.height;
final screenWidth = MediaQuery.of(
  appRouter.navigatorKey.currentState!.context,
).size.width;

const List<String> supportedCountries = [
  'Nigeria',
  'Ghana',
  'Kenya',
  'Tanzania',
  'Uganda',
  'Zambia',
  'South Africa',
  'Brasil',
  'Rwanda',
  'Cameroon',
  'Burkina Faso',
  'Benin',
  'Republic of the Congo',
  'Ivory Coast',
  'Gabon',
  'Senegal',
];

(String, String, String)? getCurrentUserFlag() {
  final countryPicker = FlCountryCodePicker();
  final userCurrentCountry = LocalStorageService.getUserSync()?.country;
  if (userCurrentCountry == null) return null;
  final flag = countryPicker.countryCodes.where(
    (e) => e.name == userCurrentCountry,
  );
  log('Flag: ${flag.first.flagUri}');
  return (
    flag.first.flagUri,
    flag.first.name,
    CurrencyCheck.getLocalCurrencyDisplayName(userCurrentCountry),
  );
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = MediaQuery.of(
    appRouter.navigatorKey.currentState!.context,
  ).size.height;
  return inputHeight * (screenHeight / 917);
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = MediaQuery.of(
    appRouter.navigatorKey.currentState!.context,
  ).size.width;
  return inputWidth * (screenWidth / 375.0);
}

double getScreenFontSize(double inputFontSize) {
  double screenHeight = MediaQuery.of(
    appRouter.navigatorKey.currentState!.context,
  ).size.height;
  return inputFontSize * (screenHeight / 917);
}

String shortenAddress(String address) {
  if (address.length < 10) return address;
  return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
}

void showSnackBar(
  String msg,
  BuildContext context, {
  bool showAction = false,
  Function? onPressedAction,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: showAction ? TextAlign.start : TextAlign.center,
        style: AppTextStyles.smRegular(
          context,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    ),
  );
}

BigInt convertToWei(String amount, int decimals) {
  if (amount.contains('.')) {
    final parts = amount.split('.');
    final wholePart = parts[0];
    var decimalPart = parts[1];
    if (decimalPart.length > decimals) {
      decimalPart = decimalPart.substring(0, decimals);
    } else {
      decimalPart = decimalPart.padRight(decimals, '0');
    }

    return BigInt.parse(wholePart + decimalPart);
  } else {
    return BigInt.parse(amount) * BigInt.from(10).pow(decimals);
  }
}

String normalizeAddress(String address) {
  if (address.startsWith('0X')) {
    return '0x${address.substring(2)}';
  }
  return address;
}

String formatScore(dynamic value) {
  double numValue;
  if (value is String) {
    numValue = double.tryParse(value.replaceAll(',', '')) ?? 0;
  } else if (value is num) {
    numValue = value.toDouble();
  } else {
    return '0';
  }

  if (numValue >= 1000000) {
    return '${_truncateTo2Decimals(numValue / 1000000)}M';
  } else if (numValue >= 1000) {
    return '${_truncateTo2Decimals(numValue / 1000)}K';
  } else {
    return numValue.toInt().toString();
  }
}

String _truncateTo2Decimals(double value) {
  double truncated = (value * 100).floorToDouble() / 100;
  return truncated.toString().replaceAll(RegExp(r'\.0$'), '');
}

String formatTokenAmount(String weiAmountString, {int decimals = 18}) {
  try {
    final weiAmount = BigInt.parse(weiAmountString);
    final divisor = BigInt.from(10).pow(decimals);
    final integerPart = weiAmount ~/ divisor;
    final remainder = weiAmount % divisor;

    final value =
        integerPart.toDouble() + (remainder.toDouble() / divisor.toDouble());

    return value.toStringAsFixed(2);
  } catch (e) {
    return '0.00';
  }
}

mixin DoubleBackToExitMixin<T extends StatefulWidget> on State<T> {
  DateTime? _lastBackPress;

  Future<bool> handleBackPressWithDialog(BuildContext context) async {
    final now = DateTime.now();

    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      return false;
    }

    await _showExitDialog(context);
    return false;
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      await _showIOSExitDialog(context);
    } else {
      await _showAndroidExitDialog(context);
    }
  }

  // iOS style dialog
  Future<void> _showIOSExitDialog(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Exit App?'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Are you sure you want to exit?'),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Exit'),
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  // Android style dialog
  Future<void> _showAndroidExitDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.7,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut)),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Are you sure you want to exit?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mdBold(context),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gray900,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Stay',
                                    style: AppTextStyles.baseSemiBold(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error600,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    SystemNavigator.pop();
                                  },
                                  child: Text(
                                    'Exit',
                                    style: AppTextStyles.baseSemiBold(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -60,
                    child: Image.asset(
                      'assets/images/sad.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
