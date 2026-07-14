import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart'
    as learn_and_earn;
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/all_course_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/completed_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/current_course_tab.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

@RoutePage()
class AdvancedScreen extends StatefulWidget {
  const AdvancedScreen({super.key});

  @override
  State<AdvancedScreen> createState() => _AdvancedScreenState();
}

class _AdvancedScreenState extends State<AdvancedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final registeredState = context.read<RegisteredCoursesBloc>().state;
    final coursesBloc = context.read<CoursesBloc>();

    bool hasCachedData = false;
    if (coursesBloc.cachedAdvancedCourses.isNotEmpty ||
        (registeredState is LoadedAdvancedRegisteredCourses &&
            registeredState.registeredCourses.isNotEmpty)) {
      hasCachedData = true;
    }

    if (hasCachedData) {
      context.read<CoursesBloc>().add(
        const FetchAdvancedCourses(forceRefresh: false),
      );
      context.read<RegisteredCoursesBloc>().add(
        const LoadAdvancedRegisteredCourses(forceRefresh: false),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<CoursesBloc>().add(
            const BackgroundRefreshAdvancedCourses(),
          );
          context.read<RegisteredCoursesBloc>().add(
            const BackgroundRefreshAdvancedRegisteredCourses(),
          );
        }
      });
    } else {
      context.read<CoursesBloc>().add(
        const FetchAdvancedCourses(forceRefresh: false),
      );
      context.read<RegisteredCoursesBloc>().add(
        const LoadAdvancedRegisteredCourses(forceRefresh: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.advanced,
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.chooseACourse,
                            style: AppTextStyles.lgBold(context),
                          ),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.learnFutureReadySkills,
                            style: AppTextStyles.md(
                              context,
                            ).copyWith(color: AppColors.gray700),
                          ),
                        ],
                      ),
                    ),
                    _buildTabsSection(context),
                    Expanded(child: _buildTabContentWrapper(context)),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context) {
    return Container(
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
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Flexible(
          flex: 3,
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
            isSelected ? AppColors.gray950 : AppColors.gray400,
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
          levelType: LevelType.advanced,
        );
      case CourseStatus.current:
        return CurrentCoursesTab(
          onCoursePressed: (course) {
            registerCourseData(course, LevelType.advanced);
            context.router.push(LessonRoute(levelType: LevelType.advanced));
          },
          layoutType: state.layoutType,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          levelType: LevelType.advanced,
          spacing: 16.0,
        );
      case CourseStatus.completed:
        return CompletedCoursesTab(
          onCoursePressed: (course) {
            registerCourseData(course, LevelType.advanced);
            context.router.push(LessonRoute(levelType: LevelType.advanced));
          },
          layoutType: state.layoutType,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          levelType: LevelType.advanced,
          spacing: 16.0,
        );
    }
  }

  void _refreshTabData(CourseStatus selectedTab) {
    switch (selectedTab) {
      case CourseStatus.all:
        context.read<CoursesBloc>().add(
          const BackgroundRefreshAdvancedCourses(),
        );
        break;
      case CourseStatus.current:
      case CourseStatus.completed:
        context.read<RegisteredCoursesBloc>().add(
          const BackgroundRefreshAdvancedRegisteredCourses(),
        );
        break;
    }
  }
}
