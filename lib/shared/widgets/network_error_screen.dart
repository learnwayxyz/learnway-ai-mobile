import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/404.png',
                width: 244,
                height: 244,
              ),
              const VSpace(40),
              Text(
                'Network Error. Try Again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.lgBold(context),
              ),
              const VSpace(12),
              Text(
                'Something went wrong while connecting. Please try again.!',
                textAlign: TextAlign.center,
                style: AppTextStyles.smRegular(context).copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTextStyles.baseSemiBold(context, color: Colors.white),
                  ),
                ),
              ),
              const VSpace(40),
            ],
          ),
        ),
      ),
    );
  }
}
