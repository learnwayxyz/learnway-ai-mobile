import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/view/contest_in_progress_view.dart';
import 'package:learnwayv2/features/contest/view/widgets/exit_contest_quiz.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class ContestQuizScreen extends StatefulWidget {
  const ContestQuizScreen({super.key, required this.contestTitle});
  final String contestTitle;

  @override
  State<ContestQuizScreen> createState() => _ContestQuizScreenState();
}

class _ContestQuizScreenState extends State<ContestQuizScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          showExitDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.contestTitle,
          barHeight: 0,
          onBackPressed: () {
            showExitDialog(context);
          },
        ),
        backgroundColor: const Color(0xffF8F9FC),
        body: BlocBuilder<ContestBloc, ContestState>(
          builder: (context, state) {
            if (state is ContestInProgress) {
              return ContestInProgressView(state: state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
