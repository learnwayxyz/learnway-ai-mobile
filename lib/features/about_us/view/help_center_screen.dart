import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
                  'Help Center/FAQs',
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
            const SizedBox(width: 56),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const VSpace(50),
            // Help icon with gradient
            Container(
              // width: 80,
              // height: 80,
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       const Color(0xFF4DD0E1),
              //       const Color(0xFF5E35B1),
              //     ],
              //   ),
              // ),
              child: Center(
                child: Image.asset(
                  'assets/images/help.png',
                  width: 94,
                  height: 94,
                  // color: Colors.white,
                ),
              ),
            ),
            const VSpace(40),
            // FAQ Items
            _buildFAQItem(
              title: 'Why LearnWay',
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim.',
              isExpanded: true,
            ),
            const VSpace(12),
            _buildFAQItem(
              title: 'How to earn XPs',
              content: '',
              isExpanded: false,
            ),
            const VSpace(12),
            _buildFAQItem(
              title: 'How to earn Gems',
              content: '',
              isExpanded: false,
            ),
            const VSpace(12),
            _buildFAQItem(
              title: 'Who\'s on the leaderboard',
              content: '',
              isExpanded: false,
            ),
            const VSpace(12),
            _buildFAQItem(
              title: 'How to earn Gems',
              content: '',
              isExpanded: false,
            ),
            const VSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String title,
    required String content,
    required bool isExpanded,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF181D27),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.2,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: const Color(0xFF6B7280),
            size: 20,
          ),
          children: [
            if (content.isNotEmpty)
              Text(
                content,
                style: const TextStyle(
                  color: Color(0xFF414651),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: 0.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
