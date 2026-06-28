import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/join_with_code_wait_room.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';

class PlayWithFriendJoinRoomModal extends StatefulWidget {
  final VoidCallback? onBattleStarted;

  const PlayWithFriendJoinRoomModal({super.key, this.onBattleStarted});

  @override
  State<PlayWithFriendJoinRoomModal> createState() =>
      _PlayWithFriendJoinRoomModalState();
}

class _PlayWithFriendJoinRoomModalState
    extends State<PlayWithFriendJoinRoomModal> {
  final _otpKey = GlobalKey<FormState>();
  String _pinValue = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).nextFocus();
    });
  }

  bool _isPinComplete() => _pinValue.length == 6;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BattlesBloc, BattlesState>(
      listener: (context, state) {
        if (state is BattleRoomJoined) {
          final battle = state.battle;
          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (ctx) => BlocProvider.value(
              value: locator<BattlesBloc>(),
              child: PlayWithFriendJoinWaitingRoomModal(
                battleId: battle.id,
                entryFees: battle.stakeAmount,
                initialParticipants: battle.participants,
                onBattleStarted: widget.onBattleStarted,
              ),
            ),
          );
        } else if (state is BattleRoomJoinError) {
          setState(() => _errorMessage = state.message);
        } else if (state is BattleRoomJoining) {
          setState(() => _errorMessage = null);
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final isJoining = state is BattleRoomJoining;

        return Container(
          height: 638,
          width: 412,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  const VSpace(25),
                  Text(
                    l10n.joinRoom,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                      letterSpacing: 0.20,
                    ),
                  ),
                  const VSpace(15),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.borderColor,
                  ),
                ],
              ),

              const VSpace(20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.enterRoomCodeToJoin,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
              ),

              const VSpace(15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: SizedBox(
                  height: 50,
                  child: OTPInputWidget(
                    formKey: _otpKey,
                    fieldHeight: 50,
                    fieldWidth: 50,
                    borderRadius: 8,
                    fillColor: Colors.white,
                    focusedBorderColor: const Color(0xFF535862),
                    borderColor: const Color(0xFFD5D6D9),
                    keyboardType: TextInputType.number,
                    autoFocus: true,
                    onChanged: (value) {
                      setState(() {
                        _pinValue = value;
                        _errorMessage = null;
                      });
                    },
                    onCompleted: (value) {
                      setState(() => _pinValue = value);
                    },
                  ),
                ),
              ),

              const VSpace(12),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              VSpace(60),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (_isPinComplete() && !isJoining)
                        ? () {
                            context.read<BattlesBloc>().add(
                              JoinBattleRoomEvent(roomCode: _pinValue),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPinComplete()
                          ? Colors.black
                          : Colors.grey,
                      disabledBackgroundColor: AppColors.gray300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: isJoining
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            l10n.joinARoom,
                            style: TextStyle(
                              color: AppColors.gray100,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.12,
                              letterSpacing: 0.20,
                            ),
                          ),
                  ),
                ),
              ),

              const VSpace(21),
            ],
          ),
        );
      },
    );
  }
}
