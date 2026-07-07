import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:learnwayv2/features/account/exceptions/account_exceptions.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account_setup/set_up_data_source/set_up_profile_helper.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/account_setup/set_up_data_source/setup_remote_source_model.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/auth_exception.dart';
import 'package:learnwayv2/services/eip_4337/account_abstraction.dart';
import 'package:variance_dart/variance_dart.dart';

class SetUpDataSource {
  Future<(SetupRemoteSourceModel, SmartWallet?)> setUpAccount({
    required String userName,
    required String country,
    required AuthProvider? authProvider,
    required String userEmail,
    String? referralCode,
    required String profileImagePath,
  }) async {
    try {
      final baseApi = locator<BaseApiClients>();

      final fields = <String, String>{
        "email": userEmail,
        "username": userName,
        "signupProvider":
            (authProvider == AuthProvider.apple ||
                authProvider == AuthProvider.google)
            ? (authProvider?.name ?? '')
            : "otp",
        "country": country,
        if (referralCode != null && referralCode.isNotEmpty)
          "referralCode": referralCode,
      };

      log('Setup account fields: $fields');

      http.Response response;

      if (profileImagePath.isEmpty || profileImagePath.startsWith('http')) {
        // Re-entry after a failed attempt: the avatar was prefilled from the
        // server profile as a URL — the image is already stored, so send the
        // fields without re-attaching a file.
        response = await baseApi.postMultipartWithBytes(
          Endpoints.setUpAccount,
          fields: fields,
          fileBytes: const {},
          fileNames: const {},
        );
      } else if (profileImagePath.startsWith('assets/')) {
        final prepared = await ProfileImageHelper.prepareImage(
          profileImagePath,
        );
        response = await baseApi.postMultipartWithBytes(
          Endpoints.setUpAccount,
          fields: fields,
          fileBytes: prepared.bytes,
          fileNames: prepared.names,
          mimeTypes: prepared.mime,
        );
      } else {
        final file = File(profileImagePath);
        if (!await file.exists()) {
          throw AuthFailure(
            'Profile image file does not exist: $profileImagePath',
          );
        }
        response = await baseApi.postMultipart(
          Endpoints.setUpAccount,
          fields: fields,
          files: {'profileImage': file},
        );
      }

      log('Response status: ${response.statusCode}');
      log('Raw response: ${response.body}');

      final decoded = json.decode(response.body);

      if (response.statusCode == 409 &&
          decoded['message'] != null &&
          decoded['message'].toString().toLowerCase().contains(
            'user with this email already exists',
          )) {
        log(
          'User already exists and is verified. Proceeding with wallet setup only.',
        );

        final existingToken = await SharedPreferencesStore.getUserToken(
          userTokenKey,
        );

        if (existingToken == null || existingToken.isEmpty) {
          throw AuthFailure(
            'User already exists but no valid authentication token found. Please login again.',
          );
        }
        final userId = await SharedPreferencesStore.getUserId(userIdKey);
        if (userId == null || userId.isEmpty) {
          throw AuthFailure(
            'User already exists but no valid authentication token found. Please login again.',
          );
        }
        log('Id because normal setup failed: $userId');
        final smartWallet = await _setUpWallet(
          existingToken,
          userEmail,
          authProvider ?? AuthProvider.email,
          userId,
        );
        if (locator.isRegistered<SmartWallet>()) {
          locator.unregister<SmartWallet>();
        }

        locator.registerLazySingleton<SmartWallet>(() => smartWallet!);
        if (smartWallet == null) {
          throw AuthFailure('Smart wallet setup failed for existing user.');
        }

        final userResponse = {
          'user': {
            'id': smartWallet.address.eip55With0x,
            'email': userEmail,
            'username': userName,
          },
          'accessToken': existingToken,
          'refreshToken':
              await SharedPreferencesStore.getUserToken(userRefreshKey) ?? '',
        };

        return (SetupRemoteSourceModel.fromJson(userResponse), smartWallet);
      }

      if (decoded['error'] != null && response.statusCode != 409) {
        throw AuthFailure(decoded['message'] ?? 'Account already exists');
      }

      final user = decoded['user'];
      if (user == null || user['id'] == null || user['email'] == null) {
        throw AuthFailure('Missing user information in response: $decoded');
      }

      final userId = user['id'].toString();
      final email = user['email'].toString();

      SharedPreferencesStore.setUserId(userIdKey, userId);
      SharedPreferencesStore.setUserToken(
        userTokenKey,
        decoded['accessToken'] ?? '',
      );
      SharedPreferencesStore.setUpRefreshToken(
        userRefreshKey,
        decoded['refreshToken'] ?? '',
      );

      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (userToken == null || userToken.isEmpty) {
        throw AuthFailure(
          'User token is null or empty, cannot proceed with setup.',
        );
      }

      final smartWallet = await _setUpWallet(
        userToken,
        email,
        authProvider ?? AuthProvider.email,
        userId,
      );

      if (locator.isRegistered<SmartWallet>()) {
        locator.unregister<SmartWallet>();
      }

      locator.registerLazySingleton<SmartWallet>(() => smartWallet!);

      if (smartWallet == null) {
        throw AuthFailure('Smart wallet setup failed.');
      }

      return (SetupRemoteSourceModel.fromJson(decoded), smartWallet);
    } catch (e) {
      log('Error in setUpAccount: $e');
      rethrow;
    }
  }

  Future<SmartWallet?> _setUpWallet(
    String authToken,
    String userEmail,
    AuthProvider? authProvider,
    String userId,
  ) async {
    try {
      final apiConfig = locator.get<ApiConfigResponse>();
      final value = await locator<AAServices>(param1: authProvider)
          .createWalletWithRecovery(
            userEmail: userEmail,
            authProvider: authProvider ?? AuthProvider.email,
            userId: userId,
            userPassphrase: '$userEmail:$userId:${apiConfig.pepAddress}',
          );
      return value.$1;
    } catch (e) {
      log('Failed to setup wallet: $e');
      throw Exception('Failed to setup wallet: $e');
    }
  }

  Future<bool> checkUserNames(String userName) async {
    try {
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
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
        throw AuthFailure('Error fetching courses}');
      }
      log('username(): ${decoded['isAvailable']}');
      return decoded['isAvailable'] as bool;
    } on SocketException catch (e) {
      throw AuthFailure('Network error: $e');
    } on HttpException catch (e) {
      throw Exception('Failed to check username: $e');
    }
  }

  Future<UserAccountModel> fetchUserData() async {
    try {
      final client = locator.get<BaseApiClients>();
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw Exception('User token is null, cannot fetch home data.');
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
      dev.log('Home data: $decoded');
      if (decoded['error'] != null) {
        throw AccountExceptions(
          'Error fetching home data: ${decoded['message']}',
        );
      }
      if (decoded['message'] == 'Unauthorized') {
        throw AccountExceptions('${decoded['message']}. Please log in again.');
      }

      return UserAccountModel.fromJson(decoded);
    } on FormatException {
      return Future.error(AccountExceptions('Invalid response format.'));
    } on HttpException catch (e) {
      return Future.error(AccountExceptions('HTTP error: ${e.message}'));
    } on SocketException catch (e) {
      return Future.error(AccountExceptions('Network error: ${e.message}'));
    } on Exception catch (e) {
      return Future.error(
        AccountExceptions('An unexpected error occurred: $e'),
      );
    }
  }
}
