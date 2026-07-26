import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../cubit/career_goal_cubit.dart';
import 'career_goal_view.dart';

@RoutePage()
class CareerGoalScreen extends StatelessWidget {
  const CareerGoalScreen({
    super.key,
    required this.cubit,
    required this.onComplete,
    required this.getUserId,
  });

  final CareerGoalCubit cubit;
  final VoidCallback onComplete;
  final String Function() getUserId;

  @override
  Widget build(BuildContext context) {
    return CareerGoalView(
      cubit: cubit,
      onComplete: onComplete,
      getUserId: getUserId,
    );
  }
}
