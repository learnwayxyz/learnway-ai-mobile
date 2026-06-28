import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/features/account/widgets/alert_dialogs.dart';
import 'package:learnwayv2/features/account/widgets/delete_account_sheet.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.security,
                  style: AppTextStyles.baseSemiBold(
                    context,
                    color: const Color(0xFF181D27),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(20),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return IndependentTile(
                    icon: Assets.icons.deleteIcon,
                    title: state.isDeleting
                        ? AppLocalizations.of(context)!.deletingAccountEllipsis
                        : AppLocalizations.of(context)!.deleteAccount,
                    styles: AppTextStyles.smRegular(context).copyWith(
                      color: state.isDeleting
                          ? AppColors.gray500
                          : AppColors.error600,
                    ),
                    onTap: state.isDeleting
                        ? null
                        : () {
                            _showDeleteAccountFlow(context);
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountFlow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: false,
      builder: (context) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SingleChildScrollView(
            child: DeleteAccountSheet(
              onDelete: () => _handleDeleteConfirmation(context),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteConfirmation(BuildContext context) {
    Navigator.pop(context);
    showDeleteConfirmationDialog(
      context,
      locator.get<ProfileCubit>().state,
      title: AppLocalizations.of(context)!.areYouDeletingAccount,
      description: AppLocalizations.of(context)!.deleteAccountDescription,
      imagePath: Assets.images.deleteAccountImage.path,
      actionType: AccountActionType.delete,
      onConfirm: () {
        locator.get<ProfileCubit>().deleteAccount();
      },
    );
  }
}
