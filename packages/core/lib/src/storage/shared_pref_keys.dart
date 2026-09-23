const String onboardKey = 'onboard_key';
const String firstTimerKey = 'first_timer_key';
const String accessToken = 'access_token';
const String refreshToken = 'refresh_token';
const String isAuthenticatedKey = 'is_authenticated';
const String hasSeenIntroSlidesKey = 'has_seen_intro_slides';
const String hasRegisteredKey = 'has_registered';
const String userTokenKey = 'user_token';
const String userRefreshKey = 'user_refresh_token';
const String completeAccountSetupKey = 'complete_account_setup';
const String vocabularyKey = 'vocabulary_key';
const String usedGoogleAuthKey = 'used_google_auth';
const String usedAppleAuthKey = 'used_apple_auth';
const String userIdKey = 'user_id';
const String themeKey = 'selected_theme_mode';
const String userEmailKey = 'used_email_auth';
const String emailVerificationTokenKey = 'email_verification_token';
const String kycCompletedAtKey = 'kyc_completed_at';
const String kycSessionIdKey = 'kyc_session_id';
const String kycStatusKey = 'kyc_status';
const String kycStateKey = 'kyc_state';
const String soundEnabledKey = 'sound_enabled';
const String notificationKey = 'notification_key';

///[transactionCache] keys
const String boxName = 'transactionsCache';
const String timestampBoxName = 'transactionTimestamps';
const String exchangeRatesBoxName = 'exchange_rates';
const String currentUserBoxName = 'current_user';

///[Defi Service] keys
const String customerKey = 'customer_key';
const String walletIdKey = 'wallet_id';

///[entitlements] keys
const String entitlementsKey = 'entitlements';
const String iosRevCatKey = 'learnway-pro';
const String preferredLanguageKey = 'preferred_language';

///[promotions] keys
String promoPopupKey(String campaignId) => 'promo_popup_$campaignId';
String promoPopupSessionKey(String campaignId) =>
    'promo_popup_session_$campaignId';

///[weeklyGoal] keys
const String weeklyGoalTextKey = 'weekly_goal_text';
const String weeklyGoalWeekKey = 'weekly_goal_week';
const String weeklyGoalDismissedWeekKey = 'weekly_goal_dismissed_week';
