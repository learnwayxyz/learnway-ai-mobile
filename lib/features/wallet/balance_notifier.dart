import 'dart:async';
import 'dart:developer';
import 'package:core/src/config/env/env.dart';
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
    log('BalanceNotifier: walletAddress=$walletAddress');
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

    if (!locator.isRegistered<SmartWallet>()) {
      log('BalanceNotifier: SmartWallet not registered yet, waiting');
      _isLoading = true;
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final balance = await _erc20Balance(walletAddress);
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

  Future<String> _erc20Balance(String walletAddress) async {
    try {
      final smartWallet = locator<SmartWallet>();
      if (smartWallet.address.eip55With0x.toLowerCase() !=
          walletAddress.toLowerCase()) {
        log(
          'BalanceNotifier: SmartWallet address ${smartWallet.address.eip55With0x} '
          'does not match stored wallet address $walletAddress',
        );
      }
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
      final humanBalance = rawBalance / divisor;
      final value = humanBalance
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'\.?0+$'), '');
      final finalValue = value.isEmpty ? '0' : value;
      log(
        '_erc20Balance(): $finalValue (raw: $rawBalance, decimals: $decimals, address: ${smartWallet.address.eip55With0x})',
      );

      return finalValue;
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
