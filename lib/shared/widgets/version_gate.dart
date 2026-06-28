import 'dart:async';
import 'dart:developer';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/version_check_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionGate extends StatefulWidget {
  const VersionGate({super.key, required this.child});

  final Widget child;

  @override
  State<VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends State<VersionGate> with WidgetsBindingObserver {
  final _service = VersionCheckService();
  VersionCheckResponse? _response;
  bool _sessionDismissed = false;
  bool _isChecking = false;

  StreamSubscription<VersionCheckResponse>? _responseSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkVersion();

    _responseSub = VersionCheckService.onResponse.listen((response) {
      if (!mounted) return;
      setState(() => _response = response);
      _maybeTriggerSoftUpdateDialog();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVersion();
    }
  }

  Future<void> _checkVersion() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    final result = await _service.check();
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _response = result;
    });
    _maybeTriggerSoftUpdateDialog();
  }

  bool get _isAuthenticated => LocalStorageService.getUserSync() != null;

  bool get _shouldShowForceUpdate =>
      _response?.status == VersionStatus.forceUpdate;

  bool get _shouldShowMaintenance =>
      _response?.status == VersionStatus.maintenance && _isAuthenticated;

  bool get _isOnHomeScreen {
    final currentRoute = appRouter.current.name;
    log('Current route: $currentRoute');
    return currentRoute == MainActivityRoute.name;
  }

  void _maybeTriggerSoftUpdateDialog() {
    if (_response?.status != VersionStatus.softUpdate) return;
    if (_sessionDismissed) return;
    if (!_isOnHomeScreen) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navigatorContext = appRouter.navigatorKey.currentContext;
      if (navigatorContext == null) return;
      showDialog(
        context: navigatorContext,
        barrierDismissible: false,
        builder: (_) => _SoftUpdateDialog(
          message:
              _response?.message ??
              'A new version of LearnWay is available with exciting new features!',
          onDismiss: () {
            setState(() => _sessionDismissed = true);
            Navigator.of(navigatorContext, rootNavigator: true).pop();
          },
          onUpdate: () {
            Navigator.of(navigatorContext, rootNavigator: true).pop();
            _openStoreUrl(_response?.storeUrl);
          },
        ),
      );
    });
  }

  Future<void> _openStoreUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      log('VersionGate: Could not open store URL: $e', name: 'LearnWay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_shouldShowForceUpdate)
          _ForceUpdateOverlay(
            message:
                'A critical update is required to continue using LearnWay.',
            onUpdate: () => _openStoreUrl(_response?.storeUrl),
          ),
        if (_shouldShowMaintenance)
          _MaintenanceOverlay(
            message:
                _response?.maintenanceMessage ??
                _response?.message ??
                "We're performing scheduled maintenance. Please check back soon.",
            maintenanceEndTime: _response?.maintenanceEndTime,
            onRetry: _checkVersion,
          ),
      ],
    );
  }
}

class _SoftUpdateDialog extends StatelessWidget {
  const _SoftUpdateDialog({
    required this.message,
    required this.onDismiss,
    required this.onUpdate,
  });

  final String message;
  final VoidCallback onDismiss;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 316,
        height: 342,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 22,
              right: 22,
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff252b37),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Color(0xff252b37),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 52,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                    image: AssetImage(Assets.images.lennyStarePose.path),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 146,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 240,
                  child: Column(
                    children: [
                      Text(
                        'New Update Available',
                        style: AppTextStyles.md(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: AppTextStyles.smRegular(
                          context,
                          color: const Color(0xFF414651),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 29,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 240,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onDismiss,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5D7DA),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: Text(
                                'Later',
                                style: AppTextStyles.smSemiBold(
                                  context,
                                  color: const Color(0xFF535862),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: onUpdate,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0D12),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: Text(
                                'Update Now',
                                style: AppTextStyles.smSemiBold(
                                  context,
                                  color: const Color(0xFFFDFDFD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForceUpdateOverlay extends StatelessWidget {
  const _ForceUpdateOverlay({required this.message, required this.onUpdate});

  final String message;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: Image(image: AssetImage(Assets.images.lennySad.path)),
              ),
              const SizedBox(height: 24),
              Text(
                'Immediate Update Required',
                style: AppTextStyles.lgBold(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppTextStyles.md(
                  context,
                ).copyWith(color: AppColors.gray700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Update Now',
                  style: AppTextStyles.mdBold(context, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaintenanceOverlay extends StatelessWidget {
  const _MaintenanceOverlay({
    required this.message,
    this.maintenanceEndTime,
    required this.onRetry,
  });

  final String message;
  final DateTime? maintenanceEndTime;
  final VoidCallback onRetry;

  String _formatEndTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Image(
                  image: AssetImage(Assets.images.lennyStarePose.path),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Under Maintenance',
                style: AppTextStyles.lgBold(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppTextStyles.md(
                  context,
                ).copyWith(color: AppColors.gray700),
                textAlign: TextAlign.center,
              ),
              if (maintenanceEndTime != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Expected back at ${_formatEndTime(maintenanceEndTime!)}',
                  style: AppTextStyles.smRegular(
                    context,
                  ).copyWith(color: AppColors.gray400),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gray900,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Check Again',
                  style: AppTextStyles.mdBold(context, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
