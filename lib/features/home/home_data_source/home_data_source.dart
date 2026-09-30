import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/home/home_exception.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';

class HomeDataSource {
  final client = locator<BaseApiClients>();
  Future<UserProfileModel> fetchHomeData() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw Exception('User token is null, cannot fetch home data.');
      }
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
        throw HomeFailure('Error fetching home data: ${decoded['message']}');
      }
      if (decoded['message'] == 'Unauthorized') {
        throw HomeFailure('${decoded['message']}. Please log in again.');
      }

      try {
        final userProfile = UserProfileModel.fromJson(decoded);
        if (decoded.containsKey('dailyLessonsRemaining')) {
          final dailyRemaining = decoded['dailyLessonsRemaining'] as int?;
          LocalStorageService.updateDailyLessonsRemaining(
            dailyRemaining ?? LocalStorageService.unlimitedDailyLessons,
          );
        }
        await LocalStorageService.saveUser(userProfile);
        if (userProfile.id != null) {
          unawaited(RevenueCatService.instance.init(userId: userProfile.id));
        }
        return userProfile;
      } catch (e, stackTrace) {
        dev.log('Error parsing UserProfileModel: $e');
        dev.log('Stack trace: $stackTrace');
        dev.log('Problematic data: $decoded');
        rethrow;
      }
    } on FormatException {
      return Future.error(HomeFailure('Invalid response format.'));
    } on HttpException catch (e) {
      return Future.error(HomeFailure('HTTP error: ${e.message}'));
    } on SocketException catch (e) {
      return Future.error(HomeFailure('Network error: ${e.message}'));
    } on Exception catch (e) {
      return Future.error(HomeFailure('An unexpected error occurred: $e'));
    }
  }
}
