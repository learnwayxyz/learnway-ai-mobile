import 'package:ai_mentor/ai_mentor.dart' as ai;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';

@RoutePage()
class AiTutorTerminalScreen extends StatelessWidget {
  const AiTutorTerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = locator<HomeBloc>();
    final currentState = homeBloc.state;

    return ai.AiTutorTerminalScreen(
      initialUsername: currentState is FetchHomeDataSuccess
          ? currentState.userProfile?.username
          : null,
      usernameUpdates: homeBloc.stream
          .where((s) => s is FetchHomeDataSuccess)
          .map((s) => (s as FetchHomeDataSuccess).userProfile?.username),
      onNavigateToHome: () {
        context.read<MainActivityCubit>().resetState();
        context.router.replaceAll([const MainActivityRoute()]);
      },
      onNavigateToCareerGoal: () =>
          context.router.push(const CareerGoalRoute()),
      onInit: () => homeBloc.add(FetchHomeDataEvent()),
    );
  }
}
