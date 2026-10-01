import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'common.dart';

/// Waits for the landing screen and opens the onboarding slides.
Future<void> openOnboarding(PatrolIntegrationTester $) async {
  await launchApp($, firstScreen: $('Join the Journey'));
  await $('Join the Journey').tap();
}

void main() {
  patrolTest('Skip on onboarding opens sign-up', ($) async {
    await openOnboarding($);

    await $('Skip').tap();

    await $('Learn. Play. Earn').waitUntilVisible();
  });

  patrolTest('Next walks through onboarding to Get Started', ($) async {
    await openOnboarding($);

    while ($('Get Started').evaluate().isEmpty) {
      await $('Next').tap();
    }
    await $('Get Started').tap();

    await $('Learn. Play. Earn').waitUntilVisible();
  });
}
