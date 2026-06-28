import 'dart:async';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:intl/intl.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/ai_tutor_response.dart';
import 'package:learnwayv2/gen/assets.gen.dart';


class _QuickActionConfig {
  const _QuickActionConfig({
    required this.promptType,
    required this.label,
    required this.chipLabel,
    required this.description,
    required this.icon,
    required this.color,
  });
  final AiTutorPromptType promptType;
  final String label;
  final String chipLabel;
  final String description;
  final IconData icon;
  final Color color;
}

final _kQuickActions = <_QuickActionConfig>[
  _QuickActionConfig(
    promptType: AiTutorPromptType.explainSimply,
    label: 'Explain Simply',
    chipLabel: 'Explain Simply',
    description: 'Break down the concept in easy words.',
    icon: Icons.menu_book_rounded,
    color: AppColors.indigo500,
  ),
  _QuickActionConfig(
    promptType: AiTutorPromptType.summarize,
    label: 'Summarize',
    chipLabel: 'Summarize',
    description: 'Get a quick summary of the key points.',
    icon: Icons.format_list_bulleted,
    color: AppColors.indigo500,
  ),
  _QuickActionConfig(
    promptType: AiTutorPromptType.example,
    label: 'Real-life Example',
    chipLabel: 'Real-life Example',
    description: 'Show real-world examples.',
    icon: Icons.lightbulb_outline,
    color: AppColors.indigo500,
  ),
  _QuickActionConfig(
    promptType: AiTutorPromptType.keyTakeaways,
    label: 'Key Takeaways',
    chipLabel: 'Key Takeaways',
    description: 'The most important points from the lesson.',
    icon: Icons.help_outline,
    color: AppColors.orange500,
  ),
];

class AiTutorBottomSheet extends StatefulWidget {
  const AiTutorBottomSheet({super.key, required this.lessonId});
  final String lessonId;

  @override
  State<AiTutorBottomSheet> createState() => _AiTutorBottomSheetState();
}

