import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/features/contest/model/contest_leaderboard_response.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/services/websocket/websocket_service.dart';

part 'leader_board_state.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  final WebsocketService _websocketService;
  final String contestId;
  String? _currentUserId;

  LeaderBoardCubit({
    required WebsocketService websocketService,
    required this.contestId,
  }) : _websocketService = websocketService,
       super(LoadingLeaderBoardState());

  Future<void> connectAndListenToLeaderboard({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      emit(LoadingLeaderBoardState());

      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final user = await LocalStorageService.getUser();
      _currentUserId = user?.id;

      final webSocketUrl = Env.webSocketUrl;
      _websocketService.connect(
        '$webSocketUrl/contest-leaderboard',
        authToken: token,
      );

      _websocketService.onEvent('contest:leaderboard:initial', (data) {
        log('Received initial leaderboard data: $data');
        _handleLeaderboardData(data);
      });

      _websocketService.onEvent('contest:leaderboard:update', (data) {
        _handleLeaderboardData(data);
      });

      _websocketService.onEvent('contest:rank:change', (data) {
        _handleRankChange(data);
      });

      _websocketService.onEvent('connect_error', (error) {
        log(' WebSocket connection error: $error');
        if (!isClosed) {
          emit(LeaderBoardError('Failed to connect to leaderboard'));
        }
      });

      _websocketService.setOnConnectCallback(() {
        log('🔌 Socket connected! Subscribing to contest: $contestId');
        subscribeToContest(limit: limit, offset: offset);
      });
    } catch (e) {
      log('Error connecting to leaderboard: $e');
      if (!isClosed) {
        emit(LeaderBoardError(e.toString()));
      }
    }
  }

  void subscribeToContest({int limit = 100, int offset = 0}) {
    log(
      'Subscribing to contest: $contestId with limit: $limit, offset: $offset',
    );
    _websocketService.emit('subscribe', {
      'contestId': contestId,
      'limit': limit,
      'offset': offset,
    });
  }

  void unsubscribeFromContest() {
    log('Unsubscribing from contest: $contestId');
    _websocketService.emit('unsubscribe', {'contestId': contestId});
  }

  void getMyPosition() {
    log('Requesting my position for contest: $contestId');
    _websocketService.emit('getMyPosition', {'contestId': contestId});
  }

  void _handleLeaderboardData(dynamic data) {
    try {
      if (isClosed) return;

      if (data is! Map<String, dynamic>) {
        log('Invalid data format received');
        return;
      }

      final response = ContestLeaderboardResponse.fromJson(data);
      final participants = response.data.participants;

      log(
        'Parsed ${participants.length} participants (total: ${response.data.total})',
      );
      int myRank = 0;
      for (final participant in participants) {
        if (participant.isCurrentUser(_currentUserId)) {
          myRank = participant.rank ?? 0;
          break;
        }
      }

      emit(
        LeaderBoardLoaded(
          participants: participants,
          myRank: myRank,
          total: response.data.total,
        ),
      );
    } catch (e, stackTrace) {
      log('Error parsing leaderboard data: $e');
      log('Stack trace: $stackTrace');
      if (!isClosed) {
        emit(LeaderBoardError('Failed to parse leaderboard data'));
      }
    }
  }

  void _handleRankChange(dynamic data) {
    try {
      if (isClosed) return;

      log('Processing rank change: $data');

      if (data is Map<String, dynamic>) {
        final rankData = data['data'] as Map<String, dynamic>?;
        final rank = rankData?['rank'] as int?;

        if (rank != null) {
          final currentState = state;
          if (currentState is LeaderBoardLoaded) {
            emit(
              LeaderBoardLoaded(
                participants: currentState.participants,
                myRank: rank,
                total: currentState.total,
              ),
            );
            log('Updated user rank to: $rank');
          }
        }
      }
    } catch (e) {
      log('Error handling rank change: $e');
    }
  }

  void requestLeaderboardUpdate() {
    _websocketService.emit('request:leaderboard', {'contestId': contestId});
  }

  @override
  Future<void> close() {
    unsubscribeFromContest();

    _websocketService.off('contest:leaderboard:initial');
    _websocketService.off('contest:leaderboard:update');
    _websocketService.off('contest:rank:change');
    _websocketService.off('connect_error');

    return super.close();
  }
}
