import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStoreService {
  static final FirebaseStoreService instance = FirebaseStoreService._internal();
  factory FirebaseStoreService() => instance;
  FirebaseStoreService._internal();
  final _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  Future<bool> uploadUserDataBlob({
    required String userId,
    required Map<String, dynamic> userData,
    bool merge = true,
  }) async {
    try {
      final dataWithMetadata = {
        ...userData,
        'lastUpdated': FieldValue.serverTimestamp(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .set(dataWithMetadata, SetOptions(merge: merge));
      return true;
    } on FirebaseException catch (e) {
      log('Firebase error storing user data: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error storing user data: $e');
      return false;
    }
  }

  Future<bool> storeUserJsonData({
    required String userId,
    required String jsonData,
    bool merge = true,
  }) async {
    try {
      log('Storing JSON user data for userId: $userId');
      log('storeToFirebase(): userData is $jsonData');
      final Map<String, dynamic> userData = jsonDecode(jsonData);

      return await uploadUserDataBlob(
        userId: userId,
        userData: userData,
        merge: merge,
      );
    } on FormatException catch (e) {
      log('Invalid JSON format: $e');
      return false;
    } catch (e) {
      log('Error storing JSON user data: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      log('Retrieving user data for userId: $userId');

      final docSnapshot =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (docSnapshot.exists) {
        log('Successfully retrieved user data for userId: $userId');
        return docSnapshot.data();
      } else {
        log('No user data found for userId: $userId');
        return null;
      }
    } on FirebaseException catch (e) {
      log('Firebase error retrieving user data: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected error retrieving user data: $e');
      return null;
    }
  }

  Future<String?> getUserJsonData(String walletAddress) async {
    try {
      final userData = await getUserData(walletAddress);

      if (userData != null) {
        final cleanData = Map<String, dynamic>.from(userData);
        cleanData.remove('lastUpdated');

        return jsonEncode(cleanData);
      }

      return null;
    } catch (e) {
      log('Error converting user data to JSON: $e');
      return null;
    }
  }
}
