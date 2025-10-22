# Nearby Map Feature (OpenStreetMap)

## Tổng quan

Feature này cho phép người dùng xem bản đồ hiển thị các quán cafe gần vị trí hiện tại của họ trong một bán kính nhất định. Sử dụng **OpenStreetMap** - giải pháp **100% miễn phí** và **không cần API key**.

## Cấu trúc

```
lib/features/nearby_map/
├── view/
│   ├── map_page.dart              # Trang chính hiển thị bản đồ
│   └── widgets/
│       ├── cafe_map_view.dart     # Widget flutter_map với OpenStreetMap
│       └── cafe_bottom_sheet.dart # Bottom sheet hiển thị thông tin cafe
└── viewmodel/
    ├── map_bloc.dart              # Business logic
    ├── map_event.dart             # Events
    └── map_state.dart             # States
```

## Tính năng

### 1. Hiển thị bản đồ OpenStreetMap
- Sử dụng `flutter_map` package
- OpenStreetMap tiles miễn phí
- **Không cần API key**
- Hiển thị vị trí hiện tại của người dùng (marker xanh)
- Hiển thị các quán cafe gần đó (marker cam/nâu)

### 2. Markers
- **Marker vị trí hiện tại**: Màu xanh, icon `my_location`, có border và shadow
- **Marker cafe**: Màu nâu/cam, icon `coffee`, tăng size khi được chọn
- **Interactive**: Tap vào marker để xem chi tiết

### 3. Tương tác
- Tap vào marker cafe để xem thông tin chi tiết
- Bottom sheet hiển thị:
  - Hình ảnh cafe
  - Tên cafe
  - Đánh giá (rating)
  - Khoảng cách
  - Nút "Xem chi tiết" để điều hướng đến trang chi tiết cafe
- Pinch to zoom
- Drag to pan
- Double tap to zoom in

### 4. Điều khiển bản đồ
- **Nút refresh**: Làm mới danh sách cafe gần đó
- **Nút current location**: Quay về vị trí hiện tại
- **Header**: Hiển thị tiêu đề và số lượng cafe tìm thấy
- **Zoom controls**: Tự động qua gestures

## States

### MapInitial
State khởi tạo ban đầu.

### MapLoading
Đang load dữ liệu cafe từ API.

### MapLoaded
Đã load thành công:
- `cafes`: Danh sách cafe
- `currentLatitude`, `currentLongitude`: Vị trí hiện tại
- `selectedCafeId`: ID của cafe đang được chọn (nếu có)
- `zoom`: Mức zoom hiện tại (default: 14.0)

### MapError
Có lỗi xảy ra với thông báo lỗi.

### MapLocationPermissionDenied
Người dùng từ chối quyền truy cập vị trí.

## Events

### LoadNearbyCafesOnMap
Load danh sách cafe gần vị trí được chỉ định.

**Parameters:**
- `latitude`: Vĩ độ
- `longitude`: Kinh độ
- `maxDistanceKm`: Bán kính tối đa (mặc định: 10km)
- `pageSize`: Số lượng cafe tối đa (mặc định: 50)

### SelectCafeMarker
Chọn một cafe marker để xem chi tiết.

### DeselectCafeMarker
Bỏ chọn cafe marker hiện tại.

### UpdateCurrentLocation
Cập nhật vị trí hiện tại của người dùng.

### RefreshNearbyCafes
Làm mới danh sách cafe gần đó.

### UpdateMapZoom
Cập nhật mức zoom của bản đồ.

## Dependencies

- `flutter_map: ^6.1.0`: Widget bản đồ với OpenStreetMap
- `latlong2: ^0.9.0`: Xử lý tọa độ latitude/longitude
- `geolocator`: Lấy vị trí hiện tại
- `flutter_bloc`: State management
- `go_router`: Navigation

## Navigation

Từ Home page, người dùng có thể tap vào nút "Xem bản đồ quán cafe gần đây" để điều hướng đến `/map`.

## Quyền cần thiết

### Android
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>App cần quyền truy cập vị trí để hiển thị quán cafe gần bạn trên bản đồ</string>
```

## OpenStreetMap Setup

**Tin tốt: KHÔNG CẦN SETUP GÌ CẢ!** 🎉

OpenStreetMap hoàn toàn miễn phí và không yêu cầu API key. Chỉ cần:

```bash
flutter run
```

Xem chi tiết tại `OPENSTREETMAP_SETUP.md` ở root directory.

## Tile Providers

Hiện tại sử dụng OpenStreetMap standard tiles:
```
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

Có thể dễ dàng thay đổi sang providers khác như:
- CartoDB Positron (light theme)
- CartoDB Dark Matter (dark theme)
- OpenStreetMap HOT

Chi tiết trong `OPENSTREETMAP_SETUP.md`.

## Usage Example

```dart
// Navigate to map page
context.push('/map');

// From HomePage
GestureDetector(
  onTap: () {
    context.push('/map');
  },
  child: const Text('Xem bản đồ'),
)
```

## Customization

### Thay đổi Tile Provider

File: `lib/features/nearby_map/view/widgets/cafe_map_view.dart`

```dart
TileLayer(
  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  subdomains: ['a', 'b', 'c', 'd'],
  userAgentPackageName: 'com.briewview.app',
)
```

### Thay đổi Marker Style

Trong `_buildMarkers()` method:

```dart
Marker(
  point: LatLng(lat, lng),
  width: 50,
  height: 50,
  child: Icon(Icons.coffee, color: Colors.brown, size: 30),
)
```

## Ưu điểm OpenStreetMap

✅ **Miễn phí 100%** - Không lo billing
✅ **Không cần API key** - Setup cực nhanh
✅ **Open source** - Cộng đồng mạnh
✅ **Privacy** - Không tracking người dùng
✅ **Flexible** - Nhiều tile providers
✅ **Offline support** - Có thể cache tiles

## Notes

- Feature này hoàn toàn miễn phí, không giới hạn
- Map hoạt động tốt trên cả emulator và thiết bị thật
- LocationService phải được khởi tạo trước khi sử dụng
- Cafe phải có latitude và longitude để hiển thị trên bản đồ
- Attribution cho OpenStreetMap là bắt buộc (đã tích hợp sẵn)

## Performance Tips

- Reduce số lượng markers nếu quá nhiều
- Implement marker clustering cho nhiều cafes
- Cache tiles cho offline usage
- Sử dụng simpler tile providers nếu cần

## Support

- [flutter_map Documentation](https://docs.fleaflet.dev/)
- [OpenStreetMap Wiki](https://wiki.openstreetmap.org/)
- [Tile Servers](https://wiki.openstreetmap.org/wiki/Tile_servers)
