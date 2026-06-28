import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class CompactProgressShimmerContentStrategy implements CardContentStrategy {
  final bool isCompact;
  final double height;

  const CompactProgressShimmerContentStrategy({
    this.isCompact = false,
    this.height = 180,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return SizedBox(
      height: height,
      child: Padding(
        padding:
            isCompact
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                : const EdgeInsets.all(20),
        child: Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildShimmerBox(
                      width: screenWidth * (isCompact ? 0.6 : 0.7),
                      height: isCompact ? 18 : 24,
                    ),
                  ),
                ],
              ),
              HSpace(isCompact ? 8 : 12),

              // Description shimmer lines
              _buildShimmerBox(
                width: screenWidth * (isCompact ? 0.8 : 0.85),
                height: isCompact ? 14 : 16,
              ),
              const SizedBox(height: 6),
              _buildShimmerBox(
                width: screenWidth * (isCompact ? 0.5 : 0.6),
                height: isCompact ? 14 : 16,
              ),
              if (!isCompact) ...[
                const SizedBox(height: 6),
                _buildShimmerBox(width: screenWidth * 0.4, height: 16),
              ],

              SizedBox(height: isCompact ? 12 : 20),
              _buildUserProgressShimmerRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProgressShimmerRow(BuildContext context) {
    final avatarSize = isCompact ? 24.0 : 32.0;
    final spacing = isCompact ? 16.0 : 24.0;

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatars row for compact
          Row(
            children: [
              // Avatar circles
              SizedBox(
                height: avatarSize,
                width: 3 * (spacing - 0.5),
                child: Stack(
                  children: List.generate(3, (index) {
                    return Positioned(
                      left: index * (spacing - 8),
                      child: _buildShimmerCircle(size: avatarSize),
                    );
                  }),
                ),
              ),
              // +X users shimmer
              _buildShimmerBox(width: 30, height: 16),
            ],
          ),
          const SizedBox(height: 8),

          // Progress section for compact
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress label
                  _buildShimmerBox(width: 60, height: 12),
                  const SizedBox(height: 4),
                  // Progress bar
                  _buildShimmerBox(
                    width: constraints.maxWidth * 0.7,
                    height: 6,
                    borderRadius: 3,
                  ),
                ],
              );
            },
          ),
        ],
      );
    } else {
      // Non-compact (horizontal layout)
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Avatar circles
                SizedBox(
                  height: avatarSize,
                  width: 3 * (spacing - 8) + 8,
                  child: Stack(
                    children: List.generate(3, (index) {
                      return Positioned(
                        left: index * (spacing - 8),
                        child: _buildShimmerCircle(size: avatarSize),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                // +X users shimmer
                _buildShimmerBox(width: 35, height: 16),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress label
                _buildShimmerBox(width: 80, height: 12),
                const SizedBox(height: 4),
                // Progress bar
                _buildShimmerBox(width: 120, height: 8, borderRadius: 4),
              ],
            ),
          ),
        ],
      );
    }
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
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
    );
  }
}
