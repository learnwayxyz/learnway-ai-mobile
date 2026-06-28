class ContestException implements Exception {
  final String message;

  ContestException(this.message);

  @override
  String toString() => message;
}

class ContestFailure extends ContestException {
  ContestFailure(super.message);
}

class StartContestFailure extends ContestException {
  StartContestFailure(super.message);
}

class ContestJoinFailure extends ContestException {
  ContestJoinFailure(super.message);
}

class ContestNetworkException extends ContestException {
  ContestNetworkException(super.message);
}

class ContestNotFoundException extends ContestException {
  ContestNotFoundException(super.message);
}

class ContestAlreadyCompletedException extends ContestException {
  ContestAlreadyCompletedException(super.message);
}

class ContestNotStartedException extends ContestException {
  ContestNotStartedException(super.message);
}

class ContestExpiredException extends ContestException {
  ContestExpiredException(super.message);
}
