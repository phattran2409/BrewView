# Review Widgets

Thư mục này chứa các widget được tách ra từ `review_list_page.dart` để tăng tính tái sử dụng và dễ bảo trì.

## Cấu trúc Widgets

### 1. ReviewItemWidget (`review_item_widget.dart`)
- Hiển thị từng review item với đầy đủ thông tin
- Bao gồm: avatar user, tên, rating, nội dung, media, action buttons
- Có method `_formatDate()` để format thời gian

### 2. ReviewHeaderWidget (`review_header_widget.dart`)
- Header hiển thị số lượng reviews và filter "Tất cả"
- Đơn giản, dễ tùy chỉnh

### 3. Loading Widgets (`loading_widgets.dart`)
- `LoadMoreIndicatorWidget`: Loading indicator khi load more
- `NoMoreReviewsWidget`: Thông báo khi hết reviews
- `EmptyReviewsWidget`: Empty state khi chưa có review nào

### 4. ReviewListWidget (`review_list_widget.dart`)
- Widget chính chứa toàn bộ danh sách reviews
- Kết hợp ReviewHeaderWidget và ListView
- Xử lý logic hiển thị empty state, loading, load more

### 5. ReviewAppBarWidget (`review_app_bar_widget.dart`)
- App bar cho ReviewListPage
- `ReviewAppBarWidget`: App bar chính với nút back và edit
- `FloatingWriteReviewButton`: Floating action button

### 6. Write Review Widgets (`write_review_widgets.dart`)
- `WriteReviewAppBarWidget`: App bar cho trang viết review
- `ReviewSectionHeaderWidget`: Header section với icon và text
- `StarRatingWidget`: Widget chấm điểm sao (StatefulWidget)
- `RatingFeedbackWidget`: Hiển thị emoji và text theo rating
- `ReviewTextSectionWidget`: TextField để nhập nội dung review
- `QuickRatingTagsWidget`: Các tag nhanh cho review

## Lợi ích của việc refactor

1. **Tái sử dụng**: Các widget có thể được sử dụng ở nhiều nơi khác
2. **Dễ test**: Mỗi widget có thể được test riêng biệt
3. **Dễ bảo trì**: Code được tổ chức rõ ràng, dễ tìm và sửa
4. **Performance**: Widget nhỏ hơn, rebuild ít hơn
5. **Đọc code**: Code ngắn gọn, dễ hiểu hơn

## Cách sử dụng

```dart
// Sử dụng ReviewListWidget
ReviewListWidget(
  reviews: reviews,
  hasNextPage: hasNextPage,
  isLoadingMore: isLoadingMore,
  scrollController: scrollController,
  onRefresh: () => _refresh(),
  onWriteReview: () => _navigateToWriteReview(),
)

// Sử dụng ReviewItemWidget
ReviewItemWidget(review: review)

// Sử dụng StarRatingWidget
StarRatingWidget(
  initialRating: 5,
  onRatingChanged: (rating) => setState(() => _rating = rating),
)
```
