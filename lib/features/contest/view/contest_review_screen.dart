import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/circular_timer_widget.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';

@RoutePage()
class ContestReviewScreen extends StatefulWidget {
  const ContestReviewScreen({super.key});

  @override
  State<ContestReviewScreen> createState() => _ContestReviewScreenState();
}

class _ContestReviewScreenState extends State<ContestReviewScreen> {
  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: ResponsiveBuilder(
        builder: (context, responsiveInfo) {
          return Scaffold(
            appBar: AppBarFactory.standardAppBar(
              title: 'Contest Review',
              barHeight: 0,
            ),
            backgroundColor: const Color(0xffF8F9FC),
            body: BlocBuilder<ContestBloc, ContestState>(
              builder: (context, state) {
                if (state is ContestXPEarned) {
                  return ContestReviewView(
                    state: state,
                    currentQuestionIndex: currentQuestionIndex,
                    responsiveInfo: responsiveInfo,
                    onQuestionChanged: (index) {
                      setState(() {
                        currentQuestionIndex = index;
                      });
                    },
                  );
                }
                return Center(
                  child: Text(
                    'No contest data available for review',
                    style: AppTextStyles.base(context).copyWith(
                      fontSize:
                          AppTextStyles.base(context).fontSize! *
                          responsiveInfo.fontSizeMultiplier,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ContestReviewView extends StatelessWidget {
  final ContestXPEarned state;
  final int currentQuestionIndex;
  final ResponsiveInfo responsiveInfo;
  final Function(int) onQuestionChanged;
  static const int _questionDuration = 30;

  const ContestReviewView({
    super.key,
    required this.state,
    required this.currentQuestionIndex,
    required this.responsiveInfo,
    required this.onQuestionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentQuestion = state.questions[currentQuestionIndex];
    final userAnswer = state.userOptions[currentQuestionIndex];
    final correctAnswer = currentQuestion.options?.firstWhere(
      (opt) => opt.correct,
    );

    final timeSpentOnQuestion = state.questionTimes[currentQuestionIndex];
    final timeRemaining = _questionDuration - timeSpentOnQuestion;
    final progress = timeRemaining / _questionDuration;

    return Column(
      children: [
        VSpace(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ContentProgressTracker(
            totalItems: state.questions.length,
            currentItem: currentQuestionIndex,
          ),
        ),
        VSpace(responsiveInfo.isTablet ? 48 : 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: responsiveInfo.isTablet ? 40 : 30,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient3,
                        borderRadius: BorderRadius.circular(
                          responsiveInfo.responsiveBorderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: responsiveInfo.isTablet ? 80 : 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  responsiveInfo.responsiveBorderRadius,
                                ),
                                topRight: Radius.circular(
                                  responsiveInfo.responsiveBorderRadius,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: responsiveInfo.responsivePadding.copyWith(
                              left: responsiveInfo.responsivePadding.left * 1.5,
                              right:
                                  responsiveInfo.responsivePadding.right * 1.5,
                              bottom:
                                  responsiveInfo.responsivePadding.bottom * 1.5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Question ${currentQuestionIndex + 1}',
                                  textAlign: TextAlign.center,
                                  style:
                                      AppTextStyles.mdBold(
                                        context,
                                        color: Colors.white,
                                      ).copyWith(
                                        fontSize:
                                            AppTextStyles.mdBold(
                                              context,
                                            ).fontSize! *
                                            responsiveInfo.fontSizeMultiplier,
                                      ),
                                ),
                                SizedBox(
                                  height: getListSpacing(responsiveInfo),
                                ),
                                Text(
                                  currentQuestion.questionText,
                                  textAlign: TextAlign.center,
                                  style:
                                      AppTextStyles.base(
                                        context,
                                        color: Colors.white,
                                      ).copyWith(
                                        fontSize:
                                            AppTextStyles.base(
                                              context,
                                            ).fontSize! *
                                            responsiveInfo.fontSizeMultiplier,
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
                        child: Transform.scale(
                          scale: responsiveInfo.isTablet ? 1.2 : 1.0,
                          child: CircularTimerWidget(
                            timeRemaining: timeRemaining.clamp(
                              0,
                              _questionDuration,
                            ),
                            progress: progress.clamp(0.0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getListSpacing(responsiveInfo) * 2),
                ...(currentQuestion.options ?? []).asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = userAnswer?.id == option.id;
                  final isCorrectAnswer = option.correct;
                  final optionLetter = String.fromCharCode(65 + index);
                  final userGotQuestionWrong =
                      userAnswer?.id != correctAnswer?.id;

                  final showCorrect =
                      (isSelected && isCorrectAnswer) ||
                      (userGotQuestionWrong && isCorrectAnswer);
                  final showWrong = isSelected && !isCorrectAnswer;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: getListSpacing(responsiveInfo),
                    ),
                    child: ContestReviewAnswerOptionWidget(
                      letter: optionLetter,
                      text: option.option,
                      isSelected: isSelected,
                      isCorrectAnswer: isCorrectAnswer,
                      showAsCorrect: showCorrect,
                      showAsWrong: showWrong,
                      userGotQuestionWrong: userGotQuestionWrong,
                      responsiveInfo: responsiveInfo,
                      onTap: () {},
                    ),
                  );
                }),
                SizedBox(height: getListSpacing(responsiveInfo) * 2),
                _buildNavigationControls(context),
                SizedBox(height: getListSpacing(responsiveInfo) * 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationControls(BuildContext context) {
    final isFirstQuestion = currentQuestionIndex == 0;
    final isLastQuestion = currentQuestionIndex == state.questions.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonFactory.whiteButton(
          mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.fromLTRB(25, 16, 16, 16),
          trailingIcon: Icon(Icons.arrow_back_ios, size: 24),
          hasBorder: true,
          borderColor: isFirstQuestion ? AppColors.gray200 : AppColors.gray300,
          text: 'Back',
          onPressed: isFirstQuestion
              ? () {}
              : () {
                  onQuestionChanged(currentQuestionIndex - 1);
                },
        ),
        SizedBox(width: getListSpacing(responsiveInfo)),
        ButtonFactory.blackButton(
          mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.fromLTRB(25, 16, 16, 16),
          leadingIcon: Icon(Icons.arrow_forward_ios, size: 24),
          text: isLastQuestion ? 'Done' : 'Next',
          onPressed: () {
            if (isLastQuestion) {
              context.router.pop();
            } else {
              onQuestionChanged(currentQuestionIndex + 1);
            }
          },
        ),
      ],
    );
  }
}

class ContestReviewAnswerOptionWidget extends StatelessWidget {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool showAsCorrect;
  final bool showAsWrong;
  final bool userGotQuestionWrong;
  final ResponsiveInfo responsiveInfo;
  final VoidCallback onTap;

  const ContestReviewAnswerOptionWidget({
    super.key,
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.showAsCorrect,
    required this.showAsWrong,
    required this.userGotQuestionWrong,
    required this.responsiveInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Icon? marker;
    if (showAsCorrect) {
      marker = Icon(Icons.check_circle, color: Colors.green, size: 24);
    } else if (showAsWrong) {
      marker = Icon(Icons.cancel, color: Colors.red, size: 24);
    }

    Color borderColor;
    if (isCorrectAnswer) {
      borderColor = Colors.green;
    } else if (showAsWrong) {
      borderColor = Colors.red;
    } else if (isSelected) {
      borderColor = AppColors.success25;
    } else {
      borderColor = AppColors.gray300;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            responsiveInfo.responsiveBorderRadius * 0.6,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                responsiveInfo.responsiveBorderRadius * 0.6,
              ),
              border: Border.all(color: AppColors.gray300, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$letter. ',
                          style: AppTextStyles.baseBold(context).copyWith(
                            fontSize:
                                AppTextStyles.baseBold(context).fontSize! *
                                responsiveInfo.fontSizeMultiplier,
                          ),
                        ),
                        TextSpan(
                          text: text,
                          style: AppTextStyles.baseBold(context).copyWith(
                            fontSize:
                                AppTextStyles.baseBold(context).fontSize! *
                                responsiveInfo.fontSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: getListSpacing(responsiveInfo) * 0.75),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected || isCorrectAnswer || !isCorrectAnswer
                        ? null
                        : Border.all(color: AppColors.gray300, width: 1),
                  ),
                  child: marker,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
