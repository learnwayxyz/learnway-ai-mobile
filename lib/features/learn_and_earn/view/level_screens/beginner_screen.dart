import 'dart:developer';
import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart'
    as learn_and_earn;
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/shared/utilities/banner_ad_manager.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/all_course_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/completed_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/current_course_tab.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

@RoutePage()
class BeginnerScreen extends StatefulWidget {
  const BeginnerScreen({super.key});

  @override
  State<BeginnerScreen> createState() => _BeginnerScreenState();
}

class _BeginnerScreenState extends State<BeginnerScreen> {
  final ScrollController _scrollController = ScrollController();
  static const _adKey = 'beginnerScreen';
  final AdService _adService = AdService.instance;
  bool get _isLevelPlay => locator<IAdService>() is LevelPlayService;
  final LevelPlayAdSize _adSize = LevelPlayAdSize.BANNER;

  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _tabKey = GlobalKey();
  double _adTopPosition = 0;

  void _measureTabBottom() {
    final tabCtx = _tabKey.currentContext;
    final stackCtx = _stackKey.currentContext;
    if (tabCtx == null || stackCtx == null) return;
    final tabBox = tabCtx.findRenderObject() as RenderBox?;
    final stackBox = stackCtx.findRenderObject() as RenderBox?;
    if (tabBox == null || stackBox == null) return;
    final offset = tabBox.localToGlobal(
      Offset(0, tabBox.size.height),
      ancestor: stackBox,
    );
    if (mounted && offset.dy != _adTopPosition) {
      setState(() => _adTopPosition = offset.dy);
    }
  }

