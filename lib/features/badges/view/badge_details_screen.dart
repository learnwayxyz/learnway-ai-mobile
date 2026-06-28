import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/badges/models/badge_catalog_model.dart';
import 'package:learnwayv2/features/badges/repository/badge_repository.dart';
import 'package:learnwayv2/features/badges/widgets/badge_details_shimmer.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class BadgeDetailsScreen extends StatefulWidget {
  final String badgeType;

  const BadgeDetailsScreen({super.key, required this.badgeType});

  @override
  State<BadgeDetailsScreen> createState() => _BadgeDetailsScreenState();
}

class _BadgeDetailsScreenState extends State<BadgeDetailsScreen> {
  final BadgeRepository _repository = BadgeRepository();
  BadgeDetailsModel? _badgeDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBadgeDetails();
  }

  Future<void> _loadBadgeDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final details = await _repository.getBadgeDetails(widget.badgeType);

      setState(() {
        _badgeDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _error != null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Badge Details',
                  style: AppTextStyles.mdBold(context),
                ),
              ),
            ),
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const BadgeDetailsShimmer();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const VSpace(16),
            Text(
              'Failed to load badge details',
              style: AppTextStyles.mdBold(context),
            ),
            const VSpace(8),
            Text(
              _error ?? 'Unknown error',
              style: AppTextStyles.sm(context),
              textAlign: TextAlign.center,
            ),
            const VSpace(20),
            ElevatedButton(
              onPressed: _loadBadgeDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_badgeDetails == null) {
      return const Center(child: Text('No badge details available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const VSpace(20),
          _buildBadgeHeader(),
          const VSpace(40),
          _buildContentSections(),
          const VSpace(40),
        ],
      ),
    );
  }

  Widget _buildBadgeHeader() {
    final badge = _badgeDetails!;
    final imageUrl = badge.imageUrl ?? '';

    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          // Background SVG spanning entire header
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/badges_details_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Badge icon centered
          Center(
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF010533).withValues(alpha: 0.08),
                    blurRadius: 42.504,
                    offset: const Offset(0, 34.003),
                  ),
                ],
              ),
              child: Center(
                child: _buildBadgeImage(imageUrl),
              ),
            ),
          ),
          // Badge title and description positioned below the badge
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    badge.name,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 28 / 24,
                      color: Color(0xFF181D27),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const VSpace(8),
                  Text(
                    badge.description,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 16 / 16,
                      color: Color(0xFF414651),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        width: 168,
        height: 168,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.emoji_events,
          size: 84,
          color: AppColors.gray400,
        ),
      );
    }

    if (imageUrl.startsWith('http')) {
      if (imageUrl.endsWith('.svg')) {
        return SvgPicture.network(
          imageUrl,
          width: 168,
          height: 168,
          placeholderBuilder: (context) => Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: 84,
              color: AppColors.gray400,
            ),
          ),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: 168,
          height: 168,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: 84,
              color: AppColors.gray400,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: 84,
              color: AppColors.gray400,
            ),
          ),
        );
      }
    }

    // Handle local assets (fallback)
    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.asset(
        imageUrl,
        width: 168,
        height: 168,
      );
    } else {
      return Image.asset(
        imageUrl,
        width: 168,
        height: 168,
        fit: BoxFit.contain,
      );
    }
  }

  Widget _buildContentSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildAdinkraSymbolSection(),
          const VSpace(20),
          _buildRequirementsSection(),
          const VSpace(16),
          if (_badgeDetails!.isTiered) _buildTiersSection(),
          if (_badgeDetails!.isTiered) const VSpace(16),
          if (!_badgeDetails!.isTiered && _badgeDetails!.gemReward != null)
            _buildGemRewardSection(),
        ],
      ),
    );
  }

  Widget _buildAdinkraSymbolSection() {
    final badge = _badgeDetails!;
    final title = badge.title ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adinkra Symbol',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 16 / 16,
              color: Color(0xFF181D27),
            ),
          ),
          const VSpace(20),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
          const VSpace(20),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Color(0xFF181D27),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection() {
    final badge = _badgeDetails!;
    final howToEarn = badge.howToEarn ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Earn',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 16 / 16,
              color: Color(0xFF181D27),
            ),
          ),
          const VSpace(20),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
          const VSpace(20),
          Text(
            howToEarn,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Color(0xFF181D27),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiersSection() {
    final badge = _badgeDetails!;

    if (badge.tiers == null || badge.tiers!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiers',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 16 / 16,
              color: Color(0xFF181D27),
            ),
          ),
          const VSpace(20),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
          const VSpace(20),
          ...badge.tiers!.map(
            (tier) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildTierCard(tier),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(BadgeTier tier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tier.name,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF181D27),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF205AEB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/badges_details_diamond.png',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tier.gemReward}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF205AEB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VSpace(12),
          ...tier.requirements.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• ${req.description}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF414651),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGemRewardSection() {
    final badge = _badgeDetails!;
    final gemReward = badge.gemReward ?? 0;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Gem Reward',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 16 / 16,
                color: Color(0xFF181D27),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEAECF5),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/badges_details_diamond.png',
                  width: 25,
                  height: 25,
                ),
                const HSpace(8),
                Text(
                  '$gemReward',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF181D27),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
