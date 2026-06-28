import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/wallet/view/wallet_screen.dart';

part 'wallet_tab_state.dart';

class WalletTabCubit extends Cubit<WalletTabState> {
  WalletTabCubit() : super(WalletTabState());
  void selectTab(WalletTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }
}
