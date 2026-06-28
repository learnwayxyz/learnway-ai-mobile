import 'package:flutter/material.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';

class BattleHeroCard extends StatelessWidget {
  const BattleHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFF47C42), Color(0xFFFF5722)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Stack(
        children: [
          _buildBackgroundCircles(),
          _buildContent(context),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          left: 211,
          top: 70.28,
          child: Container(
            transform: Matrix4.rotationZ(-0.38),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
        ),
        Positioned(
          left: 248,
          top: 83.92,
          child: Container(
            transform: Matrix4.rotationZ(-0.38),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
        ),
        Positioned(
          left: 285,
          top: 98.28,
          child: Container(
            transform: Matrix4.rotationZ(-0.38),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      left: 27,
      top: 28.50,
      child: SizedBox(
        width: 161,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    l10n.battles,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(
                    width: 161,
                    child: Text(
                      l10n.battleHeroDescription,
                      style: TextStyle(
                        color: AppColors.gray200,
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Positioned(
      left: 219,
      top: 18,
      child: Container(
        width: 122,
        height: 88.80,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/game_controller.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
