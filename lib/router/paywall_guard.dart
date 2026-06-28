import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/services/ad_service.dart';

class PaywallGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isPremium = await AdService.instance.isPremiumUser();

    if (isPremium) {
      final context = router.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You already have an active subscription!'),
          ),
        );
      }
      resolver.next(false);
    } else {
      resolver.next(true);
    }
  }
}
