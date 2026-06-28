import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class KycNotDoneScreen extends StatelessWidget {
  const KycNotDoneScreen({super.key});

  Future<void> _handleStartKyc(BuildContext context) async {
    final kycCubit = locator<KycCubit>();
    final sessionData = await kycCubit.createVerificationSession();

    if (sessionData == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(kycCubit.state.errorMessage ?? AppLocalizations.of(context)!.failedToStartKyc),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!context.mounted) return;

    await context.router.push(
      VerificationRoute(
        sessionUrl: sessionData['url'],
        sessionId: sessionData['session_id'],
        onComplete: (sessionId, params) async {
          debugPrint('KYC completed for session: $sessionId');
          await kycCubit.handleKycCompletion(sessionId, params ?? {});

          // Navigate to KYC done screen
          if (context.mounted) {
            context.router.replace(const KycDoneRoute());
          }
        },
        onError: (error) {
          debugPrint('KYC error: $error');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.verificationError(error.toString()))),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.kycNotDone,
        barHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const VSpace(67),
            Container(
              width: 365,
              height: 365,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(0.50, 0.50),
                  radius: 0.50,
                  colors: [const Color(0xFFEAECF5), const Color(0x33EAECF5)],
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/no_kyc_done.png',
                  width: 280,
                  height: 280,
                ),
              ),
            ),
            const VSpace(40),
            Text(
              AppLocalizations.of(context)!.noKycDone,
              textAlign: TextAlign.center,
              style: AppTextStyles.lgBold(
                context,
                color: const Color(0xFF181D27),
              ),
            ),
            const VSpace(10),
            Text(
              AppLocalizations.of(context)!.verifyIdentityToRemoveRestrictions,
              textAlign: TextAlign.center,
              style: AppTextStyles.smRegular(
                context,
                color: const Color(0xFF414651),
              ),
            ),
            const VSpace(42),
            ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              isFullWidth: true,
              text: AppLocalizations.of(context)!.startKyc,
              backgroundColor: Colors.black,
              textStyle: AppTextStyles.baseBold(
                context,
              ).copyWith(color: Colors.white, fontFamily: 'Manrope'),
              onPressed: () => _handleStartKyc(context),
            ),
            const VSpace(30),
          ],
        ),
      ),
    );
  }
}
