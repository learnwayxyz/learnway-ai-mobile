import 'package:ai_mentor/ai_mentor.dart' as ai;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

@RoutePage()
class CareerGoalScreen extends StatelessWidget {
  const CareerGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ai.CareerGoalScreen(
      cubit: locator<ai.CareerGoalCubit>(),
      onComplete: () {
        context.read<MainActivityCubit>().resetState();
        context.router.replaceAll([const MainActivityRoute()]);
      },
      getUserId: () => LocalStorageService.getUserSync()?.id ?? '',
    );
  }
}
