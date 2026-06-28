import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/course_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/current_tab_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/lesson_strategies.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/progess_strategies.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/shimmer_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/over_lays/course_overlays.dart';
import 'package:learnwayv2/shared/widgets/card_component/over_lays/lesson_overlays.dart';
import 'package:learnwayv2/shared/widgets/card_component/over_lays/level_overlays.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/widgets/card_component/shimmers/compact_card_shimmer.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

enum LevelType { beginner, intermediate, advanced }

abstract class CardContentStrategy {
  Widget buildContent(BuildContext context, double screenWidth);
}

abstract class CardOverlayStrategy {
  List<Widget> buildOverlays(String? characterImageAsset);
}

class EmptyOverlayStrategy implements CardOverlayStrategy {
  @override
  List<Widget> buildOverlays(String? characterImageAsset) {
    return [];
  }
}

class BaseCard extends StatelessWidget {
  final CardContentStrategy contentStrategy;
  final CardOverlayStrategy overlayStrategy;
  final String? characterImageAsset;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;

  const BaseCard({
    super.key,
    required this.contentStrategy,
    required this.overlayStrategy,
    this.characterImageAsset,
    this.gradient,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: screenWidth,
          margin: margin,
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.startLessonGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: contentStrategy.buildContent(context, screenWidth),
        ),
        ...overlayStrategy.buildOverlays(Assets.images.sharpRectangles.path),
      ],
    );
  }
}

class CardFactory {
  static Widget lessonCard({
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onButtonPressed,
    String? characterImageAsset,
    CardType cardType = CardType.lesson,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
    Map<CardType, List<OverlayConfig>> dynamicOverlays = const {},
  }) {
    return BaseCard(
      contentStrategy: LessonContentStrategy(
        title: title ?? '',
        subtitle: subtitle ?? '',
        buttonText: buttonText ?? '',
        onButtonPressed: onButtonPressed,
      ),
      overlayStrategy: LessonOverlayStrategy(
        cardType,
        dynamicOverlays: dynamicOverlays,
      ),
      characterImageAsset: characterImageAsset,
      gradient: gradient,
      margin: margin,
    );
  }

  static Widget progressCard({
    required String title,
    required String description,
    required String buttonText,
    required List<User> userAvatars,
    required int totalUsers,
    required double progressValue,
    required bool isList,
    String? progressLabel,
    VoidCallback? onButtonPressed,
    String? characterImageAsset,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: ProgressContentStrategy(
        title: title,
        description: description,
        buttonText: buttonText,
        userAvatars: userAvatars,
        totalUsers: totalUsers,
        progressValue: progressValue,
        progressLabel: progressLabel,
        onButtonPressed: onButtonPressed,
      ),
      overlayStrategy: CourseOverlayStrategy(),
      characterImageAsset: characterImageAsset,
      gradient: gradient,
      margin: margin,
    );
  }

  static Widget levelCard({
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onButtonPressed,
    String? characterImageAsset,
    required LevelType levelType,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
    bool? isLocked,
  }) {
    return BaseCard(
      contentStrategy: LessonContentStrategy(
        title: title ?? '',
        subtitle: subtitle ?? '',
        buttonText: buttonText ?? '',
        onButtonPressed: onButtonPressed,
        isLocked: isLocked ?? false,
      ),
      overlayStrategy: LevelOverlayStrategy(levelType),
      characterImageAsset: characterImageAsset,
      gradient: gradient ?? RandomGradients.getDailyGradient(seed: '$title'),
      margin: margin,
    );
  }

  static Widget courseCard({
    required String title,
    required String author,
    required String description,
    required List<String> userAvatars,
    required int totalUsers,
    VoidCallback? onButtonPressed,
    String? characterImageAsset,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: CourseContentStrategy(
        title: title,
        author: author,
        description: description,
        userAvatars: userAvatars,
        totalUsers: totalUsers,
        onButtonPressed: onButtonPressed,
      ),
      overlayStrategy: CourseOverlayStrategy(),
      characterImageAsset: characterImageAsset,
      gradient:
          gradient ??
          RandomGradients.getDailyGradient(
            seed: '$title-$author-${userAvatars.length}-$totalUsers',
          ),
      margin: margin,
    );
  }

  static Widget activeLessonCard({
    required String title,
    required String subtitle,
    required String progressLabel,
    required double progressValue,
    required int completedLessons,
    required int totalLessons,
    String? characterImageAsset,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: ActiveLessonContentStrategy(
        title: title,
        completedLessons: completedLessons,
        progressLabel: progressLabel,
        progressValue: progressValue,
        buttonText: '',
        subtitle: subtitle,
        totaLessons: totalLessons,
      ),
      overlayStrategy: EmptyOverlayStrategy(),
      characterImageAsset: characterImageAsset,
      gradient: gradient,
      margin: margin,
    );
  }

  static Widget customCard({
    required CardContentStrategy contentStrategy,
    required CardOverlayStrategy overlayStrategy,
    String? characterImageAsset,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: contentStrategy,
      overlayStrategy: overlayStrategy,
      characterImageAsset: characterImageAsset,
      gradient: gradient,
      margin: margin,
    );
  }

  static Widget currentTabCard({
    required CurrentTabStrategy contentStrategy,
    required CardOverlayStrategy overlayStrategy,
    String? characterImageAsset,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) => BaseCard(
    contentStrategy: contentStrategy,
    overlayStrategy: overlayStrategy,
    characterImageAsset: characterImageAsset,
    gradient: gradient,
    margin: margin,
  );

  ///Shimmer Cards
  static Widget shimmerCard({
    double height = 180,
    bool showButton = true,
    bool showSubtitle = true,
    bool showProgress = false,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: ShimmerContentStrategy(
        height: height,
        showButton: showButton,
        showSubtitle: showSubtitle,
        showProgress: showProgress,
      ),
      overlayStrategy: EmptyOverlayStrategy(),
      gradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade300, Colors.grey.shade200],
          ),
      margin: margin,
    );
  }

  static Widget courseShimmerCard({
    double height = 180,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: CourseShimmerContentStrategy(height: height),
      overlayStrategy: EmptyOverlayStrategy(),
      gradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade300, Colors.grey.shade200],
          ),
      margin: margin,
    );
  }

  static Widget progressShimmerCard({
    double height = 200,
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: ProgressShimmerContentStrategy(height: height),
      overlayStrategy: EmptyOverlayStrategy(),
      gradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade300, Colors.grey.shade200],
          ),
      margin: margin,
    );
  }

  static Widget compactShimmerCard({
    Gradient? gradient,
    EdgeInsetsGeometry? margin,
  }) {
    return BaseCard(
      contentStrategy: CompactProgressShimmerContentStrategy(),
      overlayStrategy: EmptyOverlayStrategy(),
      gradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade300, Colors.grey.shade200],
          ),
      margin: margin,
    );
  }
}
