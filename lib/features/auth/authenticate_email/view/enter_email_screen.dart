import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/verify_email_cubit.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';

@RoutePage()
class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading(EmailState state) =>
      state is VerifyingOtpState || state is SendingOtpState;

  String? _getErrorMessage(EmailState state) {
    if (state is VerifyingNewUserFailureState ||
        state is SendingOtpFailureState ||
        state is VerifyingOtpStateFailureState) {
      return (state as dynamic).message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<VerifyEmailCubit, EmailState>(
        listener: (context, state) {
          final errorMessage = _getErrorMessage(state);
          if (errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
          }
        },
        builder: (context, state) {
          final isLoading = _isLoading(state);

          return OverlayLoader(
            isLoading: isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomBackButton(),
                    VSpace(53),
                    Text(
                      AppLocalizations.of(context)!.enterPlatform,
                      style: AppTextStyles.xxl(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    VSpace(10),
                    Text(
                      AppLocalizations.of(context)!.enterEmailInstruction,
                      style: AppTextStyles.baseRegular(context),
                    ),
                    VSpace(51),
                    Text(AppLocalizations.of(context)!.email, style: AppTextStyles.baseBold(context)),
                    VSpace(8),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFieldFactory.email(
                        controller: _controller,
                        config: TextFieldConfig(
                          hintText: AppLocalizations.of(context)!.enterEmailHint,
                          keyboardType: TextInputType.emailAddress,
                          focusedErrorBorderColor: AppColors.gray900,
                          focusedBorderColor: AppColors.gray900,
                          hintTextStyle: AppTextStyles.smRegular(
                            context,
                          ).copyWith(color: AppColors.hintTextColor),
                          validator: BaseValidators.email,
                        ),
                      ),
                    ),
                    VSpace(50),
                    ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      text: AppLocalizations.of(context)!.continueButton,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _controller.text.trim();
                          context.read<VerifyEmailCubit>().verifyEmail(email);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
