import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BadgeDetailsShimmer extends StatelessWidget {
  const BadgeDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VSpace(20),
          _buildHeaderShimmer(),
          const VSpace(40),
          _buildContentShimmer(),
          const VSpace(40),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          // Badge icon shimmer
          Center(
            child: Shimmer.fromColors(
              baseColor: AppColors.gray200,
              highlightColor: AppColors.gray100,
              child: Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Title and description shimmer
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.gray200,
                  highlightColor: AppColors.gray100,
                  child: Container(
                    width: 200,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const VSpace(8),
                Shimmer.fromColors(
                  baseColor: AppColors.gray200,
                  highlightColor: AppColors.gray100,
                  child: Container(
                    width: 250,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionShimmer(itemCount: 3),
          const VSpace(16),
          _buildSectionShimmer(itemCount: 2),
          const VSpace(16),
          _buildRewardShimmer(),
        ],
      ),
    );
  }

  Widget _buildSectionShimmer({required int itemCount}) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray200,
      highlightColor: AppColors.gray100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const VSpace(20),
            // Divider
            Container(
              height: 1,
              color: AppColors.gray200,
            ),
            const VSpace(20),
            // Items
            ...List.generate(
              itemCount,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.gray200,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const VSpace(6),
                          Container(
                            width: 180,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.gray200,
      highlightColor: AppColors.gray100,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
