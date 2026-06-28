import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class KycInReviewScreen extends StatelessWidget {
  const KycInReviewScreen({super.key});

  Future<void> _handleCheckStatus(BuildContext context) async {
    final kycCubit = locator<KycCubit>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.checkingVerificationStatus),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await kycCubit.getSessioDecision();

      if (!context.mounted) return;

      final newState = kycCubit.state;
      if (newState.isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.verificationApproved),
            backgroundColor: Colors.green,
          ),
        );

        if (context.mounted) {
          context.router.replace(const KycDoneRoute());
        }
      } else if (newState.isInReview) {
      } else if (newState.isDeclined) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.verificationDeclined),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToCheckStatus(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.kycStatus, barHeight: 10),
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
              AppLocalizations.of(context)!.kycUnderReview,
              textAlign: TextAlign.center,
              style: AppTextStyles.lgBold(
                context,
                color: const Color(0xFF181D27),
              ),
            ),
            const VSpace(10),
            Text(
              AppLocalizations.of(context)!.kycProcessingDescription,
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
              text: AppLocalizations.of(context)!.checkStatus,
              backgroundColor: Colors.black,
              textStyle: AppTextStyles.baseBold(
                context,
              ).copyWith(color: Colors.white, fontFamily: 'Manrope'),
              onPressed: () => _handleCheckStatus(context),
            ),
            const VSpace(30),
          ],
        ),
      ),
    );
  }
}
