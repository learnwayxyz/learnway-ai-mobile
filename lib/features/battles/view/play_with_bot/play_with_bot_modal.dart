import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:learnwayv2/features/battles/view/shared/how_battle_works_dialog.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class PlayWithBotModal extends StatefulWidget {
  const PlayWithBotModal({super.key});

  @override
  State<PlayWithBotModal> createState() => _PlayWithBotModalState();
}

class _PlayWithBotModalState extends State<PlayWithBotModal> {
  BattleTopic? _selectedTopic;
  List<BattleTopic> _cachedTopics = [];
  int? _botEntryFee;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BattlesBloc>().add(const LoadBattleTopicsEvent());
      }
    });
    _loadBattleConfig();
  }

  Future<void> _loadBattleConfig() async {
    final result = await locator<BattleRepository>().getBattleConfig();
    result.fold((_) {}, (config) {
      if (mounted) setState(() => _botEntryFee = config.botEntryFee);
    });
  }

  void _onPayToStart(BuildContext context) {
    if (_selectedTopic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectATopic),
        ),
      );
      return;
    }
    context.read<BattlesBloc>().add(
      StartBotBattleEvent(topicId: _selectedTopic!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BattlesBloc, BattlesState>(
      listener: (context, state) {
        if (state is BotBattleStarted) {
          Navigator.of(context).pop();
        } else if (state is BotBattleStartError) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state is BattleTopicsLoaded) {
          _cachedTopics = state.topics;
        }
        final topics = _cachedTopics;
        final isLoadingTopics = state is BattleTopicsLoading;
        final isStarting = state is BotBattleStarting;

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
                      l10n.joinABattle,
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
                              builder: (_) => HowBattleWorksDialog(
                                title: l10n.howBattleWorksTitle,
                                steps: [
                                  l10n.howBotBattleWorksStep1,
                                  l10n.howBotBattleWorksStep2,
                                  l10n.howBattleWorksStep4,
                                  l10n.howBattleWorksStep5,
                                  l10n.howBattleWorksStep6,
                                  l10n.howBattleWorksStep7,
                                ],
                              ),
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
                          style: AppTextStyles.baseBold(context),
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
                                    onChanged: isStarting
                                        ? null
                                        : (topic) {
                                            setState(
                                              () => _selectedTopic = topic,
                                            );
                                          },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const VSpace(20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.entryFee,
                          style: AppTextStyles.baseBold(
                            context,
                          ).copyWith(letterSpacing: 0.20),
                        ),
                        const VSpace(5),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HSpace(4),
                              _botEntryFee == null
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/blue_gem.png',
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        ),
                                        const HSpace(4),
                                        Text(
                                          '$_botEntryFee',
                                          style: TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.14,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
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
                        onPressed: isStarting
                            ? null
                            : () => _onPayToStart(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: AppColors.gray10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        child: isStarting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.payToStart,
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
