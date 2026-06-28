import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

void checkLevelType(BuildContext context, LevelType levelType) {
  if (levelType == LevelType.beginner) {
    context.read<LearnAndEarnBloc>().add(FetchBeginnerLessons());
  }
  if (levelType == LevelType.intermediate) {
    context.read<LearnAndEarnBloc>().add(FetchIntermediateLessons());
  }
  if (levelType == LevelType.advanced) {
    context.read<LearnAndEarnBloc>().add(FetchAdvancedLessons());
  }
}
