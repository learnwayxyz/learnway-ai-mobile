import 'package:ai_mentor/ai_mentor.dart' as ai;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';

@RoutePage()
class DiscoveryFlowScreen extends StatefulWidget {
  const DiscoveryFlowScreen({super.key});

  @override
  State<DiscoveryFlowScreen> createState() => _DiscoveryFlowScreenState();
}

class _DiscoveryFlowScreenState extends State<DiscoveryFlowScreen> {
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SharedPreferencesStore.getUserId(userIdKey);
    if (mounted && id != null && id.isNotEmpty) {
      setState(() => _userId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ai.DiscoveryFlowScreen(
      onComplete: () {
        context.read<MainActivityCubit>().resetState();
        context.router.replaceAll([const MainActivityRoute()]);
      },
      getUserId: () => _userId,
      onEnterRecommendations: () =>
          locator<HomeBloc>().add(FetchHomeDataEvent()),
    );
  }
}
