import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContentStrategy implements CardContentStrategy {
  final double height;
  final bool showButton;
  final bool showSubtitle;
  final bool showProgress;

  const ShimmerContentStrategy({
    this.height = 180,
    this.showButton = true,
    this.showSubtitle = true,
    this.showProgress = false,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.3),
        highlightColor: Colors.white.withValues(alpha: 0.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(width: screenWidth * 0.6, height: 24),
            const SizedBox(height: 12),

            if (showSubtitle) ...[
              _buildShimmerBox(width: screenWidth * 0.8, height: 16),
              const SizedBox(height: 8),
              _buildShimmerBox(width: screenWidth * 0.5, height: 16),
              const SizedBox(height: 16),
            ],

            if (showProgress) ...[
              Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      child: _buildShimmerCircle(size: 32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildShimmerBox(width: 60, height: 16),
                ],
              ),
              const SizedBox(height: 16),

              _buildShimmerBox(
                width: screenWidth * 0.7,
                height: 8,
                borderRadius: 4,
              ),
              const SizedBox(height: 8),
              _buildShimmerBox(width: 80, height: 14),
            ],

            const Spacer(),

            if (showButton)
              Align(
                alignment: Alignment.centerRight,
                child: _buildShimmerBox(
                  width: 100,
                  height: 40,
                  borderRadius: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildShimmerCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class CourseShimmerContentStrategy implements CardContentStrategy {
  final double height;

  const CourseShimmerContentStrategy({this.height = 220});

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.7,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              width: screenWidth * 0.4,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: screenWidth * 0.8,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: screenWidth * 0.6,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 4 : 8),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressShimmerContentStrategy implements CardContentStrategy {
  final double height;

  const ProgressShimmerContentStrategy({this.height = 200});

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.3),
        highlightColor: Colors.white.withValues(alpha: 0.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.6,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: screenWidth * 0.8,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: screenWidth * 0.5,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: index < 3 ? 4 : 12),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              width: screenWidth * 0.7,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const Spacer(),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
