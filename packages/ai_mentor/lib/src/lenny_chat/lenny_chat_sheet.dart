import 'dart:math' as math;

import 'package:core/core.dart'
    show
        BaseApiClients,
        AppTextStyles,
        AppColors,
        TextFieldFactory,
        TextFieldConfig;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'lenny_chat_cubit.dart';

class LennyChatSheet {
  static void show(
    BuildContext context, {
    required String userId,
    required String username,
    required String userProfileUrl,
    required String lennyAvatarAssetPath,
    required String closeIconAssetPath,
    required String historyIconAssetPath,
    required BaseApiClients apiClient,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => LennyChatCubit(userId: userId, apiClient: apiClient),
        child: _LennyChatSheetContent(
          username: username,
          userProfileUrl: userProfileUrl,
          lennyAvatarAssetPath: lennyAvatarAssetPath,
          closeIconAssetPath: closeIconAssetPath,
          historyIconAssetPath: historyIconAssetPath,
        ),
      ),
    );
  }
}

class _LennyChatSheetContent extends StatefulWidget {
  const _LennyChatSheetContent({
    required this.username,
    required this.lennyAvatarAssetPath,
    required this.closeIconAssetPath,
    required this.historyIconAssetPath,
    required this.userProfileUrl,
  });

  final String username;
  final String lennyAvatarAssetPath;
  final String closeIconAssetPath;
  final String historyIconAssetPath;
  final String userProfileUrl;

  @override
  State<_LennyChatSheetContent> createState() => _LennyChatSheetContentState();
}

