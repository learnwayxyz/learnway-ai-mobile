import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/contest/model/start_contest_model.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class ContestLoaderScreen extends StatefulWidget {
  const ContestLoaderScreen({
    super.key,
    required this.title,
    required this.contestId,
  });
  final String title;
  final String contestId;

  @override
  State<ContestLoaderScreen> createState() => _ContestLoaderScreenState();
}

class _ContestLoaderScreenState extends State<ContestLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
    context.read<ContestBloc>().add(StartContest(widget.contestId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarFactory.standardAppBar(
          title: widget.title,
          showBackButton: false,
        ),
        body: BlocConsumer<ContestBloc, ContestState>(
          listener: (context, state) {
            if (state is ContestStarted) {
              log('ContestStarted()');
              context.router.replace(
                ContestQuizRoute(contestTitle: widget.title),
              );
            }

            if (state is ErrorStartingContest) {
              NotificationService.showError(state.message);
              context.router.pop();
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: CustomPaint(
                            size: const Size(48, 48),
                            painter: CircularProgressPainter(progress: 0.25),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We are preparing your Contest for you',
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Get ready to compete and win!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
