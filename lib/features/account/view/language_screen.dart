import 'dart:developer';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/model/supported_language_response.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selectedLanguageCode;
  String searchQuery = '';

  static const _languageToCountry = {
    'en': 'United Kingdom',
    'fr': 'France',
    'sw': 'Kenya',
    'es': 'Spain',
    'hi': 'India',
    'pt': 'Portugal',
    'zh-CN': 'China',
  };

  String? _getFlagUri(String languageCode) {
    final countryName = _languageToCountry[languageCode];
    if (countryName == null) return null;

    final countryPicker = FlCountryCodePicker();
    final match = countryPicker.countryCodes.where(
      (e) => e.name == countryName,
    );

    if (match.isEmpty) return null;
    log('Flag for $languageCode: ${match.first.flagUri}');
    return match.first.flagUri;
  }

  static const _supportedLocaleCodes = {'en', 'fr'};

  List<Language> _filteredLanguages(List<Language> languages) {
    final localized = languages
        .where((lang) => _supportedLocaleCodes.contains(lang.code))
        .toList();
    if (searchQuery.isEmpty) return localized;
    return localized
        .where(
          (lang) =>
              lang.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              lang.nativeName.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<void> _loadSavedLanguage() async {
    final saved = await SharedPreferencesStore.getPreferredLanguage();
    if (saved != null && mounted) {
      setState(() => selectedLanguageCode = saved);
    }
  }

  Future<void> _onContinue(List<Language> languages) async {
    if (selectedLanguageCode == null) return;
    await SharedPreferencesStore.savePreferredLanguage(selectedLanguageCode!);
    if (mounted) {
      context.read<ProfileCubit>().updateLanguage(selectedLanguageCode!);
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.languageUpdatedSuccessfully,
          style: AppTextStyles.smRegular(context, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.failedToUpdateLanguage,
          style: AppTextStyles.smRegular(context, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getSupportedLanguage();
    _loadSavedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.updateLanguageStatus != curr.updateLanguageStatus,
      listener: (context, state) {
        if (state.updateLanguageStatus == UpdateLanguageStatus.updated) {
          _showSuccessSnackbar();
        } else if (state.updateLanguageStatus == UpdateLanguageStatus.error) {
          _showErrorSnackbar();
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.language),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(20),
              Text(
                AppLocalizations.of(context)!.chooseTheLanguage,
                style: AppTextStyles.mdBold(
                  context,
                  color: const Color(0xFF181D27),
                ),
              ),
              const VSpace(4),
              Text(
                AppLocalizations.of(context)!.chooseLanguageSubtitle,
                style: AppTextStyles.smRegular(
                  context,
                  color: const Color(0xFF414651),
                ),
              ),
              const VSpace(30),
              Flexible(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state.supportedLanguageStatus ==
                        FetchsupportedLanguageStatus.fetching) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.supportedLanguageStatus ==
                        FetchsupportedLanguageStatus.error) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.failedToLoadLanguages,
                              style: AppTextStyles.smRegular(context),
                            ),
                            const VSpace(12),
                            TextButton(
                              onPressed: () => context
                                  .read<ProfileCubit>()
                                  .getSupportedLanguage(),
                              child: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      );
                    }

                    final languages = state.supportedLanguage ?? [];
                    final filtered = _filteredLanguages(languages);

                    // Pre-select from state.preferredLanguage (from API) if
                    // nothing is locally selected yet
                    if (selectedLanguageCode == null) {
                      final preferred = state.preferredLanguage;
                      if (preferred != null && preferred.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => selectedLanguageCode = preferred);
                          }
                        });
                      } else if (languages.isNotEmpty) {
                        final active = languages.firstWhere(
                          (l) => l.isActive,
                          orElse: () => languages.first,
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => selectedLanguageCode = active.code);
                          }
                        });
                      }
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final language = filtered[index];
                          final isSelected =
                              language.code == selectedLanguageCode;
                          final isFirst = index == 0;
                          final isLast = index == filtered.length - 1;
                          final flagUri = _getFlagUri(language.code);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedLanguageCode = language.code;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0x14205AEB)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topLeft: isFirst
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  topRight: isFirst
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomLeft: isLast
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomRight: isLast
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: flagUri != null
                                        ? Image.asset(
                                            flagUri,
                                            width: 28,
                                            height: 28,
                                            fit: BoxFit.cover,
                                            package: 'fl_country_code_picker',
                                          )
                                        : Container(
                                            width: 28,
                                            height: 28,
                                            color: AppColors.primaryColor
                                                .withOpacity(0.15),
                                            alignment: Alignment.center,
                                            child: Text(
                                              language.code
                                                  .substring(0, 2)
                                                  .toUpperCase(),
                                              style: AppTextStyles.smRegular(
                                                context,
                                              ).copyWith(fontSize: 10),
                                            ),
                                          ),
                                  ),
                                  const HSpace(20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          language.name,
                                          style: AppTextStyles.smRegular(
                                            context,
                                          ),
                                        ),
                                        if (language.nativeName !=
                                            language.name)
                                          Text(
                                            language.nativeName,
                                            style: AppTextStyles.smRegular(
                                              context,
                                              color: const Color(0xFF9CA3AF),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFE5E7EB),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const VSpace(20),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading =
                      state.updateLanguageStatus ==
                      UpdateLanguageStatus.updating;
                  final languages = state.supportedLanguage ?? [];

                  return ButtonFactory.blackButton(
                    text: isLoading ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.continueButton,
                    onPressed: selectedLanguageCode != null && !isLoading
                        ? () => _onContinue(languages)
                        : () {},
                    mainAxisAlignment: MainAxisAlignment.center,
                  );
                },
              ),
              const VSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
