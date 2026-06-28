import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/features/quiz/view/quiz_in_progress.dart';
import 'package:learnwayv2/features/quiz/widgets/quiz_exit_dialogue.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quizTitle});
  final String quizTitle;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
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
          title: widget.quizTitle,
          barHeight: 0,
          onBackPressed: () {
            showExitDialog(context);
          },
        ),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInProgress) {
              return QuizInProgressView(state: state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class QuizCompletedView extends StatelessWidget {
  final QuizCompleted state;

  const QuizCompletedView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final percentage = (state.score / state.totalQuestions * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored ${state.score} out of ${state.totalQuestions}',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const VSpace(8),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<QuizBloc>().add(ResetQuiz());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.takeQuizAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCompletedGemsView extends StatelessWidget {
  final QuizCompleted state;

  const QuizCompletedGemsView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final percentage = (state.score / state.totalQuestions * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored ${state.score} out of ${state.totalQuestions}',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<QuizBloc>().add(ResetQuiz());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.takeQuizAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCompletedXPView extends StatelessWidget {
  final QuizCompleted state;

  const QuizCompletedXPView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final percentage = (state.score / state.totalQuestions * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored ${state.score} out of ${state.totalQuestions}',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<QuizBloc>().add(ResetQuiz());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.takeQuizAgain),
            ),
          ],
        ),
      ),
    );
  }
}
