import 'package:auto_size_text/auto_size_text.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/home/models/home_tags.dart';
import 'package:learnwayv2/features/home/view/notification_sheet.dart';
import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_cubit.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_state.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';
import 'package:learnwayv2/features/promotions/view/promotion_popup_dialog.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/features/home/widgets/home_banner.dart';
import '../widgets/ai_quick_actions.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/services/att_service.dart';
import 'package:learnwayv2/services/version_check_service.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:ai_mentor/ai_mentor.dart';
import 'package:learnwayv2/features/home/widgets/streak_components.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/shimmer_app_bar.dart';
import 'package:learnwayv2/shared/widgets/screen_connectivity_wrapper.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        AutoRouteAwareStateMixin<HomeScreen>,
        ScreenLoadStateMixin<HomeScreen> {
  @override
  String get routeName => '/home';

  final AdService _adService = AdService.instance;

  @override
  void initState() {
    super.initState();
    VersionCheckService().check();
    context.read<HomeBloc>().add(const FetchHomeDataEvent());
    context.read<NotificationCubit>().loadNotifications();
    _fetchPromotions();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runAttAndLoadAds());
  }

  Future<void> _runAttAndLoadAds() async {
    if (!mounted) return;
    await ATTService.instance.requestTrackingIfNeeded();
    if (!mounted) return;
    _adService.loadRewardedAd();
    _adService.loadInterstitialAd();
    locator<AdmobService>().loadNativeAd();
    await _fetchPromotions();
  }

  Future<void> _fetchPromotions() async {
    final countryName = LocalStorageService.getUserSync()?.country;
    final countryCode = countryName != null
        ? CountryCode.fromName(countryName)?.code
        : null;
    final language = await SharedPreferencesStore.getPreferredLanguage();
    if (!mounted) return;
    context.read<PromotionsCubit>().fetchPromotions(
      country: countryCode,
      language: language ?? 'en',
    );
  }

  @override
  void didPopNext() {
    context.read<HomeBloc>().add(RefreshHomeDataEvent());
    context.read<NotificationCubit>().loadNotifications(refresh: true);
    super.didPopNext();
  }

  Future<void> _maybeShowPromoPopup(
    BuildContext context,
    PromotionModel popup,
  ) async {
    final cubit = context.read<PromotionsCubit>();
    final country = LocalStorageService.getUserSync()?.country;
    cubit.trackEvent(popup.id, 'IMPRESSION', country: country);
    final eligible = await cubit.shouldShowPopup(popup);
    if (!eligible) return;
    await cubit.markPopupSeen(popup);
    if (!context.mounted) return;
    await PromotionPopupDialog.show(context, popup);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenConnectivityWrapper(
      routeName: routeName,
      onRetry: () {
        context.read<HomeBloc>().add(const FetchHomeDataEvent());
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is FetchHomeDataSuccess) {
                markAsLoaded();
                locator<WeeklyGoalCubit>().load();
                NotificationPermissionSheet.show(
                  context,
                  hasDeviceToken: state.userProfile?.hasDeviceToken,
                );
                final promoState = context.read<PromotionsCubit>().state;
                if (promoState is PromotionsLoaded &&
                    promoState.popup != null) {
                  _maybeShowPromoPopup(context, promoState.popup!);
                }
              }
            },
          ),
          BlocListener<PromotionsCubit, PromotionsState>(
            listener: (context, state) {
              if (state is PromotionsLoaded && state.popup != null) {
                final homeState = context.read<HomeBloc>().state;
                if (homeState is FetchHomeDataSuccess) {
                  _maybeShowPromoPopup(context, state.popup!);
                }
              }
            },
          ),
        ],
        child: _buildHomeContent(),
      ),
    );
  }

  Widget _buildHomeContent() {
    final isLoading = context.select<HomeBloc, bool>(
      (HomeBloc bloc) => bloc.state is FetchingHomeData,
    );
    return Scaffold(
      appBar: isLoading ? const ShimmerAppBar() : AppBarFactory.homeAppBar(),
      body: isLoading ? _buildShimmerBody() : _buildActualBody(),
      floatingActionButton: isLoading
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LennyFloatingButton(
                onTap: () {
                  final user = LocalStorageService.getUserSync();
                  LennyChatSheet.show(
                    context,
                    userProfileUrl: user?.profileImageUrl ?? '',
                    userId: user?.id ?? '',
                    username: user?.username?.split(' ').first ?? 'there',
                    lennyAvatarAssetPath: Assets.images.lennyStarePose.path,
                    historyIconAssetPath: Assets.images.history.path,
                    closeIconAssetPath: Assets.images.cancelButtonIcon.path,
                    apiClient: locator<BaseApiClients>(
                      instanceName: 'aiTutorApiClient',
                    ),
                  );
                },
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildShimmerBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VSpace(25),

          _buildShimmerStreakComponent(),
          const VSpace(20),

          _buildShimmerHomeTags(),
          const VSpace(25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildShimmerBanner(),
          ),
          const VSpace(25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildShimmerTextSection(),
          ),
          const VSpace(25),

          _buildShimmerLessonCard(),
          _buildShimmerLessonCard(),
          _buildShimmerLessonCard(),
        ],
      ),
    );
  }

  Widget _buildActualBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.userProfile != null) {
                return Column(
                  children: [
                    const VSpace(25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const StreakComponent(),
                    ),
                    const VSpace(20),
                  ],
                );
              }
              return const VSpace(25);
            },
          ),
          BlocProvider.value(
            value: locator<WeeklyGoalCubit>(),
            child: BlocBuilder<WeeklyGoalCubit, WeeklyGoalState>(
              builder: (context, state) {
                if (state is WeeklyGoalLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: WeeklyGoalCard(
                      icon: Image.asset(Assets.images.weeklyGoalCalender.path),
                      weeklyGoal: state.weeklyGoal,
                      onDismiss: () =>
                          context.read<WeeklyGoalCubit>().dismiss(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, curr) => curr is FetchHomeDataSuccess,
            builder: (context, state) {
              final xp = state is FetchHomeDataSuccess
                  ? state.userProfile!.totalXp
                  : 0;
              final gems = state is FetchHomeDataSuccess
                  ? state.userProfile!.totalGems
                  : 0;
              final rank = state is FetchHomeDataSuccess
                  ? state.userProfile!.allTimeRank
                  : null;

              String formatRank(int? rank) {
                if (rank == null) return '--';
                String suffix = 'th';
                if (rank % 100 >= 11 && rank % 100 <= 13) {
                  suffix = 'th';
                } else {
                  switch (rank % 10) {
                    case 1:
                      suffix = 'st';
                      break;
                    case 2:
                      suffix = 'nd';
                      break;
                    case 3:
                      suffix = 'rd';
                      break;
                    default:
                      suffix = 'th';
                  }
                }
                return '$rank$suffix';
              }

              final homeTags = [
                HomeTags(Assets.images.trophy.path, 'Rank', formatRank(rank)),
                HomeTags(Assets.images.blueGem.path, 'Gems', formatScore(gems)),
                HomeTags(Assets.images.xp.path, 'XP', formatScore(xp)),
              ];

              return HorizontalTagsList(
                tags: homeTags,
                backgroundColor: AppColors.blueGray25,
              );
            },
          ),

          const VSpace(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<PromotionsCubit, PromotionsState>(
              builder: (context, state) {
                final banners = state is PromotionsLoaded
                    ? state.banners
                    : null;
                return HomeBanner(serverBanners: banners);
              },
            ),
          ),
          const VSpace(25),
          const AiQuickActionsSection(),
          const VSpace(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.exploreLearningPathTitle,
                        style: AppTextStyles.mdSemiBold(context),
                        maxLines: 2,
                        softWrap: true,
                      ),
                      const VSpace(4),
                      AutoSizeText(
                        AppLocalizations.of(
                          context,
                        )!.exploreLearningPathSubtitle,
                        style: AppTextStyles.mdRegular(context),
                        maxLines: 2,
                        minFontSize: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VSpace(25),
          CardFactory.lessonCard(
            margin: EdgeInsets.symmetric(horizontal: 16),
            cardType: CardType.lesson,
            title: AppLocalizations.of(context)!.learningPaths,
            subtitle: AppLocalizations.of(context)!.discoverLearningPaths,
            buttonText: AppLocalizations.of(context)!.startExploring,
            onButtonPressed: () {
              context.router.push(const ExplorePathsRoute());
            },
          ),
          VSpace(20),
        ],
      ),
    );
  }

  Widget _buildShimmerStreakComponent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildShimmerHomeTags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.09,
            width: 100,
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildShimmerTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const VSpace(8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLessonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class HorizontalTagsList extends StatelessWidget with ResponsiveMixin {
  final List<HomeTags> tags;
  final Color backgroundColor;
  final TextStyle? subTitleStyle;
  final TextStyle? titleStyle;

  const HorizontalTagsList({
    super.key,
    required this.tags,
    required this.backgroundColor,
    this.subTitleStyle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tags.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveDimension(context, 15),
                  vertical: getResponsiveDimension(context, 5),
                ),
                margin: responsiveInfo.responsiveMargin.copyWith(
                  top: 0,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    responsiveInfo.responsiveBorderRadius * 2,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: getResponsiveDimension(context, 38),
                      width: getResponsiveDimension(context, 38),
                      child: Image(image: AssetImage(e.imagePath)),
                    ),
                    SizedBox(width: getResponsiveDimension(context, 8)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.subTitle,
                          style:
                              subTitleStyle ??
                              AppTextStyles.xsSemiBold(context).copyWith(
                                fontSize: getResponsiveFontSize(
                                  context,
                                  AppTextStyles.xsSemiBold(context).fontSize ??
                                      12,
                                ),
                              ),
                        ),
                        Text(
                          e.title,
                          style:
                              titleStyle ??
                              AppTextStyles.baseBold(context).copyWith(
                                fontSize: getResponsiveFontSize(
                                  context,
                                  AppTextStyles.baseBold(context).fontSize ??
                                      16,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
