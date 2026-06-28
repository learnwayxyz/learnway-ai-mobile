import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class OnlineOpponentModal extends StatefulWidget {
  final VoidCallback? onBattleStarted;

  const OnlineOpponentModal({super.key, this.onBattleStarted});

  @override
  State<OnlineOpponentModal> createState() => _OnlineOpponentModalState();
}

class _OnlineOpponentModalState extends State<OnlineOpponentModal> {
  static const int _entryFee = 50;
  static const int _gemBalance = 45000;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 613,
      width: 412,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Column(
            children: [
              const VSpace(22),

              Text(
                'Join a Battle',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.12,
                  letterSpacing: 0.20,
                ),
              ),
              const VSpace(13),

              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.borderColor,
              ),
            ],
          ),

          const VSpace(31),

          Column(
            children: [
              Text(
                'Your Gem Balance',
                style: TextStyle(
                  color: AppColors.gray500,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: 0.20,
                ),
              ),
              const VSpace(10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueGray50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/blue_gem.png',
                      width: 35,
                      height: 35,
                    ),
                    const HSpace(4),
                    Text(
                      '$_gemBalance',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace(10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/battles/heroicons_light-bulb.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF215AEB),
                      BlendMode.srcIn,
                    ),
                  ),
                  const HSpace(4),
                  Text(
                    'How Battle works',
                    style: TextStyle(
                      color: const Color(0xFF215AEB),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.14,
                      letterSpacing: 0.20,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const VSpace(144),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entry Fee',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                          letterSpacing: 0.20,
                        ),
                      ),
                      const VSpace(7),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: AppColors.blueGray100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD5D7DA),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/blue_gem.png',
                                width: 25,
                                height: 25,
                              ),
                              const HSpace(8),
                              Text(
                                '$_entryFee',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const VSpace(60),

                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();

                          widget.onBattleStarted?.call();
                        },
                        borderRadius: BorderRadius.circular(60),
                        child: Center(
                          child: Text(
                            'Pay to Start',
                            style: TextStyle(
                              color: const Color(0xFFFDFDFD),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.12,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const VSpace(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
