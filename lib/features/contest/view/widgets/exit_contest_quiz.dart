import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

void showExitDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.7,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut)),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Are you sure you want to exit?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.mdBold(context),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ButtonFactory.blackButton(
                                mainAxisAlignment: MainAxisAlignment.center,
                                text: 'Stay',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ButtonFactory.blackButton(
                                backgroundColor: AppColors.error600,
                                mainAxisAlignment: MainAxisAlignment.center,
                                text: 'Exit',
                                onPressed: () {
                                  context.read<ContestBloc>().add(
                                    ResetContest(),
                                  );
                                  context.router.popUntil(
                                    (route) =>
                                        route.settings.name ==
                                        ContestRoute.name,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -60,
                  child: SizedBox(
                    height: FigmaConverter.height(context, 135),
                    width: FigmaConverter.width(context, 135),
                    child: Image(image: AssetImage(Assets.images.sad.path)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
