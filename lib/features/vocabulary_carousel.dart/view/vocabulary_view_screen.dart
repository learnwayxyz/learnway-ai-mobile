import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class VocabularyViewScreen extends StatelessWidget {
  const VocabularyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'LearnWay Basics',
                  style: AppTextStyles.xxl(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  "Here's how you earn and grow",
                  style: AppTextStyles.smRegular(
                    context,
                    color: AppColors.gray500,
                  ),
                ),
                const SizedBox(height: 24),
                _ConceptCard(
                  imageWidget: Assets.images.gemsEarned.image(height: 56),
                  title: l10n.walkThrough_title1,
                  description: l10n.walkThrough_description1,
                ),
                const SizedBox(height: 12),
                _ConceptCard(
                  imageWidget: Image.asset(
                    Assets.images.andinkraSetupBadge.path,
                    height: 56,
                  ),
                  title: l10n.walkThrough_title2,
                  description: l10n.walkThrough_description2,
                ),
                const SizedBox(height: 12),
                _ConceptCard(
                  imageWidget: Image.asset(
                    Assets.images.xpImage.path,
                    height: 56,
                  ),
                  title: l10n.walkThrough_title3,
                  description: l10n.walkThrough_description3,
                ),
                const Spacer(),
                ButtonFactory.blackButton(
                  text: 'Get Started',
                  mainAxisAlignment: MainAxisAlignment.center,
                  leadingIcon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () {
                    SharedPreferencesStore.saveVocalbularyKey(
                      vocabularyKey,
                      true,
                    );
                    context.router.replace(const DiscoveryFlowRoute());
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({
    required this.imageWidget,
    required this.title,
    required this.description,
  });

  final Widget imageWidget;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 56, height: 56, child: imageWidget),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.smBold(
                    context,
                    color: AppColors.gray950,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.xsRegular(
                    context,
                    color: AppColors.gray500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
