import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnwayv2/services/connectivity_service.dart';

/// Shows a persistent offline banner above [child] whenever the connection is
/// down.
///
/// The banner is ambient by design: it appears when the connection has been
/// down long enough to matter and disappears silently when it returns. Losing
/// connectivity is not by itself worth interrupting the user for — a failed
/// action is, and those are surfaced where the action lives.
class ConnectivityWrapper extends StatelessWidget {
  const ConnectivityWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityService().connectionListenable,
      builder: (context, hasConnection, _) {
        final isOffline = !hasConnection;

        return Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.bottomCenter,
              child: isOffline
                  ? const _OfflineBanner()
                  : const SizedBox(width: double.infinity),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                // The banner already covers the status bar inset, so app bars
                // below it must not pad for it a second time.
                removeTop: isOffline,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // The strip extends behind the status bar, so its icons need to invert.
      value: SystemUiOverlayStyle.light,
      // The banner renders above the Navigator, so there is no Material in
      // scope to supply a default text style — without one the text picks up
      // the debug double-underline.
      child: Material(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: SizedBox(
            width: double.infinity,
            height: 32,
            child: Center(
              child: Text(
                'No internet connection',
                style: AppTextStyles.xsMedium(context, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
