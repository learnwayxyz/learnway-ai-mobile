import 'dart:math' as math;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class OfframpLoaderScreen extends StatefulWidget {
  const OfframpLoaderScreen({
    super.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.offrampData,
    this.carrierName,
  });

  final String recipientNumber;
  final double amountUsdt;
  final double amountToReceive;
  final double exchangeRate;
  final String paymentChannel;
  final String localCurrency;
  final String? carrierName;
  final StoreOffRampScreenTranscientData offrampData;

  @override
  State<OfframpLoaderScreen> createState() => _OfframpLoaderScreenState();
}

class _OfframpLoaderScreenState extends State<OfframpLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

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
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.withdraw,
        showBackButton: false,
        barHeight: 0,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.createOrderStatus == CreateOrderStatus.failed) {
            NotificationService.showError(
              state.createOrderError ?? AppLocalizations.of(context)!.failedToCreateWithdrawalOrder,
            );
            context.router.popUntil(
              (route) => route.settings.name == OfframpRoute.name,
            );
          }

          if (state.createOrderStatus == CreateOrderStatus.success) {
            context.router.replace(
              OfframpSuccessRoute(
                recipientNumber: widget.recipientNumber,
                amountUsdt: widget.amountUsdt,
                amountToReceive: widget.amountToReceive,
                exchangeRate: widget.exchangeRate,
                paymentChannel: widget.paymentChannel,
                localCurrency: widget.localCurrency,
                carrierName: widget.carrierName,
                orderId: state.createOrderResponse?.fonbnkOrderId ?? '',
                depositAddress:
                    state.createOrderResponse?.cryptoWalletAddress ?? '',
              ),
            );
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
                  AppLocalizations.of(context)!.creatingWithdrawalOrder,
                  style: AppTextStyles.md(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.pleaseWaitDoNotClose,
                  style: AppTextStyles.sm(
                    context,
                  ).copyWith(color: AppColors.gray600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
