import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class QuizOnboardScreen extends StatefulWidget {
  const QuizOnboardScreen({super.key, this.title = '', required this.lessonId});
  final String title;
  final String lessonId;

  @override
  State<QuizOnboardScreen> createState() => _QuizOnboardScreenState();
}

class _QuizOnboardScreenState extends State<QuizOnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(title: widget.title, barHeight: 0),
      backgroundColor: Color(0xffF8F9FC),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/intro_page.png'),
            VSpace(33),
            Text(
              AppLocalizations.of(context)!.getReadyToTakeQuiz,
              style: AppTextStyles.xxlBold(context),
              textAlign: TextAlign.center,
            ),
            VSpace(10),
            Text(
              AppLocalizations.of(context)!.quizDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.xsRegular(context),
            ),
            VSpace(50),
            ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              text: AppLocalizations.of(context)!.getStarted,
              textStyle: AppTextStyles.baseBold(
                context,
              ).copyWith(color: Colors.white),
              onPressed: () {
                // context.router.push(
                //   QuizRoute(quizTitle: widget.title, lessonId: widget.lessonId),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
