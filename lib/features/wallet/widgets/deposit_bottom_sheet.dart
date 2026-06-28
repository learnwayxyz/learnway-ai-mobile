import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/wallet/widgets/deposit_option.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';

class DepositBottomSheet extends StatelessWidget {
  const DepositBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final countryCode = CountryCode(
      name: 'Ghana',
      code: 'GH',
      dialCode: '+233',
    );
    final flagObject = getCurrentUserFlag();
    final userCountry = LocalStorageService.getUserSync()?.country;
    final isCountrySupported =
        userCountry != null && supportedCountries.contains(userCountry);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF8F9FC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VSpace(22),
          Text(AppLocalizations.of(context)!.deposit, style: AppTextStyles.lgBold(context)),
          VSpace(11),
          Divider(color: AppColors.gray200, height: 1),
          VSpace(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DepositOption(
                  icon: Assets.icons.dexIcons.path,
                  title: AppLocalizations.of(context)!.depositViaCrypto,
                  subtitle: AppLocalizations.of(context)!.fundYourAccountWithCrypto,
                  onTap: () {
                    Navigator.pop(context);
                    context.router.push(const ReceiveRoute());
                  },
                ),
                const VSpace(16),
                if (isCountrySupported && flagObject != null)
                  DepositOption(
                    icon: flagObject.$1,
                    package: countryCode.flagImagePackage,
                    showComingSoon: false,
                    title: '${flagObject.$2} - ${flagObject.$3}',
                    subtitle: AppLocalizations.of(context)!.usingLocalPaymentMethods,
                    onTap: () async {
                      Navigator.pop(context);
                      log('${flagObject.$2} deposit selected');
                      context.router.push(const DepositPaymentMethodRoute());
                    },
                  ),
              ],
            ),
          ),
          const VSpace(20),
          VSpace(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
