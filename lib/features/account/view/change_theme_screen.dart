import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/features/account/cubit/theme_cubit.dart';
import 'package:learnwayv2/features/account/view/theme_widgets.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: 'Theme', barHeight: 0),
      body: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(20),
                    Text('Appearance', style: AppTextStyles.mdBold(context)),
                    VSpace(4),
                    Text(
                      'Customize your UI theme to what suits you.',
                      style: AppTextStyles.mdRegular(
                        context,
                        color: AppColors.gray700,
                      ),
                    ),
                    VSpace(20),
                    _buildThemeOption(
                      context,
                      title: 'Light',
                      isSelected: state.themeMode == AppThemeMode.light,
                      onTap: () => context.read<ThemeCubit>().changeTheme(
                        AppThemeMode.light,
                      ),
                      cardTheme: CardThemeEnum.light,
                    ),
                    VSpace(20),
                    _buildThemeOption(
                      context,
                      title: 'Dark',
                      isSelected: state.themeMode == AppThemeMode.dark,
                      onTap: () => context.read<ThemeCubit>().changeTheme(
                        AppThemeMode.dark,
                      ),
                      cardTheme: CardThemeEnum.dark,
                    ),
                    VSpace(20),
                    _buildThemeOption(
                      context,
                      title: 'System',
                      isSelected: state.themeMode == AppThemeMode.system,
                      onTap: () => context.read<ThemeCubit>().changeTheme(
                        AppThemeMode.system,
                      ),
                      cardTheme: CardThemeEnum.split,
                    ),
                    VSpace(20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required CardThemeEnum cardTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(color: AppColors.primaryColor, width: 3)
                    : null,
                borderRadius: BorderRadius.circular(24.5),
              ),
              padding: isSelected ? const EdgeInsets.all(2) : null,
              child: Stack(
                children: [
                  ThemedCard(theme: cardTheme),
                  if (isSelected)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: SvgPicture.asset(
                        Assets.icons.themeCheckbox,
                        width: 24,
                        height: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        VSpace(10),
        Row(
          children: [
            SvgPicture.asset(Assets.icons.modeSwitch),
            HSpace(10),
            Text(title, style: AppTextStyles.smSemiBold(context)),
          ],
        ),
      ],
    );
  }

  // PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     automaticallyImplyLeading: false,
  //     titleSpacing: 0,
  //     toolbarHeight: 60,
  //     title: Container(
  //       padding: const EdgeInsets.only(bottom: 20),
  //       child: Row(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 20),
  //             child: CustomBackButton(onPress: () => context.router.pop()),
  //           ),
  //           Expanded(
  //             child: Center(
  //               child: Text('Theme', style: AppTextStyles.mdBold(context)),
  //             ),
  //           ),
  //           const SizedBox(width: 48),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
