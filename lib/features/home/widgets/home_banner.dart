import 'dart:async';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/promotions/cubit/promotions_cubit.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key, this.serverBanners});

  final List<PromotionModel>? serverBanners;

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  bool get _hasServerBanners =>
      widget.serverBanners != null && widget.serverBanners!.isNotEmpty;

  int get _bannerCount =>
      _hasServerBanners ? widget.serverBanners!.length : 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });

    _startAutoScroll();

    if (_hasServerBanners) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _trackBannerImpressions();
      });
    }
  }

  @override
  void didUpdateWidget(HomeBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasServerBanners &&
        oldWidget.serverBanners != widget.serverBanners &&
        widget.serverBanners!.isNotEmpty) {
      _trackBannerImpressions();
    }
  }

  void _trackBannerImpressions() {
    if (!_hasServerBanners) return;
    final cubit = locator<PromotionsCubit>();
    final country = LocalStorageService.getUserSync()?.country;
    for (final banner in widget.serverBanners!) {
      cubit.trackEvent(banner.id, 'IMPRESSION', country: country);
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _bannerCount == 0) return;
      final nextPage = (_currentPage + 1) % _bannerCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasServerBanners) return const SizedBox.shrink();

    final double screenHeight = MediaQuery.of(context).size.height;
    final double bannerHeight = screenHeight * 0.185;

    return Column(
      children: [
        SizedBox(
          height: bannerHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerCount,
            itemBuilder: (context, index) => _buildServerBanner(
              context,
              widget.serverBanners![index],
            ),
          ),
        ),
        const VSpace(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerCount,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 35 : 15,
              height: 5,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xff215AEB)
                    : Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServerBanner(BuildContext context, PromotionModel banner) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context, banner),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: banner.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: banner.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: (_, _, _) => const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Future<void> _handleBannerTap(
    BuildContext context,
    PromotionModel banner,
  ) async {
    final cubit = locator<PromotionsCubit>();
    final country = LocalStorageService.getUserSync()?.country;
    cubit.trackEvent(banner.id, 'CLICK', country: country);

    final actionType = banner.actionType;
    final actionValue = banner.actionValue;

    if (actionType == null || actionValue == null || actionValue.isEmpty) {
      return;
    }

    switch (actionType) {
      case 'external_link':
      case 'deep_link':
        final uri = Uri.tryParse(actionValue);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case 'internal_screen':
        _navigateToScreen(actionValue);
    }
  }

  void _navigateToScreen(String screenName) {
    switch (screenName.toLowerCase()) {
      case 'subscription':
      case 'manage_subscription':
        appRouter.push(const ManageSubscriptionRoute());
      case 'courses':
      case 'learn_and_earn':
        appRouter.push(const LearnAndEarnRoute());
      case 'contest':
      case 'contests':
        appRouter.push(const ContestRoute());
      case 'profile':
        appRouter.push(const ProfileRoute());
      case 'account':
        appRouter.push(const AccountRoute());
      case 'referral':
      case 'invite_friends':
        appRouter.push(const InviteFriendsRoute());
      case 'battles':
        appRouter.push(const BattlesMainEntryRoute());
      default:
        dev.log(
          'No route mapped for internal_screen value: "$screenName"',
          name: 'HomeBanner',
        );
    }
  }
}

