import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

class DailyGemsSuccessDialog extends StatefulWidget {
  final int gemsAwarded;

  const DailyGemsSuccessDialog({super.key, required this.gemsAwarded});

  @override
  State<DailyGemsSuccessDialog> createState() => _DailyGemsSuccessDialogState();
}

class _DailyGemsSuccessDialogState extends State<DailyGemsSuccessDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main dialog container
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: 19.02,
                  right: 22.25,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF181D27),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF181D27),
                      ),
                    ),
                  ),
                ),

                // Blue gems row and text
                Positioned(
                  top: 120, // 120px down from the dialog top
                  left: 20, // 20px horizontal padding
                  right: 20, // 20px horizontal padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Blue gem
                      Assets.images.blueGem.image(
                        width: 35,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4), // 4px horizontal distance
                      // Text
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${widget.gemsAwarded} Gems Earned',
                            style: TextStyle(
                              color: const Color(0xFF181D27),
                              fontSize: 30,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              height: 1.17,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Congratulations text
                Positioned(
                  top: 164, // 120 + 44 (gem height) + 4px spacing
                  left: 20, // 20px horizontal padding
                  right: 20, // 20px horizontal padding
                  child: Text(
                    'Congratulations you earned your daily Gems. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF414651),
                      fontSize: 16,
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

          // Lenny image positioned outside the dialog
          Positioned(
            top: -80, // Brought down a bit - less outside, more inside
            left: 0,
            right: 0,
            child: Center(
              child: Assets.images.lennyHappy.image(
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
