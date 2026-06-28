import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_cubit.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_state.dart';
import 'package:learnwayv2/features/invite_friends/view/widgets/referral_code_input.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InviteFriendsCubit>().loadInviteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.invite, barHeight: 0),
      body: BlocBuilder<InviteFriendsCubit, InviteFriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingState();
          }

          if (state.errorMessage != null) {
            return _buildErrorState(state.errorMessage!);
          }

          if (state.inviteData == null) {
            return _buildEmptyState();
          }

          return _buildInviteContent(state);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error500),
          const VSpace(16),
          Text(
            AppLocalizations.of(context)!.errorLoadingInviteData,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF181D27),
            ),
          ),
          const VSpace(8),
          Text(
            error,
            style: AppTextStyles.smRegular(context),
            textAlign: TextAlign.center,
          ),
          const VSpace(16),
          ElevatedButton(
            onPressed: () {
              context.read<InviteFriendsCubit>().loadInviteData(
                forceRefresh: true,
              );
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.gray400),
          const VSpace(16),
          Text(
            AppLocalizations.of(context)!.noInviteDataAvailable,
            style: AppTextStyles.mdBold(context).copyWith(fontSize: 20),
          ),
          const VSpace(8),
          Text(
            AppLocalizations.of(context)!.unableToLoadReferralInfo,
            style: AppTextStyles.smRegular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInviteContent(InviteFriendsState state) {
    final inviteData = state.inviteData!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<InviteFriendsCubit>().loadInviteData(forceRefresh: true);
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppLocalizations.of(context)!.inviteAFriend, style: AppTextStyles.mdBold(context)),
          const VSpace(4),
          Text(
            AppLocalizations.of(context)!.inviteDescription(
              inviteData.totalReferrals,
              inviteData.gemsForReferrer,
              inviteData.gemsForReferee,
            ),
            style: AppTextStyles.smRegular(context),
          ),
          const VSpace(20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/diamonds.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),

                      Text(
                        '${inviteData.gemsEarned} ${AppLocalizations.of(context)!.gemsLabel}',
                        style: AppTextStyles.xxlBold(context),
                      ),
                    ],
                  ),
                ),
                const VSpace(40),

                ReferralCodeInput(
                  referralCode: inviteData.referralCode,
                  isCopied: state.isCopied,
                  onCopy: () {
                    context.read<InviteFriendsCubit>().copyReferralCode();
                  },
                ),
                const VSpace(20),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.read<InviteFriendsCubit>().shareReferralCode();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.shareReferralCode,
                      style: AppTextStyles.base(context, color: Colors.white),
                    ),
                  ),
                ),
                const VSpace(12),
                _ApplyReferralCodeButton(
                  hasUsed: inviteData.hasUsedReferralCode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplyReferralCodeButton extends StatelessWidget {
  const _ApplyReferralCodeButton({required this.hasUsed});

  final bool hasUsed;

  void _showDialog(BuildContext context) {
    final cubit = context.read<InviteFriendsCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: cubit,
        child: const _ReferralCodeDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: hasUsed ? null : () => _showDialog(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: hasUsed ? Colors.grey.shade300 : Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          disabledForegroundColor: Colors.grey.shade400,
        ),
        child: Text(
          hasUsed ? l10n.referralCodeApplied : l10n.haveAReferralCode,
          style: TextStyle(
            color: hasUsed ? Colors.grey.shade400 : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ReferralCodeDialog extends StatefulWidget {
  const _ReferralCodeDialog();

  @override
  State<_ReferralCodeDialog> createState() => _ReferralCodeDialogState();
}

class _ReferralCodeDialogState extends State<_ReferralCodeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<InviteFriendsCubit, InviteFriendsState>(
      listener: (ctx, state) {
        if (!state.isApplyingReferralCode &&
            state.referralApplyError == null &&
            (state.inviteData?.hasUsedReferralCode ?? false)) {
          Navigator.of(context).pop();
        }

        if (!state.isApplyingReferralCode && state.referralApplyError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.referralApplyError!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (ctx, state) {
        return AlertDialog(
          title: Text(l10n.enterReferralCode),
          content: TextFieldFactory.standard(
            controller: _controller,
            config: TextFieldConfig(
              hintText: l10n.referralCodeHintLabel,
              borderRadius: BorderRadius.circular(12),
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          actions: [
            TextButton(
              onPressed: state.isApplyingReferralCode
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: state.isApplyingReferralCode
                  ? null
                  : () {
                      if (_controller.text.trim().isNotEmpty) {
                        ctx.read<InviteFriendsCubit>().applyReferralCode(_controller.text);
                      }
                    },
              child: state.isApplyingReferralCode
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.applyCode),
            ),
          ],
        );
      },
    );
  }
}
