import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BadgeShimmerLoader extends StatelessWidget {
  const BadgeShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpace(20),
            // Header shimmer
            _buildHeaderShimmer(),
            const VSpace(17),
            // Tab buttons shimmer
            _buildTabButtonsShimmer(),
            const VSpace(20),
            // Badge categories shimmer
            _buildBadgeCategoryShimmer(),
            const VSpace(20),
            _buildBadgeCategoryShimmer(),
            const VSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const VSpace(4),
          Container(
            width: 250,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtonsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          const HSpace(10),
          Container(
            width: 140,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCategoryShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const VSpace(16),
          // Badge grid
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: List.generate(
              4,
              (index) => SizedBox(
                width: 160,
                child: Column(
                  children: [
                    // Badge icon circle
                    Container(
                      width: 101.03,
                      height: 101.03,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const VSpace(22),
                    // Badge name
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const VSpace(8),
                    // Badge description
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
