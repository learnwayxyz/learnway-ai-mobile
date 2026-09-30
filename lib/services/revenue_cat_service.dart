import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService _instance = RevenueCatService._();

  static RevenueCatService get instance => _instance;

  String? _currentConfiguredUserId;
  bool get isConfigured => _currentConfiguredUserId != null;

  bool _isPremiumUser = false;
  DateTime? _lastEntitlementCheck;
  static const _entitlementCacheDuration = Duration(minutes: 5);

  final ValueNotifier<bool> premiumStatusNotifier = ValueNotifier(false);

  bool get isPremiumUser => _isPremiumUser;
  Future<void>? _initInProgress;

  void _setIsPremiumUser(bool value) {
    _isPremiumUser = value;
    premiumStatusNotifier.value = value;
  }

  Future<void> init({String? userId}) async {
    while (_initInProgress != null) {
      await _initInProgress;
    }

    final completer = Completer<void>();
    _initInProgress = completer.future;
    try {
      await _doInit(userId: userId);
    } finally {
      _initInProgress = null;
      completer.complete();
    }
  }

  Future<void> _doInit({String? userId}) async {
    final revenueConfig = _revenueConfig;
    if (revenueConfig != null && !revenueConfig.enableRevenueService) {
      log(
        'RevenueCatService: Revenue service disabled by config. Skipping init.',
      );
      return;
    }
    if (revenueConfig?.revenueCat == null) {
      log(
        'RevenueCatService: No RevenueCat config in response. Skipping init.',
      );
      return;
    }

    final resolvedUserId = userId ?? LocalStorageService.getUserSync()?.id;
    if (resolvedUserId == null || resolvedUserId.isEmpty) return;

    if (_currentConfiguredUserId == resolvedUserId) return;

    try {
      if (await Purchases.isConfigured) {
        await Purchases.logIn(resolvedUserId);
      } else {
        await Purchases.setLogLevel(LogLevel.verbose);
        final purchasesConfig = PurchasesConfiguration(_platformApiKey)
          ..appUserID = resolvedUserId;
        await Purchases.configure(purchasesConfig);
      }

      _currentConfiguredUserId = resolvedUserId;
      _lastEntitlementCheck = null;
    } catch (e, st) {
      log(
        'RevenueCatService: init failed for $resolvedUserId: $e',
        stackTrace: st,
      );
      return;
    }

    await refreshEntitlementStatus();
  }

  Future<bool> checkPremiumStatus() async {
    if (_currentConfiguredUserId == null) return false;

    final now = DateTime.now();
    if (_lastEntitlementCheck != null &&
        now.difference(_lastEntitlementCheck!) < _entitlementCacheDuration) {
      return _isPremiumUser;
    }

    await refreshEntitlementStatus();
    return _isPremiumUser;
  }

  Future<void> refreshEntitlementStatus() async {
    log('Entitlement key ${_revenueConfig?.revenueCat?.entitlementKey}');
    if (!await _ensureConfigured()) return;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _setIsPremiumUser(
        customerInfo
                .entitlements
                .all[_revenueConfig?.revenueCat?.entitlementKey]
                ?.isActive ==
            true,
      );
      _lastEntitlementCheck = DateTime.now();
      log(
        "RevenueCatService: learnwayTestStore Pro entitlement active = $_isPremiumUser",
      );
    } catch (e) {
      log("RevenueCatService: Error checking entitlement: $e");
    }
  }

  Future<Offering?> getCurrentOffering() async {
    if (!await _ensureConfigured()) return null;
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      log("RevenueCatService: Error fetching offerings: $e");
      return null;
    }
  }

  Future<Map<String, Offering>> getAllOfferings() async {
    if (!await _ensureConfigured()) return {};
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.all;
    } catch (e) {
      log("RevenueCatService: Error fetching all offerings: $e");
      return {};
    }
  }

  Future<PurchaseResult> purchase(Package package) async {
    if (!await _ensureConfigured()) {
      return const PurchaseResult.failed('Service not configured.');
    }
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      _setIsPremiumUser(
        result
                .customerInfo
                .entitlements
                .all[_revenueConfig?.revenueCat?.entitlementKey]
                ?.isActive ==
            true,
      );
      _lastEntitlementCheck = DateTime.now();
      return const PurchaseResult.success();
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log("RevenueCatService: Purchase error: $e");

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return const PurchaseResult.cancelled();
      }

      return PurchaseResult.failed(_userFriendlyMessage(errorCode));
    } catch (e) {
      log("RevenueCatService: Unexpected purchase error: $e");
      return const PurchaseResult.failed(
        'Something went wrong. Please try again later.',
      );
    }
  }

  Future<PurchaseResult> changePlan(
    StoreProduct newProduct, {
    String? oldProductId,
  }) async {
    if (!await _ensureConfigured()) {
      return const PurchaseResult.failed('Service not configured.');
    }
    try {
      GoogleProductChangeInfo? googleChangeInfo;
      if (Platform.isAndroid && oldProductId != null) {
        googleChangeInfo = GoogleProductChangeInfo(
          oldProductId,
          prorationMode: GoogleProrationMode.immediateWithoutProration,
        );
      }
      final result = await Purchases.purchase(
        PurchaseParams.storeProduct(
          newProduct,
          googleProductChangeInfo: googleChangeInfo,
        ),
      );
      _setIsPremiumUser(
        result
                .customerInfo
                .entitlements
                .all[_revenueConfig?.revenueCat?.entitlementKey]
                ?.isActive ==
            true,
      );
      _lastEntitlementCheck = DateTime.now();
      return const PurchaseResult.success();
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log("RevenueCatService: ChangePlan error: $errorCode");
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return const PurchaseResult.cancelled();
      }
      return PurchaseResult.failed(_userFriendlyMessage(errorCode));
    } catch (e) {
      log("RevenueCatService: Unexpected changePlan error: $e");
      return const PurchaseResult.failed(
        'Something went wrong. Please try again later.',
      );
    }
  }

  Future<PurchaseResult> restorePurchases() async {
    if (!await _ensureConfigured()) {
      return const PurchaseResult.failed('Service not configured.');
    }
    try {
      final customerInfo = await Purchases.restorePurchases();
      _setIsPremiumUser(
        customerInfo
                .entitlements
                .all[_revenueConfig?.revenueCat?.entitlementKey]
                ?.isActive ==
            true,
      );
      _lastEntitlementCheck = DateTime.now();
      return _isPremiumUser
          ? const PurchaseResult.success()
          : const PurchaseResult.failed(
              'No active subscription found to restore.',
            );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      log("RevenueCatService: Restore error: $errorCode");
      return PurchaseResult.failed(_userFriendlyMessage(errorCode));
    } catch (e) {
      log("RevenueCatService: Unexpected restore error: $e");
      return const PurchaseResult.failed(
        'Could not restore purchases. Please try again later.',
      );
    }
  }

  String _userFriendlyMessage(PurchasesErrorCode code) {
    switch (code) {
      case PurchasesErrorCode.networkError:
        return 'Network error. Please check your connection and try again.';
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return 'This subscription plan is currently unavailable.';
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return 'You already own this subscription. Try restoring purchases.';
      case PurchasesErrorCode.paymentPendingError:
        return 'Your payment is pending. It may take a moment to process.';
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return 'This receipt is already linked to another account.';
      case PurchasesErrorCode.storeProblemError:
        return 'The app store encountered a problem. Please try again.';
      case PurchasesErrorCode.invalidCredentialsError:
      case PurchasesErrorCode.invalidReceiptError:
        return 'There was a problem verifying your purchase. Please try again.';
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Purchases are not allowed on this device.';
      default:
        return 'Purchase could not be completed. Please try again.';
    }
  }

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  String get _platformApiKey {
    if (Platform.isIOS) return _revenueConfig?.revenueCat?.iosApiKey ?? '';
    if (Platform.isAndroid) {
      return _revenueConfig?.revenueCat?.androidApiKey ?? '';
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<bool> _ensureConfigured() async {
    if (isConfigured) return true;
    await init();
    if (!isConfigured) {
      log(
        'RevenueCatService: still not configured '
        '(user=${LocalStorageService.getUserSync()?.id}, '
        'config=${_revenueConfig != null})',
      );
    }
    return isConfigured;
  }

  Future<void> logOut() async {
    if (!isConfigured) return;
    try {
      await Purchases.logOut();
    } catch (e) {
      log('RevenueCatService: logOut error: $e');
    }
    _currentConfiguredUserId = null;
    _lastEntitlementCheck = null;
    _setIsPremiumUser(false);
  }
}

class PurchaseResult {
  final bool success;
  final bool userCancelled;
  final String? errorMessage;

  const PurchaseResult({
    required this.success,
    this.userCancelled = false,
    this.errorMessage,
  });

  const PurchaseResult.success()
    : success = true,
      userCancelled = false,
      errorMessage = null;

  const PurchaseResult.cancelled()
    : success = false,
      userCancelled = true,
      errorMessage = null;

  const PurchaseResult.failed(String message)
    : success = false,
      userCancelled = false,
      errorMessage = message;
}
