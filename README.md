# BrewView

Ứng dụng Flutter **BrewView** kết nối backend BrewView API: khám phá quán cà phê, bản đồ quanh bạn, bài viết cộng đồng, gói premium và quản lý quán cho chủ quán.

> **Lưu ý:** Tên package Dart trong `pubspec.yaml` là `briewview` (đường dẫn import `package:briewview/...`). Tên hiển thị ứng dụng là **BrewView** (`main.dart`).

## Yêu cầu môi trường

- [Flutter SDK](https://docs.flutter.dev/get-started/install) tương thích **Dart ^3.7.2**
- Android Studio / Xcode (nếu build iOS)
- Tệp cấu hình **Firebase** (`lib/firebase_options.dart`) và dự án Firebase đã bật Auth, Messaging (nếu dùng FCM)

## Chạy dự án

```bash
cd BrewView
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Sau khi thêm/sửa annotation `@injectable`, `@JsonSerializable`, chạy lại `build_runner` để cập nhật `locator.config.dart` và các file `.g.dart`.

## Kiến trúc tóm tắt

| Thành phần | Thư viện |
|------------|-----------|
| Điều hướng | `go_router` (`AppRouter`, `RoutePaths`) |
| State | `flutter_bloc` + `equatable` |
| DI | `get_it` + `injectable` (`lib/app/di/locator.dart`) |
| HTTP | `dio` |
| Lỗi / kiểu tùy chọn | `dartz` (`Either`, `Failure`) |
| Lưu token / bảo mật | `flutter_secure_storage`, `shared_preferences` |

Các feature nằm dưới `lib/features/<tên_feature>/` theo hướng tách **model → service/repository → viewmodel (BLoC) → view**.

## Tính năng chính (theo mã nguồn)

- **Onboarding & splash** — luồng vào app.
- **Đăng nhập / đăng ký** — email, OTP, quên/đặt lại mật khẩu; tích hợp **Google**, **Apple**, **Facebook** qua Firebase Auth và backend.
- **Trang chủ** — nội dung tổng hợp, thông báo (UI).
- **Tìm kiếm & lọc** quán.
- **Chi tiết quán & đánh giá** — danh sách review theo quán.
- **Khảo sát sở thích** — categories và feature tags, đồng bộ user preferences.
- **Bản đồ quán gần bạn** — `flutter_map` + OpenStreetMap, vị trí `geolocator` (xem thêm `lib/features/nearby_map/README.md`).
- **Wishlist (yêu thích)** — API `favorite-cafe` theo user (xem `lib/features/wishlist/README.md`).
- **Bài viết (posts)** — danh sách, chi tiết, BLoC riêng theo route.
- **Hồ sơ** — xem/sửa profile, ảnh đại diện (`image_picker`).
- **Quán của tôi (owner)** — danh sách, tạo/sửa/chi tiết quán.
- **Premium & thanh toán** — gói premium, liên kết thanh toán, trang thành công.
- **Quảng cáo** — `google_mobile_ads` (khởi tạo trong `main`, có try/catch nếu lỗi).
- **Thông báo đẩy** — Firebase Messaging + `flutter_local_notifications`.
- **Deep link** — `app_links` + `DeepLinkService` / `DeepLinkHandler`.

## API backend

Base URL được khai báo trong `lib/core/constants/app_constants.dart` (ví dụ host Azure Container Apps). Đổi URL khi chạy backend local (trong file có ví dụ comment `10.0.2.2` cho Android emulator).

Các nhóm endpoint chính: auth, user/profile, categories/feature-tags/preferences, cafes (theo khoảng cách, owner, preferences), reviews, premium, subscriptions/payment, favorite-cafe, posts, comments.

## Firebase & nền tảng đăng nhập

- `firebase_core`, `firebase_auth`, `firebase_messaging`
- Google Sign-In, Sign in with Apple, Facebook Auth

Cần cấu hình đúng **Android/iOS** (bundle id, `GoogleService-Info.plist`, `google-services.json`, URL scheme cho Facebook/Apple nếu dùng).

## Tài nguyên & quyền

- **Assets:** `assets/images/` (khai báo trong `pubspec.yaml`).
- **Vị trí / bản đồ:** quyền trong `AndroidManifest.xml` và `Info.plist` (tham chiếu `nearby_map` README).
- **Thông báo:** cấu hình kênh Android và capability iOS cho FCM/local notifications.

## Icon launcher

Cấu hình `flutter_launcher_icons` trong `pubspec.yaml` (ảnh `assets/images/logo_app.png`).

## Điều hướng (GoRouter)

Một số route tiêu biểu: `/` splash, `/onboarding`, `/login`, `/register`, `/home`, `/map`, `/search`, `/cafe/:id`, `/cafe/:id/reviews`, `/survey`, `/profile`, `/posts`, `/posts/:id`, `/premium-plans`, `/payment/...`, `/my-cafes`, `/wishlist`, … Chi tiết trong `lib/app/router/app_router.dart` và `route_paths.dart`.

## Tài liệu theo feature

- [Wishlist](lib/features/wishlist/README.md)
- [Bản đồ lân cận (OSM)](lib/features/nearby_map/README.md)

## Tham khảo Flutter

- [Tài liệu Flutter](https://docs.flutter.dev/)
- [Cookbook](https://docs.flutter.dev/cookbook)
