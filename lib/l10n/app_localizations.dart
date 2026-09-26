import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// A subtitle for get started screen
  ///
  /// In en, this message translates to:
  /// **'Sign In with your Google account, Apple account or with your phone number.'**
  String get getStartedSubtitle;

  /// A title for go to registeration screen
  ///
  /// In en, this message translates to:
  /// **'Join the Journey'**
  String get joinJourney;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Social media section title
  ///
  /// In en, this message translates to:
  /// **'Our Social'**
  String get ourSocial;

  /// Badges section title
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// Theme section title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Bookmarks section title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Invite friends section title
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// Share app section title
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// Rate us section title
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// Logout section title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// About us section title
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Delete account section title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Deleting account loading text
  ///
  /// In en, this message translates to:
  /// **'Deleting Account...'**
  String get deletingAccount;

  /// Account deletion success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// Telegram platform name
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// Twitter/X platform name
  ///
  /// In en, this message translates to:
  /// **'Twitter/X'**
  String get twitterX;

  /// LinkedIn platform name
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// Telegram dialog title
  ///
  /// In en, this message translates to:
  /// **'Do you want to view our Telegram channel?'**
  String get doYouWantToViewOurTelegramChannel;

  /// Twitter dialog title
  ///
  /// In en, this message translates to:
  /// **'Do you want to view our Twitter/X profile?'**
  String get doYouWantToViewOurTwitterProfile;

  /// LinkedIn dialog title
  ///
  /// In en, this message translates to:
  /// **'Do you want to view our LinkedIn profile?'**
  String get doYouWantToViewOurLinkedinProfile;

  /// Stay in app button text
  ///
  /// In en, this message translates to:
  /// **'Stay in App'**
  String get stayInApp;

  /// Proceed button text
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// Social media dialog description text
  ///
  /// In en, this message translates to:
  /// **'At vero eos et accusamus et iusto odio dignissimos ducimus qui.'**
  String get socialDialogDescription;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Home navigation text
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Discover paths to build in-demand skills
  ///
  /// In en, this message translates to:
  /// **'Learning Paths'**
  String get learningPaths;

  /// Quiz Battle navigation text
  ///
  /// In en, this message translates to:
  /// **'Quiz Battle'**
  String get quizBattle;

  /// Play navigation text
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Discover tab label
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// My Learning tab label
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get myLearning;

  /// Header title on the Play/Learn screen
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// Title of the empty state on My Learning tab when no career goal is set
  ///
  /// In en, this message translates to:
  /// **'Set your career goal'**
  String get setGoalEmptyTitle;

  /// Subtitle of the empty state on My Learning tab when no career goal is set
  ///
  /// In en, this message translates to:
  /// **'Tell us where you\'re headed and we\'ll build a personalized learning path to get you there.'**
  String get setGoalEmptySubtitle;

  /// Primary CTA on the My Learning empty state
  ///
  /// In en, this message translates to:
  /// **'Set My Goal'**
  String get setGoalCta;

  /// Secondary action on the My Learning empty state, switches to Discover tab
  ///
  /// In en, this message translates to:
  /// **'Explore paths first'**
  String get exploreFirstCta;

  /// Number of courses in a learning path
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 course} other{{count} courses}}'**
  String coursesCount(int count);

  /// Error message when the roadmap fails to load on My Learning tab
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your learning paths.'**
  String get roadmapLoadError;

  /// Subtitle shown under the My Learning tab title
  ///
  /// In en, this message translates to:
  /// **'Keep up your consistency'**
  String get myLearningSubtitle;

  /// Label on the career goal card
  ///
  /// In en, this message translates to:
  /// **'Your Career Goal'**
  String get yourCareerGoal;

  /// Button text to change the career goal
  ///
  /// In en, this message translates to:
  /// **'Change Goal'**
  String get changeGoal;

  /// Section title for the user's in-progress learning paths
  ///
  /// In en, this message translates to:
  /// **'My Learning Paths'**
  String get myLearningPathsTitle;

  /// Link text to see the full list
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Label for the overall progress percentage stat
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overallProgress;

  /// Label for the completed courses count stat
  ///
  /// In en, this message translates to:
  /// **'Completed Courses'**
  String get completedCoursesLabel;

  /// Suffix text after 'X of Y' describing completed courses
  ///
  /// In en, this message translates to:
  /// **'courses completed'**
  String get coursesCompletedSuffix;

  /// Wallet navigation text
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Profile navigation text
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// My wallet title
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// Swap gems title
  ///
  /// In en, this message translates to:
  /// **'Swap Gems'**
  String get swapGems;

  /// Transfer funds title
  ///
  /// In en, this message translates to:
  /// **'Transfer Funds'**
  String get transferFunds;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No bookmarks message
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks Yet'**
  String get noBookmarksYet;

  /// No results found message
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// Play and win rewards title
  ///
  /// In en, this message translates to:
  /// **'Play and Win Rewards 🚀'**
  String get playAndWinRewards;

  /// Tech journey subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s bring you on the tech journey.'**
  String get letsBringYouOnTechJourney;

  /// Start lesson button
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLesson;

  /// Choose course title
  ///
  /// In en, this message translates to:
  /// **'Choose a course'**
  String get chooseACourse;

  /// Web3 journey subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s bring you on the web3 journey.'**
  String get letsBringYouOnWeb3Journey;

  /// Beginner level
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// Intermediate level
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// Advanced level
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Quiz onboarding title
  ///
  /// In en, this message translates to:
  /// **'Get ready to take a Quiz?'**
  String get getReadyToTakeQuiz;

  /// Quiz description text
  ///
  /// In en, this message translates to:
  /// **'Sed ut perspiciatis unde omnis iste natus error sit voluptatem.'**
  String get quizDescription;

  /// LearnWay token title
  ///
  /// In en, this message translates to:
  /// **'LearnWay Token (LWT)'**
  String get learnWayToken;

  /// LearnWay token description
  ///
  /// In en, this message translates to:
  /// **'Convert your Gems into LWT or buy LWT. Send LWT to your wallet or exchange anytime, 24/7.'**
  String get learnWayTokenDescription;

  /// Onboarding tagline part 1
  ///
  /// In en, this message translates to:
  /// **'Master In-Demand '**
  String get masterWeb3;

  /// Onboarding tagline part 2
  ///
  /// In en, this message translates to:
  /// **'Digital Skills'**
  String get learnAndEarnTagline;

  /// Onboarding description
  ///
  /// In en, this message translates to:
  /// **'Learn through gamified lessons with personalized AI guidance and support.'**
  String get onboardingDescription;

  /// Opening text for bookmarks
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get opening;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Wait a moment text
  ///
  /// In en, this message translates to:
  /// **'Wait a moment'**
  String get waitAMoment;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Take quiz again button text
  ///
  /// In en, this message translates to:
  /// **'Take Quiz Again'**
  String get takeQuizAgain;

  /// Question label
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Of text for pagination
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success text
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Warning text
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Info text
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Search text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort text
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Refresh text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Loading more text
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No more data text
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get noMoreData;

  /// Pull to refresh text
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Tap to retry text
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get tapToRetry;

  /// Network error text
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// Server error text
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// Unknown error text
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Try again text
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Settings text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Notifications text
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Privacy text
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Security text
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Help text
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Support text
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Feedback text
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// About text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Terms of service text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Create Account main title
  ///
  /// In en, this message translates to:
  /// **'Learn. Play. Earn'**
  String get createAccount_title;

  /// Create Account subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign In with your Google account, Apple account or with your Email Address.'**
  String get createAccount_subtitle;

  /// Walk through title
  ///
  /// In en, this message translates to:
  /// **'Earn Gems Daily'**
  String get walkThrough_title1;

  /// Description part one
  ///
  /// In en, this message translates to:
  /// **'Claim daily rewards, complete quizzes, and redeem Gems to unlock premium features or convert into USDT.'**
  String get walkThrough_description1;

  /// Walk through title
  ///
  /// In en, this message translates to:
  /// **'Earn Your Badges'**
  String get walkThrough_title2;

  /// Description part two
  ///
  /// In en, this message translates to:
  /// **'Collect unique badges for milestones and skills, showcase them proudly, and unlock extra rewards.'**
  String get walkThrough_description2;

  /// Walk through title
  ///
  /// In en, this message translates to:
  /// **'Level Up XP'**
  String get walkThrough_title3;

  /// Description part three
  ///
  /// In en, this message translates to:
  /// **'Earn XP from lessons and battles, climb weekly, monthly, all-time leaderboards, and unlock exclusive rewards.'**
  String get walkThrough_description3;

  /// OR separator
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// Terms agreement prefix text
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get byAgreeingText;

  /// Conjunction word 'and'
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andText;

  /// Enter platform screen title
  ///
  /// In en, this message translates to:
  /// **'Enter Platform'**
  String get enterPlatform;

  /// Email input instruction
  ///
  /// In en, this message translates to:
  /// **'Please input your Email account and make sure it\'s correct.'**
  String get enterEmailInstruction;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter an email'**
  String get enterEmailHint;

  /// Enter OTP code screen title
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// Activation code sent message prefix
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent an activation code to your email'**
  String get activationCodeSentTo;

  /// Resend code countdown prefix
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// Verify button text
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Loading wallet generation title
  ///
  /// In en, this message translates to:
  /// **'Stay put'**
  String get stayPut;

  /// Loading wallet generation subtitle
  ///
  /// In en, this message translates to:
  /// **'Something good underway'**
  String get somethingGoodUnderway;

  /// Email verification success message
  ///
  /// In en, this message translates to:
  /// **'Email verified! Please complete your profile.'**
  String get emailVerifiedCompleteProfile;

  /// OTP verification failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to verify OTP.'**
  String get failedVerifyOtp;

  /// Email verification failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to verify email.'**
  String get failedVerifyEmail;

  /// Verification code sent success message
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully!'**
  String get verificationCodeSent;

  /// Verification code send failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code. Please try again.'**
  String get failedSendVerificationCode;

  /// Get account button text on onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getAccount;

  /// Welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to LearnWay'**
  String get welcomeToLearnWay;

  /// Welcome screen subtitle after sign in
  ///
  /// In en, this message translates to:
  /// **'You\'ve successfully signed in.'**
  String get successfullySignedIn;

  /// Button text to proceed to account setup
  ///
  /// In en, this message translates to:
  /// **'Set up Account'**
  String get setUpAccount;

  /// Account setup screen title
  ///
  /// In en, this message translates to:
  /// **'Set up your account!'**
  String get setUpYourAccount;

  /// Placeholder while email loads
  ///
  /// In en, this message translates to:
  /// **'Loading user email...'**
  String get loadingUserEmail;

  /// Username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Username field hint
  ///
  /// In en, this message translates to:
  /// **'Enter preferred username'**
  String get enterPreferredUsername;

  /// Username taken error message
  ///
  /// In en, this message translates to:
  /// **'Username already exists'**
  String get usernameAlreadyExists;

  /// Username available success message
  ///
  /// In en, this message translates to:
  /// **'Username available'**
  String get usernameAvailable;

  /// Country label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Referral code field label
  ///
  /// In en, this message translates to:
  /// **'Referral Code (optional)'**
  String get referralCodeOptional;

  /// Referral code field hint
  ///
  /// In en, this message translates to:
  /// **'referral code'**
  String get referralCodeHint;

  /// Avatar selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select an Avatar'**
  String get selectAnAvatar;

  /// First part of avatar subtitle
  ///
  /// In en, this message translates to:
  /// **'Select your'**
  String get selectYour;

  /// Second part of avatar subtitle (highlighted)
  ///
  /// In en, this message translates to:
  /// **'mini me'**
  String get miniMe;

  /// Female avatar tab label
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Male avatar tab label
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Upload photo tab label
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Avatar selected confirmation title
  ///
  /// In en, this message translates to:
  /// **'Avatar Selected'**
  String get avatarSelected;

  /// Avatar selected confirmation subtitle
  ///
  /// In en, this message translates to:
  /// **'You can change it below if needed'**
  String get canChangeBelow;

  /// Hint to tap image to change uploaded photo
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to change photo'**
  String get tapToChangePhoto;

  /// Hint to tap to upload a photo
  ///
  /// In en, this message translates to:
  /// **'Tap to select from camera or gallery\n(Max 5MB, JPG/PNG/WebP)'**
  String get tapToSelectPhoto;

  /// Error when uploaded image is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid image file. Please select a valid JPG, PNG, or WebP image.'**
  String get invalidImageFile;

  /// Passphrase screen title
  ///
  /// In en, this message translates to:
  /// **'Secure Your Wallet'**
  String get secureYourWallet;

  /// First part of passphrase subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a strong passphrase to'**
  String get createStrongPassphraseTo;

  /// Highlighted part of passphrase subtitle
  ///
  /// In en, this message translates to:
  /// **'encrypt and protect'**
  String get encryptAndProtect;

  /// Last part of passphrase subtitle
  ///
  /// In en, this message translates to:
  /// **'your wallet'**
  String get yourWallet;

  /// Create passphrase field label
  ///
  /// In en, this message translates to:
  /// **'Create Passphrase'**
  String get createPassphrase;

  /// Passphrase field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your passphrase'**
  String get enterYourPassphrase;

  /// Confirm passphrase field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Passphrase'**
  String get confirmPassphrase;

  /// Confirm passphrase field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your passphrase'**
  String get confirmYourPassphrase;

  /// Passphrase requirements section label
  ///
  /// In en, this message translates to:
  /// **'Passphrase Requirements'**
  String get passphraseRequirements;

  /// Passphrase match validation label
  ///
  /// In en, this message translates to:
  /// **'Passphrases match'**
  String get passphrasesMatch;

  /// Passphrase success confirmation
  ///
  /// In en, this message translates to:
  /// **'Passphrase Created Successfully'**
  String get passphraseCreatedSuccessfully;

  /// Passphrase info box title
  ///
  /// In en, this message translates to:
  /// **'Why we need this'**
  String get whyWeNeedThis;

  /// Passphrase info box description
  ///
  /// In en, this message translates to:
  /// **'Your passphrase encrypts your wallet backup, ensuring only you can recover your funds. This passphrase never leaves your device.'**
  String get passphraseEncryptsWallet;

  /// Setup success message prefix (username appended after)
  ///
  /// In en, this message translates to:
  /// **'You\'re all set'**
  String get youreAllSet;

  /// Setup success subtitle
  ///
  /// In en, this message translates to:
  /// **'Your account has been created.'**
  String get accountHasBeenCreated;

  /// Loader screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Setting Up Account'**
  String get settingUpAccount;

  /// Setup step: collecting info
  ///
  /// In en, this message translates to:
  /// **'We are preparing your information'**
  String get preparingInformation;

  /// Setup step: uploading image
  ///
  /// In en, this message translates to:
  /// **'We are uploading your image'**
  String get uploadingImage;

  /// Setup step: creating account
  ///
  /// In en, this message translates to:
  /// **'We are creating your account'**
  String get creatingAccount;

  /// Setup step: generating wallet
  ///
  /// In en, this message translates to:
  /// **'We are generating your secure wallet'**
  String get generatingWallet;

  /// Setup step: generating referral code
  ///
  /// In en, this message translates to:
  /// **'We are generating your referral code'**
  String get generatingReferralCode;

  /// Setup step: setting up security
  ///
  /// In en, this message translates to:
  /// **'We are setting up security features'**
  String get settingUpSecurity;

  /// Setup step: finalizing
  ///
  /// In en, this message translates to:
  /// **'We are finalizing your setup'**
  String get finalizingSetup;

  /// Setup step: completed
  ///
  /// In en, this message translates to:
  /// **'Your account is ready!'**
  String get accountIsReady;

  /// Setup error title
  ///
  /// In en, this message translates to:
  /// **'Setup Failed'**
  String get setupFailed;

  /// Loader screen default title
  ///
  /// In en, this message translates to:
  /// **'We are setting up your Account'**
  String get settingUpYourAccount;

  /// Generic error fallback message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Loader initial status text
  ///
  /// In en, this message translates to:
  /// **'Preparing account setup...'**
  String get preparingAccountSetup;

  /// Note shown during wallet generation step
  ///
  /// In en, this message translates to:
  /// **'This process may take 30-60 seconds as we create your secure wallet with military-grade encryption.'**
  String get walletGenerationNote;

  /// Onboarding slide 1 title
  ///
  /// In en, this message translates to:
  /// **'Learn Smarter Daily'**
  String get onboarding1Title;

  /// Onboarding slide 1 body
  ///
  /// In en, this message translates to:
  /// **'Learn with AI personalized lessons tailored to your pace and goals.'**
  String get onboarding1Description;

  /// Onboarding slide 2 title
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboarding2Title;

  /// Onboarding slide 2 body
  ///
  /// In en, this message translates to:
  /// **'AI tracks your growth and celebrates every learning milestone.'**
  String get onboarding2Description;

  /// Onboarding slide 3 title
  ///
  /// In en, this message translates to:
  /// **'Learn Your Way'**
  String get onboarding3Title;

  /// Onboarding slide 3 body
  ///
  /// In en, this message translates to:
  /// **'Get AI recommended lessons based on your interests and goals.'**
  String get onboarding3Description;

  /// Onboarding slide 4 title
  ///
  /// In en, this message translates to:
  /// **'Meet Lenny'**
  String get onboarding4Title;

  /// Onboarding slide 4 body
  ///
  /// In en, this message translates to:
  /// **'Your AI mentor guides every step of your learning journey.'**
  String get onboarding4Description;

  /// Subtitle for learning path card
  ///
  /// In en, this message translates to:
  /// **'Discover paths to build in-demad skills'**
  String get discoverLearningPaths;

  /// Button text to start learning
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// Button text on Learning Paths card to start exploring paths
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get startExploring;

  /// Home screen heading above the Learning Paths card
  ///
  /// In en, this message translates to:
  /// **'Explore Learning Path 🚀'**
  String get exploreLearningPathTitle;

  /// Home screen subtitle above the Learning Paths card
  ///
  /// In en, this message translates to:
  /// **'Build in-demand skills and grow your career'**
  String get exploreLearningPathSubtitle;

  /// Subtitle for Contest card
  ///
  /// In en, this message translates to:
  /// **'Join themed contests, showcase knowledge, and earn rewards.'**
  String get contestSubtitle;

  /// Button text to start a contest
  ///
  /// In en, this message translates to:
  /// **'Start Contest'**
  String get startContest;

  /// Subtitle for Quiz Battle card
  ///
  /// In en, this message translates to:
  /// **'Compete in real-time quiz battles and earn more rewards.'**
  String get quizBattleSubtitle;

  /// Coming soon button/badge text
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Title for Micro-Skills Track card
  ///
  /// In en, this message translates to:
  /// **'Micro-Skills Track'**
  String get certifiedCourses;

  /// Subtitle for Micro-Skills Track card
  ///
  /// In en, this message translates to:
  /// **'Practical lessons focused on high-demand, income-generating skills.'**
  String get certifiedCoursesSubtitle;

  /// Section title in Learn & Earn screen
  ///
  /// In en, this message translates to:
  /// **'Choose your skill level'**
  String get chooseYourSkillLevel;

  /// Subtitle for Beginner level card
  ///
  /// In en, this message translates to:
  /// **'Begin your adventure, learn core skills, and earn rewards.'**
  String get beginnerSubtitle;

  /// Subtitle for Intermediate level card
  ///
  /// In en, this message translates to:
  /// **'Upgrade your skills, explore new frontiers, and earn more.'**
  String get intermediateSubtitle;

  /// Subtitle for Advanced level card
  ///
  /// In en, this message translates to:
  /// **'Master the game, complete elite missions, and unlock rewards.'**
  String get advancedSubtitle;

  /// Subtitle under Choose a course heading
  ///
  /// In en, this message translates to:
  /// **'Learn future-ready digital skills'**
  String get learnFutureReadySkills;

  /// All tab label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Current tab label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentTab;

  /// Completed tab label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// Streak counter label
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get dailyStreak;

  /// Singular day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// Plural days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Button to claim daily reward
  ///
  /// In en, this message translates to:
  /// **'Claim Now'**
  String get claimNow;

  /// Ad gate dialog title
  ///
  /// In en, this message translates to:
  /// **'Earn 10 Gems'**
  String get earnGemsTitle;

  /// Ad gate dialog description
  ///
  /// In en, this message translates to:
  /// **'Watch a quick ad to continue. Ads help fund LearnWay\'s mission or go premium for an ad-free experience.'**
  String get watchAdDescription;

  /// Ad gate watch button
  ///
  /// In en, this message translates to:
  /// **'Watch & Claim'**
  String get watchAndClaim;

  /// Abbreviated Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// Abbreviated Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// Abbreviated Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// Abbreviated Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// Abbreviated Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// Abbreviated Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// Abbreviated Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// Loader screen main message
  ///
  /// In en, this message translates to:
  /// **'We are preparing your lesson for you'**
  String get preparingYourLesson;

  /// Loader status: starting lesson
  ///
  /// In en, this message translates to:
  /// **'Starting Lesson'**
  String get startingLesson;

  /// Loader status: lesson started
  ///
  /// In en, this message translates to:
  /// **'Lesson started'**
  String get lessonStarted;

  /// Loader status: fetching slides
  ///
  /// In en, this message translates to:
  /// **'Fetching Lesson slides'**
  String get fetchingLessonSlides;

  /// Loader status: lesson fetched
  ///
  /// In en, this message translates to:
  /// **'Lesson Fetched'**
  String get lessonFetched;

  /// Loader status: default
  ///
  /// In en, this message translates to:
  /// **'Continue to read'**
  String get continueToRead;

  /// Quiz loader main message
  ///
  /// In en, this message translates to:
  /// **'We are preparing your Quiz for you'**
  String get preparingYourQuiz;

  /// Quiz loader subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s test your knowledge bank'**
  String get letsTestYourKnowledge;

  /// Error when no network
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Error when no lessons loaded
  ///
  /// In en, this message translates to:
  /// **'No Lessons yet'**
  String get noLessonsYet;

  /// Lessons section header
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// Lessons section subtitle
  ///
  /// In en, this message translates to:
  /// **'Take a lesson and earn some gems after the lesson quiz.'**
  String get takeALessonAndEarn;

  /// Empty state hint
  ///
  /// In en, this message translates to:
  /// **'Browse courses to get started'**
  String get browseCoursesToGetStarted;

  /// Empty lessons state title
  ///
  /// In en, this message translates to:
  /// **'No Lessons Available'**
  String get noLessonsAvailable;

  /// Empty lessons state subtitle
  ///
  /// In en, this message translates to:
  /// **'Lessons will appear here once they are added to this course'**
  String get lessonsWillAppearHere;

  /// Button to start a quiz
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// Image loading placeholder text
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get loadingImage;

  /// Fallback content image label
  ///
  /// In en, this message translates to:
  /// **'Content Image'**
  String get contentImage;

  /// Empty content state
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get noContentAvailable;

  /// Lesson onboard screen title
  ///
  /// In en, this message translates to:
  /// **'Ready to Take Lessons?'**
  String get readyToTakeLessons;

  /// Lesson onboard screen description
  ///
  /// In en, this message translates to:
  /// **'Dive in and learn with interactive lessons designed for your level.'**
  String get lessonOnboardDescription;

  /// Success notification after slides load
  ///
  /// In en, this message translates to:
  /// **'Slides loaded — press Get Started to continue.'**
  String get successfullyFetchedSlides;

  /// Button text while lessons load
  ///
  /// In en, this message translates to:
  /// **'Loading Lessons...'**
  String get loadingLessons;

  /// Enrollment dialog title
  ///
  /// In en, this message translates to:
  /// **'Enroll in Course'**
  String get enrollInCourse;

  /// Enrollment confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you ready to start this course?'**
  String get areYouReadyToStartCourse;

  /// Enrollment confirm button
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get enrollNow;

  /// Receive screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// Error message when wallet address is not available
  ///
  /// In en, this message translates to:
  /// **'Wallet address not available'**
  String get walletAddressNotAvailable;

  /// Instruction shown when wallet setup is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please complete your wallet setup'**
  String get pleaseCompleteWalletSetup;

  /// Receive screen QR code heading
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Receive screen QR code subtext
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code below to process the transaction'**
  String get scanQrCodeToProcess;

  /// Warning label inside QR card
  ///
  /// In en, this message translates to:
  /// **'Send only USDT on the Celo network'**
  String get sendOnlyUsdtOnLisk;

  /// Snackbar message after copying wallet address
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Button to share wallet address
  ///
  /// In en, this message translates to:
  /// **'Share Address'**
  String get shareAddress;

  /// Error message when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Error state placeholder username
  ///
  /// In en, this message translates to:
  /// **'Error loading user'**
  String get errorLoadingUser;

  /// Error state placeholder email
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// KYC verification tile title
  ///
  /// In en, this message translates to:
  /// **'KYC Verification'**
  String get kycVerification;

  /// Badges and achievements tile title
  ///
  /// In en, this message translates to:
  /// **'Badges & Achievements'**
  String get badgesAndAchievement;

  /// Preferences tile title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Refer and earn tile title
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// Support and legal tile title
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportAndLegal;

  /// Logout tile text while logging out
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOutEllipsis;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Are you logging out?'**
  String get areYouLoggingOut;

  /// Logout confirmation dialog description
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of your account.'**
  String get logoutDescription;

  /// Rate app dialog title
  ///
  /// In en, this message translates to:
  /// **'Rate LearnWay'**
  String get rateLearnWay;

  /// Rate app dialog description
  ///
  /// In en, this message translates to:
  /// **'Enjoying LearnWay? Rate us on {storeName}:\n{storeUrl}'**
  String rateAppDescription(String storeName, String storeUrl);

  /// Copy link button in rate app dialog
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// Snackbar after copying store URL
  ///
  /// In en, this message translates to:
  /// **'Store URL copied!'**
  String get storeUrlCopied;

  /// Loading text while checking KYC status
  ///
  /// In en, this message translates to:
  /// **'Checking KYC status...'**
  String get checkingKycStatus;

  /// Withdraw screen title
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// Withdraw funds heading
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdrawFunds;

  /// Select payment method label
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// Select network provider label
  ///
  /// In en, this message translates to:
  /// **'Select Network Provider'**
  String get selectNetworkProvider;

  /// Select bank label
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// Error when payment channels fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load payment channels'**
  String get failedToLoadPaymentChannels;

  /// Select payment channel label
  ///
  /// In en, this message translates to:
  /// **'Select Payment Channel'**
  String get selectPaymentChannel;

  /// Mobile money number field label
  ///
  /// In en, this message translates to:
  /// **'MoMo Number'**
  String get momoNumber;

  /// Airtime number field label
  ///
  /// In en, this message translates to:
  /// **'Airtime Number'**
  String get airtimeNumber;

  /// Bank account number field label
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// Airtime payment channel
  ///
  /// In en, this message translates to:
  /// **'Airtime'**
  String get airtime;

  /// Bank transfer payment channel
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// Mobile money payment channel
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoney;

  /// Validation message for bank account number
  ///
  /// In en, this message translates to:
  /// **'Please enter your bank account number'**
  String get pleaseEnterBankAccountNumber;

  /// Validation message for mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get pleaseEnterMobileNumber;

  /// Validation message for mobile money number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile money number'**
  String get pleaseEnterValidMobileMoneyNumber;

  /// Validation message for airtime number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid airtime number'**
  String get pleaseEnterValidAirtimeNumber;

  /// Validation message for bank account number format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid bank account number'**
  String get pleaseEnterValidBankAccountNumber;

  /// Validation message for full name
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// Validation message for full name minimum length
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 3 characters'**
  String get fullNameMinLength;

  /// Amount screen heading
  ///
  /// In en, this message translates to:
  /// **'Enter amount to withdraw to'**
  String get enterAmountToWithdrawTo;

  /// Amount to withdraw label with currency
  ///
  /// In en, this message translates to:
  /// **'Amount to withdraw ({currency})'**
  String amountToWithdrawCurrency(String currency);

  /// Amount in local currency label
  ///
  /// In en, this message translates to:
  /// **'Amount in {currency}'**
  String amountInCurrency(String currency);

  /// Amount to withdraw in USDT label
  ///
  /// In en, this message translates to:
  /// **'Amount to withdraw (USDT)'**
  String get amountToWithdrawUsdt;

  /// Amount in USD label
  ///
  /// In en, this message translates to:
  /// **'Amount in USD'**
  String get amountInUsd;

  /// Confirm withdrawal button
  ///
  /// In en, this message translates to:
  /// **'Confirm Withdrawal'**
  String get confirmWithdrawal;

  /// Error when exchange rate fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load exchange rate'**
  String get failedToLoadExchangeRate;

  /// Exchange rate label
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// Insufficient balance error message
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance. You have {balance} USDT but need {amountNeeded} USDT'**
  String insufficientBalance(String balance, String amountNeeded);

  /// Validation message for empty amount
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAnAmount;

  /// Minimum amount validation message
  ///
  /// In en, this message translates to:
  /// **'Minimum amount is {min}'**
  String minimumAmount(String min);

  /// Maximum amount validation message
  ///
  /// In en, this message translates to:
  /// **'Maximum amount is {max}'**
  String maximumAmount(String max);

  /// Transfer confirmation screen title
  ///
  /// In en, this message translates to:
  /// **'Transfer Confirmation'**
  String get transferConfirmation;

  /// Subtitle on confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Please check the details before proceeding'**
  String get checkBeforeProceeding;

  /// Payment details section title
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// Recipient number label
  ///
  /// In en, this message translates to:
  /// **'Recipient Number'**
  String get recipientNumber;

  /// Payment channel label
  ///
  /// In en, this message translates to:
  /// **'Payment Channel'**
  String get paymentChannel;

  /// Carrier label
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get carrier;

  /// Amount in USDT label
  ///
  /// In en, this message translates to:
  /// **'Amount (USDT)'**
  String get amountUsdt;

  /// Amount to receive label
  ///
  /// In en, this message translates to:
  /// **'Amount to Receive'**
  String get amountToReceive;

  /// Error when sending verification code fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code'**
  String get failedToSendVerificationCode;

  /// Transaction failed title
  ///
  /// In en, this message translates to:
  /// **'Transaction Failed'**
  String get transactionFailed;

  /// Withdrawal successful screen title
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Successful'**
  String get withdrawalSuccessfulTitle;

  /// Withdrawal successful message
  ///
  /// In en, this message translates to:
  /// **'You have successfully withdrawn {amount} {currency}'**
  String withdrawalSuccessful(String amount, String currency);

  /// Transfer confirmed status
  ///
  /// In en, this message translates to:
  /// **'Transfer Confirmed'**
  String get transferConfirmed;

  /// Onchain transfer complete status
  ///
  /// In en, this message translates to:
  /// **'Onchain transfer complete'**
  String get onchainTransferComplete;

  /// Processing transfer status
  ///
  /// In en, this message translates to:
  /// **'Processing Transfer'**
  String get processingTransfer;

  /// Sending funds status
  ///
  /// In en, this message translates to:
  /// **'Sending funds to withdrawal service'**
  String get sendingFundsToWithdrawal;

  /// Withdrawal order created status
  ///
  /// In en, this message translates to:
  /// **'Withdrawal order created'**
  String get withdrawalOrderCreated;

  /// Withdrawal processing notice
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal will be processed shortly'**
  String get withdrawalWillBeProcessed;

  /// Error when creating withdrawal order fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create withdrawal order'**
  String get failedToCreateWithdrawalOrder;

  /// Loading text when creating withdrawal order
  ///
  /// In en, this message translates to:
  /// **'Creating withdrawal order...'**
  String get creatingWithdrawalOrder;

  /// Warning not to close app during processing
  ///
  /// In en, this message translates to:
  /// **'Please wait and do not close the app'**
  String get pleaseWaitDoNotClose;

  /// Success message after email verification
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully'**
  String get emailVerifiedSuccessfully;

  /// Verify transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Verify Transaction'**
  String get verifyTransaction;

  /// Verification code sent to email message
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to your email'**
  String get verificationCodeSentToEmail;

  /// Suffix for verification code sent message
  ///
  /// In en, this message translates to:
  /// **'to confirm this transaction'**
  String get toConfirmThisTransaction;

  /// Verify and continue button
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// Loading text while verifying OTP code
  ///
  /// In en, this message translates to:
  /// **'Verifying code...'**
  String get verifyingCode;

  /// Send button/tab label
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Swap button/tab label
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// Redeem button label
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// Gems label
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

  /// USDT currency label
  ///
  /// In en, this message translates to:
  /// **'USDT'**
  String get usdt;

  /// View all transactions link
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Go home button
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// Transactions section title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Transaction history screen title
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// Empty state for transaction history
  ///
  /// In en, this message translates to:
  /// **'No transaction history'**
  String get noTransactionHistory;

  /// Swap gems subtitle
  ///
  /// In en, this message translates to:
  /// **'Swap your gems for USDT instantly'**
  String get swapGemsForUsdtInstantly;

  /// Send screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Easily transfer tokens to any address'**
  String get easilyTransferTokens;

  /// Recipient address field label
  ///
  /// In en, this message translates to:
  /// **'Recipient Address'**
  String get recipientAddress;

  /// Recipient address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter address or scan QR'**
  String get enterAddressOrScan;

  /// USDT amount field hint
  ///
  /// In en, this message translates to:
  /// **'USDT amount'**
  String get usdtAmount;

  /// Token amount label
  ///
  /// In en, this message translates to:
  /// **'Token Amount'**
  String get tokenAmount;

  /// Network label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Transaction fee label
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// Payment address label
  ///
  /// In en, this message translates to:
  /// **'Payment Address'**
  String get paymentAddress;

  /// Send confirmation screen title
  ///
  /// In en, this message translates to:
  /// **'Send Confirmation'**
  String get sendConfirmation;

  /// Verify and send button
  ///
  /// In en, this message translates to:
  /// **'Verify & Send'**
  String get verifyAndSend;

  /// Loading text while sending OTP
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get sendingOtp;

  /// Processing transaction message
  ///
  /// In en, this message translates to:
  /// **'Please wait while we process your transaction'**
  String get pleaseWaitWhileWeProcess;

  /// Processing transaction title
  ///
  /// In en, this message translates to:
  /// **'Processing Transaction'**
  String get processingTransaction;

  /// View onchain button
  ///
  /// In en, this message translates to:
  /// **'View Onchain'**
  String get viewOnchain;

  /// Error when transaction link cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open transaction: {error}'**
  String couldNotOpenTransaction(String error);

  /// Payment status label
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// Failed status
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Sending status
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get sending;

  /// Unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Validation message for empty address
  ///
  /// In en, this message translates to:
  /// **'Please enter an address'**
  String get pleaseEnterAnAddress;

  /// Validation message for invalid Ethereum address
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Ethereum address'**
  String get pleaseEnterValidEthereumAddress;

  /// Validation message for invalid number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Validation message for zero amount
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountMustBeGreaterThanZero;

  /// Validation message when amount exceeds balance
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds your balance of {balance} USDT'**
  String amountExceedsBalance(String balance);

  /// Deposit transaction type label
  ///
  /// In en, this message translates to:
  /// **'Crypto Deposit'**
  String get cryptoDeposit;

  /// Withdrawal transaction type label
  ///
  /// In en, this message translates to:
  /// **'Crypto Withdraw'**
  String get cryptoWithdraw;

  /// Swap transaction type label
  ///
  /// In en, this message translates to:
  /// **'Crypto Swap'**
  String get cryptoSwap;

  /// Leaderboard screen title
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// All time leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// Monthly leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Weekly leaderboard tab
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Error when leaderboard fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load leaderboard'**
  String get failedToLoadLeaderboard;

  /// Current user rank label in leaderboard
  ///
  /// In en, this message translates to:
  /// **'Your Current Rank'**
  String get yourCurrentRank;

  /// Empty state for leaderboard podium
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data available yet.'**
  String get noLeaderboardData;

  /// Invite screen title
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// Error state title on invite screen
  ///
  /// In en, this message translates to:
  /// **'Error Loading Invite Data'**
  String get errorLoadingInviteData;

  /// Empty state title on invite screen
  ///
  /// In en, this message translates to:
  /// **'No Invite Data Available'**
  String get noInviteDataAvailable;

  /// Empty state subtitle on invite screen
  ///
  /// In en, this message translates to:
  /// **'Unable to load your referral information.'**
  String get unableToLoadReferralInfo;

  /// Invite a friend heading
  ///
  /// In en, this message translates to:
  /// **'Invite a Friend'**
  String get inviteAFriend;

  /// Invite description with referral stats
  ///
  /// In en, this message translates to:
  /// **'You\'ve referred {totalReferrals} friends. Earn {gemsForReferrer} gems per referral, and your friend gets {gemsForReferee} gems too!'**
  String inviteDescription(int totalReferrals, int gemsForReferrer, int gemsForReferee);

  /// Gems label on invite screen reward display
  ///
  /// In en, this message translates to:
  /// **'gems'**
  String get gemsLabel;

  /// Share referral code button
  ///
  /// In en, this message translates to:
  /// **'Share Referral Code'**
  String get shareReferralCode;

  /// Button to open apply referral code dialog
  ///
  /// In en, this message translates to:
  /// **'Enter Referral code'**
  String get haveAReferralCode;

  /// Disabled button state after code applied
  ///
  /// In en, this message translates to:
  /// **'Referral code applied ✓'**
  String get referralCodeApplied;

  /// Dialog title for applying a referral code
  ///
  /// In en, this message translates to:
  /// **'Enter Referral Code'**
  String get enterReferralCode;

  /// Hint text in referral code input field
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get referralCodeHintLabel;

  /// Apply referral code button in dialog
  ///
  /// In en, this message translates to:
  /// **'Apply Code'**
  String get applyCode;

  /// Error when badges fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load badges'**
  String get failedToLoadBadges;

  /// Empty state for badges screen
  ///
  /// In en, this message translates to:
  /// **'No badges available'**
  String get noBadgesAvailable;

  /// Badges earned section heading
  ///
  /// In en, this message translates to:
  /// **'Badges You\'ve Earned'**
  String get badgesYouveEarned;

  /// Achievements collected subtitle
  ///
  /// In en, this message translates to:
  /// **'achievements collected'**
  String get achievementsCollected;

  /// All badges tab label
  ///
  /// In en, this message translates to:
  /// **'All Badges'**
  String get allBadges;

  /// Earned badges tab label
  ///
  /// In en, this message translates to:
  /// **'Earned Badges'**
  String get earnedBadges;

  /// Empty state title for earned badges
  ///
  /// In en, this message translates to:
  /// **'No Badges Earned Yet'**
  String get noBadgesEarnedYet;

  /// Empty state subtitle for earned badges
  ///
  /// In en, this message translates to:
  /// **'Complete challenges and lessons to earn your first badge!'**
  String get completeChallengesForBadge;

  /// Earned badges list section title
  ///
  /// In en, this message translates to:
  /// **'Your Earned Badges'**
  String get yourEarnedBadges;

  /// KYC done screen title
  ///
  /// In en, this message translates to:
  /// **'KYC Done'**
  String get kycDone;

  /// KYC done success heading
  ///
  /// In en, this message translates to:
  /// **'You\'ve Completed Your KYC!'**
  String get youveDoneYourKyc;

  /// KYC done success subtitle
  ///
  /// In en, this message translates to:
  /// **'Your identity has been verified successfully.'**
  String get identityVerifiedSuccessfully;

  /// Back to home button
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Snackbar while checking KYC status
  ///
  /// In en, this message translates to:
  /// **'Checking verification status...'**
  String get checkingVerificationStatus;

  /// KYC verification approved message
  ///
  /// In en, this message translates to:
  /// **'Verification approved!'**
  String get verificationApproved;

  /// KYC verification declined message
  ///
  /// In en, this message translates to:
  /// **'Verification declined.'**
  String get verificationDeclined;

  /// Error when checking KYC status fails
  ///
  /// In en, this message translates to:
  /// **'Failed to check status: {error}'**
  String failedToCheckStatus(String error);

  /// KYC in review screen title
  ///
  /// In en, this message translates to:
  /// **'KYC Status'**
  String get kycStatus;

  /// KYC under review heading
  ///
  /// In en, this message translates to:
  /// **'KYC Under Review'**
  String get kycUnderReview;

  /// KYC under review description
  ///
  /// In en, this message translates to:
  /// **'Your identity is being reviewed. This may take a few hours.'**
  String get kycProcessingDescription;

  /// Check KYC status button
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// Error when KYC session creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to start KYC'**
  String get failedToStartKyc;

  /// Error during KYC verification
  ///
  /// In en, this message translates to:
  /// **'Verification error: {error}'**
  String verificationError(String error);

  /// KYC not done screen title
  ///
  /// In en, this message translates to:
  /// **'KYC Not Done'**
  String get kycNotDone;

  /// KYC not done heading
  ///
  /// In en, this message translates to:
  /// **'No KYC Done Yet'**
  String get noKycDone;

  /// KYC not done description
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to remove restrictions and unlock all features.'**
  String get verifyIdentityToRemoveRestrictions;

  /// Start KYC button
  ///
  /// In en, this message translates to:
  /// **'Start KYC'**
  String get startKyc;

  /// Preferences screen title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preference;

  /// Sound toggle label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Profile update success snackbar
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Profile update failure snackbar
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// Generic error with message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Placeholder when username is not set
  ///
  /// In en, this message translates to:
  /// **'Add username'**
  String get addUsername;

  /// Placeholder when email is not set
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get addEmail;

  /// Placeholder when country is not set
  ///
  /// In en, this message translates to:
  /// **'Add country'**
  String get addCountry;

  /// Loading text while updating profile
  ///
  /// In en, this message translates to:
  /// **'Updating profile...'**
  String get updatingProfile;

  /// Generic no data available message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Loading state text on delete account tile
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccountEllipsis;

  /// Delete account confirmation title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get areYouDeletingAccount;

  /// Delete account confirmation description
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone.'**
  String get deleteAccountDescription;

  /// Loading text during logout
  ///
  /// In en, this message translates to:
  /// **'Processing logout...'**
  String get processingLogout;

  /// Deleting status text in dialog button
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// Country picker helper text
  ///
  /// In en, this message translates to:
  /// **'Select your country of residence'**
  String get selectCountryDescription;

  /// Instruction for delete confirmation input
  ///
  /// In en, this message translates to:
  /// **'Type \'delete\' below to confirm account deletion'**
  String get deleteConfirmInstruction;

  /// Hint text for delete confirmation input
  ///
  /// In en, this message translates to:
  /// **'Type \'delete\' to confirm'**
  String get typeDeleteToConfirm;

  /// Validation error when field is empty
  ///
  /// In en, this message translates to:
  /// **'Please type \'delete\' to confirm'**
  String get pleaseTypeDeleteToConfirm;

  /// Validation error when text does not match
  ///
  /// In en, this message translates to:
  /// **'Please spell \'delete\' exactly'**
  String get pleaseSpellDeleteExactly;

  /// Processing button loading state
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingEllipsis;

  /// Loading text during account deletion
  ///
  /// In en, this message translates to:
  /// **'Deleting your account...'**
  String get deletingYourAccountEllipsis;

  /// Email field hint in email edit sheet
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// Error banner when username is unavailable
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get usernameTakenError;

  /// Helper text below username field
  ///
  /// In en, this message translates to:
  /// **'Your username will be visible on the leaderboard'**
  String get usernameVisibleOnLeaderboard;

  /// Error when username check fails
  ///
  /// In en, this message translates to:
  /// **'Error checking username'**
  String get errorCheckingUsername;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumberHint;

  /// Phone number field helper text
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number with country code'**
  String get phoneNumberDescription;

  /// Terms and conditions menu item
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// Onchain withdrawal option title
  ///
  /// In en, this message translates to:
  /// **'Onchain Withdrawal'**
  String get onchainWithdrawal;

  /// Onchain withdrawal option subtitle
  ///
  /// In en, this message translates to:
  /// **'Transfer via crypto address'**
  String get transferViaCryptoAddress;

  /// Local payment methods option subtitle
  ///
  /// In en, this message translates to:
  /// **'Using local payment methods'**
  String get usingLocalPaymentMethods;

  /// Total balance label on wallet card
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Crypto deposit option title
  ///
  /// In en, this message translates to:
  /// **'Deposit via Crypto'**
  String get depositViaCrypto;

  /// Crypto deposit option subtitle
  ///
  /// In en, this message translates to:
  /// **'Fund your account with crypto'**
  String get fundYourAccountWithCrypto;

  /// Quiz result screen title
  ///
  /// In en, this message translates to:
  /// **'Quiz Result'**
  String get quizResult;

  /// Seconds abbreviation
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get sec;

  /// Retake quiz result heading
  ///
  /// In en, this message translates to:
  /// **'Practice Makes Perfect!'**
  String get practiceMakesPerfect;

  /// First time quiz result heading with username
  ///
  /// In en, this message translates to:
  /// **'Good effort, {name}!'**
  String goodEffort(String name);

  /// Retake quiz result subheading
  ///
  /// In en, this message translates to:
  /// **'You\'ve already completed this lesson.'**
  String get alreadyCompletedLesson;

  /// First time quiz result subheading
  ///
  /// In en, this message translates to:
  /// **'Keep learning and trying your best!'**
  String get keepLearningAndTrying;

  /// Review answers button
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// Ad gate dialog description for review answers
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to review your answers'**
  String get watchAdToReviewAnswers;

  /// Watch ad button text
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// Correct answers label in quiz result
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// Wrong answers label in quiz result
  ///
  /// In en, this message translates to:
  /// **'Wrong Answer'**
  String get wrongAnswer;

  /// Loading state while preparing share card
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// Share scores button
  ///
  /// In en, this message translates to:
  /// **'Share Your Scores'**
  String get shareYourScores;

  /// Go back to lessons button
  ///
  /// In en, this message translates to:
  /// **'Go Back to Lessons'**
  String get goBackToLessons;

  /// Default username fallback
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// Fallback lesson title
  ///
  /// In en, this message translates to:
  /// **'Unknown Lesson'**
  String get unknownLesson;

  /// Text shared with lesson score card
  ///
  /// In en, this message translates to:
  /// **'I just completed a lesson on LearnWay! Check out my score! 🎉 Learning web3, AI, and finance has never been this fun or rewarding.\n\nJoin me and start earning real rewards while leveling up your skills! 🚀\n\nDownload the app now 👉 https://onelink.to/q3ypvq'**
  String get lessonShareText;

  /// Subject line when sharing lesson result
  ///
  /// In en, this message translates to:
  /// **'I just completed a lesson on LearnWay! 🎉'**
  String get lessonCompletedSubject;

  /// Error message when sharing fails
  ///
  /// In en, this message translates to:
  /// **'Failed to share: {error}'**
  String failedToShare(String error);

  /// Go back button label
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Contest section title
  ///
  /// In en, this message translates to:
  /// **'Contest'**
  String get contest;

  /// Language screen title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language screen heading
  ///
  /// In en, this message translates to:
  /// **'Choose the Language'**
  String get chooseTheLanguage;

  /// Language screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language below. This helps us serve you better.'**
  String get chooseLanguageSubtitle;

  /// Error when languages fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load languages'**
  String get failedToLoadLanguages;

  /// Success message after language update
  ///
  /// In en, this message translates to:
  /// **'Language updated successfully'**
  String get languageUpdatedSuccessfully;

  /// Error when language update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update language. Please try again.'**
  String get failedToUpdateLanguage;

  /// Loading text while saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Battle screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Battle'**
  String get battle;

  /// Question label with number
  ///
  /// In en, this message translates to:
  /// **'Question {index}'**
  String questionNumber(int index);

  /// Fallback name for opponent
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// Battle section title
  ///
  /// In en, this message translates to:
  /// **'Quiz Battles'**
  String get battles;

  /// Battle hero card subtitle
  ///
  /// In en, this message translates to:
  /// **'Compete in real-time quiz battles and earn more rewards.'**
  String get battleHeroDescription;

  /// Battle history link label
  ///
  /// In en, this message translates to:
  /// **'Battle History'**
  String get battleHistory;

  /// Play with a friend option
  ///
  /// In en, this message translates to:
  /// **'Challenge a Friend'**
  String get playWithAFriend;

  /// Challenge AI battle option
  ///
  /// In en, this message translates to:
  /// **'Challenge AI'**
  String get challengeAI;

  /// Bot battle modal title
  ///
  /// In en, this message translates to:
  /// **'Join a Battle'**
  String get joinABattle;

  /// Bot battle pay button
  ///
  /// In en, this message translates to:
  /// **'Pay to Start'**
  String get payToStart;

  /// Play with friends screen title
  ///
  /// In en, this message translates to:
  /// **'Play with friends'**
  String get playWithFriends;

  /// Play with friends heading
  ///
  /// In en, this message translates to:
  /// **'Get ready to participate'**
  String get getReadyToParticipate;

  /// Play with friends subtitle
  ///
  /// In en, this message translates to:
  /// **'Battle your friends and win real rewards!'**
  String get battleEntryDescription;

  /// Create room button
  ///
  /// In en, this message translates to:
  /// **'Create a Room'**
  String get createARoom;

  /// Join room button
  ///
  /// In en, this message translates to:
  /// **'Join a Room'**
  String get joinARoom;

  /// Divider between create and join
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Create battle modal title
  ///
  /// In en, this message translates to:
  /// **'Create a Battle'**
  String get createABattle;

  /// Gem balance label
  ///
  /// In en, this message translates to:
  /// **'Your Gem Balance'**
  String get yourGemBalance;

  /// How battle works link
  ///
  /// In en, this message translates to:
  /// **'How Battle works'**
  String get howBattleWorks;

  /// Topic selection label
  ///
  /// In en, this message translates to:
  /// **'Choose Your Topic'**
  String get chooseYourTopic;

  /// Topic dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select a topic'**
  String get selectATopic;

  /// Amount input label
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// Gems amount input hint
  ///
  /// In en, this message translates to:
  /// **'Gems Amount'**
  String get gemsAmount;

  /// Topic validation error
  ///
  /// In en, this message translates to:
  /// **'Please select a topic'**
  String get pleaseSelectATopic;

  /// Gem amount validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid gem amount'**
  String get pleaseEnterValidGemAmount;

  /// Join room modal title
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get joinRoom;

  /// Join room instruction
  ///
  /// In en, this message translates to:
  /// **'Enter Room Code to join Battle'**
  String get enterRoomCodeToJoin;

  /// Waiting room title
  ///
  /// In en, this message translates to:
  /// **'Waiting Room'**
  String get waitingRoom;

  /// Topic label with value
  ///
  /// In en, this message translates to:
  /// **'Topic: {topicTitle}'**
  String battleTopic(String topicTitle);

  /// Entry fees label
  ///
  /// In en, this message translates to:
  /// **'Entry Fees:'**
  String get entryFees;

  /// Invite code section label
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get inviteCode;

  /// Invite code instruction
  ///
  /// In en, this message translates to:
  /// **'Share this code with a friend and Invite them to join'**
  String get shareCodeWithFriend;

  /// Snackbar after copying room code
  ///
  /// In en, this message translates to:
  /// **'Room code copied!'**
  String get roomCodeCopied;

  /// Share invite text
  ///
  /// In en, this message translates to:
  /// **'Join my LearnWay battle! 🎮\n\nTopic: {topic}\nEntry fee: {gems} gems 💎\n\nUse room code: {code}\n\nDownload LearnWay 👉 https://onelink.to/q3ypvq'**
  String battleShareInviteText(String code, String topic, String gems);

  /// Cancel room dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Room?'**
  String get cancelRoom;

  /// Cancel room dialog description
  ///
  /// In en, this message translates to:
  /// **'If you leave this screen, the room will no longer exist'**
  String get cancelRoomDescription;

  /// Leave room confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this room?'**
  String get leaveRoomConfirmation;

  /// Room full status message
  ///
  /// In en, this message translates to:
  /// **'Room is full — ready to start!'**
  String get roomFullReadyToStart;

  /// Waiting for players button state
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waitingForPlayers;

  /// Creator role label
  ///
  /// In en, this message translates to:
  /// **'CREATOR'**
  String get creatorRole;

  /// Player role label
  ///
  /// In en, this message translates to:
  /// **'PLAYER'**
  String get playerRole;

  /// Waiting message for joiner
  ///
  /// In en, this message translates to:
  /// **'Creator will start and the Quiz will begin.'**
  String get creatorWillStart;

  /// Battle ready screen heading
  ///
  /// In en, this message translates to:
  /// **'Get ready to battle'**
  String get getReadyToBattle;

  /// Good luck message before battle
  ///
  /// In en, this message translates to:
  /// **'Good Luck!'**
  String get goodLuck;

  /// Start battle button
  ///
  /// In en, this message translates to:
  /// **'Start Battle'**
  String get startBattle;

  /// Waiting for creator message
  ///
  /// In en, this message translates to:
  /// **'Waiting for creator to start…'**
  String get waitingForCreatorToStart;

  /// Win screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Play With Friends'**
  String get playWithFriendsTitle;

  /// Win screen title
  ///
  /// In en, this message translates to:
  /// **'You won the Battle'**
  String get congratulations;

  /// Draw message with name
  ///
  /// In en, this message translates to:
  /// **'It\'s a Draw, {name}.'**
  String itsADraw(String name);

  /// Win subtitle showing gems earned
  ///
  /// In en, this message translates to:
  /// **'Good work, you won {gems} Gems'**
  String youWonThisBattle(int gems);

  /// Draw/lose subtitle
  ///
  /// In en, this message translates to:
  /// **'You fought hard.'**
  String get youFoughtHard;

  /// Sharing in progress text
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparingShare;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Battle results app bar title
  ///
  /// In en, this message translates to:
  /// **'Battle Results'**
  String get battleResults;

  /// Defeat label
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get defeat;

  /// Defeat subtitle
  ///
  /// In en, this message translates to:
  /// **'Better Luck next time.'**
  String get betterLuckNextTime;

  /// Leave game dialog default title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the games?'**
  String get leaveGameConfirmation;

  /// Leave button label
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveButton;

  /// How battle works dialog title
  ///
  /// In en, this message translates to:
  /// **'How Battle Works'**
  String get howBattleWorksTitle;

  /// How battle works step 1
  ///
  /// In en, this message translates to:
  /// **'Select a topic and enter the number of Gems you want to stake.'**
  String get howBattleWorksStep1;

  /// How battle works step 2
  ///
  /// In en, this message translates to:
  /// **'Create a quiz room and share the invitation code.'**
  String get howBattleWorksStep2;

  /// How battle works step 3
  ///
  /// In en, this message translates to:
  /// **'Another learner joins using the code and matches your stake.'**
  String get howBattleWorksStep3;

  /// How battle works step 4
  ///
  /// In en, this message translates to:
  /// **'Both players take the quiz in real time.'**
  String get howBattleWorksStep4;

  /// How battle works step 5
  ///
  /// In en, this message translates to:
  /// **'Earn extra points for speed.'**
  String get howBattleWorksStep5;

  /// How battle works step 6
  ///
  /// In en, this message translates to:
  /// **'The player with the highest XP wins the staked Gems.'**
  String get howBattleWorksStep6;

  /// How battle works step 7
  ///
  /// In en, this message translates to:
  /// **'A small commission is deducted by the platform.'**
  String get howBattleWorksStep7;

  /// How bot battle works step 1
  ///
  /// In en, this message translates to:
  /// **'Select a topic. The number of Gems to stake is fixed.'**
  String get howBotBattleWorksStep1;

  /// How bot battle works step 2
  ///
  /// In en, this message translates to:
  /// **'Click Pay to Start to begin the battle.'**
  String get howBotBattleWorksStep2;

  /// Recent section label in battle history
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// Battle history subtitle
  ///
  /// In en, this message translates to:
  /// **'Your completed battles'**
  String get yourCompletedBattles;

  /// Empty state for battle history
  ///
  /// In en, this message translates to:
  /// **'No battle history yet'**
  String get noBattleHistoryYet;

  /// Won outcome label
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get won;

  /// Draw outcome label
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// Group battle type label
  ///
  /// In en, this message translates to:
  /// **'GROUP BATTLE'**
  String get groupBattle;

  /// Number of players in group battle
  ///
  /// In en, this message translates to:
  /// **'{count} Players'**
  String nPlayers(int count);

  /// Yesterday date label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Battle details screen title
  ///
  /// In en, this message translates to:
  /// **'Battle Details'**
  String get battleDetails;

  /// Entry fee label in battle details
  ///
  /// In en, this message translates to:
  /// **'Entry Fee:'**
  String get entryFee;

  /// Battle status section label
  ///
  /// In en, this message translates to:
  /// **'BATTLE STATUS'**
  String get battleStatus;

  /// Completed date section label
  ///
  /// In en, this message translates to:
  /// **'COMPLETED DATE'**
  String get completedDate;

  /// Label for current user in participant list
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meLabel;

  /// Redeem feature unavailable text
  ///
  /// In en, this message translates to:
  /// **'Redeem Gems for USDT'**
  String get redeemUnavailableTitle;

  /// Redeem sub text
  ///
  /// In en, this message translates to:
  /// **'This feature is unavailable'**
  String get redeemUnavailableSubText;

  /// Confirmation button text on unavailable feature modal
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get iUnderstand;

  /// Withdraw feature unavailable text
  ///
  /// In en, this message translates to:
  /// **'Withdraw to local accounts'**
  String get withdrawUnavailableTitle;

  /// Withdraw sub text
  ///
  /// In en, this message translates to:
  /// **'This feature is unavailable'**
  String get withdrawUnavailableSubText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
