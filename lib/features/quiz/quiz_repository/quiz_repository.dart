import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_exception.dart';
import 'package:learnwayv2/features/quiz/models/quiz_response.dart';
import 'package:learnwayv2/features/quiz/models/submit_quiz_response.dart';
import 'package:learnwayv2/features/quiz/quiz_remote_data_source/quiz_remote_data_source.dart';
import 'package:core/core.dart';

///
class QuizRepository {
  QuizRepository._internal() {
    _quizRemoteDataSource = QuizRemoteDataSource();
  }
  factory QuizRepository() => _instance;
  static final QuizRepository _instance = QuizRepository._internal();
  late QuizRemoteDataSource _quizRemoteDataSource;

  Future<Either<Failure, QuizData>> getQuestions(String questionId) async {
    try {
      final result = await _quizRemoteDataSource.getQuestions(questionId);
      return Right(result.data);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, SubmitQuizResponse>> submitQuizResults(
    String questionId,
    int score,
    List<bool> answers,
    int timeTaken,
  ) async {
    try {
      final result = await _quizRemoteDataSource.submitQuizResults(
        questionId: questionId,
        score: score,
        answers: answers,
        timeTaken: timeTaken,
      );
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }
}
