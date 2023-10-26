part of 'notifications_repository.dart';

abstract class NotificationsStorageKeys {
  static const notificationsEnabled = '__notifications_enabled_storage_key__';
  static const categoriesPreferences = '__categories_preferences_storage_key__';
}

class NotificationsStorage {
  const NotificationsStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  Future<void> setNotificationsEnabled({required bool enabled}) =>
      _storage.write(
        key: NotificationsStorageKeys.notificationsEnabled,
        value: enabled.toString(),
      );

  Future<bool> fetchNotificationsEnabled() async {
    return (await _storage.read(
                key: NotificationsStorageKeys.notificationsEnabled))
            ?.parseBool() ??
        false;
  }

  Future<void> setCategoriesPreferences({
    required Set<Category> categories,
  }) async {
    final categoriesEncoded =
        json.encode(categories.map((e) => e.name).toList());
    await _storage.write(
        key: NotificationsStorageKeys.categoriesPreferences,
        value: categoriesEncoded);
  }

  Future<Set<Category>?> fetchCategoriesPreferences() async {
    final categories = await _storage.read(
      key: NotificationsStorageKeys.categoriesPreferences,
    );
    if (categories == null) {
      return null;
    }
    return List<String>.from(json.decode(categories) as List)
        .map(Category.fromString)
        .toSet();
  }
}

extension _BoolFromStringParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