class _AiTutorBottomSheetState extends State<AiTutorBottomSheet> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <AiTutorMessage>[];
  bool _isTyping = false;
  AiTutorRateLimit? _rateLimit;
  bool _isLessonLimited = false;
  bool _isDailyLimited = false;

  static final _timeFormat = DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    final bloc = locator<LearnAndEarnBloc>();
    _messages.addAll(bloc.getAiConversation(widget.lessonId));
    _rateLimit = bloc.getAiRateLimit(widget.lessonId);
    _isLessonLimited = bloc.isAiLessonLimited(widget.lessonId);
    _isDailyLimited = bloc.isAiDailyLimitReached;
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuickPrompt(AiTutorPromptType promptType, String label) {
    if (_isTyping) return;
    setState(() {
      _messages.add(
        AiTutorMessage(text: label, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });
    _scrollToBottom();
    context.read<LearnAndEarnBloc>().add(
      AskAiTutorWithQuickPrompt(
        lessonId: widget.lessonId,
        promptType: promptType,
        displayLabel: label,
      ),
    );
  }

  void _sendCustomQuestion() {
    final text = _textController.text.trim();
    if (text.isEmpty || _isTyping) return;
    _textController.clear();
    setState(() {
      _messages.add(
        AiTutorMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });
    _scrollToBottom();
    context.read<LearnAndEarnBloc>().add(
      AskAiTutorWithCustomQuestion(
        lessonId: widget.lessonId,
        customQuestion: text,
      ),
    );
  }

  void _onAiResponse(AiTutorResponseData data) {
    setState(() {
      _isTyping = false;
      _rateLimit = data.rateLimitRemaining;
      _messages.add(
        AiTutorMessage(
          text: data.response,
          isUser: false,
          timestamp: DateTime.now(),
          fromCache: data.fromCache,
        ),
      );
    });
    _scrollToBottom();
  }

  void _onAiError(String error) {
    setState(() {
      _isTyping = false;
      _messages.add(
        AiTutorMessage(
          text: error,
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;
    final effectiveBottomInset = bottomInset + safeAreaBottom;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.85;

    return BlocListener<LearnAndEarnBloc, LearnAndEarnState>(
      listenWhen: (_, curr) =>
          curr is AiTutorResponseReceived ||
          curr is AiTutorRequestFailed ||
          curr is AiTutorLessonLimitReached ||
          curr is AiTutorDailyLimitReached,
      listener: (_, state) {
        if (state is AiTutorResponseReceived) {
          _onAiResponse(state.data);
        } else if (state is AiTutorRequestFailed) {
          _onAiError(state.message);
        } else if (state is AiTutorLessonLimitReached) {
          setState(() {
            _isTyping = false;
            _isLessonLimited = true;
          });
        } else if (state is AiTutorDailyLimitReached) {
          setState(() {
            _isTyping = false;
            _isDailyLimited = true;
          });
        }
      },
      child: Container(
        height: sheetHeight + effectiveBottomInset,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DragHandle(),
            _AiTutorHeader(
              onClose: () => Navigator.pop(context),
              onQuickPromptTapped: _sendQuickPrompt,
              isEnabled: !_isTyping,
            ),
            const Divider(height: 1),
            Expanded(
              child: _messages.isEmpty
                  ? _AiTutorSuggestionsBody(
                      onQuickActionTapped: _sendQuickPrompt,
                    )
                  : _AiTutorChatBody(
                      messages: _messages,
                      isTyping: _isTyping,
                      scrollController: _scrollController,
                      timeFormat: _timeFormat,
                    ),
            ),
            _AiTutorInputBar(
              controller: _textController,
              onSend: _sendCustomQuestion,
              isEnabled: !_isTyping && !_isLessonLimited && !_isDailyLimited,
              bottomInset: effectiveBottomInset,
              rateLimit: _rateLimit,
              isLessonLimited: _isLessonLimited,
              isDailyLimited: _isDailyLimited,
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.gray300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _AiTutorHeader extends StatelessWidget {
  const _AiTutorHeader({
    required this.onClose,
    required this.onQuickPromptTapped,
    required this.isEnabled,
  });
  final VoidCallback onClose;
  final void Function(AiTutorPromptType, String) onQuickPromptTapped;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'LearnWay AI Tutor',
                    style: AppTextStyles.lgBold(context),
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset(Assets.icons.askAiIcon2),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                color: AppColors.gray600,
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Ask questions about this lesson',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const SizedBox(height: 12),
          _QuickPromptChipRow(
            onChipTapped: onQuickPromptTapped,
            isEnabled: isEnabled,
          ),
        ],
      ),
    );
  }
}

class _QuickPromptChipRow extends StatelessWidget {
  const _QuickPromptChipRow({
    required this.onChipTapped,
    required this.isEnabled,
  });
  final void Function(AiTutorPromptType, String) onChipTapped;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _kQuickActions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _QuickPromptChip(
              action: action,
              onTap: isEnabled
                  ? () => onChipTapped(action.promptType, action.chipLabel)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickPromptChip extends StatelessWidget {
  const _QuickPromptChip({required this.action, required this.onTap});
  final _QuickActionConfig action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? action.color.withValues(alpha: 0.08)
              : AppColors.gray50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? action.color.withValues(alpha: 0.3)
                : AppColors.gray200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              action.icon,
              size: 14,
              color: active ? action.color : AppColors.gray400,
            ),
            const SizedBox(width: 5),
            Text(
              action.chipLabel,
              style: AppTextStyles.xsRegular(context).copyWith(
                color: active ? action.color : AppColors.gray400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiTutorSuggestionsBody extends StatelessWidget {
  const _AiTutorSuggestionsBody({required this.onQuickActionTapped});
  final void Function(AiTutorPromptType, String) onQuickActionTapped;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Image.asset(Assets.images.lennybot.path, width: 120, height: 120),
          const SizedBox(height: 16),
          Text(
            'I can help you understand this lesson\nin different ways.',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _kQuickActions.map((action) {
              return _SuggestionCapsule(
                action: action,
                onTap: () =>
                    onQuickActionTapped(action.promptType, action.label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCapsule extends StatelessWidget {
  const _SuggestionCapsule({required this.action, required this.onTap});
  final _QuickActionConfig action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: action.color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, size: 16, color: action.color),
            const SizedBox(width: 7),
            Text(
              action.label,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: action.color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiTutorChatBody extends StatelessWidget {
  const _AiTutorChatBody({
    required this.messages,
    required this.isTyping,
    required this.scrollController,
    required this.timeFormat,
  });
  final List<AiTutorMessage> messages;
  final bool isTyping;
  final ScrollController scrollController;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const _AiTutorTypingIndicator();
        }
        final message = messages[index];
        if (message.isError) {
          return _AiTutorErrorBubble(message: message, timeFormat: timeFormat);
        }
        return message.isUser
            ? _AiTutorUserBubble(message: message, timeFormat: timeFormat)
            : _AiTutorBotBubble(message: message, timeFormat: timeFormat);
      },
    );
  }
}

class _AiTutorUserBubble extends StatelessWidget {
  const _AiTutorUserBubble({required this.message, required this.timeFormat});
  final AiTutorMessage message;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.72,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You ${timeFormat.format(message.timestamp)}',
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: AppColors.gray400),
          ),
        ],
      ),
    );
  }
}

class _AiTutorBotBubble extends StatelessWidget {
  const _AiTutorBotBubble({required this.message, required this.timeFormat});
  final AiTutorMessage message;
  final DateFormat timeFormat;

  MarkdownStyleSheet _markdownStyle(BuildContext context) {
    final base = AppTextStyles.smRegular(
      context,
    ).copyWith(color: AppColors.textPrimary);
    return MarkdownStyleSheet(
      p: base,
      strong: base.copyWith(fontWeight: FontWeight.w700),
      em: base.copyWith(fontStyle: FontStyle.italic),
      code: base.copyWith(
        fontFamily: 'monospace',
        backgroundColor: AppColors.gray200,
      ),
      h1: AppTextStyles.baseBold(context),
      h2: AppTextStyles.smBold(context),
      h3: AppTextStyles.smBold(context),
      listBullet: base,
      blockSpacing: 6,
      listIndent: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BotAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    shrinkWrap: true,
                    styleSheet: _markdownStyle(context),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'AI Tutor ${timeFormat.format(message.timestamp)}',
                      style: AppTextStyles.xsRegular(
                        context,
                      ).copyWith(color: AppColors.gray400),
                    ),
                    if (message.fromCache) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.indigo500.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.indigo500.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 10,
                              color: AppColors.indigo500,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Cached',
                              style: AppTextStyles.xsRegular(context).copyWith(
                                color: AppColors.indigo500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiTutorErrorBubble extends StatelessWidget {
  const _AiTutorErrorBubble({required this.message, required this.timeFormat});
  final AiTutorMessage message;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BotAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: AppColors.errorColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: AppColors.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message.text,
                          style: AppTextStyles.smRegular(context).copyWith(
                            color: AppColors.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI Tutor ${timeFormat.format(message.timestamp)}',
                  style: AppTextStyles.xsRegular(
                    context,
                  ).copyWith(color: AppColors.gray400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiTutorTypingIndicator extends StatefulWidget {
  const _AiTutorTypingIndicator();

  @override
  State<_AiTutorTypingIndicator> createState() =>
      _AiTutorTypingIndicatorState();
}

class _AiTutorTypingIndicatorState extends State<_AiTutorTypingIndicator> {
  int _dotCount = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _dotCount = (_dotCount % 3) + 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _BotAvatar(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Text(
              'AI Tutor is typing${'.' * _dotCount}',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        Assets.images.lennybot.path,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _AiTutorInputBar extends StatefulWidget {
  const _AiTutorInputBar({
    required this.controller,
    required this.onSend,
    required this.isEnabled,
    required this.bottomInset,
    this.rateLimit,
    this.isLessonLimited = false,
    this.isDailyLimited = false,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;
  final double bottomInset;
  final AiTutorRateLimit? rateLimit;
  final bool isLessonLimited;
  final bool isDailyLimited;

  @override
  State<_AiTutorInputBar> createState() => _AiTutorInputBarState();
}

class _AiTutorInputBarState extends State<_AiTutorInputBar> {
  int _charCount = 0;
  Timer? _countdownTimer;
  Duration _timeUntilMidnight = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    if (widget.isDailyLimited) _startCountdown();
  }

  @override
  void didUpdateWidget(_AiTutorInputBar old) {
    super.didUpdateWidget(old);
    if (widget.isDailyLimited && !old.isDailyLimited) _startCountdown();
    if (!widget.isDailyLimited && old.isDailyLimited) _stopCountdown();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _stopCountdown();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => _charCount = widget.controller.text.length);
  }

  void _startCountdown() {
    _tick();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tick(),
    );
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _tick() {
    final now = DateTime.now().toUtc();
    final midnight = DateTime.utc(now.year, now.month, now.day + 1);
    if (mounted) setState(() => _timeUntilMidnight = midnight.difference(now));
  }

  String get _countdownLabel {
    final h = _timeUntilMidnight.inHours.toString().padLeft(2, '0');
    final m = (_timeUntilMidnight.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_timeUntilMidnight.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final rateLimit = widget.rateLimit;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + widget.bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isLessonLimited)
            _LimitBanner(
              icon: Icons.block_rounded,
              message: 'Limit reached for this lesson (5/5 used).',
              color: AppColors.orange500,
            )
          else if (widget.isDailyLimited)
            _LimitBanner(
              icon: Icons.schedule_rounded,
              message: 'Daily limit reached. Resets in $_countdownLabel',
              color: AppColors.errorColor,
            )
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFieldFactory.standard(
                    controller: widget.controller,
                    config: TextFieldConfig(
                      hintText: 'Ask about this lesson...',
                      hintTextStyle: AppTextStyles.smRegular(
                        context,
                      ).copyWith(color: AppColors.hintTextColor),
                      fontStyle: AppTextStyles.smRegular(context),
                      maxLines: 2,
                      enabled: widget.isEnabled,
                      fillColor: AppColors.gray50,
                      enabledBorderColor: AppColors.borderColor,
                      focusedBorderColor: AppColors.borderColor,
                      enabledBorderRadius: BorderRadius.circular(24),
                      focusedBorderRadius: BorderRadius.circular(24),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.isEnabled && _charCount <= 500
                      ? widget.onSend
                      : null,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.isEnabled && _charCount <= 500
                          ? AppColors.primaryColor
                          : AppColors.gray300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (rateLimit != null) ...[
                  _RateLimitBadge(
                    label: 'Lesson',
                    remaining: rateLimit.lesson,
                    max: AiTutorRateLimit.maxLessonAsks,
                  ),
                  const SizedBox(width: 10),
                  _RateLimitBadge(
                    label: 'Daily',
                    remaining: rateLimit.daily,
                    max: AiTutorRateLimit.maxDailyAsks,
                  ),
                ],
                const Spacer(),
                Text(
                  '$_charCount/500',
                  style: AppTextStyles.xsRegular(context).copyWith(
                    color: _charCount >= 500
                        ? AppColors.errorColor
                        : _charCount > 450
                        ? AppColors.orange500
                        : AppColors.gray400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LimitBanner extends StatelessWidget {
  const _LimitBanner({
    required this.icon,
    required this.message,
    required this.color,
  });
  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.smRegular(context).copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateLimitBadge extends StatelessWidget {
  const _RateLimitBadge({
    required this.label,
    required this.remaining,
    required this.max,
  });
  final String label;
  final int remaining;
  final int max;

  @override
  Widget build(BuildContext context) {
    final color = remaining <= 0
        ? AppColors.errorColor
        : remaining == 1
        ? AppColors.orange500
        : AppColors.gray500;

    return Text(
      '$label: $remaining/$max',
      style: AppTextStyles.xsRegular(context).copyWith(color: color),
    );
  }
}
