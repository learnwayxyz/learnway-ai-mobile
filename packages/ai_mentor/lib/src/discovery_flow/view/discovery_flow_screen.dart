import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../career_goal/repository/career_goal_repository.dart';
import 'discovery_flow.dart';

@RoutePage()
class DiscoveryFlowScreen extends StatelessWidget {
  const DiscoveryFlowScreen({
    super.key,
    required this.onComplete,
    required this.getUserId,
    this.onEnterRecommendations,
    this.onSkip,
    this.allowBack = false,
  });

  final VoidCallback onComplete;
  final String Function() getUserId;
  final VoidCallback? onEnterRecommendations;
  final VoidCallback? onSkip;
  final bool allowBack;

  @override
  Widget build(BuildContext context) {
    return DiscoveryFlow(
      repository: GetIt.instance<CareerGoalRepository>(),
      onComplete: onComplete,
      getUserId: getUserId,
      onEnterRecommendations: onEnterRecommendations,
      onSkip: onSkip,
      allowBack: allowBack,
    );
  }
}
