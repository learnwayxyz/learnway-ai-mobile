import 'dart:async';

import 'package:intl/intl.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class UpcomingDetailsScreen extends StatelessWidget {
  const UpcomingDetailsScreen({super.key, required this.contest});
  final Contest contest;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: 'Upcoming Details',
        barHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // VSpace(20),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image.asset(contest.bannerImageUrl ?? ''),
            // ),
            VSpace(20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contest.title ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  VSpace(13),
                  Divider(color: AppColors.gray200),
                  VSpace(13),
                  Text(
                    'POOL TOTAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  Text(
                    contest.totalGemPrize.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  VSpace(13),
                  Text(
                    'CONTEST TIMELINE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  // Text(
                  //   contest.endDate != null
                  //       ? '${contest.timeLeft!.day} days ${contest.timeLeft!.hour} hours ${contest.timeLeft!.minute} minutes left'
                  //       : 'N/A',
                  //   style: AppTextStyles.smSemiBold(context),
                  // ),
                  VSpace(13),
                  Text(
                    'START DATE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm a',
                    ).format(DateTime.parse(contest.startDate ?? '')),
                    style: AppTextStyles.smSemiBold(context),
                  ),
                  VSpace(13),
                  Text(
                    'END DATE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppColors.gray900,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm a',
                    ).format(DateTime.parse(contest.endDate ?? '')),
                    style: AppTextStyles.smSemiBold(context),
                  ),
                  VSpace(20),
                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    onPressed: () {
                      context.router.pop();
                    },
                    text: 'Back to Contests',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCountDown extends StatefulWidget {
  const TimeCountDown({super.key});

  @override
  State<TimeCountDown> createState() => _TimeCountDownState();
}

class _TimeCountDownState extends State<TimeCountDown> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
