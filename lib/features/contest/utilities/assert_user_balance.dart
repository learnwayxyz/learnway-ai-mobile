import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

Future<bool> checkUserGemBalance(int amountToDeduct) async {
  final userData = await LocalStorageService.getUser();

  if (userData!.totalGems! > amountToDeduct) {
    return true;
  }
  return false;
}
