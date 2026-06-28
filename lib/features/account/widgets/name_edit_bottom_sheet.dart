import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/cubit/theme_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';

import 'dart:async';

class NameEditBottomSheet extends StatefulWidget {
  final String currentName;
  final Function(String) onSave;

  const NameEditBottomSheet({
    super.key,
    required this.currentName,
    required this.onSave,
  });

  @override
  State<NameEditBottomSheet> createState() => _NameEditBottomSheetState();
}

class _NameEditBottomSheetState extends State<NameEditBottomSheet> {
  late TextEditingController _nameController;
  bool _isValid = false;
  String? _errorMessage;
  bool? userNameExists;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _nameController.addListener(_onNameChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().clearUsernameCheck();
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onNameChanged() {
    final name = _nameController.text.trim();

    if (name.isEmpty || name == widget.currentName) {
      setState(() {
        _isValid = false;
        _errorMessage = null;
        userNameExists = null;
      });
      _debounceTimer?.cancel();
      context.read<ProfileCubit>().clearUsernameCheck();
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<ProfileCubit>().checkUserName(name);
    });
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && _isValid && userNameExists == true) {
      widget.onSave(name);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(20),
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: AppTextStyles.baseSemiBold(context),
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.username,
                    style: AppTextStyles.baseBold(context),
                  ),
                ),
                Spacer(),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final canSave =
                        _nameController.text.trim().isNotEmpty &&
                        _isValid &&
                        userNameExists == true &&
                        !state.isCheckingUsername;

                    return InkWell(
                      onTap: canSave ? _handleSave : null,
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: AppTextStyles.baseSemiBold(context).copyWith(
                          color: canSave
                              ? AppColors.gray900
                              : AppColors.gray400,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            VSpace(20),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        TextFieldFactory.name(
                          controller: _nameController,
                          config: TextFieldConfig(
                            hintText: AppLocalizations.of(context)!.enterPreferredUsername,
                            fillColor: AppColors.gray100,
                            hintTextStyle: AppTextStyles.base(
                              context,
                            ).copyWith(color: AppColors.hintTextColor),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                BaseValidators.validateUsername(value ?? ''),
                            borderRadius: BorderRadius.circular(12),
                            enabledBorderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(child: _showLoaderOrIcon(state)),
                        ),
                      ],
                    ),
                    if (userNameExists == false) ...[
                      VSpace(2),
                      Center(
                        child: ErrorBanner(
                          message: AppLocalizations.of(context)!.usernameTakenError,
                          textColor: Colors.red,
                          padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                        ),
                      ),
                    ],
                    VSpace(5),
                    Text(
                      AppLocalizations.of(context)!.usernameVisibleOnLeaderboard,
                      style: AppTextStyles.smRegular(
                        context,
                      ).copyWith(color: AppColors.gray600),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showLoaderOrIcon(ProfileState state) {
    if (state.isCheckingUsername) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state.isUsernameAvailable) {
      userNameExists = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isValid = true;
            _errorMessage = null;
          });
        }
      });
      return SvgPicture.asset(Assets.icons.tickCircle);
    }

    if (state.isUsernameUnavailable) {
      userNameExists = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isValid = false;
            _errorMessage = AppLocalizations.of(context)!.usernameAlreadyExists;
          });
        }
      });
      return const Icon(Icons.cancel_rounded, color: Colors.red, size: 16);
    }

    if (state.hasUsernameCheckError) {
      userNameExists = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isValid = false;
            _errorMessage = AppLocalizations.of(context)!.errorCheckingUsername;
          });
        }
      });
      return const Icon(Icons.error_rounded, color: Colors.orange, size: 16);
    }

    return const SizedBox.shrink();
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool showArrow;

  const ErrorBanner({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final bannerColor = backgroundColor ?? AppColors.error600;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bannerColor,
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              child: Text(
                message,
                style: AppTextStyles.smRegular(color: Colors.white, context),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          if (showArrow)
            Positioned(
              top: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: 45 * 3.14159 / 180,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
