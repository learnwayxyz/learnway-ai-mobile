import 'package:core/src/config/env/env.dart';

class Endpoints {
  static String baseUrl = Env.baseUrl;
  static const String verifyEmail = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String setUpAccount = 'auth/setup-account';
  static const String loginWithOtp = 'auth/login-with-otp';
  static const String updateProfile = 'user/profile';
  static const String getUserProfile = 'auth/profile';
  static const String loginUser = 'auth/login-with-social';
  static const String registerUser = 'auth/register-with-social';
  static const String getCourses = 'course';
  static const String enrollCourse = 'user-courses/enroll';
  static const String getMyCourses = 'user-courses/my-courses';
  static const String getCourseLessons = 'course';
  static const String lessonSlides = 'lesson-slide/lesson';
  static const String getQuestions = 'question/lesson';
  static const String checkUserName = 'auth/check-username-availability';
  static const String uploadImage = 'media/upload';
  static const String deleteAccount = 'user/profile';
  static const String startLesson = 'user-lesson/start';
  static const String getLessonProgress = 'user-lesson/progress';
  static const String completeLesson = 'user-lesson/complete';
  static const String dailyLessonsRemaining = 'user-lesson/daily-remaining';
  static String lessonInfoDetails(String lessonId) => 'course/$lessonId/info';
  static String courseProject(String courseId) => 'course/$courseId/project';
  static String courseProjectDraft(String courseId) =>
      'course/$courseId/project/draft';
  static String courseProjectSubmit(String courseId) =>
      'course/$courseId/project/submit';
  static String courseProjectSubmissions(String courseId) =>
      'course/$courseId/project/submissions';
  static String courseProjectSubmission(String courseId, String submissionId) =>
      'course/$courseId/project/submissions/$submissionId';
  static const String aiTutorAsk = 'ai-tutor/ask';
  static const String claimCertificate = 'certificates/claim';
  static const String myCertificates = 'certificates/my';

  // Contest endpoints
  static const String getContestQuestions = 'contest/questions';
  static const String submitContestResults = 'user/contests/';
  static const String getContestLeaderboard = 'contest/leaderboard';
  static const String getAllContests = 'user/contests';
  static const String joinContest = 'user/contests/';
  static const String startContest = 'user/contests/';

  /// User verification endpoints
  static const String updateVerificationStatus = 'auth/verify-kyc';
  static const String getKycStatus = 'user/verification-status';
  static const String logout = 'auth/logout';
  static const String leaderboardAllTime = 'leaderboard/alltime';
  static const String leaderboardMonthly = 'leaderboard/monthly';
  static const String leaderboardWeekly = 'leaderboard/weekly';
  static const String leaderboardMyPosition = 'leaderboard/my-position';
  static const String apiConfig = 'config/api-keys';
  static const String revenueConfig = 'config/revenue';

  // Referral endpoints
  static const String generateReferralCode = 'referral/code';
  static const String processReferral = 'referral/process';
  static const String referralStats = 'referral/stats';
  static const String generateShareLink = 'referral/share-link';

  // Badge endpoints
  static const String getUserBadges = 'badges/user';
  static const String getUserBadgeShowcase = 'badges/user';
  static const String getBadgeCatalog = 'badges/user';
  static const String getBadgeDetails = 'badges';

  //Set pin endpoints
  static const String setPin = 'auth/set-wallet-pin';
  static const String updatePin = 'auth/update-wallet-pin';
  static const String getResetPinOtp = 'auth/reset-wallet-pin-otp';
  static const String resetPin = 'auth/verify-reset-wallet-pin';
  static const String verifyPin = 'auth/verify-pin';

  static const String bestOfframpOffer = '/api/offramp/best-offer/';
  static const String getPaymentChannels = '/api/onramp/payment-channels';
  static const String bestOnrampOffer = '/api/onramp/best-offer/';
  static const String getSupportedCurrencies = '/payment/currencies';
  static const String getOffRampQuote = '/payment/quote';
  //onramp
  static const String getOrderLimits = '/payment/order-limits';
  static const String createOrder = '/payment/off-ramp/initialize';
  static const String getTransactionStatus = '/payment/transactions';
  static const String confirmOrder = '/payment/off-ramp/confirm';
  static const String getOnRampOrderLimit = '/payment/on-ramp/order-limits';
  static const String initializeOnRamp = '/payment/on-ramp/initialize';
  static const String confirmOnRamperOder = 'payment/on-ramp/confirm';
  static const String intermediateAction = '/on-ramp/intermediate-action';
  static const String getOnRampQuote = '/payment/on-ramp/quote';

  //notification endpoints
  static const String postDeviceToken = 'notifications/device-token';
  static const String getNotifications = 'notifications';
  static const String getExchangeRates = '/exchange-rates';

  // Version check
  static const String appVersionCheck = 'app/version-check';

  // Promotions
  static const String getActivePromotions = 'promotions/active';
  static const String promotionEvent = 'promotions';

  //Get Language
  static const String getLanguage = 'user/languages';
  static const String updateLanguagePref = 'user/language-preference';
  //Quiz Battle
  static const String createFriendOrGroupRoom = '/quiz-battles';
  static const String fetchAllTopics = '/quiz-battles/topics';
  static const String battleHistory = '/quiz-battles/history';
  static String startBattle(String battleId) => '/quiz-battles/$battleId/start';
  static String deleteBattle(String battleId) => '/quiz-battles/$battleId';
  static String getBattleDetail(String battleId) => '/quiz-battles/$battleId';
  static String joinRoom(String roomCode) => '/quiz-battles/$roomCode/join';
  static String prefetchBattleQuestions(String battleId) =>
      '/quiz-battles/$battleId/questions';
  static const String startBotBattle = '/quiz-battles/bot/start';
  static const String battleConfig = '/quiz-battles/config';
  // Career Goal
  static const String saveCareerGoal = '/api/v1/ai-mentor/career-goal';
  static const String generateCareerRoadmap = '/ai-mentor/career-path/generate';
  static String getRecommendations(String userId) =>
      '/ai-mentor/recommendations/$userId';

  static const String discoveryRecommendations =
      '/ai-mentor/discovery/recommendations';
  static const String saveCareer = '/ai-mentor/career-goal';

  static const String aiMentorChat = '/ai-mentor/chat';

  static String aiMentorDashboard(String userId) =>
      '/ai-mentor/dashboard/$userId';

  // Learning paths
  static const String learningPaths = 'learning-path';
  static const String myRoadmap = 'learning-path/roadmap/me';
  static String learningPathById(String id) => '/learning-path/$id';
  static String coursesByPath(String pathId) =>
      '$getCourses?learningPathId=$pathId';
}
