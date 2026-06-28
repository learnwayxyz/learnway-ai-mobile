import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class QuizLoaderScreen extends StatefulWidget {
  const QuizLoaderScreen({super.key, required this.title, required this.id});
  final String title;
  final String id;
  @override
  State<QuizLoaderScreen> createState() => _QuizLoaderScreenState();
}

class _QuizLoaderScreenState extends State<QuizLoaderScreen>
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
    context.read<QuizBloc>().add(
      FetchQuestions(widget.id, lessonTitle: widget.title),
    );
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
        appBar: AppBarFactory.standardAppBar(
          title: widget.title,
          showBackButton: false,
          barHeight: 0,
        ),
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuestionsFetched) {
              context.router.push(QuizRoute(quizTitle: widget.title));
            }

            if (state is ErrorFetchingQuestions) {
              NotificationService.showError(state.message);
            }
            if (state is ErrorFetchingQuestions) {
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
                    AppLocalizations.of(context)!.preparingYourQuiz,
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.letsTestYourKnowledge,
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
