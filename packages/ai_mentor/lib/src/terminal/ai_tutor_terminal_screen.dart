import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'ai_tutor_terminal.dart';

@RoutePage()
class AiTutorTerminalScreen extends StatelessWidget {
  const AiTutorTerminalScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToCareerGoal,
    this.onInit,
    this.initialUsername,
    this.usernameUpdates,
  });

  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToCareerGoal;
  final VoidCallback? onInit;
  final String? initialUsername;
  final Stream<String?>? usernameUpdates;

  @override
  Widget build(BuildContext context) {
    return AiTutorTerminal(
      onNavigateToHome: onNavigateToHome,
      onNavigateToCareerGoal: onNavigateToCareerGoal,
      onInit: onInit,
      initialUsername: initialUsername,
      usernameUpdates: usernameUpdates,
    );
  }
}
