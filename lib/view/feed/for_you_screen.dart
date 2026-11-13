import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/providers/feed_provider.dart';
import '../../cors/theme/app_colors.dart';
import 'for_you/for_you_post_widget.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  final PageController _pageController = PageController();
  bool isLoadingMore = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Fetch initial feed once the widget is built
    var pro = context.read<FeedProvider>();

    if (pro.feedList.isEmpty)
      Future.microtask(() {
        Provider.of<FeedProvider>(context, listen: false).fetchFeed(context);
      });
  }

  Future<void> _loadMore(FeedProvider provider) async {
    if (isLoadingMore || provider.isLoading || !provider.hasMore) return;

    setState(() => isLoadingMore = true);
    await provider.loadMoreFeed(context);
    setState(() => isLoadingMore = false);
  }

  Future<void> _refreshFeed(BuildContext context) async {
    await Provider.of<FeedProvider>(context, listen: false)
        .refreshFeed(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, _) {
        // 🔄 Loading on first fetch
        if (feedProvider.isLoading && feedProvider.feedList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        // ⚠️ Error handling
        if (feedProvider.errorMessage != null &&
            feedProvider.feedList.isEmpty) {
          return Center(
            child: Text(
              feedProvider.errorMessage!,
              style: const TextStyle(color: AppColors.primaryWhite),
              textAlign: TextAlign.center,
            ),
          );
        }

        // 📭 Empty feed case
        if (feedProvider.feedList.isEmpty) {
          return const Center(
            child: Text(
              "No feed data available.",
              style: TextStyle(color: AppColors.primaryWhite),
            ),
          );
        }

        // 📱 Feed content with pagination
        return Stack(
          children: [
            RefreshIndicator(
              color: Colors.orange,
              backgroundColor: Colors.black,
              onRefresh: () => _refreshFeed(context),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: feedProvider.feedList.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  // debugger();
                  // 🟠 Trigger pagination when near end
                  if (index >= feedProvider.feedList.length - 2 &&
                      feedProvider.hasMore &&
                      !feedProvider.isLoading) {
                    _loadMore(feedProvider);
                  }
                },
                itemBuilder: (context, index) {
                  final feedItem = feedProvider.feedList[index];
                  return ForYouPostWidget(feedItem: feedItem);
                },
              ),
            ),

            // 🔁 Bottom loader when fetching next page
            if (isLoadingMore)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Loading more...",
                          style: TextStyle(
                              color: AppColors.primaryWhite, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
