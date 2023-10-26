abstract class NotificationException implements Exception {
  const NotificationException(this.error);
  final Object error;
}

class SubscribeToCategoryFailure extends NotificationException {
  const SubscribeToCategoryFailure(super.error);
}

class UnsubscribeFromCategoryFailure extends NotificationException {
  const UnsubscribeFromCategoryFailure(super.error);
}

abstract class NotificationsClient {
  Future<void> subscribeToCategory(String category);

  Future<void> unsubscribeFromCategory(String category);
}
