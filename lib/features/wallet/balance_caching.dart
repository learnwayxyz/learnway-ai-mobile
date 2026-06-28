import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceCache {
  static const String _balanceKey = 'cached_balance';
  static const Duration _cacheExpiry = Duration(seconds: 3);

  static Future<void> saveBalance(String walletAddress, String balance) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'walletAddress': walletAddress,
      'balance': balance,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    await prefs.setString(_balanceKey, jsonEncode(cacheData));
  }

  static Future<String?> getCachedBalance(String walletAddress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedDataString = prefs.getString(_balanceKey);

      if (cachedDataString == null) return null;

      final cachedData = jsonDecode(cachedDataString) as Map<String, dynamic>;
      final cachedWalletAddress = cachedData['walletAddress'] as String;
      final cachedBalance = cachedData['balance'] as String;
      final timestamp = cachedData['timestamp'] as int;

      if (cachedWalletAddress.toLowerCase() != walletAddress.toLowerCase()) {
        return null;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      if (now.difference(cacheTime) > _cacheExpiry) {
        await clearCache();
        return null;
      }

      return cachedBalance;
    } catch (e) {
      await clearCache();
      return null;
    }
  }

  static Future<bool> hasCachedBalance(String walletAddress) async {
    final cachedBalance = await getCachedBalance(walletAddress);
    return cachedBalance != null;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_balanceKey);
  }

  static Future<void> forceRefresh() async {
    await clearCache();
  }
}
