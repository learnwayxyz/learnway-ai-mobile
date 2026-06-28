import 'dart:developer';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class ContestSubmitScreen extends StatefulWidget {
  const ContestSubmitScreen({super.key, required this.contestId});
  final String contestId;

  @override
  State<ContestSubmitScreen> createState() => _ContestSubmitScreenState();
}

class _ContestSubmitScreenState extends State<ContestSubmitScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _submitContest();
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

  void _submitContest() {
    log('Submitting contest ${widget.contestId}');
    context.read<ContestBloc>().add(SubmitContest(widget.contestId));
  }

  void _retrySubmission() {
    log('Retrying submission');
    _controller.repeat();
    _submitContest();
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
          title: 'Contest',
          showBackButton: true,
          onBackPressed: () {
            context.router.popUntil(
              (route) => route.settings.name == ContestRoute.name,
            );
          },
        ),
        body: BlocConsumer<ContestBloc, ContestState>(
          listener: (context, state) {
            if (state is ErrorSubmittingContest) {
              _controller.stop();
            }
          },
          builder: (context, state) {
            log('state:23 ${state.runtimeType}');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is ErrorSubmittingContest) ...[
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 24),
                    Text(
                      'Please do not close your app, click the retry button to submit your answers',
                      style: AppTextStyles.md(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _retrySubmission,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ] else ...[
                    if (state is ContestSubmitting) ...[
                      Center(
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: CustomPaint(
                                size: const Size(48, 48),
                                painter: CircularProgressPainter(
                                  progress: 0.25,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'You have submitted your answers to the blockchain',
                      style: AppTextStyles.md(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We are calculating your rank and rewards',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
