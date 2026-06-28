import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KycSyncQueue {
  static const String kycSyncQueue = 'kyc_sync_queue';

  static Future<void> addToQueue({
    required Map<String, dynamic> sessionDecision,
    required String sessionId,
  }) async {
    final queue = await _getQueue();
    queue.add({'sessionDecision': sessionDecision, 'sessionId': sessionId});
    await _saveQueue(queue);
  }

  static Future<List<Map<String, dynamic>>> _getQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString(kycSyncQueue);
    if (queueJson == null) return [];
    final List<dynamic> decoded = jsonDecode(queueJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> _saveQueue(List<Map<String, dynamic>> queue) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(queue);
    await prefs.setString(kycSyncQueue, encoded);
  }

  static Future<List<Map<String, dynamic>>> getPendingItems() async {
    return await _getQueue();
  }

  static Future<void> removeFromQueue(String sessionId) async {
    final queue = await _getQueue();
    queue.removeWhere((item) => item['sessionId'] == sessionId);
    await _saveQueue(queue);
  }

  static Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kycSyncQueue);
  }
}
