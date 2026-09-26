import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class SendLoaderScreen extends StatefulWidget {
  const SendLoaderScreen({
    super.key,
    this.title,
    this.recipientAddress,
    this.amount,
  });
  final String? title;
  final String? recipientAddress;
  final String? amount;

  @override
  State<SendLoaderScreen> createState() => _SendLoaderScreenState();
}

class _SendLoaderScreenState extends State<SendLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  String statusText = '';
  bool _hasNavigatedToSuccess = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.title ?? '',
          showBackButton: false,
        ),
        body: BlocConsumer<WalletCubit, WalletState>(
          listenWhen: (previous, current) =>
              previous.transactionStatus != current.transactionStatus,
          listener: (context, state) {
            if (state.transactionStatus == TransactionStatus.success ||
                state.transactionStatus == TransactionStatus.pending) {
              // pending -> success (off-ramp) must not push a second screen.
              if (_hasNavigatedToSuccess) return;
              _hasNavigatedToSuccess = true;
              context.router.push(
                SendSuccessRoute(
                  recipientAddress: widget.recipientAddress ?? '0x00',
                  amount: widget.amount ?? '0',
                  transactionHash: state.transactionHash!,
                ),
              );
            }

            if (state.transactionStatus == TransactionStatus.failed) {
              NotificationService.showError(
                state.transactionError ?? 'Transaction failed. Please try again.',
              );
              context.router.popUntilRouteWithName(SendRoute.name);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
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
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Processing your transfer',
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
