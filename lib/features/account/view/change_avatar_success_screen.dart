import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/utilities/confetti_helper.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class ChangeAvatarSuccessScreen extends StatefulWidget {
  const ChangeAvatarSuccessScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ChangeAvatarSuccessScreen> createState() =>
      _ChangeAvatarSuccessScreenState();
}

class _ChangeAvatarSuccessScreenState extends State<ChangeAvatarSuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConfettiHelper.launchCelebration(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(widget.imagePath),
                ),
                VSpace(55),
                Text('You\'re all set!', style: AppTextStyles.xxlBold(context)),
                VSpace(10),
                Center(
                  child: Text(
                    'Your profile has been updated successfully.',
                    style: AppTextStyles.md(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                VSpace(42),
                ButtonFactory.blackButton(
                  text: 'Back to Home',
                  mainAxisAlignment: MainAxisAlignment.center,
                  textStyle: AppTextStyles.baseBold(
                    context,
                  ).copyWith(color: Colors.white),
                  onPressed: () {
                    context.router.popUntil(
                      (route) => route.settings.name == MainActivityRoute.name,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
