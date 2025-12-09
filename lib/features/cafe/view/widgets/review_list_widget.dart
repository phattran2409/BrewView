import 'package:briewview/features/cafe/model/review.dart';
import 'package:briewview/features/cafe/view/widgets/loading_widgets.dart';
import 'package:briewview/features/cafe/view/widgets/review_header_widget.dart';
import 'package:briewview/features/cafe/view/widgets/review_item_widget.dart';
import 'package:flutter/material.dart';

class ReviewListWidget extends StatelessWidget {
  final List<Review> reviews;
  final bool hasNextPage;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final VoidCallback onWriteReview;

  const ReviewListWidget({
    super.key,
    required this.reviews,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Reviews Header
          ReviewHeaderWidget(reviewCount: reviews.length),
          // Reviews List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: () {
                  if (reviews.isEmpty) return 1;

                  // Base count: number of reviews
                  int count = reviews.length;

                  // Add 1 if we need to show loading or "no more" indicator
                  if (hasNextPage || isLoadingMore) {
                    count += 1;
                  }

                  return count;
                }(),
                itemBuilder: (_, i) {
                  // Show empty state if no reviews
                  if (reviews.isEmpty) {
                    return EmptyReviewsWidget(onWriteReview: onWriteReview);
                  }

                  // Show review item if index is within reviews range
                  if (i < reviews.length) {
                    final review = reviews[i];
                    return ReviewItemWidget(review: review);
                  }

                  // Show loading or "no more" indicator at the end
                  if (i == reviews.length) {
                    if (isLoadingMore) {
                      return const LoadMoreIndicatorWidget();
                    } else if (hasNextPage) {
                      // This shouldn't happen with our new logic, but just in case
                      return const LoadMoreIndicatorWidget();
                    } else {
                      return const NoMoreReviewsWidget();
                    }
                  }

                  // Fallback - should not reach here
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
