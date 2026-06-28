import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ReferralCodeInput extends StatelessWidget {
  final String referralCode;
  final bool isCopied;
  final VoidCallback onCopy;

  const ReferralCodeInput({
    super.key,
    required this.referralCode,
    required this.isCopied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Your referral code',
          style: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray600),
        ),
        const SizedBox(height: 5),
        // Input wrapper - matching Figma design
        Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD5D7DA)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Referral code text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    referralCode,
                    style: AppTextStyles.baseSemiBold(
                      context,
                    ).copyWith(color: AppColors.gray800),
                  ),
                ),
              ),
              // Copy button - matching Figma design
              Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: IconButton(
                  onPressed: onCopy,
                  icon: Icon(
                    isCopied ? Icons.check : Icons.copy,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
