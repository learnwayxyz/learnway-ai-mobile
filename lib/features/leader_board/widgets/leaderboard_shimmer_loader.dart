import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardShimmerLoader extends StatelessWidget {
  const LeaderboardShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: FigmaConverter.symmetricPadding(context, horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: FigmaConverter.height(context, 22)),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: FigmaConverter.height(context, 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  FigmaConverter.width(context, 30),
                ),
              ),
            ),
          ),
          SizedBox(height: FigmaConverter.height(context, 20)),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: FigmaConverter.height(context, 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  FigmaConverter.width(context, 60),
                ),
              ),
            ),
          ),
          SizedBox(height: FigmaConverter.height(context, 20)),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: FigmaConverter.height(context, 80),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      FigmaConverter.width(context, 15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
