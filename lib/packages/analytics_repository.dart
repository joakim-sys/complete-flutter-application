import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsFailure with EquatableMixin implements Exception {
  AnalyticsFailure(this.error);
  final Object error;

  @override
  List<Object?> get props => [error];
}

class TrackEventFailure extends AnalyticsFailure {
  TrackEventFailure(super.error);
}

class SetUserIdFailure extends AnalyticsFailure {
  SetUserIdFailure(super.error);
}

class AnalyticsRepository {
  const AnalyticsRepository(FirebaseAnalytics analytics)
      : _analytics = analytics;
  final FirebaseAnalytics _analytics;

  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.name,
        parameters: event.properties,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    }
  }
}

class AnalyticsEvent extends Equatable {
  const AnalyticsEvent(this.name, {this.properties});
  final String name;
  final Map<String, dynamic>? properties;

  @override
  List<Object?> get props => [name, properties];
}

mixin AnalyticsEventMixin on Equatable {
  AnalyticsEvent get event;

  @override
  List<Object> get props => [event];
}
