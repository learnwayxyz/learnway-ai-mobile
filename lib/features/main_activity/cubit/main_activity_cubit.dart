import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwayv2/features/home/view/home_screen.dart';
import 'package:learnwayv2/features/leader_board/view/leader_board_screen.dart';
import 'package:learnwayv2/features/play/view/play_screen.dart';
import 'package:learnwayv2/features/account/view/account_screen.dart';
import 'package:learnwayv2/features/wallet/view/wallet_screen.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

part 'main_activity_state.dart';

class MainActivityCubit extends Cubit<MainActivityState> {
  MainActivityCubit()
    : super(
        MainActivityState(
          currentIndex: 0,
          activeBottomNav: _activeBottomNav,
          inActiveBottomNav: _inActiveBottomNav,
          pages: const [
            HomeScreen(),
            PlayScreen(),
            LeaderboardScreen(),
            WalletScreen(),
            AccountScreen(),
          ],
        ),
      );

  int _previousIndex = 0;

  void navigateTo(int index) {
    if (index != state.currentIndex) {
      _previousIndex = state.currentIndex;
      emit(state.copyWith(currentIndex: index, timestamp: DateTime.now()));
    }
  }

  int get previousIndex => _previousIndex;

  bool get isNavigatingToWallet => state.currentIndex == 3;

  void resetState() {
    _previousIndex = 0;
    emit(
      MainActivityState(
        currentIndex: 0,
        activeBottomNav: _activeBottomNav,
        inActiveBottomNav: _inActiveBottomNav,
        pages: const [
          HomeScreen(),
          PlayScreen(),
          LeaderboardScreen(),
          WalletScreen(),
          AccountScreen(),
        ],
      ),
    );
  }
}
