import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_response_model.dart';
import 'package:learnwayv2/features/leader_board/models/my_position_model.dart';
import 'package:learnwayv2/features/leader_board/repository/leaderboard_repository.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/services/websocket/websocket_service.dart';

part 'leader_board_state.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  final LeaderboardRepository _repository;
  final Map<String, LeaderboardResponseModel> _cachedLeaderboards = {};
  MyPositionModel? _cachedMyPosition;

  LeaderBoardCubit(this._repository) : super(LeaderBoardInitial());

  Future<void> loadAllTimeLeaderboard({
    int limit = 100,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    try {
      final period = 'alltime';
      final hasCachedData = _cachedLeaderboards.containsKey(period);

      if (!hasCachedData || forceRefresh) {
        if (!forceRefresh && !hasCachedData) {
          if (!isClosed) emit(LeaderBoardLoading());
        } else if (hasCachedData) {
          if (!isClosed) {
            emit(
              LeaderBoardLoaded(
                leaderboard: _cachedLeaderboards[period]!,
                myPosition: _cachedMyPosition,
                period: period,
                isRefreshing: true,
              ),
            );
          }
        }
      } else {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: true,
            ),
          );
        }
      }

      final leaderboard = await _repository.getAllTimeLeaderboard(
        limit: limit,
        offset: offset,
      );

      // Check if cubit is still active before continuing
      if (isClosed) return;

      MyPositionModel? myPosition;
      try {
        myPosition = await _repository.getMyPosition();
        _cachedMyPosition = myPosition;
      } catch (e) {
        myPosition = _cachedMyPosition;
      }

      // Check again after async operation
      if (isClosed) return;

      _cachedLeaderboards[period] = leaderboard;

      if (!isClosed) {
        emit(
          LeaderBoardLoaded(
            leaderboard: leaderboard,
            myPosition: myPosition,
            period: period,
            isRefreshing: false,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      final period = 'alltime';
      if (_cachedLeaderboards.containsKey(period)) {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: false,
            ),
          );
        }
      } else {
        if (!isClosed) emit(LeaderBoardError(e.toString()));
      }
    }
  }

  Future<void> loadMonthlyLeaderboard({
    int limit = 100,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    try {
      final period = 'monthly';
      final hasCachedData = _cachedLeaderboards.containsKey(period);

      if (!hasCachedData || forceRefresh) {
        if (!forceRefresh && !hasCachedData) {
          if (!isClosed) emit(LeaderBoardLoading());
        } else if (hasCachedData) {
          if (!isClosed) {
            emit(
              LeaderBoardLoaded(
                leaderboard: _cachedLeaderboards[period]!,
                myPosition: _cachedMyPosition,
                period: period,
                isRefreshing: true,
              ),
            );
          }
        }
      } else {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: true,
            ),
          );
        }
      }

      final leaderboard = await _repository.getMonthlyLeaderboard(
        limit: limit,
        offset: offset,
      );
      if (isClosed) return;

      MyPositionModel? myPosition;
      try {
        myPosition = await _repository.getMyPosition();
        _cachedMyPosition = myPosition;
      } catch (e) {
        myPosition = _cachedMyPosition;
      }

      // Check again after async operation
      if (isClosed) return;

      // Cache the new data
      _cachedLeaderboards[period] = leaderboard;

      if (!isClosed) {
        emit(
          LeaderBoardLoaded(
            leaderboard: leaderboard,
            myPosition: myPosition,
            period: period,
            isRefreshing: false,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      // If we have cached data, show it instead of error
      final period = 'monthly';
      if (_cachedLeaderboards.containsKey(period)) {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: false,
            ),
          );
        }
      } else {
        if (!isClosed) emit(LeaderBoardError(e.toString()));
      }
    }
  }

  Future<void> loadWeeklyLeaderboard({
    int limit = 100,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    try {
      final period = 'weekly';
      final hasCachedData = _cachedLeaderboards.containsKey(period);

      if (!hasCachedData || forceRefresh) {
        if (!forceRefresh && !hasCachedData) {
          if (!isClosed) emit(LeaderBoardLoading());
        } else if (hasCachedData) {
          if (!isClosed) {
            emit(
              LeaderBoardLoaded(
                leaderboard: _cachedLeaderboards[period]!,
                myPosition: _cachedMyPosition,
                period: period,
                isRefreshing: true,
              ),
            );
          }
        }
      } else {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: true,
            ),
          );
        }
      }

      final leaderboard = await _repository.getWeeklyLeaderboard(
        limit: limit,
        offset: offset,
      );

      // Check if cubit is still active before continuing
      if (isClosed) return;

      MyPositionModel? myPosition;
      try {
        myPosition = await _repository.getMyPosition();
        _cachedMyPosition = myPosition;
      } catch (e) {
        // If getting user position fails, use cached or null
        myPosition = _cachedMyPosition;
      }

      // Check again after async operation
      if (isClosed) return;

      // Cache the new data
      _cachedLeaderboards[period] = leaderboard;

      if (!isClosed) {
        emit(
          LeaderBoardLoaded(
            leaderboard: leaderboard,
            myPosition: myPosition,
            period: period,
            isRefreshing: false,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      // If we have cached data, show it instead of error
      final period = 'weekly';
      if (_cachedLeaderboards.containsKey(period)) {
        if (!isClosed) {
          emit(
            LeaderBoardLoaded(
              leaderboard: _cachedLeaderboards[period]!,
              myPosition: _cachedMyPosition,
              period: period,
              isRefreshing: false,
            ),
          );
        }
      } else {
        if (!isClosed) emit(LeaderBoardError(e.toString()));
      }
    }
  }

  Future<void> getLeaderBoard() async {
    try {
      final socket = locator.get<WebsocketService>();
      final authToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      socket.connect(Env.webSocketUrl, authToken: authToken);
      socket.onEvent('leaderboard', (data) {
        emit(
          LeaderBoardLoaded(
            leaderboard: data,
            period: '',
            myPosition: null,
            isRefreshing: false,
          ),
        );
      });
    } catch (e) {
      emit(LeaderBoardError(e.toString()));
    }
  }
}
