import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

void handleUnAvailable(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(60),
                Center(
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.mdBold(
                          context,
                        ).copyWith(fontFamily: 'Poppins', color: Colors.black),
                      ),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: () => Navigator.of(context).pop(),
                      text: AppLocalizations.of(context)!.iUnderstand,
                      textStyle: AppTextStyles.smSemiBold(
                        context,
                      ).copyWith(color: AppColors.white),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  HSpace(10),
                  // Expanded(
                  //   child: ButtonFactory.blackButton(
                  //     isFullWidth: false,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     textStyle: AppTextStyles.smSemiBold(
                  //       context,
                  //     ).copyWith(color: AppColors.white),
                  //     text: 'Enroll',
                  //     padding: EdgeInsets.all(10),
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, 130),
                child: Image.asset(
                  Assets.images.lennyStarePose.path,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
