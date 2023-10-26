import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:pro_one/packages/permission_client.dart';

import 'notifications_client.dart';
import 'storage.dart';
import 'package:api/client.dart';
import 'dart:convert';

part 'notifications_storage.dart';


abstract class NotificationsFailure with EquatableMixin implements Exception {
  const NotificationsFailure(this.error);
  final Object error;

  @override
  List<Object?> get props => [error];
}

class InitializeCategoriesPreferencesFailure extends NotificationsFailure {
  const InitializeCategoriesPreferencesFailure(super.error);
}

class ToggleNotificationsFailure extends NotificationsFailure {
  const ToggleNotificationsFailure(super.error);
}

class FetchNotificationsEnabledFailure extends NotificationsFailure {
  const FetchNotificationsEnabledFailure(super.error);
}

class SetCategoriesPreferencesFailure extends NotificationsFailure {
  const SetCategoriesPreferencesFailure(super.error);
}

class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  const FetchCategoriesPreferencesFailure(super.error);
}

class NotificationsRepository {
  NotificationsRepository({
    required PermissionClient permissionClient,
    required NotificationsStorage storage,
    required NotificationsClient notificationsClient,
    required TrcApiClient apiClient,
  })  : _permissionClient = permissionClient,
        _storage = storage,
        _notificationsClient = notificationsClient,
        _apiClient = apiClient {
    unawaited(_initializeCategoriesPreferences());
  }

  final PermissionClient _permissionClient;
  final NotificationsStorage _storage;
  final NotificationsClient _notificationsClient;
  final TrcApiClient _apiClient;

  Future<void> toggleNotifications({required bool enable}) async {
    try {
      if (enable) {
        final permissionStatus = await _permissionClient.notificationStatus();

        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }
      await _toggleCategoriesPreferencesSubscriptions(enable: enable);
      await _storage.setNotificationsEnabled(enabled: enable);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  Future<bool> fetchNotificationsEnabled() async {
    try {
      final results = await Future.wait([
        _permissionClient.notificationStatus(),
        _storage.fetchNotificationsEnabled(),
      ]);

      final permissionStatus = results.first as PermissionStatus;
      final notificationsEnabled = results.last as bool;

      return permissionStatus.isGranted && notificationsEnabled;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          FetchNotificationsEnabledFailure(error), stackTrace);
    }
  }

  Future<void> setCategoriesPreferences(Set<Category> categories) async {
    try {
      await _toggleCategoriesPreferencesSubscriptions(enable: false);
      await _storage.setCategoriesPreferences(categories: categories);

      if (await fetchNotificationsEnabled()) {
        await _toggleCategoriesPreferencesSubscriptions(enable: true);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          SetCategoriesPreferencesFailure(error), stackTrace);
    }
  }

  Future<Set<Category>?> fetchCategoriesPreferences() async {
    try {
      return await _storage.fetchCategoriesPreferences();
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(
          FetchCategoriesPreferencesFailure(error), stackTrace);
    }
  }

  Future<void> _toggleCategoriesPreferencesSubscriptions({
    required bool enable,
  }) async {
    final categoriesPreferences =
        await _storage.fetchCategoriesPreferences() ?? {};
    await Future.wait(categoriesPreferences.map((e) => enable
        ? _notificationsClient.subscribeToCategory(e.name)
        : _notificationsClient.unsubscribeFromCategory(e.name)));
  }

  Future<void> _initializeCategoriesPreferences() async {
    try {
      final categoriesPreferences = await _storage.fetchCategoriesPreferences();
      if (categoriesPreferences == null) {
        final categoriesResponse = await _apiClient.getCategories();
        await _storage.setCategoriesPreferences(
            categories: categoriesResponse.categories.toSet());
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          InitializeCategoriesPreferencesFailure(error), stackTrace);
    }
  }
}

