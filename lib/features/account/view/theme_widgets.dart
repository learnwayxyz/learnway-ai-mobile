import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

enum CardThemeEnum { light, dark, split }

class ThemedCard extends StatelessWidget {
  final CardThemeEnum theme;

  const ThemedCard({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    switch (theme) {
      case CardThemeEnum.light:
        return Column(
          children: [
            _buildFirstHalfCard(
              backgroundColor: Colors.white,
              primaryColor: const Color(0xFFE8E9F3),
              secondaryColor: const Color(0xFFD1D5DB),
              theme: CardThemeEnum.light,
            ),
            _buildSecondHalfCard(
              backgroundColor: Colors.white,
              primaryColor: const Color(0xFFE8E9F3),
              secondaryColor: const Color(0xFFD1D5DB),
              secondHalfTheme: CardThemeEnum.light,
            ),
          ],
        );
      case CardThemeEnum.dark:
        return Column(
          children: [
            _buildFirstHalfCard(
              backgroundColor: const Color(0xFF1F2937),
              primaryColor: const Color(0xFF374151),
              secondaryColor: const Color(0xFF4B5563),
              theme: CardThemeEnum.dark,
            ),
            _buildSecondHalfCard(
              backgroundColor: const Color(0xFF1F2937),
              primaryColor: const Color(0xFF374151),
              secondaryColor: const Color(0xFF4B5563),
              secondHalfTheme: CardThemeEnum.dark,
            ),
          ],
        );
      case CardThemeEnum.split:
        return _buildSplitCard(context);
    }
  }

  Widget _buildFirstHalfCard({
    required Color backgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    required CardThemeEnum theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            theme == CardThemeEnum.dark
                ? const Color(0xFF2C2C2E)
                : backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.5),
          topRight: Radius.circular(22.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        theme == CardThemeEnum.dark
                            ? Color(0xFF484A4B)
                            : primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7.2),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                          theme == CardThemeEnum.dark
                              ? Color(0xFF484A4B)
                              : primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 77,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        theme == CardThemeEnum.dark
                            ? Color(0xFF494B4C)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondHalfCard({
    required Color backgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    required CardThemeEnum secondHalfTheme,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      decoration: BoxDecoration(
        color:
            secondHalfTheme == CardThemeEnum.dark
                ? Color(0xFF1F2123)
                : AppColors.gray25,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22.5),
          bottomRight: Radius.circular(22.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 105,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        secondHalfTheme == CardThemeEnum.dark
                            ? Color(0xFF494B4C)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color:
                        secondHalfTheme == CardThemeEnum.dark
                            ? Color(0xFF494B4C)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color:
                        secondHalfTheme == CardThemeEnum.dark
                            ? Color(0xFF494B4C)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
              ),
            ],
          ),
          VSpace(10),
          Container(
            height: 22,
            decoration: BoxDecoration(
              color:
                  secondHalfTheme == CardThemeEnum.dark
                      ? Color(0xFF494B4C)
                      : primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitCard(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.5),
        child: Row(
          children: [
            // Left half - Light theme
            Expanded(
              child: Column(
                children: [
                  // Top section of light side
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 12,
                        bottom: 6,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8E9F3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 49,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E9F3),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom section of light side
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 6,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 49,
                            width: 105,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8E9F3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 49,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E9F3),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.82),
                                  bottomLeft: Radius.circular(10.82),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom bar spanning full width
                  Container(height: 22, color: const Color(0xFFE8E9F3)),
                ],
              ),
            ),
            // Right half - Dark theme
            Expanded(
              child: Column(
                children: [
                  // Top section of dark side
                  Expanded(
                    child: Container(
                      color: const Color(0xFF2C2C2E),
                      padding: const EdgeInsets.only(
                        right: 18,
                        top: 12,
                        bottom: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 49,
                              decoration: const BoxDecoration(
                                color: Color(0xFF484A4B),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.82),
                                  bottomRight: Radius.circular(10.82),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 77,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF484A4B),
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom section of dark side
                  Expanded(
                    child: Container(
                      color: const Color(0xFF1F2123),
                      padding: const EdgeInsets.only(
                        right: 18,
                        top: 6,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 49,
                              decoration: const BoxDecoration(
                                color: Color(0xFF484A4B),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.82),
                                  bottomRight: Radius.circular(10.82),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 77,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF484A4B),
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom bar spanning full width
                  Container(height: 22, color: const Color(0xFF484A4B)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