  @override
  void initState() {
    super.initState();
    _adService.premiumStatusNotifier.addListener(_onPremiumChanged);
    if (_adService.shouldShowAds && !_isLevelPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final width = MediaQuery.of(context).size.width.truncate();
          BannerAdManager.instance.loadAd(_adKey, width);
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _onPremiumChanged() {
    if (!_adService.shouldShowAds && !_isLevelPlay) {
      BannerAdManager.instance.disposeAd(_adKey);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adService.premiumStatusNotifier.removeListener(_onPremiumChanged);
    _scrollController.dispose();
    if (!_isLevelPlay) {
      BannerAdManager.instance.disposeAd(_adKey);
    }
    super.dispose();
  }

  void _refreshData() {
    final registeredState = context.read<RegisteredCoursesBloc>().state;
    final coursesBloc = context.read<CoursesBloc>();

    bool hasCachedData = false;

    if (coursesBloc.cachedBeginnerCourses.isNotEmpty ||
        (registeredState is LoadedBeginnerRegisteredCourses &&
            registeredState.registeredCourses.isNotEmpty)) {
      hasCachedData = true;
    }

    if (hasCachedData) {
      context.read<CoursesBloc>().add(
        const FetchBeginnerCourses(forceRefresh: false),
      );
      context.read<RegisteredCoursesBloc>().add(
        const LoadBeginnerRegisteredCourses(forceRefresh: false),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<CoursesBloc>().add(
            const BackgroundRefreshBeginnerCourses(),
          );
          context.read<RegisteredCoursesBloc>().add(
            const BackgroundRefreshBeginnerRegisteredCourses(),
          );
        }
      });
    } else {
      context.read<CoursesBloc>().add(
        const FetchBeginnerCourses(forceRefresh: false),
      );
      context.read<RegisteredCoursesBloc>().add(
        const LoadBeginnerRegisteredCourses(forceRefresh: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.beginner,
        barHeight: 10,
      ),
      body: SafeArea(
        child:
            BlocConsumer<
              learn_and_earn.LearnAndEarnBloc,
              learn_and_earn.LearnAndEarnState
            >(
              listener: (context, state) {},
              builder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _measureTabBottom(),
                );
                return Stack(
                  key: _stackKey,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.chooseACourse,
                                style: AppTextStyles.lgBold(context),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.learnFutureReadySkills,
                                style: AppTextStyles.md(
                                  context,
                                ).copyWith(color: AppColors.gray700),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        _buildTabsSection(context),
                        Expanded(child: _buildTabContentWrapper(context)),
                      ],
                    ),
                    if (_adService.shouldShowAds && _adTopPosition > 0)
                      Positioned(
                        top: _adTopPosition,
                        left: 0,
                        right: 0,
                        child: const BannerAdSlot(slotKey: _adKey),
                      ),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context) {
    return Container(
      key: _tabKey,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: BlocBuilder<CourseTabsBloc, CourseTabsState>(
        builder: (context, tabState) {
          return _buildTabsAndToggleRow(context, tabState);
        },
      ),
    );
  }

  Widget _buildTabsAndToggleRow(BuildContext context, CourseTabsState state) {
    return Row(
      children: [
        Expanded(
          child: CustomTabs<CourseStatus>(
            tabs: [
              TabItem(
                value: CourseStatus.all,
                label: AppLocalizations.of(context)!.all,
                selectedColor: AppColors.gray900,
                unselectedColor: AppColors.blueGray100,
                selectedTextColor: Colors.white,
                unselectedTextColor: AppColors.gray700,
              ),
              TabItem(
                value: CourseStatus.current,
                label: AppLocalizations.of(context)!.currentTab,
                selectedColor: AppColors.gray900,
                unselectedColor: AppColors.blueGray100,
                selectedTextColor: Colors.white,
                unselectedTextColor: AppColors.gray700,
              ),
              TabItem(
                value: CourseStatus.completed,
                label: AppLocalizations.of(context)!.completedTab,
                selectedColor: AppColors.gray900,
                unselectedColor: AppColors.blueGray100,
                selectedTextColor: Colors.white,
                unselectedTextColor: AppColors.gray700,
              ),
            ],
            selectedValue: state.selectedTab,
            onTabSelected: (value) {
              context.read<CourseTabsBloc>().changeTab(value);
            },
            padding: EdgeInsets.zero,
            spacing: 8.0,
            borderRadius: 20.0,
            defaultPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            defaultTextStyle: AppTextStyles.smBold(context),
          ),
        ),
        const HSpace(12),
        _buildLayoutToggleButtons(context, state),
      ],
    );
  }

  Widget _buildLayoutToggleButtons(
    BuildContext context,
    CourseTabsState state,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleButton(
          icon: Assets.icons.gridLayoutIcon,
          isSelected: state.layoutType == LayoutType.grid,
          onTap: () {
            context.read<CourseTabsBloc>().changeLayout(LayoutType.grid);
          },
        ),
        const HSpace(10),
        _buildToggleButton(
          icon: Assets.icons.listLayoutIcon,
          isSelected: state.layoutType == LayoutType.list,
          onTap: () {
            context.read<CourseTabsBloc>().changeLayout(LayoutType.list);
          },
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.blueGray100,
          borderRadius: BorderRadius.circular(60),
        ),
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.gray700 : AppColors.gray400,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContentWrapper(BuildContext context) {
    return BlocBuilder<CourseTabsBloc, CourseTabsState>(
      builder: (context, tabState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshTabData(tabState.selectedTab);
        });

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: (_adService.shouldShowAds && _adTopPosition > 0)
              ? const EdgeInsets.only(top: 50)
              : EdgeInsets.zero,
          child: _buildTabContent(context, tabState),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, CourseTabsState state) {
    switch (state.selectedTab) {
      case CourseStatus.all:
        return AllCoursesTab(
          layoutType: state.layoutType,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          spacing: 16.0,
          levelType: LevelType.beginner,
        );
      case CourseStatus.current:
        return CurrentCoursesTab(
          onCoursePressed: (course) {
            registerCourseData(course, LevelType.beginner);
            context.router.push(LessonRoute(levelType: LevelType.beginner));
          },
          layoutType: state.layoutType,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          levelType: LevelType.beginner,
          spacing: 16.0,
        );
      case CourseStatus.completed:
        return CompletedCoursesTab(
          onCoursePressed: (course) {
            registerCourseData(course, LevelType.beginner);
            context.router.push(LessonRoute(levelType: LevelType.beginner));
          },
          layoutType: state.layoutType,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          levelType: LevelType.beginner,
          spacing: 16.0,
        );
    }
  }

  void _refreshTabData(CourseStatus selectedTab) {
    switch (selectedTab) {
      case CourseStatus.all:
        context.read<CoursesBloc>().add(
          const BackgroundRefreshBeginnerCourses(),
        );
        break;
      case CourseStatus.current:
      case CourseStatus.completed:
        context.read<RegisteredCoursesBloc>().add(
          const BackgroundRefreshBeginnerRegisteredCourses(),
        );
        break;
    }
  }
}

class _BeginnerBannerSlot extends StatefulWidget {
  const _BeginnerBannerSlot({
    required this.adKey,
    required this.isLevelPlay,
    required this.adSize,
    required this.adService,
  });

  final String adKey;
  final bool isLevelPlay;
  final LevelPlayAdSize adSize;
  final AdService adService;

  @override
  State<_BeginnerBannerSlot> createState() => _BeginnerBannerSlotState();
}

class _BeginnerBannerSlotState extends State<_BeginnerBannerSlot>
    implements LevelPlayBannerAdViewListener {
  final GlobalKey<LevelPlayBannerAdViewState> _bannerKey =
      GlobalKey<LevelPlayBannerAdViewState>();

  void _onAdMobReady() {
    if (mounted) setState(() {});
  }

  void _loadLevelPlayBanner() {
    _bannerKey.currentState?.loadAd();
  }

  @override
  void initState() {
    super.initState();
    if (widget.adService.shouldShowAds) {
      if (widget.isLevelPlay) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted && _bannerKey.currentState != null) {
            _loadLevelPlayBanner();
          }
        });
      } else {
        BannerAdManager.instance.addListener(widget.adKey, _onAdMobReady);
      }
    }
  }

  @override
  void dispose() {
    if (widget.isLevelPlay) {
      _bannerKey.currentState?.destroy();
    } else {
      BannerAdManager.instance.removeListener(widget.adKey, _onAdMobReady);
    }
    super.dispose();
  }

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  @override
  Widget build(BuildContext context) {
    if (!widget.adService.shouldShowAds) return const SizedBox.shrink();

    if (widget.isLevelPlay) {
      return Center(
        child: Container(
          width: widget.adSize.width.toDouble(),
          height: widget.adSize.height.toDouble(),
          alignment: Alignment.center,
          color: Colors.transparent,
          child: LevelPlayBannerAdView(
            key: _bannerKey,
            adUnitId: Platform.isAndroid
                ? _revenueConfig?.adUnitIds?.android.banner ?? ''
                : _revenueConfig?.adUnitIds?.ios.banner ?? '',
            adSize: widget.adSize,
            listener: this,
            placementName: 'DefaultBanner',
          ),
        ),
      );
    }

    final ad = BannerAdManager.instance.getAd(widget.adKey);
    if (ad == null) return const SizedBox.shrink();

    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(key: const ValueKey('beginnerScreenBanner'), ad: ad),
    );
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    log('BeginnerScreen LevelPlay Banner loaded: ${adInfo.adNetwork}');
    if (mounted) setState(() {});
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    log('BeginnerScreen LevelPlay Banner load failed $error');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}
  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {}
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}
  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {}
  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {}
  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {}
}
