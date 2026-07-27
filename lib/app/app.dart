import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/cubit/theme_cubit.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/timer_cubit.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/verify_email_cubit.dart';
import 'package:learnwayv2/features/badges/bloc/badge_bloc.dart';
import 'package:learnwayv2/features/bookmarks/cubit/bookmark_cubit.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/leader_board/cubit/leader_board_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/certificate_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_info_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_project_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/features/statistics/cubit/statistics_cubit.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_cubit.dart';
import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/home/bloc/streak_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';
import 'package:learnwayv2/features/streak/domain/usecases/claim_daily_reward_usecase.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/swap_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_tab_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/connectivity_wrapper.dart';
import 'package:learnwayv2/shared/widgets/version_gate.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:provider/provider.dart';

import 'app_barrel.dart';

final appRouter = AppRouter();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late ThemeCubit _themeCubit;
  Locale _locale = const Locale('en');
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeCubit = ThemeCubit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final saved = await SharedPreferencesStore.getPreferredLanguage();
    if (saved != null && saved.isNotEmpty && mounted) {
      setState(() {
        _locale = _localeFromCode(saved);
      });
    }
  }

  Locale _localeFromCode(String code) {
    final parts = code.split('-');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(parts[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeCubit.close();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeCubit.updateSystemBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator.get<MainActivityCubit>()),
        BlocProvider(create: (_) => locator.get<AccountSetupCubit>()),
        BlocProvider(create: (_) => locator.get<VerifyEmailCubit>()),
        BlocProvider(create: (_) => locator.get<GoogleAuthCubit>()),
        BlocProvider(create: (_) => locator.get<AppleAuthCubit>()),
        BlocProvider(
          create: (_) => StreakBloc(
            streakRepository: locator.get<StreakRepository>(),
            claimDailyRewardUseCase: locator.get<ClaimDailyRewardUseCase>(),
          ),
        ),
        BlocProvider(create: (_) => locator.get<HomeBloc>()),
        BlocProvider(create: (_) => locator.get<QuizBloc>()),
        BlocProvider.value(value: locator.get<LearnAndEarnBloc>()),
        BlocProvider(create: (_) => locator.get<CourseTabsBloc>()),
        BlocProvider(create: (_) => locator.get<RegisteredCoursesBloc>()),
        BlocProvider<CoursesBloc>(create: (context) => locator<CoursesBloc>()),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(create: (_) => WalletTabCubit()),
        ChangeNotifierProvider(create: (_) => BalanceNotifier()),
        BlocProvider(create: (_) => SwapCubit()),
        BlocProvider(create: (_) => locator.get<WalletCubit>()),
        BlocProvider(create: (_) => locator<ProfileCubit>()),
        BlocProvider(create: (_) => BookmarkCubit()),
        BlocProvider(create: (_) => StatisticsCubit()),
        BlocProvider(create: (_) => locator.get<InviteFriendsCubit>()),
        BlocProvider.value(value: _themeCubit),
        BlocProvider(create: (_) => ContestBloc()),
        BlocProvider(create: (_) => locator.get<KycCubit>()),
        BlocProvider(create: (_) => locator.get<BadgeBloc>()),
        BlocProvider(create: (_) => locator.get<LeaderBoardCubit>()),
        BlocProvider(create: (_) => locator.get<NotificationCubit>()),
        BlocProvider(create: (_) => locator.get<PromotionsCubit>()),
        BlocProvider(
          create: (_) => CourseInfoCubit(
            repository: locator.get<LearnAndEarnRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => CourseProjectCubit(
            repository: locator.get<LearnAndEarnRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => CertificateCubit(
            repository: locator.get<LearnAndEarnRepository>(),
          ),
        ),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            prev.updateLanguageStatus != curr.updateLanguageStatus &&
            curr.updateLanguageStatus == UpdateLanguageStatus.updated,
        listener: (context, state) {
          if (state.preferredLanguage != null &&
              state.preferredLanguage!.isNotEmpty) {
            setState(() {
              _locale = _localeFromCode(state.preferredLanguage!);
            });
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              routerConfig: appRouter.config(
                navigatorObservers: () => [AutoRouteObserver(), observer],
              ),
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: NotificationService.scaffoldMessengerKey,
              theme: AppTheme.lightTheme.copyWith(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
              ),
              themeMode: ThemeMode.light,
              title: 'Learnway',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: VersionGate(
                    child: ConnectivityWrapper(
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ThemeMode _convertToFlutterThemeMode(AppThemeMode themeMode) {
  //   switch (themeMode) {
  //     case AppThemeMode.light:
  //       return ThemeMode.light;
  //     case AppThemeMode.dark:
  //       return ThemeMode.dark;
  //     case AppThemeMode.system:
  //       return ThemeMode.system;
  //   }
  // }
}
