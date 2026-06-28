import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BottomCardContainer extends StatelessWidget {
  const BottomCardContainer({super.key, required this.balance});
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(23, 19, 23, 19),
      decoration: BoxDecoration(
        color: Color(0xff000000),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image(image: AssetImage(Assets.images.tetherImage.path)),
                      HSpace(4),
                      Text(
                        '$balance usdt',
                        style: AppTextStyles.xlBold(
                          context,
                        ).copyWith(color: Colors.white, fontSize: 22.7),
                      ),
                    ],
                  ),
                  VSpace(5),
                  Text(
                    'Balance',
                    style: AppTextStyles.xsRegular(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.lwIcon,
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                  VSpace(10),
                  Text(
                    'LearnWay',
                    style: AppTextStyles.xsRegular(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
