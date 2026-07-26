import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_keys.dart';

class SharedPreferencesStore {
  static Future<void> saveVocalbularyKey(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setBool(key, value);
    });
  }

  static Future<bool?> getVocalbularyKey(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> removeStorage(String key) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future<void> saveFirstTimerKey(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setBool(key, value);
    });
  }

  static Future<bool?> getFirstTimerKey(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> removeFirstTimerKey(String key) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future<void> saveIsAuthenticatedKey(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setBool(key, value);
    });
  }

  static Future<bool?> getIsAuthenticatedKey(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> removeIsAuthenticatedKey(String key) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future<void> hasSeenIntroSlide(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setBool(key, value);
    });
  }

  static Future<bool?> getHasSeenIntroSlides(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> removeHasSeenIntroSlides(String key) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future<void> hasRegistered(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      final result = await prefs.setBool(key, value);
      if (!result) {
        throw Exception('Failed to save registration status');
      }
    });
  }

  static Future<bool?> getHasRegistered(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> setUserToken(String key, String value) async {
    return await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString(key, value);
    });
  }

  static Future<String?> getUserToken(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
  }

  static Future<void> setUpRefreshToken(String key, String value) async {
    return await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    });
  }

  static Future<String?> getRefreshToken(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
  }

  static Future<void> completeAccountSetup(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(key, value);
    });
  }

  static Future<bool?> getCompleteAccountSetup(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> usedGoogleAuth(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(key, value);
    });
  }

  static Future<void> usedAppleAuth(String key, bool value) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(key, value);
    });
  }

  static Future<bool?> getUsedGoogleAuth(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<bool?> getUsedAppleAuth(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(key);
    });
  }

  static Future<void> setUserId(String key, String value) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(key, value);
    });
  }

  static Future<String?> getUserId(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
  }

  static Future<void> saveUserEmail(String key, String value) async {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString(key, value);
    });
  }

  static Future<String?> getUserEmail(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
  }

  static Future<void> saveKycStatus(
    String kycStatusKey,
    bool isCompleted,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kycStatusKey, isCompleted);
    if (isCompleted) {
      await prefs.setString(
        kycCompletedAtKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  static Future<bool> getKycStatus(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> saveKycSessionId(String key, String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, sessionId);
  }

  static Future<String?> getKycSessionId(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveKycState(String key, String kycState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, kycState);
  }

  static Future<void> clearKycData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kycStatusKey);
    await prefs.remove(kycSessionIdKey);
    await prefs.remove(kycCompletedAtKey);
    await prefs.remove(kycStateKey);
    await prefs.remove(notificationKey);
  }

  static Future<DateTime?> getKycCompletedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(kycCompletedAtKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<void> saveSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(soundEnabledKey, value);
  }

  static Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(soundEnabledKey) ?? true;
  }

  static Future<bool> saveNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(notificationKey, true);
  }

  static Future<bool> getNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationKey) ?? false;
  }

  static Future<void> savePreferredLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(preferredLanguageKey, languageCode);
  }

  static Future<String?> getPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(preferredLanguageKey);
  }

  static Future<void> clearPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(preferredLanguageKey);
  }

  static Future<void> savePromoPopupTimestamp(
    String campaignId,
    int timestampMs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(promoPopupKey(campaignId), timestampMs);
  }

  static Future<int?> getPromoPopupTimestamp(String campaignId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(promoPopupKey(campaignId));
  }

  static Future<void> savePromoPopupSessionSeen(String campaignId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(promoPopupSessionKey(campaignId), true);
  }

  static Future<bool> getPromoPopupSessionSeen(String campaignId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(promoPopupSessionKey(campaignId)) ?? false;
  }
}
