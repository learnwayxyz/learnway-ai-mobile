import 'dart:async';
import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/env.prod.dart';
import 'package:learnwayv2/features/wallet/utils.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart' as UiUtils;
import 'package:variance_dart/variance_dart.dart';
import 'package:wallet/wallet.dart';
part 'swap_state.dart';

enum SwapType { gem, lwt }

class SwapCubit extends Cubit<SwapState> {
  SwapCubit() : super(SwapState());

  final _inputController = StreamController<String>.broadcast();
  Stream<String> get inputStream => _inputController.stream;

  StreamSubscription? _streamSubscription;
  SwapType? _lastType;

  void init() {
    _streamSubscription?.cancel();
    _streamSubscription = inputStream.listen((input) {
      const oneGemEquivalentToLWT = 0.02;
      const oneLWTEquivalentToGem = 50;
      if (input.isNotEmpty) {
        try {
          //500 Gems = 10 LWT
          // SO 1Gem = 0.02LWT
          // 1LWT = 50Gems
          if (_lastType == SwapType.gem) {
            final calculatedGemValue =
                double.parse(input) * oneGemEquivalentToLWT;
            log('Gem Value $calculatedGemValue');
            emit(
              state.copyWith(
                calculatedGemValue: calculatedGemValue,
                userInput: input,
                type: SwapType.gem,
              ),
            );
          } else {
            final calculatedLWTValue =
                double.parse(input) * oneLWTEquivalentToGem;
            emit(
              state.copyWith(
                calculatedLwtValue: calculatedLWTValue,
                userInput: input,
                type: SwapType.lwt,
              ),
            );
          }
        } catch (e) {
          emit(state.copyWith(errorMessage: 'Invalid input'));
        }
      } else {}
    });
  }

  void addInput(String userInput, SwapType type) {
    _lastType = type;
    _inputController.sink.add(userInput);
  }

  String getEquationText() {
    // Default text
    String text = '1 Token = 50 Gems';

    final currentState = state;

    text =
        '${currentState.userInput} Gem = ${currentState.calculatedGemValue} Token';

    return text;
  }

  Future<void> sendTransaction(String userInput, SwapType type) async {
    try {
      emit(state.copyWith(swapStatus: SwapStatus.inProgress));
      final smartWallet = locator<SmartWallet>();
      final response = await smartWallet.sendTransaction(
        EthereumAddress.fromHex(''),
        encodeERC20TransferWithTag(
          EthereumAddress.fromHex(''),
          EthereumAddress.fromHex(smartWallet.address.eip55With0x),
          UiUtils.convertToWei(userInput, 18),
        ),
      );
      final hash = await response.wait();
      emit(state.copyWith(swapStatus: SwapStatus.completed));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error sending LWT',
          swapStatus: SwapStatus.failed,
        ),
      );
    }
  }

  void resetState() {
    _lastType = null;
    emit(SwapState());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _inputController.close();
    return super.close();
  }
}
