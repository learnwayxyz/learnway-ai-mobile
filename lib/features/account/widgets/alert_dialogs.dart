import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

enum AccountActionType { delete, logout, none }

bool _isLoggingOut(ProfileState state, AccountActionType actionType) {
  return actionType == AccountActionType.logout &&
      state.logoutAccountStatus == LogoutAccountStatus.loggingOut;
}

void showDeleteConfirmationDialog(
  BuildContext context,
  ProfileState state, {
  required String title,
  required String description,
  required String imagePath,
  AccountActionType actionType = AccountActionType.none,
  required VoidCallback onConfirm,
}) {
  // final isDark = Theme.of(context).brightness == Brightness.dark;
  showDialog(
    context: context,
    barrierDismissible: !state.isDeleting && !_isLoggingOut(state, actionType),
    builder: (context) => PopScope(
      canPop: !state.isDeleting && !_isLoggingOut(state, actionType),
      child: AlertDialog(
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!state.isDeleting && !_isLoggingOut(state, actionType))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray800, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.gray800,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            VSpace(16),
            if (imagePath.isNotEmpty) ...[
              Image(image: AssetImage(imagePath)),
              VSpace(16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.mdBold(context),
            ),
            VSpace(8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,

                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                text: AppLocalizations.of(context)!.cancel,
                backgroundColor: AppColors.gray300,
                textStyle: AppTextStyles.baseBold(
                  context,
                ).copyWith(color: Colors.white),
                onPressed: () {
                  log('Cancel button pressed ${state.isDeleting}');
                  (state.isDeleting || _isLoggingOut(state, actionType))
                      ? null
                      : Navigator.pop(context);
                },
              ),
              SizedBox(width: 16),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    text: actionType == AccountActionType.delete
                        ? _getDeleteText(context, state)
                        : _getLogoutText(context, state),
                    backgroundColor: actionType == AccountActionType.delete
                        ? AppColors.error700
                        : (AppColors.gray900),
                    textStyle: AppTextStyles.baseBold(
                      context,
                    ).copyWith(color: Colors.white),
                    onPressed: () {
                      if (state.isDeleting ||
                          _isLoggingOut(state, actionType)) {
                        return;
                      }
                      onConfirm();
                    },
                  );
                },
              ),
            ],
          ),
          // Show loading indicator when logging out
          if (_isLoggingOut(state, actionType)) ...[
            VSpace(16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.gray900,
                      ),
                    ),
                  ),
                  HSpace(8),
                  Text(
                    AppLocalizations.of(context)!.processingLogout,
                    style: AppTextStyles.smRegular(context),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

String _getDeleteText(BuildContext context, ProfileState state) {
  log('state status: ${state.deleteStatus}');
  final l10n = AppLocalizations.of(context)!;
  switch (state.deleteStatus) {
    case DeleteStatus.deleting:
      return l10n.deleting;
    case DeleteStatus.deleted:
      return l10n.success;
    case DeleteStatus.error:
      return l10n.retry;
    default:
      return l10n.delete;
  }
}

String _getLogoutText(BuildContext context, ProfileState state) {
  final l10n = AppLocalizations.of(context)!;
  switch (state.logoutAccountStatus) {
    case LogoutAccountStatus.loggingOut:
      return l10n.loggingOutEllipsis;
    case LogoutAccountStatus.loggedOut:
      return l10n.success;
    case LogoutAccountStatus.error:
      return l10n.retry;
    default:
      return l10n.logout;
  }
}
