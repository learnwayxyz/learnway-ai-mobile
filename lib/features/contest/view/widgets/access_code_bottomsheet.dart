import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

Future<String?> showAccessCodeBottomSheet({
  required BuildContext context,
  required Contest contest,
  required ContestBloc contestBloc,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) => BlocProvider.value(
      value: contestBloc,
      child: AccessCodeBottomSheet(contest: contest),
    ),
  );
}

class AccessCodeBottomSheet extends StatefulWidget {
  const AccessCodeBottomSheet({super.key, required this.contest});

  final Contest contest;

  @override
  State<AccessCodeBottomSheet> createState() => _AccessCodeBottomSheetState();
}

class _AccessCodeBottomSheetState extends State<AccessCodeBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;
  String _accessCode = '';

  void _submitAccessCode() {
    setState(() {
      _errorMessage = null;
    });

    if (_accessCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit code';
      });
      return;
    }

    context.read<ContestBloc>().add(SubmitAccessCode(_accessCode));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocConsumer<ContestBloc, ContestState>(
      listener: (context, state) {
        if (state is AccessCodeVerified) {
          Navigator.pop(context, state.accessCode);
        }

        if (state is AccessCodeInvalid) {
          setState(() {
            _errorMessage = state.errorMessage;
          });
        }
      },
      builder: (context, state) {
        final isJoining = state is VerifyingAccessCode;

        return PopScope(
          canPop: !isJoining,
          child: Container(
            padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, isJoining),
                    const VSpace(11),
                    _buildDivider(),
                    const VSpace(24),
                    if (isJoining)
                      _buildJoiningState()
                    else
                      _buildAccessCodeEntry(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isJoining) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Join a Private Contest',
                style: AppTextStyles.baseSemiBold(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (!isJoining)
            GestureDetector(
              onTap: () => Navigator.pop(context, null),
              child: Icon(Icons.close, color: AppColors.gray900, size: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAccessCodeEntry(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'Enter Room Code to join Contest',
            style: AppTextStyles.baseSemiBold(
              context,
            ).copyWith(fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
        ),
        const VSpace(32),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: OTPInputWidget(
            numberOfFields: 6,
            formKey: _formKey,
            fieldWidth: 50,
            fieldHeight: 50,
            textStyle: AppTextStyles.lgBold(context),
            borderColor: AppColors.gray300,
            focusedBorderColor: AppColors.gray900,
            onChanged: (value) {
              setState(() {
                _accessCode = value;
                _errorMessage = null;
              });
            },
          ),
        ),
        const VSpace(12),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: _buildErrorMessage(_errorMessage!, context: context),
          ),
        const VSpace(60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonFactory.blackButton(
            onPressed: _submitAccessCode,
            mainAxisAlignment: MainAxisAlignment.center,
            child: const Text(
              'Join Contest',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const VSpace(100),
      ],
    );
  }

  Widget _buildJoiningState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VSpace(40),
          CircularProgressIndicator(),
          VSpace(24),
          Text('Joining contest...'),
          VSpace(40),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message, {required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.warning700, size: 20),
          const HSpace(8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.warning700),
            ),
          ),
        ],
      ),
    );
  }
}
