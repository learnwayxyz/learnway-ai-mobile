import 'dart:developer';
import 'dart:math' as math;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/env.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/services/order_polling_service.dart';

@RoutePage()
class DepositAndBuyScreen extends StatefulWidget {
  const DepositAndBuyScreen({
    super.key,
    required this.params,
    this.isOffRamp = false,
    this.address,
    this.amount,
    this.countryIsoCode,
    this.paymentChannel,
    this.offRampParams,
  });

  final String params;
  final String? offRampParams;
  final bool isOffRamp;
  final String? address;
  final String? amount;
  final String? countryIsoCode;
  final String? paymentChannel;

  @override
  State<DepositAndBuyScreen> createState() => _DepositAndBuyScreenState();
}

class _DepositAndBuyScreenState extends State<DepositAndBuyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animatiionController;
  late Animation<double> _rotationAnimation;
  late WebViewController _controller;
  late OrderPollingService _orderPollingService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animatiionController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animatiionController, curve: Curves.linear),
    );
    _animatiionController.repeat();
    _orderPollingService = OrderPollingService(
      pollingInterval: const Duration(seconds: 3),
    );

    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..loadRequest(
        Uri.parse(
          widget.isOffRamp
              ? widget.offRampParams!
              : widget.params, // Complete onRamp payment URL
        ),
      )
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          log('FlutterChannel received: ${message.message}');

          if (message.message.contains('ORDER_COMPLETED')) {
            _handleOrderCompleted();
          } else if (message.message.contains('ORDER_IN_PROGRESS')) {
            final status = message.message.split(':').length > 1
                ? message.message.split(':').last
                : message.message;
            log('Order in progress: $status');
          } else if (message.message.contains('ORDER_FAILED')) {
            _handleOrderFailed(message.message);
          } else if (message.message.contains('STATUS_UPDATE')) {
            final status = message.message.split(':').length > 1
                ? message.message.split(':').last
                : 'unknown';
            if (status.toLowerCase().contains('expired')) {
              _handleOrderExpired();
            }
          }
        },
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
              _animatiionController.stop();
            } else if (!isLoading) {
              setState(() {
                isLoading = true;
              });
              _animatiionController.repeat();
            }
          },
          onPageStarted: (String url) {
            log('Page started: $url');
            Future.delayed(Duration(milliseconds: 300), () {});
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            Future.delayed(Duration(milliseconds: 500), () {
              _injectMonitoringScript();
            });
          },
          onWebResourceError: (WebResourceError error) {
            log('Web resource error: ${error.description}');
          },
        ),
      );
    _controller = controller;
  }

  void _injectMonitoringScript() {
    final script = _orderPollingService.generateMonitoringScript();
    _controller
        .runJavaScript(script)
        .then((_) {
          log('Monitoring script injected successfully');
        })
        .catchError((error) {
          log('Error injecting script: $error');
        });
  }

  void _handleOrderCompleted() {
    log('Order completed successfully!');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order completed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.router.popUntil(
            (route) => route.settings.name == MainActivityRoute.name,
          );
        }
      });
    }
  }

  void _handleOrderExpired() {
    log('Order has expired - user did not confirm in time');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order has expired. Please try again.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.router.popUntil(
            (route) => route.settings.name == MainActivityRoute.name,
          );
        }
      });
    }
  }

  void _handleOrderFailed(String message) {
    final failureReason = message.split(':').length > 1
        ? message.split(':').last
        : 'Unknown error';

    log('Order failed: $failureReason');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $failureReason'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _animatiionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: CustomPaint(
                      size: const Size(48, 48),
                      painter: CircularProgressPainter(progress: 0.25),
                    ),
                  );
                },
              ),
            )
          : SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
