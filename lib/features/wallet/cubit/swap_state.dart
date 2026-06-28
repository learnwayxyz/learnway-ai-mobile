part of 'swap_cubit.dart';

enum SwapStatus { initial, inProgress, completed, failed }

class SwapState {
  SwapState({
    this.gemValue = '0.00',
    this.lwtValue = '0.00',
    this.calculatedGemValue = 0.00,
    this.calculatedLwtValue = 0.00,
    this.errorMessage,
    this.userInput,
    this.type,
    this.swapStatus = SwapStatus.initial,
  });

  final String gemValue;
  final String lwtValue;
  final String? userInput;
  final String? errorMessage;
  final double calculatedGemValue;
  final double calculatedLwtValue;
  final SwapType? type;
  final SwapStatus swapStatus;

  SwapState copyWith({
    String? gemValue,
    String? lwtValue,
    String? userInput,
    String? errorMessage,
    double? calculatedGemValue,
    double? calculatedLwtValue,
    SwapType? type,
    SwapStatus? swapStatus,
  }) {
    return SwapState(
      gemValue: gemValue ?? this.gemValue,
      lwtValue: lwtValue ?? this.lwtValue,
      userInput: userInput ?? this.userInput,
      errorMessage: errorMessage ?? this.errorMessage,
      calculatedGemValue: calculatedGemValue ?? this.calculatedGemValue,
      calculatedLwtValue: calculatedLwtValue ?? this.calculatedLwtValue,
      type: type ?? this.type,
      swapStatus: swapStatus ?? this.swapStatus,
    );
  }
}
