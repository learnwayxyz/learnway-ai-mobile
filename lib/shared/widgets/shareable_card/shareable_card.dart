import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/widgets/shareable_card/shareable_card_strategy.dart';

class ShareableCard extends StatelessWidget {
  final ShareableCardStrategy strategy;
  final ShareableCardSkin skin;

  const ShareableCard({
    super.key,
    required this.strategy,
    this.skin = QuizSkin.blue,
  });

  @override
  Widget build(BuildContext context) {
    if (skin is BattleSkin) {
      return _buildBattleCard(skin as BattleSkin);
    }
    return _buildQuizCard(skin as QuizSkin);
  }

  Widget _buildQuizCard(QuizSkin quizSkin) {
    return Container(
      width: 1080,
      height: 1080,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(quizSkin.backgroundAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(child: Image.asset('assets/images/learnway.png')),
          ),

          Positioned(
            top: 241,
            left: 0,
            right: 0,
            child: Center(child: _buildQuizAvatars(quizSkin)),
          ),

          Positioned(
            left: 60,
            top: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strategy.primaryStatValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: -4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strategy.primaryStatLabel,
                  style: const TextStyle(
                    color: Color(0xFFC7CBE4),
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.25,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 60,
            top: 397,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  label: 'XPS',
                  icon: Image.asset(
                    'assets/images/xp_image.png',
                    width: 50,
                    height: 50,
                  ),
                  value: '${strategy.xpValue}',
                ),
                const SizedBox(height: 24),
                _buildStatRow(
                  label: 'REWARD',
                  icon: Image.asset(
                    'assets/images/single_diamond.png',
                    width: 50,
                    height: 50,
                  ),
                  value: '${strategy.gemsValue}',
                ),
              ],
            ),
          ),

          Positioned(
            top: 540,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/lesson_card_banner.png'),
            ),
          ),

          Positioned(
            top: 580,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                strategy.bannerName,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.50,
                ),
              ),
            ),
          ),

          Positioned(
            top: 705,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                strategy.headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -4.75,
                ),
              ),
            ),
          ),

          Positioned(
            top: 833,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                strategy.subtext,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFC7CBE4),
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -2.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizAvatars(QuizSkin quizSkin) {
    if (strategy.avatars.length == 2) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatarCircle(
            strategy.avatars[0],
            size: 240,
            borderColor: Colors.white,
          ),
          const SizedBox(width: 32),
          const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 32),
          _buildAvatarCircle(
            strategy.avatars[1],
            size: 240,
            borderColor: Colors.white,
          ),
        ],
      );
    }
    return _buildAvatarCircle(
      strategy.avatars.first,
      size: 352.94,
      borderColor: Colors.white,
    );
  }

  Widget _buildStatRow({
    required String label,
    required Widget icon,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC7CBE4),
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            letterSpacing: -1.25,
          ),
        ),
        const SizedBox(width: 10),
        icon,
        const SizedBox(width: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: -2,
          ),
        ),
      ],
    );
  }

  Widget _buildBattleCard(BattleSkin battleSkin) {
    return Container(
      width: 1080,
      height: 1080,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(battleSkin.backgroundAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 72,
            left: 0,
            right: 0,
            child: Center(child: Image.asset('assets/images/learnway.png')),
          ),

          Positioned(
            top: 210,
            left: 80,
            right: 80,
            child: Text(
              strategy.headline,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: battleSkin.headlineColor,
                fontSize: 62,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),

          Positioned(
            top: 340,
            left: 80,
            right: 80,
            child: Text(
              strategy.subtext,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: battleSkin.subtitleColor,
                fontSize: 38,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),

          Positioned(
            top: 450,
            left: 0,
            right: 0,
            child: _buildBattlePlayerRow(battleSkin),
          ),
        ],
      ),
    );
  }

  Widget _buildBattlePlayerRow(BattleSkin battleSkin) {
    final avatars = strategy.avatars;
    if (avatars.length < 2) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBattlePlayerColumn(avatars[0], battleSkin),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SizedBox(
              width: 160,
              height: 160,
              child: Image.asset('assets/images/vs.png', fit: BoxFit.contain),
            ),
          ),
          _buildBattlePlayerColumn(avatars[1], battleSkin),
        ],
      ),
    );
  }

  Widget _buildBattlePlayerColumn(
    ShareableAvatar avatar,
    BattleSkin battleSkin,
  ) {
    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatarCircle(
            avatar,
            size: 240,
            borderColor: battleSkin.avatarBorderColor,
          ),
          const SizedBox(height: 24),
          Text(
            avatar.name ?? avatar.initial,
            style: TextStyle(
              color: battleSkin.nameColor,
              fontSize: 40,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          if (avatar.xpValue != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/new_xp.png',
                    width: 55,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${avatar.xpValue}',
                    style: const TextStyle(
                      color: Color(0xFF252B37),
                      fontSize: 38,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(
    ShareableAvatar avatar, {
    required double size,
    required Color borderColor,
  }) {
    Widget imageWidget;

    if (avatar.imageUrl != null && avatar.imageUrl!.isNotEmpty) {
      imageWidget = avatar.isAsset
          ? Image.asset(
              avatar.imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : Image.network(
              avatar.imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Image.asset(
                'assets/avatars/male2.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            );
    } else {
      imageWidget = Container(
        width: size,
        height: size,
        color: skin.defaultAvatarColor,
        child: Center(
          child: Text(
            avatar.initial,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: imageWidget,
      ),
    );
  }
}
