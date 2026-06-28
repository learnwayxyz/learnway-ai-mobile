part of 'contest_bloc.dart';

abstract class ContestEvent {}

class StartContest extends ContestEvent {
  StartContest(this.contestId);
  final String contestId;
}

class StopContest extends ContestEvent {}

class FetchContestQuestions extends ContestEvent {
  FetchContestQuestions(this.contestId);
  final String contestId;
}

class SelectContestOption extends ContestEvent {
  final QuestionOption option;
  SelectContestOption(this.option);
}

class NextContestQuestion extends ContestEvent {}

class ContestTimerTick extends ContestEvent {}

class ContestTimeExpired extends ContestEvent {}

class SubmitContest extends ContestEvent {
  final String contestId;
  SubmitContest(this.contestId);
}

class ShowContestXPScreen extends ContestEvent {}

class ShowContestGemsScreen extends ContestEvent {}

class ShowContestResultsScreen extends ContestEvent {}

class ResetContest extends ContestEvent {}

class GetAllContestsEvent extends ContestEvent {
  GetAllContestsEvent({
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
    this.forceRefresh = false,
    this.isBackgroundRefresh = false,
    this.contestStatus,
    this.order = 'DESC',
    this.sort = 'createdAt',
  });
  final int page;
  final int limit;
  final bool isLoadMore;
  final bool forceRefresh;
  final bool isBackgroundRefresh;
  final ContestStatus? contestStatus;
  final String order;
  final String sort;
}

class InitializeEntry extends ContestEvent {
  InitializeEntry({required this.contest});
  final Contest contest;
}

class SubmitAccessCode extends ContestEvent {
  SubmitAccessCode(this.code);
  final String code;
}

class RetryAccessCode extends ContestEvent {
  RetryAccessCode();
}

class ProcessPayment extends ContestEvent {
  ProcessPayment();
}

class BackToCodeEntry extends ContestEvent {
  BackToCodeEntry();
}

class JoinContestEvent extends ContestEvent {
  JoinContestEvent({required this.contestId, this.accessCode});
  final String contestId;
  final String? accessCode;
  final List<Question> questions = [];
}

class JoinPrivateContestEvent extends ContestEvent {
  JoinPrivateContestEvent({required this.contestId, required this.accessCode});
  final String contestId;
  final String accessCode;
}

class StartContestEvent extends ContestEvent {
  StartContestEvent({required this.contestId});
  final String contestId;
}

class PlayContestAudio extends ContestEvent {
  final bool isCorrect;
  PlayContestAudio(this.isCorrect);
}

class RetryStartContest extends ContestEvent {
  final String contestId;
  RetryStartContest({required this.contestId});
}

class RestoreCachedContestsEvent extends ContestEvent {
  RestoreCachedContestsEvent();
}

class ShowPaymentScreen extends ContestEvent {
  ShowPaymentScreen({required this.contest, required this.accessCode});
  final Contest contest;
  final String accessCode;
}
