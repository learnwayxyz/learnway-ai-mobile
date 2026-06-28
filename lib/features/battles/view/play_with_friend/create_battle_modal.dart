import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/play_with_friend_waiting_room_modal.dart';
import 'package:learnwayv2/features/battles/view/shared/enums/battle_quiz_enums.dart';
import 'package:learnwayv2/features/battles/view/shared/how_battle_works_dialog.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class CreateBattleModal extends StatefulWidget {
  final VoidCallback? onBattleStarted;
  final bool isGroupBattle;

  const CreateBattleModal({
    super.key,
    this.onBattleStarted,
    this.isGroupBattle = false,
  });

  @override
  State<CreateBattleModal> createState() => _CreateBattleModalState();
}

class _CreateBattleModalState extends State<CreateBattleModal> {
  BattleTopic? _selectedTopic;
  final TextEditingController _amountController = TextEditingController();
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BattlesBloc>().add(const LoadBattleTopicsEvent());
      }
    });
  }

  void _validateAmount() {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      if (_amountError != null) setState(() => _amountError = null);
      return;
    }

    final parsed = int.tryParse(text);
    final totalGems = LocalStorageService.getUserSync()?.totalGems ?? 0;

    String? error;
    if (parsed == null || parsed <= 0) {
      error = 'Amount must be greater than 0';
    } else if (parsed > totalGems) {
      error =
          'Exceeds your balance of ${NumberFormat('#,##0').format(totalGems)} gems';
    }

    if (error != _amountError) setState(() => _amountError = error);
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateAmount);
    _amountController.dispose();
    super.dispose();
  }

  void _onCreateRoom(BuildContext context, List<BattleTopic> topics) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedTopic == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectATopic)));
      return;
    }
    final amount = _amountController.text.trim();
    if (amount.isEmpty || int.tryParse(amount) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterValidGemAmount)));
      return;
    }

    final parsedAmount = int.parse(amount);
    final totalGems = LocalStorageService.getUserSync()?.totalGems ?? 0;

    if (parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than 0')),
      );
      return;
    }

    if (parsedAmount > totalGems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient gems. Your balance is ${NumberFormat('#,##0').format(totalGems)} gems.',
          ),
        ),
      );
      return;
    }

    context.read<BattlesBloc>().add(
      CreateBattleRoomEvent(
        type: widget.isGroupBattle ? RoomType.group : RoomType.friend,
        topicId: _selectedTopic!.id,
        stakeAmount: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BattlesBloc, BattlesState>(
      listener: (context, state) {
        if (state is BattleRoomCreated) {
          final bloc = context.read<BattlesBloc>();
          final battle = state.battle;
          final topicTitle =
              state.topics
                  .where((t) => t.id == battle.topicId)
                  .map((t) => t.title)
                  .firstOrNull ??
              _selectedTopic?.title ??
              '';

          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (ctx) => BlocProvider.value(
              value: bloc,
              child: PlayWithFriendWaitingRoomModal(
                battleId: battle.id,
                roomCode: battle.roomCode ?? '',
                entryFees: battle.stakeAmount,
                topicTitle: topicTitle,
                onBattleStarted: widget.onBattleStarted,
                isGroupBattle: widget.isGroupBattle,
              ),
            ),
          );
        } else if (state is BattleRoomCreateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final topics = switch (state) {
          BattleTopicsLoaded(:final topics) => topics,
          BattleRoomCreating(:final topics) => topics,
          BattleRoomCreated(:final topics) => topics,
          BattleRoomCreateError(:final topics) => topics,
          _ => <BattleTopic>[],
        };

        final isCreating = state is BattleRoomCreating;
        final isLoadingTopics = state is BattleTopicsLoading;

        final totalGems = LocalStorageService.getUserSync()?.totalGems ?? 0;
        final formattedGems = NumberFormat('#,##0').format(totalGems);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VSpace(22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Text(
                      l10n.createABattle,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.12,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                  const VSpace(11),
                  Container(height: 1, color: AppColors.borderLight),

                  const VSpace(31),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        Text(
                          l10n.yourGemBalance,
                          style: TextStyle(
                            color: AppColors.gray500,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const VSpace(10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEBF5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/blue_gem.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const HSpace(4),
                              Text(
                                formattedGems,
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VSpace(10),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final l10n = AppLocalizations.of(context)!;
                                return HowBattleWorksDialog(
                                  title: l10n.howBattleWorksTitle,
                                  steps: [
                                    l10n.howBattleWorksStep1,
                                    l10n.howBattleWorksStep2,
                                    l10n.howBattleWorksStep3,
                                    l10n.howBattleWorksStep4,
                                    l10n.howBattleWorksStep5,
                                    l10n.howBattleWorksStep6,
                                    l10n.howBattleWorksStep7,
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/battles/heroicons_light-bulb.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  AppColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const HSpace(4),
                              Text(
                                l10n.howBattleWorks,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.14,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VSpace(41),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chooseYourTopic,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.12,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const VSpace(5),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: isLoadingTopics
                              ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<BattleTopic>(
                                    isExpanded: true,
                                    value: _selectedTopic,
                                    hint: Text(
                                      l10n.selectATopic,
                                      style: TextStyle(
                                        color: AppColors.gray400,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.gray600,
                                    ),
                                    items: topics
                                        .map(
                                          (topic) =>
                                              DropdownMenuItem<BattleTopic>(
                                                value: topic,
                                                child: Text(
                                                  topic.title,
                                                  style: TextStyle(
                                                    color: AppColors.gray800,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                        )
                                        .toList(),
                                    onChanged: (topic) {
                                      setState(() => _selectedTopic = topic);
                                    },
                                  ),
                                ),
                        ),

                        const VSpace(20),
                        Text(
                          l10n.enterAmount,
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.12,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const VSpace(5),
                        TextFieldFactory.standard(
                          controller: _amountController,
                          config: TextFieldConfig(
                            hintText: l10n.gemsAmount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            errorText: _amountError,
                            errorBorderColor: AppColors.error500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VSpace(30),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 21,
                      right: 21,
                      bottom: MediaQuery.of(context).viewPadding.bottom,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isCreating
                            ? null
                            : () => _onCreateRoom(context, topics),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: AppColors.gray10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        child: isCreating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.createARoom,
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
            ),
          ),
        );
      },
    );
  }
}
