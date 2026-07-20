import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:core/core.dart';

class LocalStorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BiWeeklyStreakAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(EarnedBadgeAdapter());
    }
    await Hive.openBox('user_wallet');
    await Hive.openBox('user');
    await Hive.openBox<UserProfileModel>(currentUserBoxName);
    await Hive.openBox(boxName);
    await Hive.openBox(timestampBoxName);
    await Hive.openBox(exchangeRatesBoxName);
    await Hive.openBox(projectDraftsBoxName);
  }

  static const String projectDraftsBoxName = 'project_drafts';

  static Future<void> saveProjectDraft(
    String courseId, {
    required String submissionType,
    required String content,
  }) async {
    final box = Hive.box(projectDraftsBoxName);
    await box.put(courseId, {
      'submissionType': submissionType,
      'content': content,
    });
  }

  static ({String submissionType, String content})? getProjectDraft(
    String courseId,
  ) {
    final box = Hive.box(projectDraftsBoxName);
    final draft = box.get(courseId);
    if (draft == null) return null;
    return (
      submissionType: draft['submissionType'] as String? ?? '',
      content: draft['content'] as String? ?? '',
    );
  }

  static Future<void> clearProjectDraft(String courseId) async {
    final box = Hive.box(projectDraftsBoxName);
    await box.delete(courseId);
  }

  static Future<void> saveWalletAddress(String walletAddress) async {
    final box = Hive.box('user_wallet');
    await box.put('mnemonic', walletAddress);
  }

  // Synchronous version - since box is already open
  static String getWalletAddressSync() {
    final box = Hive.box('user_wallet');
    final mnemonic = box.get('mnemonic');
    return mnemonic ?? '';
  }

  // Keep async version for compatibility
  static Future<String> getWalletAddress() async {
    return getWalletAddressSync();
  }

  static Future<void> clearWalletAddress() async {
    final box = Hive.box('user_wallet');
    await box.clear();
  }

  static Future<void> saveJwtToken(String token) async {
    final box = Hive.box('user');
    await box.put('token', token);
  }

  static Future<String> getJwtToken() async {
    final box = Hive.box('user');
    return box.get('token');
  }

  // In-memory only — never persisted to Hive so it can never go stale.
  static final ValueNotifier<int?> dailyLessonsNotifier = ValueNotifier(null);

  static Future<void> saveUser(UserProfileModel userModel) async {
    final box = Hive.box<UserProfileModel>('current_user');
    await box.put('user', userModel);
  }

  static void updateDailyLessonsRemaining(int value) {
    dailyLessonsNotifier.value = value;
  }

  // Synchronous version - since box is already open
  static UserProfileModel? getUserSync() {
    final box = Hive.box<UserProfileModel>('current_user');
    return box.get('user');
  }

  // Keep async version for compatibility
  static Future<UserProfileModel?> getUser() async {
    return getUserSync();
  }

  static Future<void> saveExchangeRates(Map<String, dynamic> rates) async {
    final box = Hive.box(exchangeRatesBoxName);
    final timestampBox = Hive.box(timestampBoxName);
    await box.put('rates', rates);
    await timestampBox.put(
      'exchange_rates_last_update',
      DateTime.now().toIso8601String(),
    );
  }

  static Future<Map<String, dynamic>?> getExchangeRates() async {
    final box = Hive.box(exchangeRatesBoxName);
    final rates = box.get('rates');

    if (rates == null) return null;

    return Map<String, dynamic>.from(rates);
  }

  static Future<DateTime?> getExchangeRatesLastUpdate() async {
    final timestampBox = Hive.box(timestampBoxName);
    final timestamp = timestampBox.get('exchange_rates_last_update');

    if (timestamp == null) return null;

    return DateTime.parse(timestamp);
  }

  static Future<bool> shouldUpdateExchangeRates() async {
    final lastUpdate = await getExchangeRatesLastUpdate();

    if (lastUpdate == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    return difference.inDays >= 3;
  }

  static Future<void> clearExchangeRates() async {
    final box = Hive.box(exchangeRatesBoxName);
    final timestampBox = Hive.box(timestampBoxName);

    await box.delete('rates');
    await timestampBox.delete('exchange_rates_last_update');
  }

  static Future<void> clear() async {
    await Hive.box('user_wallet').clear();
    await Hive.box<UserProfileModel>('current_user').clear();
    await Hive.box('user').clear();
    await Hive.box(boxName).clear();
    await Hive.box(timestampBoxName).clear();
    await Hive.box(exchangeRatesBoxName).clear();
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
