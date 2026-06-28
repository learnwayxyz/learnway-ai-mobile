import 'dart:math' as math;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/view/level_screens/screen_helper.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

@RoutePage()
class RouteLoaderScreen extends StatefulWidget {
  const RouteLoaderScreen({
    super.key,
    this.title,
    this.lessonId,
    this.levelType,
    this.lessonImage,
  });
  final String? title;
  final String? lessonId;
  final LevelType? levelType;
  final String? lessonImage;

  @override
  State<RouteLoaderScreen> createState() => _RouteLoaderScreenState();
}

class _RouteLoaderScreenState extends State<RouteLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  String statusText = '';

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
    context.read<LearnAndEarnBloc>().add(
      StartLesson(lessonId: widget.lessonId!, courseId: checkCourseLevelType()),
    );
  }

  void forceRefresh() {
    context.read<LearnAndEarnBloc>().add(
      FetchCourseLessons(id: checkCourseLevelType(), forceRefresh: true),
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
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          forceRefresh();
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.title ?? '',
          barHeight: 0,
          onBackPressed: () {
            context.router.pop();
            forceRefresh();
          },
        ),
        body: BlocConsumer<LearnAndEarnBloc, LearnAndEarnState>(
          listener: (context, state) {
            if (state is StartedLesson) {
              context.read<LearnAndEarnBloc>().add(
                FetchLessonSlides(id: widget.lessonId!),
              );
            }
            if (state is FetchedLessonSlide) {
              context.router.push(
                ContentReaderRoute(
                  id: widget.lessonId ?? '',
                  title: widget.title ?? '',
                  slidesResponse: state.slide,
                  lessonImage: widget.lessonImage ?? '',
                ),
              );
            }

            if (state is StartedLessonError) {
              context.router.pop();
              forceRefresh();
            }

            if (state is FetchCourseLessonsError) {
              // NotificationService.showError(state.error);
              context.router.pop();
              forceRefresh();
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
                    AppLocalizations.of(context)!.preparingYourLesson,
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<LearnAndEarnBloc, LearnAndEarnState>(
                    builder: (context, state) {
                      return Text(
                        getStatusText(context, state),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getStatusText(BuildContext context, LearnAndEarnState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state is StartingLesson) {
      return l10n.startingLesson;
    } else if (state is StartedLesson) {
      return l10n.lessonStarted;
    } else if (state is FetchingCourseLessons) {
      return l10n.fetchingLessonSlides;
    } else if (state is FetchedCourseLessons) {
      return l10n.lessonFetched;
    } else {
      return l10n.continueToRead;
    }
  }
}
