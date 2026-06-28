import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_state.dart';
import 'package:learnwayv2/features/auth/widget/auth_bottons.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogleLoading = context.select(
      (GoogleAuthCubit cubit) => cubit.state is GoogleAuthLoading,
    );

    final isGoogleAuth = context.select((GoogleAuthCubit cubit) {
      if (cubit.state is GoogleAuthLoading) {
        return AuthProvider.google;
      } else {
        return AuthProvider.apple;
      }
    });

    final isAppleLoading = context.select(
      (AppleAuthCubit cubit) => cubit.state is AppleAuthLoading,
    );

    bool showRegularLoader = AuthProvider.google == isGoogleAuth
        ? isGoogleLoading
        : isAppleLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        body: OverlayLoader(
          isLoading: showRegularLoader,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VSpace(65),
                    Center(
                      child: Image(
                        image: AssetImage(Assets.images.lennyHi.path),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.createAccount_title,
                      style: AppTextStyles.xxlBold(context),
                      textAlign: TextAlign.center,
                    ),
                    VSpace(10),
                    Text(
                      AppLocalizations.of(context)!.createAccount_subtitle,
                      style: AppTextStyles.mdRegular(context),
                      textAlign: TextAlign.center,
                    ),
                    VSpace(40),

                    if (Platform.isAndroid) GoogleButton(),
                    VSpace(10),
                    if (Platform.isIOS) AppleButton(),
                    VSpace(20),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Container(
                              height: 1,
                              color: AppColors.gray300,
                            ),
                          ),
                        ),
                        HSpace(10),
                        Text(
                          AppLocalizations.of(context)!.orText,
                          style: AppTextStyles.baseSemiBold(
                            context,
                          ).copyWith(fontFamily: 'Poppins'),
                        ),
                        HSpace(10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Container(
                              height: 1,
                              color: AppColors.gray300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    VSpace(20),
                    GmailButton(),
                    VSpace(24),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.smRegular(
                            context,
                          ).copyWith(color: AppColors.gray700),
                          children: [
                            TextSpan(
                              text:
                                  '${AppLocalizations.of(context)!.byAgreeingText}\n',
                            ),
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              )!.termsOfService,
                              style: TextStyle(
                                color: AppColors.gray900,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchUrl(
                                    'https://app.learnway.xyz/play-store-terms-conditions',
                                  );
                                },
                            ),
                            TextSpan(
                              text:
                                  ' ${AppLocalizations.of(context)!.andText} ',
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.privacyPolicy,
                              style: TextStyle(
                                color: AppColors.gray900,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchUrl('https://learnway.xyz/privacy');
                                },
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    VSpace(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
