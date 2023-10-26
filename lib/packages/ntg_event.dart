import 'analytics_repository.dart';

abstract class NTGEvent extends AnalyticsEvent {
  NTGEvent({
    required String name,
    required String category,
    required String action,
    required bool nonInteraction,
    String? label,
    Object? value,
    String? hitType,
  }) : super(
          name,
          properties: <String, Object>{
            'eventCategory': category,
            'eventAction': action,
            'nonInteraction': '$nonInteraction',
            if (label != null) 'eventLabel': label,
            if (value != null) 'eventValue': value,
            if (hitType != null) 'hitType': hitType,
          },
        );
}

class NewsletterEvent extends NTGEvent {
  /// An analytics event for tracking newsletter sign up.
  NewsletterEvent.signUp()
      : super(
          name: 'newsletter_signup',
          category: 'NTG newsletter',
          action: 'newsletter signup',
          label: 'success',
          nonInteraction: false,
        );

  /// An analytics event for tracking newsletter impression.
  NewsletterEvent.impression({String? articleTitle})
      : super(
          name: 'newsletter_impression',
          category: 'NTG newsletter',
          action: 'newsletter modal impression 3',
          label: articleTitle ?? '',
          nonInteraction: false,
        );
}

class LoginEvent extends NTGEvent {
  /// {@macro login_event}
  LoginEvent()
      : super(
          name: 'login',
          category: 'NTG account',
          action: 'login',
          label: 'success',
          nonInteraction: false,
        );
}

class RegistrationEvent extends NTGEvent {
  /// {@macro registration_event}
  RegistrationEvent()
      : super(
          name: 'registration',
          category: 'NTG account',
          action: 'registration',
          label: 'success',
          nonInteraction: false,
        );
}

class ArticleMilestoneEvent extends NTGEvent {
  /// {@macro article_milestone_event}
  ArticleMilestoneEvent({
    required int milestonePercentage,
    required String articleTitle,
  }) : super(
          name: 'article_milestone',
          category: 'NTG article milestone',
          action: '$milestonePercentage%',
          label: articleTitle,
          value: milestonePercentage,
          nonInteraction: true,
          hitType: 'event',
        );
}

class ArticleCommentEvent extends NTGEvent {
  /// {@macro article_comment_event}
  ArticleCommentEvent({required String articleTitle})
      : super(
          name: 'comment',
          category: 'NTG user',
          action: 'comment added',
          label: articleTitle,
          nonInteraction: false,
        );
}

class SocialShareEvent extends NTGEvent {
  /// {@macro social_share_event}
  SocialShareEvent()
      : super(
          name: 'social_share',
          category: 'NTG social',
          action: 'social share',
          label: 'OS share menu',
          nonInteraction: false,
        );
}

class PushNotificationSubscriptionEvent extends NTGEvent {
  /// {@macro push_notification_subscription_event}
  PushNotificationSubscriptionEvent()
      : super(
          name: 'push_notification_click',
          category: 'NTG push notification',
          action: 'click',
          nonInteraction: false,
        );
}

class PaywallPromptEvent extends NTGEvent {
  /// An analytics event for tracking paywall prompt impression.
  PaywallPromptEvent.impression({
    required PaywallPromptImpression impression,
    required String articleTitle,
  }) : super(
          name: 'paywall_impression',
          category: 'NTG paywall',
          action: 'paywall modal impression $impression',
          label: articleTitle,
          nonInteraction: true,
        );

  /// An analytics event for tracking paywall prompt click.
  PaywallPromptEvent.click({required String articleTitle})
      : super(
          name: 'paywall_click',
          category: 'NTG paywall',
          action: 'click',
          label: articleTitle,
          nonInteraction: false,
        );
}

enum PaywallPromptImpression {
  /// The rewarded paywall prompt impression.
  rewarded(1),

  /// The subscription paywall prompt impression.
  subscription(2);

  /// {@macro paywall_prompt_impression}
  const PaywallPromptImpression(this._impressionType);
  final int _impressionType;

  @override
  String toString() => _impressionType.toString();
}

class UserSubscriptionConversionEvent extends NTGEvent {
  /// {@macro user_subscription_conversion_event}
  UserSubscriptionConversionEvent()
      : super(
          name: 'subscription_submit',
          category: 'NTG subscription',
          action: 'submit',
          label: 'success',
          nonInteraction: false,
        );
}
