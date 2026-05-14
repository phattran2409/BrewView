# Wishlist Feature

## Cấu trúc thư mục

```
lib/features/wishlist/
├── model/
│   └── wishlist_model.dart          # Model cho wishlist và response
├── repository/
│   ├── wishlist_repository.dart     # Abstract repository
│   └── wishlist_repository_impl.dart # Repository implementation
├── services/
│   ├── wishlist_service.dart       # Abstract service
│   └── wishlist_service_impl.dart  # Service implementation với HTTP calls
├── view/
│   ├── wishlist_page.dart          # Trang danh sách wishlist
│   └── widgets/
│       ├── wishlist_item_widget.dart # Widget cho từng item trong wishlist
│       └── wishlist_widgets.dart   # Các widget hỗ trợ (empty, loading, error)
└── viewmodel/
    ├── wishlist_bloc.dart          # BLoC chính
    ├── wishlist_event.dart         # Các event
    └── wishlist_state.dart         # Các state
```

## Cách sử dụng

### 1. Navigation đến WishlistPage

```dart
// Sử dụng GoRouter
context.goNamed('wishlist');

// Hoặc Navigator
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const WishlistPage(),
  ),
);
```

### 2. Thêm/xóa khỏi wishlist

```dart
// Lấy WishlistBloc từ DI
final wishlistBloc = getIt<WishlistBloc>();

// Thêm vào wishlist
wishlistBloc.add(AddToWishlist(cafeId));

// Xóa khỏi wishlist
wishlistBloc.add(RemoveFromWishlist(cafeId));

// Tải lại wishlist
wishlistBloc.add(const LoadWishlist());
```

### 3. Tích hợp với CafeDetail

WishlistPage đã được tích hợp sẵn với CafeDetail. Khi nhấn vào một item trong wishlist, nó sẽ navigate đến CafeDetail với cafeId tương ứng.

## API Endpoints

Theo `AppConstants` và `WishlistServiceImpl`:

- `GET /api/favorite-cafe/{userId}` — lấy danh sách yêu thích
- `POST /api/favorite-cafe/{userId}` — thêm quán (body: `{"cafeIds": ["<cafeId>"]}`)

Xóa khỏi wishlist qua API có thể được bổ sung sau (code remove hiện đang comment trong service).

## Dependency Injection

Sau khi thêm các file mới, cần chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Để regenerate file `locator.config.dart` với các dependency mới.

## Features

- ✅ Hiển thị danh sách quán cà phê yêu thích
- ✅ Pull-to-refresh để tải lại dữ liệu
- ✅ Empty state với nút khám phá
- ✅ Loading và error states
- ✅ Xóa khỏi wishlist với confirmation dialog
- ✅ Navigation đến cafe detail
- ✅ Responsive design với dark theme
- ✅ Error handling và user feedback
