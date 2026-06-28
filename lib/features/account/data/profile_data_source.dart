import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/account/exceptions/account_exceptions.dart';
import 'package:learnwayv2/features/account/data/profile_interface.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account/model/supported_language_response.dart';
import 'package:learnwayv2/features/account/models/language_pref_model.dart';
import 'package:learnwayv2/features/account_setup/set_up_data_source/set_up_profile_helper.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

class ProfileDataSource implements Iprofile {
  final client = locator.get<BaseApiClients>();

  @override
  Future<bool> deleteMyAccount() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        dev.log('No user token found for deleteMyAccount');
      }

      final response = await client.delete(
        Endpoints.deleteAccount,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      dev.log('Delete account status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        await _clearAllStorage();
        return true;
      } else {
        final decoded = json.decode(response.body);
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to delete account. Please try again.',
        );
      }
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in deleteMyAccount: $e');
      throw AccountExceptions.unknown();
    }
  }

  @override
  Future<UserAccountModel> updateProfile({
    String? username,
    String? email,
    String? phoneNumber,
    String? country,
    String? profileImagePath,
  }) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw AccountExceptions('Unable to authenticate. Please log in again.');
      }

      final fields = <String, String>{
        'username': ?username,
        'email': ?email,
        'phoneNumber': ?phoneNumber,
        'country': ?country,
      };

      final response = await _sendProfileUpdate(
        token,
        fields,
        profileImagePath,
      );
      final Map<String, dynamic> decoded = json.decode(response.body);

      dev.log('Update profile response: $decoded');

      if (decoded['error'] != null ||
          (response.statusCode != 200 && response.statusCode != 201)) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to update profile. Please try again.',
        );
      }

      dev.log('Profile updated successfully');
      return UserAccountModel.fromJson(decoded);
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in updateProfile: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<http.Response> _sendProfileUpdate(
    String token,
    Map<String, String> fields,
    String? profileImagePath,
  ) async {
    final headers = {'Authorization': 'Bearer $token'};

    if (profileImagePath == null || profileImagePath.isEmpty) {
      return await client.patch(
        Endpoints.updateProfile,
        headers: {...headers, 'Content-Type': 'application/json'},
        body: fields,
      );
    } else if (profileImagePath.startsWith('assets/')) {
      final prepared = await ProfileImageHelper.prepareImage(profileImagePath);
      return await client.patchMultipartWithBytes(
        Endpoints.updateProfile,
        fields: fields,
        fileBytes: prepared.bytes,
        fileNames: prepared.names,
        mimeTypes: prepared.mime,
        headers: {...headers, 'Content-Type': 'multipart/form-data'},
      );
    } else {
      final file = File(profileImagePath);
      if (!await file.exists()) {
        throw AccountExceptions(
          'Selected profile image could not be found. Please try again.',
        );
      }
      return await client.patchMultipart(
        Endpoints.updateProfile,
        fields: fields,
        files: {'profileImage': file},
        headers: {...headers, 'Content-Type': 'multipart/form-data'},
      );
    }
  }

  @override
  Future<UserAccountModel> fetchUserData() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw AccountExceptions('Unable to authenticate. Please log in again.');
      }

      // dev.log('User token: $token');
      final response = await client.get(
        Endpoints.getUserProfile,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      dev.log('User data: $decoded');

      if (decoded['message'] == 'Unauthorized') {
        throw AccountExceptions(
          'Your session has expired. Please log in again.',
        );
      }

      if (decoded['error'] != null ||
          (response.statusCode != 200 && response.statusCode != 201)) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to load profile. Please try again.',
        );
      }

      return UserAccountModel.fromJson(decoded);
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in fetchUserData: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<bool> checkUserNames(String userName) async {
    try {
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (userToken == null) {
        throw AccountExceptions('Unable to authenticate. Please log in again.');
      }

      final client = locator.get<BaseApiClients>();
      final response = await client.post(
        Endpoints.checkUserName,
        body: {'username': userName},
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to check username availability',
        );
      }

      dev.log('username availability: ${decoded['isAvailable']}');
      return decoded['isAvailable'] as bool;
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in checkUserNames: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<LanguagePrefResponse> updateUserLanguage(
    String languagePrefString,
  ) async {
    try {
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (userToken == null) {
        throw AccountExceptions('Unable to authenticate. Please log in again.');
      }

      final client = locator.get<BaseApiClients>();
      final response = await client.patch(
        Endpoints.updateLanguagePref,
        body: {'preferredLanguage': languagePrefString},
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to change language preference',
        );
      }

      return LanguagePrefResponse.fromJson(decoded);
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in checkUserNames: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<LanguageResponse> fetchSupportedLanguages() async {
    try {
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (userToken == null) {
        throw AccountExceptions('Unable to authenticate. Please log in again.');
      }

      final client = locator.get<BaseApiClients>();
      final response = await client.get(
        Endpoints.getLanguage,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to get supported languages',
        );
      }

      return LanguageResponse.fromJson(decoded);
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in checkUserNames: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<bool> logOut() async {
    try {
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (userToken == null) {
        await _clearAuthStorage();
        return true;
      }

      final client = locator.get<BaseApiClients>();
      final response = await client.post(
        Endpoints.logout,
        body: {},
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AccountExceptions(
          decoded['message'] ?? 'Failed to log out. Please try again.',
        );
      }

      dev.log('logout: ${decoded['message']}');
      await _clearAuthStorage();
      return true;
    } on SocketException {
      throw AccountExceptions.network();
    } on HttpException catch (e) {
      throw AccountExceptions('Connection error: ${e.message}');
    } on FormatException {
      throw AccountExceptions.server();
    } on AccountExceptions {
      rethrow;
    } catch (e) {
      dev.log('Unexpected error in logOut: $e');
      throw AccountExceptions.unknown();
    }
  }

  Future<void> _clearAuthStorage() async {
    await SharedPreferencesStore.removeStorage(accessToken);
    await SharedPreferencesStore.removeStorage(userTokenKey);
    await SharedPreferencesStore.removeStorage(refreshToken);
    await SharedPreferencesStore.removeStorage(userRefreshKey);
    await SharedPreferencesStore.removeStorage(usedGoogleAuthKey);
    await SharedPreferencesStore.removeStorage(usedAppleAuthKey);
    await SharedPreferencesStore.removeStorage(userIdKey);
    await LocalStorageService.clear();

    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
  }

  Future<void> _clearAllStorage() async {
    await SharedPreferencesStore.removeStorage(accessToken);
    await SharedPreferencesStore.removeStorage(userTokenKey);
    await SharedPreferencesStore.removeStorage(refreshToken);
    await SharedPreferencesStore.removeStorage(userRefreshKey);
    await SharedPreferencesStore.removeStorage(usedGoogleAuthKey);
    await SharedPreferencesStore.removeStorage(usedAppleAuthKey);
    await SharedPreferencesStore.removeStorage(userIdKey);
    await SharedPreferencesStore.removeStorage(onboardKey);
    await SharedPreferencesStore.removeStorage(firstTimerKey);
    await SharedPreferencesStore.removeStorage(isAuthenticatedKey);
    await SharedPreferencesStore.removeStorage(hasSeenIntroSlidesKey);
    await SharedPreferencesStore.removeStorage(hasRegisteredKey);
    await SharedPreferencesStore.removeStorage(vocabularyKey);
    await SharedPreferencesStore.removeStorage(completeAccountSetupKey);
    await SharedPreferencesStore.removeStorage(themeKey);
    await LocalStorageService.clear();

    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
  }
}
