import 'dart:async';
import 'dart:developer';
import 'package:core/src/config/env/env.dart';
import 'package:core/src/config/env/env.dev.dart';
import 'package:learnwayv2/features/wallet/balance_caching.dart';
import 'package:learnwayv2/features/wallet/utils.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:variance_dart/variance_dart.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:wallet/wallet.dart';

class BalanceNotifier extends ChangeNotifier {
  String? _balance;
  bool _isLoading = false;
  String? _error;
  Timer? _autoRefreshTimer;

  String? get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void startAutoRefresh() {
    stopAutoRefresh();
    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => fetchBalance(),
    );
  }

  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  Future<void> fetchBalance({bool forceRefresh = false}) async {
    final walletAddress = await LocalStorageService.getWalletAddress();

    if (walletAddress.isEmpty) {
      clearState();
      return;
    }

    if (!forceRefresh) {
      final cachedBalance = await BalanceCache.getCachedBalance(walletAddress);
      if (cachedBalance != null) {
        final currentWallet = await LocalStorageService.getWalletAddress();
        if (currentWallet.isEmpty || currentWallet != walletAddress) {
          await BalanceCache.clearCache();
          clearState();
          return;
        }

        _balance = cachedBalance;
        _error = null;
        notifyListeners();
        return;
      }
    } else {
      await BalanceCache.forceRefresh();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final balance = await _erc20Balance();
      final currentWallet = await LocalStorageService.getWalletAddress();
      if (currentWallet.isEmpty || currentWallet != walletAddress) {
        clearState();
        return;
      }

      await BalanceCache.saveBalance(walletAddress, balance);

      _balance = balance;
      _error = null;
    } catch (e) {
      log('Error fetching balance: $e');
      _error = 'Error getting balance: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _erc20Balance() async {
    try {
      log('activeTokenAddress: ${Env.activeTokenAddress}');
      final smartWallet = locator<SmartWallet>();
      final result = await smartWallet.readContract(
        EthereumAddress.fromHex(Env.activeTokenAddress),
        ContractAbis.get('ERC20_BalanceOf'),
        'balanceOf',
        params: [smartWallet.address],
        sender: smartWallet.address,
      );

      final rawBalance = result.first as BigInt;

      final decimals = getTokenDecimals();

      final divisor = BigInt.from(10).pow(decimals);
      final integerPart = rawBalance ~/ divisor;
      final remainder = rawBalance % divisor;
      final humanBalance =
          integerPart.toDouble() + (remainder.toDouble() / divisor.toDouble());
      final value = humanBalance
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'\.?0+$'), '');
      log('_erc20Balance(): $value');

      return value;
    } catch (e) {
      throw Exception('Failed to fetch balance: $e');
    }
  }

  void clearState() {
    _balance = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
