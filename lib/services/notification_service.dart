// notification_service.dart
import 'dart:async';

import 'package:flutter/material.dart';

enum NotificationType { success, error, warning, info }

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  static void showNotification({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 1),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final context = _scaffoldMessengerKey.currentContext;
    if (context == null) return;

    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      _buildModernSnackBar(
        message: message,
        type: type,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        context: context,
      ),
    );
  }

  static SnackBar _buildModernSnackBar({
    required String message,
    required NotificationType type,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    required BuildContext context,
  }) {
    final colors = _getNotificationColors(type);
    final icon = _getNotificationIcon(type);

    return SnackBar(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colors['background']!,
              colors['background']!.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors['iconBg'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: colors['icon'], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getNotificationTitle(type),
                      style: TextStyle(
                        color: colors['title'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: colors['message'],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (actionLabel != null && onActionPressed != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: colors['action'],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static Map<String, Color> _getNotificationColors(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return {
          'background': const Color(0xFF10B981),
          'iconBg': const Color(0xFF065F46).withOpacity(0.2),
          'icon': Colors.white,
          'title': Colors.white,
          'message': const Color(0xFFD1FAE5),
          'action': Colors.white,
        };
      case NotificationType.error:
        return {
          'background': const Color(0xFFEF4444),
          'iconBg': const Color(0xFF7F1D1D).withOpacity(0.2),
          'icon': Colors.white,
          'title': Colors.white,
          'message': const Color(0xFFFEE2E2),
          'action': Colors.white,
        };
      case NotificationType.warning:
        return {
          'background': const Color(0xFFF59E0B),
          'iconBg': const Color(0xFF78350F).withOpacity(0.2),
          'icon': Colors.white,
          'title': Colors.white,
          'message': const Color(0xFFFEF3C7),
          'action': Colors.white,
        };
      case NotificationType.info:
        return {
          'background': const Color(0xFF3B82F6),
          'iconBg': const Color(0xFF1E40AF).withOpacity(0.2),
          'icon': Colors.white,
          'title': Colors.white,
          'message': const Color(0xFFDBEAFE),
          'action': Colors.white,
        };
    }
  }

  static IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_rounded;
      case NotificationType.error:
        return Icons.error_rounded;
      case NotificationType.warning:
        return Icons.warning_rounded;
      case NotificationType.info:
        return Icons.info_rounded;
    }
  }

  static String _getNotificationTitle(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return 'Success';
      case NotificationType.error:
        return 'Error';
      case NotificationType.warning:
        return 'Warning';
      case NotificationType.info:
        return 'Info';
    }
  }

  // Convenience methods for different notification types
  static void showSuccess(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showNotification(
      message: message,
      type: NotificationType.success,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showError(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showNotification(
      message: message,
      type: NotificationType.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showWarning(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showNotification(
      message: message,
      type: NotificationType.warning,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showInfo(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showNotification(
      message: message,
      type: NotificationType.info,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}

// Alternative: Custom Toast Widget (overlay-based)
class AppToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show({
    required BuildContext context,
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _removeCurrentToast();

    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        onDismiss: _removeCurrentToast,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _timer = Timer(duration, () {
      _removeCurrentToast();
    });
  }

  static void _removeCurrentToast() {
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Convenience methods
  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: NotificationType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: NotificationType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context: context, message: message, type: NotificationType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context: context, message: message, type: NotificationType.info);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final NotificationType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onActionPressed,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = NotificationService._getNotificationColors(widget.type);
    final icon = NotificationService._getNotificationIcon(widget.type);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors['background']!,
                        colors['background']!.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors['iconBg'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: colors['icon'], size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                NotificationService._getNotificationTitle(
                                  widget.type,
                                ),
                                style: TextStyle(
                                  color: colors['title'],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.message,
                                style: TextStyle(
                                  color: colors['message'],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (widget.actionLabel != null &&
                            widget.onActionPressed != null) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              widget.onActionPressed!();
                              widget.onDismiss();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colors['action'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              widget.actionLabel!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onDismiss,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colors['iconBg'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.close,
                              color: colors['icon'],
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
