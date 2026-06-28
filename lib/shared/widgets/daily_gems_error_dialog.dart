import 'package:flutter/material.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

class DailyGemsErrorDialog extends StatelessWidget {
  const DailyGemsErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
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
                Positioned(
                  top: 120,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Oops couldn\'t retrieve your Gems',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF181D27),
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                ),

                Positioned(
                  top: 150,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Try again to Claim Gems one more time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF414651),
                      fontSize: 14,
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

          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Center(
              child: Assets.images.lennySad.image(
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
