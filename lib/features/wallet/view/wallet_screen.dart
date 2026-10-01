import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/utils.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:learnwayv2/features/wallet/view/all_transaction_history_screen.dart';
import 'package:learnwayv2/features/wallet/widgets/slideable_action.dart';
import 'package:learnwayv2/features/wallet/widgets/wallet_shimmer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/wallet/widgets/wallet_balance_card.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/time_util.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';

enum WalletTab { all, send, receive, swap }

enum TransactionType { send, receive, swap }

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with AutomaticKeepAliveClientMixin {
  String? userWalletAddress;
  bool _isKycStatusLoading = false;
  bool _isTransactionLoading = true;
  bool _isSlideableActionLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  bool get isLoading => _isTransactionLoading;

  void _initializeWallet() async {
    log('Initializing wallet screen');
    final kycCubit = locator.get<KycCubit>();
    await kycCubit.initialize();
    final walletAddress = await LocalStorageService.getWalletAddress();
    setState(() {
      userWalletAddress = walletAddress;
    });

    if (mounted) {
      final walletCubit = context.read<WalletCubit>();
      final balanceNotifier = context.read<BalanceNotifier>();
      await walletCubit.loadCachedExchangeRates();
      walletCubit.fetchWalletData();
      walletCubit.fetchExchangeRates();
      balanceNotifier.fetchBalance();
      balanceNotifier.startAutoRefresh();
    }
  }

  void _refreshWalletData() {
    if (!mounted) return;

    final balanceNotifier = context.read<BalanceNotifier>();
    balanceNotifier.fetchBalance();
    balanceNotifier.startAutoRefresh();
    final walletCubit = context.read<WalletCubit>();
    walletCubit.fetchWalletData();
    walletCubit.fetchBalance();
  }

  void _handleSlideableActionLoadingChanged(bool isLoading) {
    if (mounted) {
      setState(() {
        _isSlideableActionLoading = isLoading;
      });
    }
  }

  TransactionType _determineTransactionType(
    LearnWayTransaction transaction,
    String? userWalletAddress,
  ) {
    if (userWalletAddress == null) return TransactionType.receive;

    final isFromUser =
        transaction.sender.toLowerCase() == userWalletAddress.toLowerCase();

    return isFromUser ? TransactionType.send : TransactionType.receive;
  }

  String _getTransactionTitle(
    BuildContext context,
    LearnWayTransaction transaction,
    TransactionType type,
  ) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case TransactionType.receive:
        return l10n.cryptoDeposit;
      case TransactionType.send:
        return l10n.cryptoWithdraw;
      case TransactionType.swap:
        return l10n.cryptoSwap;
    }
  }

  String _getTransactionAmount(
    LearnWayTransaction transaction,
    TransactionType type,
  ) {
    final amount = transaction.amount;

    switch (type) {
      case TransactionType.receive:
        return '+\$${formatTokenAmount(amount, decimals: transaction.decimals ?? getTokenDecimals())}';
      case TransactionType.send:
        return '-\$${formatTokenAmount(amount, decimals: transaction.decimals ?? getTokenDecimals())}';
      case TransactionType.swap:
        return '~\$${formatTokenAmount(amount, decimals: transaction.decimals ?? getTokenDecimals())}';
    }
  }

  String _getTransactionAmountSubTitle(
    LearnWayTransaction transaction,
    TransactionType type,
  ) {
    final amount = transaction.amount;

    switch (type) {
      case TransactionType.receive:
        return formatTokenAmount(
          amount,
          decimals: transaction.decimals ?? getTokenDecimals(),
        );
      case TransactionType.send:
        return formatTokenAmount(
          amount,
          decimals: transaction.decimals ?? getTokenDecimals(),
        );
      case TransactionType.swap:
        return formatTokenAmount(
          amount,
          decimals: transaction.decimals ?? getTokenDecimals(),
        );
    }
  }

  Color _getTransactionAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.receive:
        return AppColors.success700;
      case TransactionType.send:
        return AppColors.error700;
      case TransactionType.swap:
        return AppColors.primaryMain;
    }
  }

  String _getTransactionIcon(TransactionType type, bool isDarkMode) {
    switch (type) {
      case TransactionType.send:
        return isDarkMode
            ? Assets.icons.moneySendWhite
            : Assets.icons.moneySend;
      case TransactionType.receive:
        return isDarkMode
            ? Assets.icons.moneyReciveWhite
            : Assets.icons.moneyReceive;
      case TransactionType.swap:
        return isDarkMode
            ? Assets.icons.moneySwapWhite
            : Assets.icons.walletSwap;
    }
  }

  Widget _buildTransactionList(List<LearnWayTransaction> transactions) {
    final limitedTransactions = transactions.take(10).toList();
    return Container(
      height: limitedTransactions.length * 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.gray100,
          height: 0.5,
          indent: 36.0,
          endIndent: 36,
        ),
        itemCount: limitedTransactions.length,
        itemBuilder: (context, index) {
          final transaction = limitedTransactions[index];
          final type = _determineTransactionType(
            transaction,
            userWalletAddress ?? '',
          );
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 12, right: 12),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: SvgPicture.asset(_getTransactionIcon(type, false)),
                ),
                const HSpace(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTransactionTitle(context, transaction, type),
                        style: AppTextStyles.baseSemiBold(context),
                      ),
                      const VSpace(8),
                      Text(
                        TimeAgo.format(transaction.timestamp),
                        style: AppTextStyles.xsRegular(
                          context,
                        ).copyWith(color: AppColors.gray500),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getTransactionAmount(transaction, type),
                      style: AppTextStyles.baseSemiBold(
                        context,
                      ).copyWith(color: _getTransactionAmountColor(type)),
                    ),
                    Text(
                      '${_getTransactionAmountSubTitle(transaction, type)} USDT',
                      style: AppTextStyles.xsRegular(
                        context,
                      ).copyWith(color: AppColors.gray500),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image(image: AssetImage(Assets.images.newWallet.path))],
        ),
      ),
    );
  }

  void _navigateToAllTransactionHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllTransactionHistoryScreen()),
    );
    _refreshWalletData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final balance = context.select<BalanceNotifier, String>(
      (BalanceNotifier cubit) => cubit.balance ?? '',
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<MainActivityCubit, MainActivityState>(
          listenWhen: (previous, current) {
            return previous.timestamp != current.timestamp;
          },
          listener: (context, state) {},
        ),
        BlocListener<KycCubit, KycState>(
          listener: (context, state) {
            setState(() {
              if (state.status == KycStatus.loading) {
                _isKycStatusLoading = true;
              } else if (state.status == KycStatus.loaded) {
                _isKycStatusLoading = false;
              } else if (state.status == KycStatus.error) {
                _isKycStatusLoading = false;
              }
            });
          },
        ),
        BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            setState(() {
              if (state.isWalletLoading) {
                _isTransactionLoading = true;
              } else if (state.isWalletLoaded || state.hasWalletError) {
                _isTransactionLoading = false;
              }
            });
          },
        ),
      ],
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              log('Pull-to-refresh triggered');
              await context.read<WalletCubit>().reloadWalletData();
              final kycCubit = locator.get<KycCubit>();
              kycCubit.initialize();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        AppLocalizations.of(context)!.myWallet,
                        style: AppTextStyles.xlBold(context),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(26),
                        WalletBalanceCard(balance: balance),
                        const VSpace(11),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: isLoading
                      ? KycCardShimmer()
                      : SlideableActionCards(
                          onLoadingStateChanged:
                              _handleSlideableActionLoadingChanged,
                        ),
                ),
                const SliverToBoxAdapter(child: VSpace(40)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.transactionHistory,
                              style: AppTextStyles.mdBold(context),
                            ),
                            GestureDetector(
                              onTap: _navigateToAllTransactionHistory,
                              child: Text(
                                AppLocalizations.of(context)!.viewAll,
                                style: AppTextStyles.smSemiBold(
                                  context,
                                ).copyWith(color: AppColors.primaryMain),
                              ),
                            ),
                          ],
                        ),
                        const VSpace(16),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, walletState) {
                    if (walletState.hasWalletError &&
                        walletState.transactions == null) {
                      return SliverToBoxAdapter(
                        child: isLoading
                            ? WalletCardShimmer()
                            : _buildEmptyState(),
                      );
                    }

                    if (walletState.isWalletLoaded) {
                      final allTransactions =
                          walletState.transactions?.data ?? [];

                      if (allTransactions.isEmpty) {
                        return SliverToBoxAdapter(
                          child: isLoading
                              ? WalletCardShimmer()
                              : _buildEmptyState(),
                        );
                      }

                      return SliverToBoxAdapter(
                        child: _buildTransactionList(allTransactions),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: isLoading
                          ? WalletCardShimmer()
                          : _buildEmptyState(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
