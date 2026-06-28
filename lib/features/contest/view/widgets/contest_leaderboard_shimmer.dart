import 'package:flutter/material.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:shimmer/shimmer.dart';

class ContestLeaderboardShimmer extends StatelessWidget {
  const ContestLeaderboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeaderSection(context),
              _buildPodiumSection(context, responsiveInfo),
              _buildCurrentUserSection(context, responsiveInfo),
              VSpace(FigmaConverter.height(context, 16)),
              _buildListSection(context, responsiveInfo),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: FigmaConverter.symmetricPadding(context, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: FigmaConverter.height(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 12,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 12,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: FigmaConverter.height(context, 8)),
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: FigmaConverter.height(context, 16)),
        ],
      ),
    );
  }

  Widget _buildPodiumSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) {
    return Padding(
      padding: FigmaConverter.symmetricPadding(context, horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: FigmaConverter.height(context, 22)),
          Container(
            padding: FigmaConverter.padding(
              context,
              left: 0,
              right: 0,
              top: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                FigmaConverter.width(context, 30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPodiumUserShimmer(context, responsiveInfo, false),
                    SizedBox(width: FigmaConverter.width(context, 25)),
                    _buildPodiumUserShimmer(context, responsiveInfo, true),
                    SizedBox(width: FigmaConverter.width(context, 25)),
                    _buildPodiumUserShimmer(context, responsiveInfo, false),
                  ],
                ),
                SizedBox(height: FigmaConverter.height(context, 20)),
              ],
            ),
          ),
          SizedBox(height: FigmaConverter.height(context, 20)),
        ],
      ),
    );
  }

  Widget _buildPodiumUserShimmer(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    bool isFirst,
  ) {
    double size = isFirst
        ? (responsiveInfo.isTablet
              ? FigmaConverter.width(context, 120)
              : FigmaConverter.width(context, 117))
        : (responsiveInfo.isTablet
              ? FigmaConverter.width(context, 120)
              : FigmaConverter.width(context, 80));

    return Column(
      children: [
        CircleAvatar(radius: size / 2, backgroundColor: Colors.white),
        SizedBox(height: FigmaConverter.height(context, 30)),
        Container(
          height: 14,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: FigmaConverter.height(context, 10)),
        Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              FigmaConverter.width(context, 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) {
    return Padding(
      padding: FigmaConverter.symmetricPadding(context, horizontal: 16),
      child: Container(
        padding: FigmaConverter.padding(
          context,
          left: 16,
          right: 16,
          top: 15,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            FigmaConverter.width(context, 60),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: FigmaConverter.width(context, 12)),
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: FigmaConverter.width(context, 8)),
            Container(
              height: 16,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: FigmaConverter.width(context, 8)),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: responsiveInfo.isTablet
                  ? FigmaConverter.width(context, 28)
                  : FigmaConverter.width(context, 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) {
    return Padding(
      padding: FigmaConverter.symmetricPadding(context, horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            FigmaConverter.width(context, 25),
          ),
        ),
        child: Column(
          children: List.generate(
            5,
            (index) => _buildListItemShimmer(context, responsiveInfo),
          ),
        ),
      ),
    );
  }

  Widget _buildListItemShimmer(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) {
    return Container(
      height: FigmaConverter.height(context, 80, min: 70, max: 90),
      margin: FigmaConverter.padding(context, bottom: 8),
      padding: FigmaConverter.symmetricPadding(
        context,
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            height: 14,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: responsiveInfo.isTablet
                ? FigmaConverter.width(context, 26)
                : FigmaConverter.width(context, 22),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 16,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
