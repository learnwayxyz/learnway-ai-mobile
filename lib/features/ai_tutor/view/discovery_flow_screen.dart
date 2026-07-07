import 'package:ai_mentor/ai_mentor.dart' as ai;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/play/cubit/roadmap_cubit.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

@RoutePage()
class DiscoveryFlowScreen extends StatefulWidget {
  const DiscoveryFlowScreen({super.key, this.allowBack = false});

  final bool allowBack;

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
    var id = await SharedPreferencesStore.getUserId(userIdKey);

    // Existing installs may never have persisted the id to SharedPreferences
    // (it was only written during onboarding/verification). Fall back to the
    // Hive-cached profile and heal the missing key.
    if (id == null || id.isEmpty) {
      id = LocalStorageService.getUserSync()?.id;
      if (id != null && id.isNotEmpty) {
        await SharedPreferencesStore.setUserId(userIdKey, id);
      }
    }

    if (mounted && id != null && id.isNotEmpty) {
      setState(() => _userId = id!);
    }
  }

  String _resolveUserId() {
    if (_userId.isNotEmpty) return _userId;
    // Last resort if the async load hasn't finished (or found nothing) by the
    // time the flow submits.
    return LocalStorageService.getUserSync()?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ai.DiscoveryFlowScreen(
      onComplete: () {
        // The goal just changed on the backend — refetch so the My Learning
        // tab's BlocBuilders rebuild with the new career goal and roadmap.
        locator<ai.DashboardCubit>().fetchDashboard();
        locator<RoadmapCubit>().fetchMyRoadmap();

        final mainActivityCubit = context.read<MainActivityCubit>();
        if (widget.allowBack) {
          // Entered from Play > My Learning: go straight back there.
          mainActivityCubit.navigateToPlayTab(1);
          context.router.replaceAll([const MainActivityRoute()]);
        } else {
          mainActivityCubit.resetState();
          context.router.replaceAll([const MainActivityRoute()]);
        }
      },
      getUserId: _resolveUserId,
      onSkip: () {
        context.read<MainActivityCubit>().resetState();
        context.router.replaceAll([const MainActivityRoute()]);
      },
      onEnterRecommendations: () =>
          locator<HomeBloc>().add(FetchHomeDataEvent()),
      allowBack: widget.allowBack,
    );
  }
}
