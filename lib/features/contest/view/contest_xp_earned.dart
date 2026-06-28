import 'package:auto_route/auto_route.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class ContestXPEarnedScreen extends StatefulWidget {
  const ContestXPEarnedScreen({super.key});

  @override
  State<ContestXPEarnedScreen> createState() => _ContestXPEarnedScreenState();
}

class _ContestXPEarnedScreenState extends State<ContestXPEarnedScreen>
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
    final xpEarned = context.select<ContestBloc, int>(
      (bloc) => bloc.state is ContestXPEarned
          ? (bloc.state as ContestXPEarned).xpEarned
          : 0,
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: 'Contest',
          barHeight: 0,
          showBackButton: false,
        ),
        backgroundColor: const Color(0xffF8F9FC),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Center(
                child: Text(
                  'Congratulations on your gains',
                  style: AppTextStyles.baseRegular(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const VSpace(81),
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: () {
                  context.read<ContestBloc>().add(ShowContestResultsScreen());
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
