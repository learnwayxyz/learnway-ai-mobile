import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class QuizGemsEarnedScreen extends StatefulWidget {
  const QuizGemsEarnedScreen({super.key});

  @override
  State<QuizGemsEarnedScreen> createState() => _QuizGemsEarnedScreenState();
}

class _QuizGemsEarnedScreenState extends State<QuizGemsEarnedScreen>
    with TickerProviderStateMixin {
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
    final state = context.select<QuizBloc, QuizGemsEarned?>(
      (bloc) =>
          bloc.state is QuizGemsEarned ? bloc.state as QuizGemsEarned : null,
    );
    final gemsEarned = state?.gemsEarned ?? 0;
    final doubleGemsApplied = state?.submissionData?.doubleGemsApplied ?? false;
    final displayedGems = doubleGemsApplied && gemsEarned > 0
        ? gemsEarned * 2
        : gemsEarned;
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
                child: Image.asset(Assets.images.gemsEarned.path),
              ),
              const VSpace(39),
              Text(
                'You gained $displayedGems Gems!',
                style: AppTextStyles.xxlBold(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              const VSpace(10),
              if (doubleGemsApplied) ...[
                Text(
                  '2x gems for your first lesson of the day!',

                  style: AppTextStyles.baseRegular(context),
                ),
              ],
              const VSpace(81),
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: () {
                  context.read<QuizBloc>().add(ShowXPScreen());
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
