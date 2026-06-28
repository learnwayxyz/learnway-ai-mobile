import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({super.key});

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Learning Progress',
                  style: const TextStyle(
                    color: Color(0xFF181D27),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildCustomAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpace(20),
            AccountSections(
              children: [
                AccountTiles(
                  icon: Assets.icons.bookMarkIcon,
                  title: 'Bookmarks',
                  onTap: () {
                    context.router.push(const BookmarksRoute());
                  },
                ),
                AccountTiles(
                  icon: Assets.icons.statisticsIcon,
                  title: 'Statistics',
                  onTap: () {
                    context.router.push(const StatisticsRoute());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
