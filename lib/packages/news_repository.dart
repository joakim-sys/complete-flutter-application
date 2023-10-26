import 'package:equatable/equatable.dart';
import 'package:api/client.dart';

abstract class NewsFailure with EquatableMixin implements Exception {
  const NewsFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetFeedFailure extends NewsFailure {
  const GetFeedFailure(super.error);
}

class GetCategoriesFailure extends NewsFailure {
  const GetCategoriesFailure(super.error);
}

class PopularSearchFailure extends NewsFailure {
  const PopularSearchFailure(super.error);
}

class RelevantSearchFailure extends NewsFailure {
  const RelevantSearchFailure(super.error);
}

class NewsRepository {
  const NewsRepository({
    required TrcApiClient apiClient,
  }) : _apiClient = apiClient;

  final TrcApiClient _apiClient;

  Future<FeedResponse> getFeed({
    Category? category,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getFeed(
        category: category,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFeedFailure(error), stackTrace);
    }
  }

  Future<CategoriesResponse> getCategories() async {
    try {
      return await _apiClient.getCategories();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetCategoriesFailure(error), stackTrace);
    }
  }

  Future<void> subscribeToNewsletter({required String email}) async {
    try {
      await _apiClient.subscribeToNewsletter(email: email);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFeedFailure(error), stackTrace);
    }
  }

  Future<PopularSearchResponse> popularSearch() async {
    try {
      return await _apiClient.popularSearch();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PopularSearchFailure(error), stackTrace);
    }
  }

  Future<RelevantSearchResponse> relevantSearch({required String term}) async {
    try {
      return await _apiClient.relevantSearch(term: term);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RelevantSearchFailure(error), stackTrace);
    }
  }
}
