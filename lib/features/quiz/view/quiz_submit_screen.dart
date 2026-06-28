import 'dart:developer';
import 'dart:math' as math;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class QuizSubmitScreen extends StatefulWidget {
  const QuizSubmitScreen({super.key, required this.quizId});
  final String quizId;

  @override
  State<QuizSubmitScreen> createState() => _QuizSubmitScreenState();
}

class _QuizSubmitScreenState extends State<QuizSubmitScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _hasNavigatedToGemsEarned = false;
  bool _hasNavigatedToResult = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _submitQuiz();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  void _submitQuiz() {
    context.read<QuizBloc>().add(
      SubmitQuiz(locator.get<String>(instanceName: 'lessonId')),
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
          title: 'Learn And Earn',
          showBackButton: false,
        ),
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizGemsEarned && !_hasNavigatedToGemsEarned) {
              _hasNavigatedToGemsEarned = true;
              context.router.push(QuizGemsEarnedRoute());
            }

            if (state is QuizCompleted &&
                !_hasNavigatedToResult &&
                !_hasNavigatedToGemsEarned) {
              _hasNavigatedToResult = true;
              context.router.push(QuizResultRoute());
            }
          },
          builder: (context, state) {
            log('state: ${state.runtimeType}');
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
                    'You have submitted your answers to the blockchain',
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are minting your results',
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
