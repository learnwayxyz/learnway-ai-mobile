import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/view/play_in_group/join_waiting_room_modal.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';

class JoinRoomModal extends StatefulWidget {
  final VoidCallback? onBattleStarted;

  const JoinRoomModal({super.key, this.onBattleStarted});

  @override
  State<JoinRoomModal> createState() => _JoinRoomModalState();
}

class _JoinRoomModalState extends State<JoinRoomModal> {
  final _otpKey = GlobalKey<FormState>();
  String _pinValue = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus the PinPut when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Try to focus the first text field in the PinPut
      FocusScope.of(context).nextFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isPinComplete() {
    return _pinValue.length == 6;
  }

  @override
  Widget build(BuildContext context) {
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
          // Header with title and divider
          Column(
            children: [
              const VSpace(25),
              // Title
              Text(
                'Join Room',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.12,
                  letterSpacing: 0.20,
                ),
              ),
              const VSpace(15),
              // Divider line
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.borderColor,
              ),
            ],
          ),

          const VSpace(20),

          // Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter Room Code to join Battle',
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

          // Room code input boxes
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
                focusedBorderColor: Color(0xFF535862),
                borderColor: Color(0xFFD5D6D9),
                keyboardType: TextInputType.number,
                autoFocus: true,
                onChanged: (value) {
                  setState(() {
                    _pinValue = value;
                  });
                },
                onCompleted: (value) {
                  setState(() {
                    _pinValue = value;
                  });
                },
              ),
            ),
          ),

          const VSpace(60),

          // Join a Room Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isPinComplete()
                    ? () {
                        // Close current modal and show waiting room modal
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => JoinWaitingRoomModal(
                            roomCode: _pinValue,
                            entryFees: 0, // TODO: Get from room data
                            onBattleStarted: widget.onBattleStarted,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPinComplete()
                      ? Colors.black
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: Text(
                  'Join a Room',
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
  }
}
