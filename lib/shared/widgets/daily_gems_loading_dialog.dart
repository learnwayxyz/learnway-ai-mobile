import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';

class DailyGemsLoadingDialog extends StatefulWidget {
  const DailyGemsLoadingDialog({super.key});

  @override
  State<DailyGemsLoadingDialog> createState() => _DailyGemsLoadingDialogState();
}

class _DailyGemsLoadingDialogState extends State<DailyGemsLoadingDialog>
    with TickerProviderStateMixin {
  late AnimationController _spinnerController;
  late Animation<double> _spinnerAnimation;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _spinnerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _spinnerController, curve: Curves.linear),
    );
    _spinnerController.repeat();
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
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
              top: 69,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Receive your daily Gems',
                    style:
                        AppTextStyles.mdBold(
                          context,
                          color: const Color(0xFF181D27),
                        ).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 24 / 18,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wait a while, it\'s not you it\'s us.',
                    style:
                        AppTextStyles.smRegular(
                          context,
                          color: const Color(0xFF414651),
                        ).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          height: 14 / 14,
                          letterSpacing: 0.2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 153,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _spinnerAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _spinnerAnimation.value * 2 * 3.14159,
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CustomPaint(
                          painter: CircularProgressPainter(progress: 0.25),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
