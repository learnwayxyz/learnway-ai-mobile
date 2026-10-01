import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/utils.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:learnwayv2/features/wallet/view/wallet_screen.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/time_util.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

enum TransactionHistoryTab { all, deposit, swap, withdraw }

class AllTransactionHistoryScreen extends StatefulWidget {
  const AllTransactionHistoryScreen({super.key});

  @override
  State<AllTransactionHistoryScreen> createState() =>
      _AllTransactionHistoryScreenState();
}

class _AllTransactionHistoryScreenState
    extends State<AllTransactionHistoryScreen> {
  String? userWalletAddress;
  TransactionHistoryTab selectedTab = TransactionHistoryTab.all;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  void _initializeWallet() {
    LocalStorageService.getWalletAddress().then((value) {
      setState(() {
        userWalletAddress = value;
      });
    });
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

  List<LearnWayTransaction> _getFilteredTransactions(
    TransactionHistoryTab selectedTab,
    List<LearnWayTransaction> transactions,
  ) {
    if (selectedTab == TransactionHistoryTab.all) return transactions;

    return transactions.where((transaction) {
      final type = _determineTransactionType(
        transaction,
        userWalletAddress ?? '',
      );

      switch (selectedTab) {
        case TransactionHistoryTab.withdraw:
          return type == TransactionType.send;
        case TransactionHistoryTab.deposit:
          return type == TransactionType.receive;
        case TransactionHistoryTab.swap:
          return type == TransactionType.swap;
        case TransactionHistoryTab.all:
          return true;
      }
    }).toList();
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

  String _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.send:
        return Assets.icons.moneySend;
      case TransactionType.receive:
        return Assets.icons.moneyReceive;
      case TransactionType.swap:
        return Assets.icons.walletSwap;
    }
  }

  Widget _buildTransactionList(List<LearnWayTransaction> transactions) {
    return Container(
      height: transactions.length * 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) =>
            Divider(color: AppColors.gray100, height: 1),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
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
                  child: SvgPicture.asset(_getTransactionIcon(type)),
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(Assets.images.newWallet.path)),
            const VSpace(16),
            Text(
              AppLocalizations.of(context)!.noTransactionHistory,
              style: AppTextStyles.xlBold(
                context,
              ).copyWith(color: AppColors.gray900, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.transactions,
        barHeight: 10,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace(20),

                Text(
                  AppLocalizations.of(context)!.transactionHistory,
                  style: AppTextStyles.mdBold(context),
                ),
                const VSpace(10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTabs<TransactionHistoryTab>(
                        selectedValue: selectedTab,
                        onTabSelected: (TransactionHistoryTab value) {
                          setState(() {
                            selectedTab = value;
                          });
                        },
                        tabs: [
                          TabItem(
                            value: TransactionHistoryTab.all,
                            label: AppLocalizations.of(context)!.all,
                            selectedColor: AppColors.gray900,
                            unselectedColor: const Color(0xFFEAECF5),
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                            textStyle: AppTextStyles.smSemiBold(context),
                          ),
                          TabItem(
                            value: TransactionHistoryTab.deposit,
                            label: AppLocalizations.of(context)!.deposit,
                            selectedColor: AppColors.gray900,
                            unselectedColor: const Color(0xFFEAECF5),
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                            textStyle: AppTextStyles.smSemiBold(context),
                          ),
                          TabItem(
                            value: TransactionHistoryTab.swap,
                            label: AppLocalizations.of(context)!.redeem,
                            selectedColor: AppColors.gray900,
                            unselectedColor: const Color(0xFFEAECF5),
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                            textStyle: AppTextStyles.smSemiBold(context),
                          ),
                          TabItem(
                            value: TransactionHistoryTab.withdraw,
                            label: AppLocalizations.of(context)!.withdraw,
                            selectedColor: AppColors.gray900,
                            unselectedColor: const Color(0xFFEAECF5),
                            selectedTextColor: Colors.white,
                            unselectedTextColor: AppColors.gray700,
                            textStyle: AppTextStyles.smSemiBold(context),
                          ),
                        ],
                        padding: EdgeInsets.zero,
                        borderRadius: 60,
                        spacing: 10.0,
                        defaultPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        defaultTextStyle: AppTextStyles.smBold(context),
                      ),
                    ),
                  ],
                ),
                const VSpace(31),
              ],
            ),
          ),
          BlocBuilder<WalletCubit, WalletState>(
            builder: (context, walletState) {
              if (walletState.isWalletLoading &&
                  walletState.transactions == null) {
                return _buildLoadingState();
              }

              if (walletState.hasWalletError &&
                  walletState.transactions == null) {
                return _buildEmptyState();
              }

              if (walletState.isWalletLoaded) {
                final allTransactions = walletState.transactions?.data ?? [];
                final filteredTransactions = _getFilteredTransactions(
                  selectedTab,
                  allTransactions,
                );

                if (filteredTransactions.isEmpty) {
                  return _buildEmptyState();
                }

                return Expanded(
                  child: _buildTransactionList(filteredTransactions),
                );
              }

              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }
}
