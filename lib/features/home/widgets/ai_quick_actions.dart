import 'dart:async';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

class AiQuickActionsSection extends StatelessWidget {
  const AiQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_SectionHeader(), const SizedBox(height: 14), _ActionGrid()],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: 18,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 6),
        Text(
          'AI Quick Actions',
          style: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(color: AppColors.gray950),
        ),
      ],
    );
  }
}

class _ActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = _actions(context);
    return Row(
      children: [
        Expanded(child: _ActionCard(item: actions[0])),
        const SizedBox(width: 10),
        Expanded(child: _ActionCard(item: actions[1])),
      ],
    );
  }

  List<_QuickActionItem> _actions(BuildContext context) => [
    _QuickActionItem(
      icon: Assets.images.botToMoonPng.path,
      label: 'Explore Path',
      onTap: () => context.router.push(const ExplorePathsRoute()),
    ),
    _QuickActionItem(
      icon: Assets.images.careerIcon.path,
      label: 'Career Roadmap',
      onTap: () => context.router.push(const DiscoveryFlowRoute()),
    ),
  ];
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({required this.item});

  final _QuickActionItem item;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.item.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _resolveImage(widget.item.icon),
              const SizedBox(height: 12),
              Text(
                widget.item.label,
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: AppColors.gray700, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LennyFloatingButton extends StatefulWidget {
  const LennyFloatingButton({
    super.key,
    required this.onTap,
    this.hasNotification = false,
  });

  final VoidCallback onTap;
  final bool hasNotification;

  @override
  State<LennyFloatingButton> createState() => _LennyFloatingButtonState();
}

class _LennyFloatingButtonState extends State<LennyFloatingButton>
    with TickerProviderStateMixin {
  late final AnimationController _collapseCtrl;
  late final AnimationController _bobbleCtrl;
  late final Animation<double> _width;
  late final Animation<double> _textOpacity;
  late final Animation<double> _bobble;
  Timer? _collapseTimer;

  static const double _expandedWidth = 160;
  static const double _collapsedWidth = 62;

  @override
  void initState() {
    super.initState();

    _collapseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _width = Tween<double>(
      begin: _expandedWidth,
      end: _collapsedWidth,
    ).animate(CurvedAnimation(parent: _collapseCtrl, curve: Curves.easeInOut));

    _textOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _collapseCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _bobbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bobble = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(CurvedAnimation(parent: _bobbleCtrl, curve: Curves.easeInOut));

    _collapseTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) _collapseCtrl.forward();
    });
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _collapseCtrl.dispose();
    _bobbleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_width, _textOpacity, _bobble]),
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, -_bobble.value),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: _width.value,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(31),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            Assets.images.lennyStarePose.path,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),

                        Opacity(
                          opacity: _textOpacity.value,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Text(
                              'Ask Lenny',
                              style: AppTextStyles.baseBold(
                                context,
                              ).copyWith(color: AppColors.primaryColor),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.hasNotification)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _resolveImage(String path, {double size = 36}) {
  if (path.endsWith('.svg')) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
  return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
}
