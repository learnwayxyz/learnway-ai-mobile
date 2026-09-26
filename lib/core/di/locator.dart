import 'dart:developer' as dev;
import 'package:get_it/get_it.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/verify_email_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/badges/bloc/badge_bloc.dart';
import 'package:learnwayv2/features/battles/bloc/battle_history_bloc.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/data/battle_data_source.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:learnwayv2/features/contest/bloc/contest_bloc.dart';
import 'package:learnwayv2/features/contest/data/contest_data_source.dart';
import 'package:learnwayv2/features/contest/repository/contest_repository.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_cubit.dart';
import 'package:learnwayv2/features/home/home_repository/home_repository.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/learn_and_earn_data_source.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/features/notifications/data/notification_data_source.dart';
import 'package:learnwayv2/features/notifications/repository/notification_repository.dart';
import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/features/quiz/bloc/quiz_bloc.dart';
import 'package:learnwayv2/features/quiz/quiz_repository/quiz_repository.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/wallet_data_source/wallet_data_source.dart';
import 'package:learnwayv2/features/wallet/wallet_repository/wallet_repository.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/services/analytics/analytics_service.dart';
import 'package:learnwayv2/services/biomterics/biometrics_service.dart';
import 'package:learnwayv2/services/defi_service/kotani_pay/kotani_pay_adapter.dart';
import 'package:learnwayv2/services/eip_4337/account_abstraction.dart';
import 'package:learnwayv2/services/eip_4337/wallet_configuration.dart';
import 'package:learnwayv2/services/firebase_store_service.dart';
import 'package:learnwayv2/services/interfaces.dart';
import 'package:learnwayv2/services/kyc_service/verification_manager.dart';
import 'package:learnwayv2/services/kyc_service/verification_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/cryptography_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_manager.dart';
import 'package:learnwayv2/features/streak/data/data_sources/streak_remote_data_source.dart';
import 'package:learnwayv2/features/streak/data/repositories/streak_repository_impl.dart';
import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';
import 'package:learnwayv2/features/streak/domain/usecases/claim_daily_reward_usecase.dart';
import 'package:learnwayv2/features/leader_board/repository/leaderboard_repository.dart';
import 'package:learnwayv2/features/leader_board/repository/leaderboard_repository_impl.dart';
import 'package:learnwayv2/features/leader_board/cubit/leader_board_cubit.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/services/bot_battle_event_service.dart';
import 'package:learnwayv2/services/websocket/websocket_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_cubit.dart';
import 'package:learnwayv2/features/promotions/repository/promotions_repository.dart';
import 'package:learnwayv2/shared/utilities/app_version_info.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:ai_mentor/ai_mentor.dart';
import 'package:learnwayv2/features/play/cubit/roadmap_cubit.dart';
import 'package:learnwayv2/features/play/data_source/roadmap_data_source.dart';
import 'package:learnwayv2/features/play/repository/roadmap_repository.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final baseApi = BaseApiClients(baseUrl: Env.baseUrl);
  locator.registerSingleton<BaseApiClients>(baseApi);

  final chainConfig = ChainConfiguration(
    bundleUrl: Env.bundleUrl,
    accountFactoryAddress: Env.accountFactory,
    learnWayPOCAddress: '',
    learnWayTokenAddress: '',
    learnWayFaucetAddress: '',
  );
  locator.registerSingleton<ChainConfiguration>(chainConfig);

  locator.registerLazySingleton<BaseApiClients>(
    () => BaseApiClients(
      baseUrl: Env.kotanBaseUrl,
      headers: {
        'Authorization': 'Bearer ${Env.kotanApiKey}',
        'Content-Type': 'application/json',
      },
    ),
    instanceName: 'kotaniApiClient',
  );

  locator.registerLazySingleton<BaseApiClients>(() {
    final config = locator.get<ApiConfigResponse>();
    return BaseApiClients(
      baseUrl: Env.didItBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': config.didItApiKey,
        'accept': 'application/json',
      },
    );
  }, instanceName: 'didItApiClient');

  locator.registerLazySingleton<BaseApiClients>(
    () => BaseApiClients(baseUrl: Env.aiTutorBaseUrl),
    instanceName: 'aiTutorApiClient',
  );

  locator.registerLazySingleton(() => WalletDataSource());
  locator.registerLazySingleton<LearnAndEarnDataSource>(
    () => LearnAndEarnDataSource(),
  );

  locator.registerLazySingleton<BattleDataSource>(() => BattleDataSource());

  locator.registerLazySingleton<StreakRemoteDataSource>(
    () => StreakRemoteDataSource(),
  );

  locator.registerLazySingleton<NotificationDataSource>(
    () => NotificationDataSourceImpl(locator<BaseApiClients>()),
  );

  locator.registerLazySingleton<CareerGoalDataSource>(
    () => CareerGoalDataSource(
      locator<BaseApiClients>(instanceName: 'aiTutorApiClient'),
    ),
  );

  locator.registerLazySingleton<RoadmapDataSource>(
    () => RoadmapDataSource(locator<BaseApiClients>()),
  );

  locator.registerLazySingleton<DashboardDataSource>(
    () => DashboardDataSource(
      locator<BaseApiClients>(instanceName: 'aiTutorApiClient'),
    ),
  );

  locator.registerLazySingleton<LearningPathDataSource>(
    () => LearningPathDataSource(locator<BaseApiClients>()),
  );

  locator.registerLazySingleton(() => HomeRepository());
  locator.registerLazySingleton(() => QuizRepository());
  locator.registerLazySingleton(() => WalletRepository());
  locator.registerLazySingleton(
    () => LearnAndEarnRepository(locator<LearnAndEarnDataSource>()),
  );

  locator.registerLazySingleton<ContestRepository>(
    () => ContestRepository(ContestRemoteDataSource()),
  );

  locator.registerLazySingleton<BattleRepository>(
    () => BattleRepository(locator()),
  );

  locator.registerLazySingleton<StreakRepository>(
    () => StreakRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => PromotionsRepository());

  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(locator()),
  );

  locator.registerLazySingleton<CareerGoalRepository>(
    () => CareerGoalRepository(locator()),
  );

  locator.registerLazySingleton<RoadmapRepository>(
    () => RoadmapRepository(locator()),
  );

  locator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(locator()),
  );

  locator.registerLazySingleton<LearningPathRepository>(
    () => LearningPathRepository(locator()),
  );

  locator.registerLazySingleton(() => ClaimDailyRewardUseCase(locator()));

  locator.registerFactory(() => AccountSetupCubit());
  locator.registerFactory(() => VerifyEmailCubit());
  locator.registerLazySingleton<MainActivityCubit>(() => MainActivityCubit());
  locator.registerSingleton<GoogleAuthCubit>(GoogleAuthCubit());
  locator.registerSingleton<AppleAuthCubit>(AppleAuthCubit());

  locator.registerLazySingleton<HomeBloc>(
    () => HomeBloc(homeRepository: locator()),
  );
  locator.registerLazySingleton<QuizBloc>(() => QuizBloc());
  locator.registerLazySingleton<LearnAndEarnBloc>(() => LearnAndEarnBloc());
  locator.registerLazySingleton<CourseTabsBloc>(() => CourseTabsBloc());
  locator.registerLazySingleton<RegisteredCoursesBloc>(
    () => RegisteredCoursesBloc(),
  );
  locator.registerLazySingleton<CoursesBloc>(() => CoursesBloc());
  locator.registerLazySingleton<ProfileCubit>(() => ProfileCubit());
  locator.registerLazySingleton<WalletCubit>(() => WalletCubit());
  locator.registerLazySingleton<ContestBloc>(() => ContestBloc());
  locator.registerLazySingleton<InviteFriendsCubit>(() => InviteFriendsCubit());

  locator.registerLazySingleton<KycCubit>(
    () => KycCubit(verificationService: locator()),
  );

  locator.registerLazySingleton<BadgeBloc>(() => BadgeBloc());

  locator.registerLazySingleton<BattlesBloc>(() => BattlesBloc(locator()));
  locator.registerFactory<BattleHistoryBloc>(
    () => BattleHistoryBloc(locator()),
  );

  locator.registerFactory(() => LeaderBoardCubit(locator()));

  locator.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(locator()),
  );

  locator.registerLazySingleton<PromotionsCubit>(
    () => PromotionsCubit(promotionsRepository: locator()),
  );

  locator.registerLazySingleton<CareerGoalCubit>(
    () => CareerGoalCubit(locator()),
  );
  locator.registerLazySingleton<WeeklyGoalCubit>(
    () => WeeklyGoalCubit(
      repository: locator(),
      getUserId: () => LocalStorageService.getUserSync()?.id ?? '',
    ),
  );

  locator.registerLazySingleton<RoadmapCubit>(() => RoadmapCubit(locator()));

  locator.registerLazySingleton<DashboardCubit>(
    () => DashboardCubit(
      repository: locator(),
      getUserId: () => LocalStorageService.getUserSync()?.id ?? '',
    ),
  );

  locator.registerLazySingleton<LearningPathCubit>(
    () => LearningPathCubit(locator()),
  );

  locator.registerFactoryParam<AAServices, AuthProvider?, void>((
    authProvider,
    _,
  ) {
    ICloudServices? cloudService;

    if (authProvider != null && authProvider != AuthProvider.email) {
      try {
        cloudService = ICloudServices.isPlatform();
      } catch (e) {
        dev.log('Cloud service initialization failed: $e');
        cloudService = null;
      }
    }
    return AAServices(
      chainConfig: locator(),
      secretSharingManager: SecretSharingManager(cloudService: cloudService),
      cloudService: cloudService,
    );
  });

  locator.registerLazySingleton<BiometricService>(() => BiometricService());

  locator.registerLazySingleton<CryptographyService>(
    () => CryptographyService(),
  );

  locator.registerLazySingleton<FirebaseStoreService>(
    () => FirebaseStoreService(),
  );

  locator.registerLazySingleton<VerificationService>(
    () =>
        KycServiceImpl(locator<BaseApiClients>(instanceName: 'didItApiClient')),
  );

  locator.registerLazySingleton<VerificationManager>(
    () => VerificationManager(),
  );

  locator.registerLazySingleton<BalanceNotifier>(() => BalanceNotifier());

  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  locator.registerLazySingleton<KotaniPayAdapter>(
    () => KotaniPayAdapter(apiClient: locator<BaseApiClients>()),
  );

  locator.registerLazySingleton<WebsocketService>(() => WebsocketService());
  locator.registerLazySingleton<BattleEventService>(
    () => BattleEventService(locator()),
  );
  locator.registerLazySingleton<BotBattleEventService>(
    () => BotBattleEventService(WebsocketService()),
  );

  locator.registerLazySingleton<AdmobService>(() => AdmobService());
  locator.registerLazySingleton<LevelPlayService>(() => LevelPlayService());
  locator.registerLazySingleton<IAdService>(() {
    final config = locator.isRegistered<RevenueConfigResponse>()
        ? locator.get<RevenueConfigResponse>()
        : null;
    return config?.isUnity == true
        ? locator<LevelPlayService>()
        : locator<AdmobService>();
  });

  locator.registerLazySingleton<AppVersionInfo>(() => AppVersionInfo());
}
