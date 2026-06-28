import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_state.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleAuthCubit, GoogleAuthState>(
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: ButtonFactory.outlinedButton(
          mainAxisAlignment: MainAxisAlignment.center,
          borderColor: AppColors.gray300,
          text: 'Continue with Google',
          onPressed: () {
            locator<GoogleAuthCubit>().signInWithGoogle();
            SharedPreferencesStore.usedGoogleAuth(usedGoogleAuthKey, true);
          },
          trailingSpace: 10,
          leadingSpace: 0,
          trailingIcon: SvgPicture.asset('assets/images/google_icon.svg'),
        ),
      ),
    );
  }
}

class AppleButton extends StatelessWidget {
  const AppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppleAuthCubit, AppleAuthState>(
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: ButtonFactory.outlinedButton(
          mainAxisAlignment: MainAxisAlignment.center,
          borderColor: AppColors.gray300,
          text: 'Continue with Apple',
          onPressed: () {
            locator<AppleAuthCubit>().signInWithApple();
            SharedPreferencesStore.usedAppleAuth(usedGoogleAuthKey, true);
          },
          trailingSpace: 10,
          leadingSpace: 0,
          trailingIcon: SvgPicture.asset(
            'assets/images/apple_icon.svg',
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberButton extends StatelessWidget {
  const PhoneNumberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonFactory.outlinedButton(
      text: 'Continue with Phone Number',
      onPressed: () {},
      trailingSpace: 10,
      leadingSpace: 0,
      padding: EdgeInsets.only(left: 40, top: 0, bottom: 16),
      trailingIcon: SvgPicture.asset(
        'assets/images/phone_icon.svg',
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }
}

class GmailButton extends StatelessWidget {
  const GmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: ButtonFactory.outlinedButton(
        mainAxisAlignment: MainAxisAlignment.center,
        borderColor: AppColors.gray300,
        text: 'Continue with Email',
        onPressed: () {
          appRouter.push(const EnterEmailRoute());
        },
        trailingSpace: 10,
        leadingSpace: 0,
        trailingIcon: SvgPicture.asset('assets/icons/email_icon.svg'),
      ),
    );
  }
}
