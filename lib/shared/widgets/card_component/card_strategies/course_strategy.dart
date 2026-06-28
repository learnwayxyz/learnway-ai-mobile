import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class CourseContentStrategy implements CardContentStrategy {
  final String title;
  final String author;
  final String description;
  final List<String> userAvatars;
  final int totalUsers;
  final VoidCallback? onButtonPressed;

  const CourseContentStrategy({
    required this.title,
    required this.author,
    required this.description,
    required this.userAvatars,
    required this.totalUsers,
    this.onButtonPressed,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    final displayedAvatars = userAvatars.take(3).toList();
    final remainingUsers = totalUsers - displayedAvatars.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 26, 17.7, 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.mdBold(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: AppTextStyles.smRegular(
                        context,
                      ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              const HSpace(12),
              _buildBlackButton(context),
            ],
          ),
          const VSpace(12),

          Text(
            description,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 20),
          _buildUserProgressRow(context, displayedAvatars, remainingUsers),
        ],
      ),
    );
  }

  Widget _buildBlackButton(BuildContext context) {
    return Container(
      height: 39,
      width: 41,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onButtonPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: SvgPicture.asset(Assets.icons.arrowRight),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProgressRow(
    BuildContext context,
    List<String> displayedAvatars,
    int remainingUsers,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: displayedAvatars.length * 24.0 + 8,
                child: Stack(
                  children:
                      displayedAvatars.asMap().entries.map((entry) {
                        final index = entry.key;
                        final avatar = entry.value;
                        return Positioned(
                          left: index * 24.0,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage:
                                avatar.startsWith('http')
                                    ? NetworkImage(avatar)
                                    : AssetImage(avatar) as ImageProvider,
                          ),
                        );
                      }).toList(),
                ),
              ),
              if (remainingUsers > 0) ...[
                HSpace(4),
                Text(
                  '+$remainingUsers',
                  style: AppTextStyles.smBold(context).copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
