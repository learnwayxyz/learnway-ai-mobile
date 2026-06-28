import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/widgets/deposit_bottom_sheet.dart';
import 'package:learnwayv2/features/wallet/widgets/withdrawal_bottom_sheet.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/widgets/information_modal.dart';

class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
    this.onDeposit,
    this.onSwap,
    this.onWithdraw,
  });

  final String balance;
  final VoidCallback? onDeposit;
  final VoidCallback? onSwap;
  final VoidCallback? onWithdraw;
  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  bool isFiatSelected = true;
  String? userPreferredCountry;
  String? userLocalCurrencyCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeUserPreferences();
    });
  }

  Future<void> _initializeUserPreferences() async {
    final userData = await LocalStorageService.getUser();
    log('User data: ${userData?.country}');
    final preferredCountry = userData?.country ?? 'United States';

    setState(() {
      userPreferredCountry = preferredCountry;
      userLocalCurrencyCode = CurrencyCheck.getLocalCurrencyCode(
        preferredCountry,
      );
    });
  }

  bool _isLocalCurrencySupported(Map<String, dynamic> exchangeRates) {
    final code = userLocalCurrencyCode;
    if (code == null || code == 'USD') return false;
    return exchangeRates.containsKey('USD$code');
  }

  void _showDepositBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DepositBottomSheet(),
    );
  }

  void _showWithdrawBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => WithdrawalBottomSheet(),
    );
  }

  double _convertCurrency(
    double usdAmount,
    Map<String, dynamic> exchangeRates,
    String targetCurrency,
  ) {
    if (targetCurrency == 'USD') return usdAmount;

    final rateKey = 'USD$targetCurrency';
    final rate = exchangeRates[rateKey]?.toDouble() ?? 1.0;

    return usdAmount * rate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, homeState) {
        if (homeState.userProfile?.country != null) {
          _initializeUserPreferences();
        }
      },
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, walletState) {
          final exchangeRates = walletState.exchangeRates;
          final usdtBalance = double.tryParse(widget.balance) ?? 0.0;
          final isSupported = _isLocalCurrencySupported(exchangeRates);
          final topLabel = isSupported
              ? (userLocalCurrencyCode ?? 'USD')
              : 'USD';
          log('Local top label: $topLabel $exchangeRates');
          final displayAmount = isFiatSelected
              ? _convertCurrency(usdtBalance, exchangeRates, topLabel)
              : usdtBalance;
          final currencySymbol = isFiatSelected ? topLabel : 'USDT';

          return SizedBox(
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 80),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 64,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAECF5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            iconPath: Assets.images.moneyRecive.path,
                            onPressed: _showDepositBottomSheet,
                            label: AppLocalizations.of(context)!.deposit,
                            color: Colors.white,
                          ),
                          _buildActionButton(
                            iconPath: Assets.images.arrowSwap.path,
                            onPressed: () {
                              handleUnAvailable(
                                context,
                                AppLocalizations.of(
                                  context,
                                )!.redeemUnavailableTitle,
                                AppLocalizations.of(
                                  context,
                                )!.redeemUnavailableSubText,
                              );
                            },
                            label: AppLocalizations.of(context)!.redeem,
                            color: Colors.white,
                          ),
                          _buildActionButton(
                            iconPath: Assets.images.moneySend.path,
                            onPressed: () {
                              _showWithdrawBottomSheet();
                              // handleUnAvailable(
                              //   context,
                              //   AppLocalizations.of(
                              //     context,
                              //   )!.withdrawUnavailableTitle,
                              //   AppLocalizations.of(
                              //     context,
                              //   )!.withdrawUnavailableSubText,
                              // );
                            },
                            label: AppLocalizations.of(context)!.withdraw,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient3,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.total,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const VSpace(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '$currencySymbol ${displayAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const HSpace(10),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        topLabel,
                                        style: AppTextStyles.smBold(context)
                                            .copyWith(
                                              fontSize: 12,
                                              color: isFiatSelected
                                                  ? Colors.white
                                                  : AppColors.blueGray300,
                                            ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.usdt,
                                        style: AppTextStyles.smBold(context)
                                            .copyWith(
                                              fontSize: 12,
                                              color: !isFiatSelected
                                                  ? Colors.white
                                                  : AppColors.blueGray300,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const HSpace(5),
                                  SizedBox(
                                    height: 44,
                                    width: 24,
                                    child: AnimatedToggleSwitch<bool>.rolling(
                                      indicatorSize: const Size(14, 14),
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.05,
                                      current: isFiatSelected,
                                      borderWidth: 0,
                                      clipBehavior: Clip.none,
                                      padding: const EdgeInsets.all(4),
                                      spacing: 10,
                                      values: const [true, false],
                                      style: ToggleStyle(
                                        indicatorColor: AppColors.white,
                                        backgroundColor: Color(0xff031387),
                                      ),
                                      onChanged: (value) {
                                        setState(() => isFiatSelected = value);
                                      },
                                      animationDuration: const Duration(
                                        milliseconds: 200,
                                      ),
                                    ).vertical(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              child: Image.asset(iconPath, width: 25, height: 25),
            ),
          ),
        ),
        const VSpace(10),
        Text(label, style: AppTextStyles.smSemiBold(context)),
      ],
    );
  }
}
