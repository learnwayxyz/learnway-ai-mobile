import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool isSoundEnabled = true;
  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final soundEnabled = await SharedPreferencesStore.getSoundEnabled();
    setState(() {
      isSoundEnabled = soundEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.preference,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpace(20),
            AccountSections(
              children: [
                // AccountTiles(
                //   icon: Assets.icons.switchThemeIcon,
                //   title: 'Theme',
                //   onTap: () {
                //     context.router.push(const ChangeThemeRoute());
                //   },
                // ),
                _ToggleTile(
                  icon: 'assets/icons/sound.svg',
                  title: AppLocalizations.of(context)!.sound,
                  child: _CustomToggle(
                    value: isSoundEnabled,
                    onChanged: (value) async {
                      setState(() {
                        isSoundEnabled = value;
                      });
                      await SharedPreferencesStore.saveSoundEnabled(value);
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.router.push(const LanguageRoute());
                  },
                  child: _ToggleTile(
                    icon: Assets.icons.languageSquare,
                    title: 'Language',
                    child: Icon(Icons.chevron_right, color: AppColors.gray600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.child,
  });

  final String icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 24, height: 24),
          const HSpace(10),
          Expanded(child: Text(title, style: AppTextStyles.smRegular(context))),
          child,
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  const _CustomToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 41,
        height: 24.92,
        decoration: BoxDecoration(
          color: value ? AppColors.primary600 : const Color(0xFFE9E9EA),
          borderRadius: BorderRadius.circular(12.86),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 27.33,
              height: 21.71,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.86),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 5.63,
                    offset: Offset(0, 2.41),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
