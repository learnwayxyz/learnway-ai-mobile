import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../shared/loader/circular_progress_painter.dart';

@RoutePage()
class VerificationScreen extends StatefulWidget {
  final String sessionUrl;
  final String sessionId;
  final Function(String sessionId, Map<String, dynamic>? params)? onComplete;
  final Function(String error)? onError;

  const VerificationScreen({
    super.key,
    required this.sessionUrl,
    required this.sessionId,
    this.onComplete,
    this.onError,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool isLoading = true;
  String? errorMessage;
  double progress = 0;
  bool _verificationCompleted = false;
  bool _callbackTriggered = false;

  late InAppWebViewSettings settings;

  @override
  void initState() {
    super.initState();
    requestPermission();
    _initializeSettings();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  void _initializeSettings() {
    settings = InAppWebViewSettings(
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
      domStorageEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; geolocation",
      iframeAllowFullscreen: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 "
          "(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
      useHybridComposition: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      allowsPictureInPictureMediaPlayback: true,
      cacheEnabled: true,
      clearCache: false,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
    );
  }

  Future<void> requestPermission() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  void _handleDeepLinkCallback(String url) {
    if (_callbackTriggered == true) {
      return;
    }

    try {
      final uri = Uri.parse(url);
      final params = uri.queryParameters;

      _callbackTriggered = true;
      _verificationCompleted = true;

      widget.onComplete?.call(widget.sessionId, params);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
      widget.onError?.call('Error handling callback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.sessionUrl)),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              webViewController = controller;
              debugPrint('WebView created successfully');
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              debugPrint('Page load started: $url');
              final urlString = Uri.parse(url.toString()).toString();
              if (urlString.startsWith('learnway://')) {
                _handleDeepLinkCallback(urlString);
              }
            },
            onLoadStop: (controller, url) async {
              setState(() {
                isLoading = false;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onReceivedError: (controller, request, error) {
              setState(() {
                errorMessage = 'Error loading page: ${error.description}';
                isLoading = false;
              });
              log('Error loading page: ${error.description}');
              widget.onError?.call(error.description);
            },
            onReceivedHttpError: (controller, request, errorResponse) {
              setState(() {
                errorMessage = 'HTTP Error: ${errorResponse.statusCode}';
                isLoading = false;
              });
              log('HTTP error: ${errorResponse.statusCode}');
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              log('Navigation request: $url');

              if (url.startsWith('learnway://')) {
                _handleDeepLinkCallback(url);
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint(
                'WebView Console [${consoleMessage.messageLevel}]: '
                '${consoleMessage.message}',
              );
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    if (progress > 0 && progress < 1)
                      Center(
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: CustomPaint(
                                size: const Size(48, 48),
                                painter: CircularProgressPainter(
                                  progress: 0.25,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text(
                      'Loading verification...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    if (!_verificationCompleted && widget.sessionId.isNotEmpty) {
      debugPrint('Verification screen closing - checking final status');
      try {
        final kycCubit = context.read<KycCubit>();
        if (!kycCubit.isClosed && mounted) {
          kycCubit.getSessioDecision();
        }
      } catch (e) {
        debugPrint('Error checking final status on deactivate: $e');
      }
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    webViewController?.dispose();
    super.dispose();
  }
}
