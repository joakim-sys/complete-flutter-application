import 'package:pro_one/app/app.dart';
import 'package:pro_one/bootstrap.dart';
import 'package:pro_one/packages/ads_consent_client.dart';
import 'package:pro_one/packages/article_repository.dart';
import 'package:pro_one/packages/deep_link_client.dart';
import 'package:pro_one/packages/firebase_authentication_client.dart';
import 'package:pro_one/packages/firebase_notifications_client.dart';
import 'package:pro_one/packages/in_app_purchase_repository.dart';
import 'package:pro_one/packages/news_repository.dart';
import 'package:pro_one/packages/notifications_repository.dart';
import 'package:pro_one/packages/package_info_client.dart';
import 'package:pro_one/packages/permission_client.dart';
import 'package:pro_one/packages/persistent_storage.dart';
import 'package:pro_one/packages/purchase_client.dart';
import 'package:pro_one/packages/token_storage.dart';
import 'package:api/client.dart';
import 'package:pro_one/packages/user_repository.dart';

import 'gen/version.gen.dart';

void main() async {
  bootstrap((
    firebaseDynamicLinks,
    firebaseMessaging,
    sharedPreferences,
    analyticsRepository,
  ) async {
    final tokenStorage = InMemoryTokenStorage();
    final apiClient =
        TrcApiClient.localhost(tokenProvider: tokenStorage.readToken);

    const permissionClient = PermissionClient();
    final persistentStorage =
        PersistentStorage(sharedPreferences: sharedPreferences);
    final packageInfoClient = PackageInfoClient(
      appName: 'Pro One (dev)',
      packageName: 'com.example.pro_one',
      packageVersion: packageVersion,
    );

    final deepLinkClient =
        DeepLinkClient(firebaseDynamicLinks: firebaseDynamicLinks);

    final userStorage = UserStorage(storage: persistentStorage);
    final authenticationClient =
        FirebaseAuthenticationClient(tokenStorage: tokenStorage);

    final notificationsClient =
        FirebaseNotificationsClient(firebaseMessaging: firebaseMessaging);

    final userRepository = UserRepository(
        apiClient: apiClient,
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkClient: deepLinkClient,
        storage: userStorage);

    final newsRepository = NewsRepository(apiClient: apiClient);

    final notificationsRepository = NotificationsRepository(
        permissionClient: permissionClient,
        storage: NotificationsStorage(storage: persistentStorage),
        notificationsClient: notificationsClient,
        apiClient: apiClient);

    final articleRepository = ArticleRepository(
        apiClient: apiClient,
        storage: ArticleStorage(storage: persistentStorage));

    final adsConsentClient = AdsConsentClient();

    final inAppPurchaseRepository = InAppPurchaseRepository(
        authenticationClient: authenticationClient,
        apiClient: apiClient,
        inAppPurchase: PurchaseClient());

    return App(
      userRepository: userRepository,
      newsRepository: newsRepository,
      notificationsRepository: notificationsRepository,
      articleRepository: articleRepository,
      inAppPurchaseRepository: inAppPurchaseRepository,
      analyticsRepository: analyticsRepository,
      adsConsentClient: adsConsentClient,
      user: await userRepository.user.first,
    );
  });
}
