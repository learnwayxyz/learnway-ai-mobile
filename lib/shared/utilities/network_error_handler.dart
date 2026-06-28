import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/network_error_screen.dart';
import 'package:learnwayv2/shared/widgets/no_internet_screen.dart';

class NetworkErrorHandler {
  /// Show appropriate error screen based on the exception type
  static void showErrorScreen(
    BuildContext context,
    dynamic error, {
    required VoidCallback onRetry,
  }) {
    if (error is NetworkException) {
      final message = error.message.toLowerCase();
      
      // Check if it's a no internet connection error
      if (message.contains('no internet') || message.contains('socket')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternetScreen(
              onRetry: () {
                Navigator.pop(context);
                onRetry();
              },
            ),
          ),
        );
      } else {
        // Other network errors (timeout, bad request, etc.)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkErrorScreen(
              onRetry: () {
                Navigator.pop(context);
                onRetry();
              },
            ),
          ),
        );
      }
    } else {
      // For non-network errors, show network error screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkErrorScreen(
            onRetry: () {
              Navigator.pop(context);
              onRetry();
            },
          ),
        ),
      );
    }
  }

  /// Check if error is a no internet connection error
  static bool isNoInternetError(dynamic error) {
    if (error is NetworkException) {
      final message = error.message.toLowerCase();
      return message.contains('no internet') || message.contains('socket');
    }
    return false;
  }

  /// Check if error is a network error
  static bool isNetworkError(dynamic error) {
    return error is NetworkException;
  }
}
