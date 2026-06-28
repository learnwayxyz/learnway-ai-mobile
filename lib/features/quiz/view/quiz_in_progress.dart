import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/features/quiz/widgets/answer_option_widget.dart';
import 'package:learnwayv2/shared/widgets/circular_timer_widget.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';

class QuizInProgressView extends StatelessWidget {
  final QuizInProgress state;

  const QuizInProgressView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentQuestion = state.questions[state.currentQuestionIndex];
    return Column(
      children: [
        VSpace(20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ContentProgressTracker(
            totalItems: state.questions.length,
            currentItem: state.currentQuestionIndex,
          ),
        ),
        VSpace(40),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Question ${state.currentQuestionIndex + 1}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.mdBold(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                                const VSpace(12),
                                Text(
                                  currentQuestion.question,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.base(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularTimerWidget(
                          timeRemaining: state.timeRemaining,
                          progress: state.timerProgress,
                        ),
                      ),
                    ),
                  ],
                ),
                const VSpace(32),
                ...currentQuestion.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = state.selectedOptions == option.option;
                  final isCorrectAnswer = option.correct;
                  final optionLetter = String.fromCharCode(65 + index);
                  final showCorrect =
                      state.isAnswered && isSelected && isCorrectAnswer;
                  final showWrong =
                      state.isAnswered && isSelected && !isCorrectAnswer;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AnswerOptionWidget(
                      letter: optionLetter,
                      text: option.option,
                      isSelected: isSelected,
                      isAnswered: state.isAnswered,
                      isCorrectAnswer: showCorrect,
                      isWrongAnswer: showWrong,
                      onTap: () {
                        if (!state.isAnswered) {
                          context.read<QuizBloc>().add(SelectAnOption(option));
                          context.read<QuizBloc>().add(
                            PlayAudio(isCorrectAnswer),
                          );
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