class _LennyChatSheetContentState extends State<_LennyChatSheetContent> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _textCtrl.clear();
    context.read<LennyChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LennyChatCubit, LennyChatState>(
      listener: (_, state) {
        if (state is! LennyChatTyping) _scrollToBottom();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Divider(height: 1, color: AppColors.gray200),
            Expanded(child: _buildMessages()),
            _buildQuickChips(),
            _buildInput(),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.gray300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.grayBubble,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.blueLight100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(widget.lennyAvatarAssetPath),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lenny', style: AppTextStyles.baseBold(context)),
                  Text(
                    'AI Mentor',
                    style: AppTextStyles.xsRegular(
                      context,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _CircleButton(icon: widget.historyIconAssetPath, onTap: () {}),
              const SizedBox(width: 8),
              _CircleButton(
                icon: widget.closeIconAssetPath,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: Align(alignment: Alignment.topCenter, child: _buildHandle()),
        ),
      ],
    );
  }

  Widget _buildMessages() {
    return BlocConsumer<LennyChatCubit, LennyChatState>(
      listenWhen: (_, curr) => curr is LennyChatError,
      listener: (context, state) {
        if (state is LennyChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.read<LennyChatCubit>().clearError();
        }
      },
      builder: (_, state) {
        if (state.messages.isEmpty && state is! LennyChatTyping) {
          return _WelcomeState(
            username: widget.username,
            lennyAvatarAssetPath: widget.lennyAvatarAssetPath,
            onActionTap: _send,
          );
        }
        return ListView.builder(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          itemCount: state.messages.length + (state is LennyChatTyping ? 1 : 0),
          itemBuilder: (context, i) {
            if (i == state.messages.length) {
              return const _TypingIndicator();
            }
            return _MessageBubble(
              message: state.messages[i],
              lennyAvatarAssetPath: widget.lennyAvatarAssetPath,
              userProfileUrl: widget.userProfileUrl,
            );
          },
        );
      },
    );
  }

  static const _chips = [
    (label: 'What should I learn next?', color: Color(0xFF2563EB)),
    (label: 'How am I progressing?', color: Color(0xFF7C3AED)),
  ];

  Widget _buildQuickChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _chips.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final chip = _chips[i];
          return GestureDetector(
            onTap: () => _send(chip.label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: chip.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    chip.label,
                    style: AppTextStyles.xsSemiBold(context, color: chip.color),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static const _maxLength = 500;

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: BlocBuilder<LennyChatCubit, LennyChatState>(
        builder: (_, state) {
          final isBusy = state is LennyChatTyping;
          return TextFieldFactory.standard(
            controller: _textCtrl,
            config: TextFieldConfig(
              enabled: !isBusy,
              hintText: isBusy ? 'Lenny is thinking…' : 'Ask Lenny anything...',
              hintTextStyle: AppTextStyles.smRegular(
                context,
                color: AppColors.gray400,
              ),
              fontStyle: AppTextStyles.smRegular(context),
              fillColor: AppColors.grayBubble,
              enabledBorderColor: Colors.transparent,
              focusedBorderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              enabledBorderRadius: BorderRadius.circular(14),
              focusedBorderRadius: BorderRadius.circular(14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
              prefixIcon: const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textCtrl,
                builder: (context, value, child) {
                  final count = value.text.length;
                  final isNearLimit = count >= (_maxLength * 0.9).toInt();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$count/$_maxLength',
                        style: AppTextStyles.xsRegular(
                          context,
                          color: isNearLimit
                              ? AppColors.error500
                              : AppColors.gray400,
                        ),
                      ),
                      if (!isBusy) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _send(_textCtrl.text),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              maxLength: _maxLength,
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeState extends StatelessWidget {
  const _WelcomeState({
    required this.username,
    required this.lennyAvatarAssetPath,
    required this.onActionTap,
  });

  final String username;
  final String lennyAvatarAssetPath;
  final void Function(String) onActionTap;

  static const _quickActions = [
    (
      emoji: '🚀',
      title: 'Progress',
      description: 'Track your learning progress.',
      bgColor: Color(0xFFEEF2FF),
      titleColor: Color(0xFF4F46E5),
    ),
    (
      emoji: '📋',
      title: 'Recommendations',
      description: 'Get personalized learning suggestions.',
      bgColor: Color(0xFFFFFBEB),
      titleColor: Color(0xFFD97706),
    ),
    (
      emoji: '🎯',
      title: 'Motivation',
      description: 'Help stay motivated every day.',
      bgColor: Color(0xFFFFF1F2),
      titleColor: Color(0xFFE11D48),
    ),
    (
      emoji: '💼',
      title: 'Career Guide',
      description: 'Guide you towards your career goal',
      bgColor: Color(0xFFECFDF5),
      titleColor: Color(0xFF059669),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.grayBubble,
              shape: BoxShape.circle,
            ),
            child: lennyAvatarAssetPath.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      lennyAvatarAssetPath,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          Text(
            'Hey $username ',
            style: AppTextStyles.baseBold(
              context,
            ).copyWith(color: AppColors.gray950),
          ),
          const SizedBox(height: 4),
          Text(
            "I'm Lenny , your AI learning mentor",
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _ActionCard(action: _quickActions[0], onTap: onActionTap),
                    const SizedBox(height: 32),
                    _ActionCard(action: _quickActions[2], onTap: onActionTap),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  children: [
                    _ActionCard(action: _quickActions[1], onTap: onActionTap),
                    const SizedBox(height: 32),
                    _ActionCard(action: _quickActions[3], onTap: onActionTap),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action, required this.onTap});

  final ({
    String emoji,
    String title,
    String description,
    Color bgColor,
    Color titleColor,
  })
  action;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(action.title),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: action.bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(action.emoji, style: AppTextStyles.xl(context))),
            const SizedBox(height: 8),
            Text(
              action.title,
              style: AppTextStyles.smBold(
                context,
              ).copyWith(color: action.titleColor),
            ),
            const SizedBox(height: 4),
            Text(
              action.description,
              style: AppTextStyles.xsRegular(
                context,
              ).copyWith(color: AppColors.gray500, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });
    _scales = _ctrls.map((c) {
      return Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();
    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      for (int i = 0; i < _ctrls.length; i++) {
        if (!mounted) return;
        _ctrls[i].forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 160));
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _LennyMiniAvatar(assetPath: '', profileUrl: '', isUser: false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _scales[i],
                  builder: (context, child) => Container(
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.gray400.withValues(
                        alpha: math.max(0.3, _scales[i].value),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.lennyAvatarAssetPath,
    required this.userProfileUrl,
  });

  final ChatMessage message;
  final String lennyAvatarAssetPath;
  final String userProfileUrl;

  static const _userBubbleColor = Color(0xFF1E3A8A);
  static const _avatarSize = 30.0;
  static const _avatarOverlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: isUser ? 0 : _avatarSize - _avatarOverlap,
                    right: isUser ? _avatarSize - _avatarOverlap : 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                    decoration: BoxDecoration(
                      color: isUser ? _userBubbleColor : AppColors.grayBubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUser)
                            Text(
                              message.text,
                              style: AppTextStyles.smRegular(
                                context,
                              ).copyWith(color: Colors.white, height: 1.5),
                            )
                          else
                            MarkdownBody(
                              data: message.text,
                              shrinkWrap: true,
                              styleSheet: MarkdownStyleSheet(
                                p: AppTextStyles.smRegular(context).copyWith(
                                  color: AppColors.gray950,
                                  height: 1.5,
                                ),
                                strong: AppTextStyles.smRegular(context)
                                    .copyWith(
                                      color: AppColors.gray950,
                                      fontWeight: FontWeight.w700,
                                    ),
                                em: AppTextStyles.smRegular(context).copyWith(
                                  color: AppColors.gray950,
                                  fontStyle: FontStyle.italic,
                                ),
                                code: AppTextStyles.smRegular(context).copyWith(
                                  fontFamily: 'monospace',
                                  backgroundColor: AppColors.gray300,
                                ),
                                h1: AppTextStyles.baseBold(
                                  context,
                                ).copyWith(color: AppColors.gray950),
                                h2: AppTextStyles.smBold(
                                  context,
                                ).copyWith(color: AppColors.gray950),
                                h3: AppTextStyles.smBold(
                                  context,
                                ).copyWith(color: AppColors.gray950),
                                listBullet: AppTextStyles.smRegular(
                                  context,
                                ).copyWith(color: AppColors.gray950),
                                blockSpacing: 6,
                                listIndent: 16,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            _formatTime(message.time),
                            textAlign: TextAlign.end,
                            style: AppTextStyles.xsRegular(context).copyWith(
                              color: isUser
                                  ? Colors.white.withValues(alpha: 0.65)
                                  : AppColors.gray400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isUser)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _LennyMiniAvatar(
                      assetPath: lennyAvatarAssetPath,
                      profileUrl: '',
                      isUser: false,
                    ),
                  ),
                if (isUser)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _LennyMiniAvatar(
                      assetPath: userProfileUrl,
                      profileUrl: userProfileUrl,
                      isUser: true,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour == 0
        ? 12
        : t.hour > 12
        ? t.hour - 12
        : t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'pm' : 'am';
    return '$h:$m $ampm';
  }
}

class _LennyMiniAvatar extends StatelessWidget {
  const _LennyMiniAvatar({
    required this.assetPath,
    required this.profileUrl,
    required this.isUser,
  });

  final String assetPath;
  final String profileUrl;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.blueLight100,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: assetPath.isEmpty
            ? const SizedBox.shrink()
            : isUser
            ? Image.network(
                profileUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: Colors.white);
                },
              )
            : Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.gray300),
        ),
        child: Image(
          image: AssetImage(icon),
          colorBlendMode: BlendMode.srcIn,
          color: AppColors.gray900,
        ),
      ),
    );
  }
}
