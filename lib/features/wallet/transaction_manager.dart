import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:hive/hive.dart';
import 'package:core/core.dart';

String _createCacheKey(String walletAddress, int limit, int offset) {
  return '$walletAddress:limit=$limit:offset=$offset';
}

class TransactionCache {
  TransactionCache({this.cacheExpiration = const Duration(seconds: 5)});

  final Duration cacheExpiration;

  /// Get transactions from cache or fetch from network
  ///
  /// [walletAddress] - The wallet address to fetch transactions for
  /// [fetchFromNetworkFunction] - Function to fetch data from API
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data
  /// [limit] - Number of transactions to fetch
  /// [offset] - Offset for pagination
  Future<TransactionResponse> getTransactionsFromStorage(
    String walletAddress,
    Future<TransactionResponse> Function({
      required String walletAddress,
      required int limit,
      required int offset,
    })
    fetchFromNetworkFunction, {
    bool forceRefresh = false,
    int limit = 100,
    int offset = 0,
  }) async {
    final cacheKey = _createCacheKey(walletAddress, limit, offset);
    final now = DateTime.now();
    final transactionsBox = Hive.box<dynamic>(boxName);
    final timestampBox = Hive.box<dynamic>(timestampBoxName);

    final timestampString = timestampBox.get(cacheKey);
    final hasTimestamp = timestampString != null;
    DateTime? lastFetchTime;

    if (hasTimestamp) {
      try {
        lastFetchTime = DateTime.parse(timestampString as String);
      } catch (e) {
        log('Error parsing timestamp: $e');
        lastFetchTime = null;
      }
    }

    final isCacheValid =
        transactionsBox.containsKey(cacheKey) &&
        lastFetchTime != null &&
        now.difference(lastFetchTime) < cacheExpiration &&
        !forceRefresh;

    if (isCacheValid) {
      try {
        final dynamic cachedData = transactionsBox.get(cacheKey);
        if (cachedData is! String) {
          log('Invalid cache format, fetching from network');
          return _fetchAndCacheTransactions(
            walletAddress,
            fetchFromNetworkFunction,
            transactionsBox,
            timestampBox,
            limit: limit,
            offset: offset,
          );
        }

        final dynamic decoded = json.decode(cachedData);
        log('Data loaded from cache for key: $cacheKey');
        final decodedData = decoded as Map<String, dynamic>;

        return TransactionResponse.fromJson(decodedData);
      } catch (e) {
        log('Error reading from cache: $e, fetching from network');
        return _fetchAndCacheTransactions(
          walletAddress,
          fetchFromNetworkFunction,
          transactionsBox,
          timestampBox,
          limit: limit,
          offset: offset,
        );
      }
    }

    log('Cache miss or expired, fetching from network');
    return _fetchAndCacheTransactions(
      walletAddress,
      fetchFromNetworkFunction,
      transactionsBox,
      timestampBox,
      limit: limit,
      offset: offset,
    );
  }

  /// Fetch transactions from network and cache them
  Future<TransactionResponse> _fetchAndCacheTransactions(
    String walletAddress,
    Future<TransactionResponse> Function({
      required String walletAddress,
      required int limit,
      required int offset,
    })
    fetchFunction,
    Box<dynamic> transactionsBox,
    Box<dynamic> timestampBox, {
    required int limit,
    required int offset,
  }) async {
    final cacheKey = _createCacheKey(walletAddress, limit, offset);

    try {
      log('Fetching transactions from network for: $walletAddress');
      final response = await fetchFunction(
        walletAddress: walletAddress,
        limit: limit,
        offset: offset,
      );

      // Only cache successful responses
      if (response.success) {
        final responseJson = json.encode(_transactionResponseToJson(response));

        await transactionsBox.put(cacheKey, responseJson);
        await timestampBox.put(cacheKey, DateTime.now().toIso8601String());

        log('Transactions cached successfully for key: $cacheKey');
      }

      return response;
    } catch (e) {
      log('Error fetching from network: $e');

      // Try to return cached data as fallback
      if (transactionsBox.containsKey(cacheKey)) {
        try {
          final dynamic cachedData = transactionsBox.get(cacheKey);
          if (cachedData is String) {
            final dynamic decoded = json.decode(cachedData);
            final decodedData = decoded as Map<String, dynamic>;
            log('Returning stale cache as fallback');
            return TransactionResponse.fromJson(decodedData);
          }
        } catch (parseError) {
          log('Error parsing cached fallback data: $parseError');
        }
      }

      // If no cache available, rethrow error
      rethrow;
    }
  }

  /// Convert TransactionResponse to JSON (helper for caching)
  Map<String, dynamic> _transactionResponseToJson(
    TransactionResponse response,
  ) {
    return {
      'success': response.success,
      'count': response.count,
      'data': response.data.map((tx) => tx.toJson()).toList(),
      if (response.error != null) 'error': response.error,
    };
  }

  /// Clear cache for specific wallet address
  Future<void> clearCache(String walletAddress) async {
    final transactionsBox = Hive.box<dynamic>(boxName);
    final timestampBox = Hive.box<dynamic>(timestampBoxName);

    final keys = transactionsBox.keys
        .where((key) => key.toString().startsWith(walletAddress))
        .toList();

    log('Clearing cache for $walletAddress (${keys.length} entries)');

    for (final key in keys) {
      await transactionsBox.delete(key);
      await timestampBox.delete(key);
    }
  }

  /// Clear all cached transactions
  Future<void> clearAllCache() async {
    final transactionsBox = Hive.box<dynamic>(boxName);
    final timestampBox = Hive.box<dynamic>(timestampBoxName);

    log('Clearing all transaction cache');
    await transactionsBox.clear();
    await timestampBox.clear();
  }

  /// Check if cached data exists for given parameters
  bool hasCachedData(String walletAddress, {int limit = 100, int offset = 0}) {
    final cacheKey = _createCacheKey(walletAddress, limit, offset);
    final transactionsBox = Hive.box<dynamic>(boxName);
    return transactionsBox.containsKey(cacheKey);
  }

  /// Check if cached data is still valid (not expired)
  bool isCacheValid(String walletAddress, {int limit = 100, int offset = 0}) {
    final cacheKey = _createCacheKey(walletAddress, limit, offset);
    final transactionsBox = Hive.box<dynamic>(boxName);
    final timestampBox = Hive.box<dynamic>(timestampBoxName);

    if (!transactionsBox.containsKey(cacheKey)) {
      return false;
    }

    final timestampString = timestampBox.get(cacheKey);
    if (timestampString == null) {
      return false;
    }

    try {
      final lastFetchTime = DateTime.parse(timestampString as String);
      final now = DateTime.now();
      return now.difference(lastFetchTime) < cacheExpiration;
    } catch (e) {
      return false;
    }
  }
}
