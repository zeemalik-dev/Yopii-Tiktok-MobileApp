import 'package:flutter/material.dart';
import '../../model/feed/feed_model.dart';
import '../services/api_manager.dart';
import '../services/app_toast.dart';

class FeedProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  final List<FeedItem> _feedList = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  List<FeedItem> get feedList => List.unmodifiable(_feedList);
  String? get errorMessage => _errorMessage;

  /// Fetch feed content (For You)
  Future<void> fetchFeed(
    BuildContext context, {
    int limit = 10,
    bool loadMore = false,
  }) async {
    // Avoid multiple requests while one is in progress
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Reset feed on first load
    if (!loadMore) {
      _feedList.clear();
      _currentPage = 1;
      _hasMore = true;
    }

    try {
      // debugger();
      final response = await ApiManager.getForYouFeed(
        context,
        page: _currentPage,
        limit: limit,
      );
      // debugger();
      if (response != null && response.data != null) {
        final newFeed = response.data!.feed;

        if (newFeed.isNotEmpty) {
          _feedList.addAll(newFeed);
          // debugger();
          _hasMore = response.data!.pagination?.hasNextPage ?? false;
          _currentPage++;
          notifyListeners();
        } else {
          _hasMore = false;
          if (!loadMore) {
            _errorMessage = 'No feed data available.';
            AppToast.warning(context, 'No more feed available.');
          }
        }
      } else {
        _hasMore = false;
        if (!loadMore) {
          _errorMessage = 'No feed data available.';
          AppToast.error(context, 'No feed data found.');
        }
      }
    } catch (e) {
      _errorMessage = 'Error fetching feed: $e';
      AppToast.error(context, _errorMessage!);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh feed manually (pull-to-refresh)
  Future<void> refreshFeed(BuildContext context) async {
    _feedList.clear();
    _currentPage = 1;
    _hasMore = true;
    await fetchFeed(context, limit: 10);
  }

  /// Load more feed (pagination / infinite scroll)
  Future<void> loadMoreFeed(BuildContext context) async {
    if (_hasMore && !_isLoading) {
      await fetchFeed(context, loadMore: true);
    }
  }

  /// Clear all feed data
  void clearFeed() {
    _feedList.clear();
    _errorMessage = null;
    _hasMore = true;
    _currentPage = 1;
    notifyListeners();
  }
}
