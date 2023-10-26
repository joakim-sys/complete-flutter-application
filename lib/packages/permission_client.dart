import 'package:permission_handler/permission_handler.dart';
export 'package:permission_handler/permission_handler.dart'
    show PermissionStatus, PermissionStatusGetters;

class PermissionClient {
  const PermissionClient();

  Future<PermissionStatus> requestNotifications() =>
      Permission.notification.request();

  Future<PermissionStatus> notificationStatus() =>
      Permission.notification.status;

  Future<bool> openPermissionSettings() => openAppSettings();
}
