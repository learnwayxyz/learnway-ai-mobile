import 'package:auto_route/auto_route.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class QuizXPEarnedScreen extends StatefulWidget {
  const QuizXPEarnedScreen({super.key});

  @override
  State<QuizXPEarnedScreen> createState() => _QuizXPEarnedScreenState();
}

class _QuizXPEarnedScreenState extends State<QuizXPEarnedScreen>
    with TickerProviderStateMixin {
  bool _hasNavigatedToResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final xpEarned = context.select<QuizBloc, int>(
      (bloc) => bloc.state is QuizXPEarned
          ? (bloc.state as QuizXPEarned).xpEarned
          : 0,
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: 'Learn and Earn',
          barHeight: 0,
          showBackButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 260,
                height: 260,
                child: Image.asset(Assets.images.xpImage.path),
              ),
              const VSpace(39),
              Text(
                'You gained $xpEarned XPs',
                style: AppTextStyles.xxlBold(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              const VSpace(10),

              Text(
                'Congratulations on your gains',
                style: AppTextStyles.baseRegular(context),
              ),
              const VSpace(81),

              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: () {
                  if (!_hasNavigatedToResult) {
                    _hasNavigatedToResult = true;
                    context.read<QuizBloc>().add(ShowResultsScreen());
                  }
                },
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
