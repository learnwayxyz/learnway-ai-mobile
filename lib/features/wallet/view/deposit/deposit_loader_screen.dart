import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class DepositLoaderScreen extends StatefulWidget {
  const DepositLoaderScreen({
    super.key,
    required this.selectedImage,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
  });
  final String selectedImage;
  final String phoneNumber;
  final String fullName;
  final String paymentChannel;
  final double fiatAmount;
  final double usdtAmount;
  final double exchangeRate;
  final double feeAmount;
  final String localCurrencyCode;
  final String localCurrencySymbol;
  final String countryCode;
  final String quoteId;
  final String carrierCode;
  final String carrierName;
  final String bankCode;
  final String bankAccountNumber;

  @override
  State<DepositLoaderScreen> createState() => _DepositLoaderScreenState();
}

class _DepositLoaderScreenState extends State<DepositLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  String statusText = '';

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
        backgroundColor: Colors.white,
        appBar: AppBarFactory.standardAppBar(
          title: 'Deposit',
          showBackButton: false,
        ),
        body: BlocConsumer<WalletCubit, WalletState>(
          listenWhen: (previous, current) =>
              previous.onRampOrderStatus != current.onRampOrderStatus,
          listener: (context, state) {
            if (state.onRampOrderStatus == OnRampOrderStatus.success &&
                widget.paymentChannel == "mobile_money") {
              context.router.push(
                DepositUssdRoute(
                  selectedImage: widget.selectedImage,
                  phoneNumber: widget.phoneNumber,
                  fullName: widget.fullName,
                  paymentChannel: widget.paymentChannel,
                  fiatAmount: widget.fiatAmount,
                  usdtAmount: widget.usdtAmount,
                  exchangeRate: widget.exchangeRate,
                  feeAmount: widget.feeAmount,
                  localCurrencyCode: widget.localCurrencyCode,
                  localCurrencySymbol: widget.localCurrencySymbol,
                  countryCode: widget.countryCode,
                  quoteId: widget.quoteId,
                  carrierCode: widget.carrierCode,
                  carrierName: widget.carrierName,
                ),
              );
            } else if (state.onRampOrderStatus == OnRampOrderStatus.success) {
              context.router.push(
                DepositSuccessfulRoute(
                  selectedImage: '',
                  phoneNumber: widget.phoneNumber,
                  fullName: widget.fullName,
                  paymentChannel: widget.paymentChannel,
                  fiatAmount: widget.fiatAmount,
                  usdtAmount: widget.usdtAmount,
                  exchangeRate: widget.exchangeRate,
                  feeAmount: widget.feeAmount,
                  localCurrencyCode: widget.localCurrencyCode,
                  localCurrencySymbol: widget.localCurrencySymbol,
                  countryCode: widget.countryCode,
                  quoteId: widget.quoteId,
                ),
              );
            }

            if (state.onRampOrderStatus == OnRampOrderStatus.failed) {
              context.router.pop();
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
