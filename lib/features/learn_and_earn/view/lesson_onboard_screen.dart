import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/view/level_screens/screen_helper.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

@RoutePage()
class LessonOnboardScreen extends StatefulWidget {
  const LessonOnboardScreen({
    super.key,
    this.title = '',
    required this.lessonId,
    required this.levelType,
  });
  final String title;
  final String lessonId;
  final LevelType levelType;

  @override
  State<LessonOnboardScreen> createState() => _LessonOnboardScreenState();
}

class _LessonOnboardScreenState extends State<LessonOnboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LearnAndEarnBloc>().add(
      FetchLessonSlides(id: widget.lessonId),
    );
  }

  void forceRefresh() {
    context.read<LearnAndEarnBloc>().add(
      FetchCourseLessons(id: checkCourseLevelType(), forceRefresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          forceRefresh();
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.title,
          onBackPressed: () {
            context.router.pop();
            forceRefresh();
          },
        ),
        backgroundColor: Color(0xffF8F9FC),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/intro_page.png'),
              VSpace(33),
              Text(
                AppLocalizations.of(context)!.readyToTakeLessons,
                style: AppTextStyles.xxlBold(context),
              ),
              VSpace(10),
              Text(
                AppLocalizations.of(context)!.lessonOnboardDescription,
                textAlign: TextAlign.center,
                style: AppTextStyles.xsRegular(context),
              ),
              VSpace(50),
              BlocConsumer<LearnAndEarnBloc, LearnAndEarnState>(
                listener: (context, state) {
                  NotificationService.showSuccess(
                    AppLocalizations.of(context)!.successfullyFetchedSlides,
                  );
                },
                builder: (context, state) {
                  if (state is FetchingLessonSlide) {
                    final isLoading = context.select<LearnAndEarnBloc, bool>(
                      (r) => r.state is FetchingLessonSlide,
                    );
                    return ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      text: AppLocalizations.of(context)!.loadingLessons,
                      leadingIcon: isLoading
                          ? CircularProgressIndicator.adaptive()
                          : null,
                      textStyle: AppTextStyles.baseBold(
                        context,
                      ).copyWith(color: Colors.white),
                      onPressed: () {},
                    );
                  }
                  if (state is FetchedLessonSlide) {
                    return ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      text: AppLocalizations.of(context)!.getStarted,
                      textStyle: AppTextStyles.baseBold(
                        context,
                      ).copyWith(color: Colors.white),
                      onPressed: () {
                        // context.router.push(
                        //   ContentReaderRoute(
                        //     id: widget.lessonId,
                        //     title: widget.title,
                        //     slidesResponse: state.slide,
                        //   ),
                        // );
                      },
                    );
                  }
                  return ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    text: 'Get Started',
                    leadingIcon: CircularProgressIndicator.adaptive(),
                    textStyle: AppTextStyles.baseBold(
                      context,
                    ).copyWith(color: Colors.white),
                    onPressed: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
