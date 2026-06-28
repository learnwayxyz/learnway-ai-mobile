import 'package:learnwayv2/features/account/data/user_account_model.dart';

abstract class Iprofile {
  Future<void> updateProfile({
    required String username,
    required String email,
    required String phoneNumber,
    required String country,
    required String profileImagePath,
  });
  Future<void> deleteMyAccount();
  Future<UserAccountModel> fetchUserData();
}
