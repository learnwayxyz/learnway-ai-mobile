import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class SetUpSuccessScreen extends StatefulWidget {
  const SetUpSuccessScreen({super.key});

  @override
  State<SetUpSuccessScreen> createState() => _SetUpSuccessScreenState();
}

class _SetUpSuccessScreenState extends State<SetUpSuccessScreen> {
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

  ImageProvider _getProfileImage(String imagePath) {
    debugPrint('Profile image path: $imagePath');

    if (imagePath.isEmpty) {
      debugPrint('Image path is empty, using default avatar');
      return const AssetImage("assets/default_avatar.png");
    }

    // Check if it's a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      debugPrint('Using NetworkImage for URL: $imagePath');
      return NetworkImage(imagePath);
    }

    // Check if it's an asset path
    if (imagePath.startsWith('assets/')) {
      debugPrint('Using AssetImage for asset: $imagePath');
      return AssetImage(imagePath);
    }

    // Check if it's a local file path
    if (imagePath.startsWith('/') || imagePath.contains('\\')) {
      final file = File(imagePath);
      debugPrint(
        'Checking local file: $imagePath, exists: ${file.existsSync()}',
      );
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    // Fallback to default avatar
    debugPrint('Fallback to default avatar');
    return const AssetImage("assets/default_avatar.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: BlocBuilder<AccountSetupCubit, AccountSetupState>(
          builder: (context, state) {
            if (state is AccountSetupSucess) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: _getProfileImage(state.prefferedImage),
                    ),
                    VSpace(55),
                    Text(
                      '${AppLocalizations.of(context)!.youreAllSet} ${state.userName}!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.xxlBold(context),
                    ),
                    VSpace(10),
                    Text(
                      AppLocalizations.of(context)!.accountHasBeenCreated,
                      style: AppTextStyles.md(context),
                    ),
                    VSpace(42),
                    ButtonFactory.blackButton(
                      text: AppLocalizations.of(context)!.getStarted,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textStyle: AppTextStyles.baseBold(
                        context,
                      ).copyWith(color: Colors.white),
                      onPressed: () {
                        // Reset MainActivityCubit to ensure we start on Home tab
                        context.router.replace(const DiscoveryFlowRoute());
                      },
                    ),
                  ],
                ),
              );
            }
            return emptyState(context);
          },
        ),
      ),
    );
  }
}

Widget emptyState(BuildContext context) {
  return Column(
    children: [
      Image(image: AssetImage('assets/images/empty_state.png')),
      Text(
        AppLocalizations.of(context)!.youreAllSet,
        style: AppTextStyles.xxlBold(context),
      ),
      VSpace(10),
      Text(
        AppLocalizations.of(context)!.accountHasBeenCreated,
        style: AppTextStyles.md(context),
      ),
      VSpace(42),
      ButtonFactory.blackButton(
        text: AppLocalizations.of(context)!.getStarted,
        textStyle: AppTextStyles.baseBold(
          context,
        ).copyWith(color: Colors.white),
        onPressed: () {
          // Reset MainActivityCubit to ensure we start on Home tab
          context.read<MainActivityCubit>().resetState();
          context.router.replace(const DiscoveryFlowRoute());
        },
      ),
    ],
  );
}
