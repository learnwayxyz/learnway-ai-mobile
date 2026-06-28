import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/notifications/data/notification_data_source.dart';
import 'package:learnwayv2/features/notifications/model/notification_model.dart';
import 'package:learnwayv2/features/notifications/network_exception.dart';

class NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepository(this._dataSource);

  Future<Either<NotificationFailure, NotificationResponse>>
      getUserNotifications({int? limit, int? offset}) async {
    try {
      final response = await _dataSource.getUserNotifications(
        limit: limit,
        offset: offset,
      );
      return Right(response);
    } on NotificationFailure catch (e) {
      log('NotificationFailure in repository: $e');
      return Left(e);
    } catch (e) {
      log('Error in getUserNotifications: $e');
      return Left(NotificationFailure(e.toString()));
    }
  }

  Future<Either<NotificationFailure, bool>> markAsRead(
    String notificationId,
  ) async {
    try {
      final result = await _dataSource.markAsRead(notificationId);
      return Right(result);
    } on NotificationFailure catch (e) {
      return Left(e);
    } catch (e) {
      log('Error in markAsRead: $e');
      return Left(NotificationFailure(e.toString()));
    }
  }

  Future<Either<NotificationFailure, bool>> markAllAsRead() async {
    try {
      final result = await _dataSource.markAllAsRead();
      return Right(result);
    } on NotificationFailure catch (e) {
      return Left(e);
    } catch (e) {
      log('Error in markAllAsRead: $e');
      return Left(NotificationFailure(e.toString()));
    }
  }

  Future<Either<NotificationFailure, bool>> deleteNotification(
    String notificationId,
  ) async {
    try {
      final result = await _dataSource.deleteNotification(notificationId);
      return Right(result);
    } on NotificationFailure catch (e) {
      return Left(e);
    } catch (e) {
      log('Error in deleteNotification: $e');
      return Left(NotificationFailure(e.toString()));
    }
  }

  Future<Either<NotificationFailure, bool>> deleteAllNotifications() async {
    try {
      final result = await _dataSource.deleteAllNotifications();
      return Right(result);
    } on NotificationFailure catch (e) {
      return Left(e);
    } catch (e) {
      log('Error in deleteAllNotifications: $e');
      return Left(NotificationFailure(e.toString()));
    }
  }
}
