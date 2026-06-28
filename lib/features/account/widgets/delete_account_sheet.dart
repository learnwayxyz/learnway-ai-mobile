import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/cubit/theme_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key, required this.onDelete});

  final VoidCallback onDelete;

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: state.isDeleting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: AppTextStyles.baseRegular(context).copyWith(
                          color: state.isDeleting ? AppColors.gray400 : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: AppTextStyles.baseSemiBold(context),
                        ),
                      ),
                    ),
                  ],
                ),
                VSpace(40),
                Text(
                  AppLocalizations.of(context)!.areYouDeletingAccount,
                  style: AppTextStyles.mdBold(context),
                ),
                Text(
                  AppLocalizations.of(context)!.deleteConfirmInstruction,
                  style: AppTextStyles.smRegular(context),
                ),
                VSpace(23),
                TextFieldFactory.name(
                  controller: _nameController,
                  config: TextFieldConfig(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    fillColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    enabledBorderRadius: BorderRadius.circular(12),
                    hintText: AppLocalizations.of(context)!.typeDeleteToConfirm,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseTypeDeleteToConfirm;
                      }
                      if (value.toLowerCase().trim() != 'delete') {
                        return AppLocalizations.of(context)!.pleaseSpellDeleteExactly;
                      }
                      return null;
                    },
                  ),
                ),
                VSpace(60),
                ButtonFactory.blackButton(
                  onPressed: state.isDeleting
                      ? () {}
                      : () {
                          if (_formKey.currentState!.validate()) {
                            widget.onDelete();
                          }
                        },
                  text: state.isDeleting
                      ? AppLocalizations.of(context)!.processingEllipsis
                      : AppLocalizations.of(context)!.proceed,
                  mainAxisAlignment: MainAxisAlignment.center,
                  backgroundColor: state.isDeleting ? AppColors.gray400 : null,
                ),
                if (state.isDeleting) ...[
                  VSpace(20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        HSpace(8),
                        Text(
                          AppLocalizations.of(context)!.deletingYourAccountEllipsis,
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
      },
    );
  }
}
