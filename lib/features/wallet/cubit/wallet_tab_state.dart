part of 'wallet_tab_cubit.dart';

class WalletTabState extends Equatable {
  final WalletTab selectedTab;

  const WalletTabState({this.selectedTab = WalletTab.all});

  WalletTabState copyWith({WalletTab? selectedTab}) {
    return WalletTabState(selectedTab: selectedTab ?? this.selectedTab);
  }

  @override
  List<Object?> get props => [selectedTab];
}
