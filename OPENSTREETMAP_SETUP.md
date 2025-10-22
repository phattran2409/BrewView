# Hướng dẫn sử dụng OpenStreetMap (flutter_map)

## 🎉 Tin tốt: 100% MIỄN PHÍ - Không cần API Key!

OpenStreetMap là giải pháp bản đồ **hoàn toàn miễn phí**, mã nguồn mở, và không yêu cầu đăng ký API key như Google Maps.

## ✅ Đã cài đặt sẵn

Dự án đã được cấu hình để sử dụng OpenStreetMap thông qua package `flutter_map`:

```yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
```

## 🚀 Sử dụng ngay

**Không cần cấu hình gì thêm!** App đã sẵn sàng chạy:

```bash
flutter run
```

## 🗺️ Tính năng

### 1. Tile Providers
Hiện tại đang sử dụng OpenStreetMap tiles miễn phí:
- URL: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **Hoàn toàn miễn phí**
- Không giới hạn requests
- Cập nhật thường xuyên bởi cộng đồng

### 2. Markers
- **Current Location**: Marker màu xanh với icon `my_location`
- **Cafe Markers**: Marker màu nâu/cam với icon `coffee`
- **Interactive**: Tap để xem thông tin chi tiết

### 3. Map Controls
- Zoom in/out bằng pinch gesture
- Pan/drag để di chuyển
- Double tap để zoom in
- Two-finger tap để zoom out

## 📱 Quyền truy cập

### Android
Đã có sẵn trong `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS
Đã có sẵn trong `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>App cần quyền truy cập vị trí để hiển thị quán cafe gần bạn</string>
```

## 🎨 Custom Styles (Tùy chọn)

### Các Tile Providers khác bạn có thể dùng:

#### 1. **OpenStreetMap Standard** (Hiện tại)
```dart
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
```
- ✅ Miễn phí
- ✅ Style chuẩn
- ✅ Cập nhật thường xuyên

#### 2. **OpenStreetMap HOT** (Humanitarian)
```dart
urlTemplate: 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png'
subdomains: ['a', 'b']
```
- ✅ Miễn phí
- ✅ Tập trung vào thông tin nhân đạo

#### 3. **CartoDB Positron** (Light theme)
```dart
urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'
subdomains: ['a', 'b', 'c', 'd']
```
- ✅ Miễn phí
- ✅ Giao diện sáng, tối giản
- ✅ Đẹp cho ứng dụng hiện đại

#### 4. **CartoDB Dark Matter** (Dark theme)
```dart
urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
subdomains: ['a', 'b', 'c', 'd']
```
- ✅ Miễn phí
- ✅ Giao diện tối
- ✅ Phù hợp với dark mode

### Cách thay đổi Tile Provider:

File: `lib/features/nearby_map/view/widgets/cafe_map_view.dart`

```dart
TileLayer(
  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  subdomains: ['a', 'b', 'c', 'd'],
  userAgentPackageName: 'com.briewview.app',
),
```

## 🔧 Offline Maps (Nâng cao)

Nếu muốn hỗ trợ offline:

1. Thêm package:
```yaml
dependencies:
  flutter_map_tile_caching: ^9.0.0
```

2. Download tiles trước và cache

## 🆚 So sánh với Google Maps

| Feature | Google Maps | OpenStreetMap |
|---------|------------|---------------|
| **Giá** | $200 free/tháng → $7/1000 loads | **Miễn phí vĩnh viễn** |
| **API Key** | Bắt buộc | **Không cần** |
| **Setup** | Phức tạp | **Cực đơn giản** |
| **Offline** | ❌ | ✅ |
| **Custom Style** | Có hạn | ✅✅✅ |
| **Open Source** | ❌ | ✅ |
| **Data** | Google proprietary | Cộng đồng |
| **Privacy** | Google tracking | **Không tracking** |

## 📖 Documentation

- [flutter_map Documentation](https://docs.fleaflet.dev/)
- [OpenStreetMap Wiki](https://wiki.openstreetmap.org/)
- [Tile Servers List](https://wiki.openstreetmap.org/wiki/Tile_servers)

## ⚠️ Best Practices

### 1. Attribution
**BẮT BUỘC**: Phải hiển thị attribution cho OpenStreetMap (đã có sẵn trong code):
```dart
RichAttributionWidget(
  attributions: [
    TextSourceAttribution('OpenStreetMap contributors'),
  ],
)
```

### 2. Rate Limiting
- OpenStreetMap tiles miễn phí nhưng có rate limit
- Tránh spam requests
- Sử dụng caching khi có thể

### 3. User Agent
Đã set `userAgentPackageName` để identify app:
```dart
userAgentPackageName: 'com.briewview.app'
```

## 🐛 Troubleshooting

### 1. Tiles không load
- Kiểm tra internet connection
- Kiểm tra permission INTERNET trong AndroidManifest.xml
- Thử tile provider khác

### 2. Map hiển thị màu xám
- Đợi tiles load
- Kiểm tra console logs
- Thử zoom in/out

### 3. Performance issues
- Reduce marker count
- Implement clustering
- Use simpler tile providers

## 🎯 Kết luận

OpenStreetMap với flutter_map là lựa chọn hoàn hảo vì:

✅ **Miễn phí 100%** - Không lo về billing
✅ **Không cần API key** - Setup trong 5 phút
✅ **Privacy-friendly** - Không tracking người dùng
✅ **Flexible** - Nhiều tile providers và styles
✅ **Open Source** - Cộng đồng support tốt

**Chỉ cần `flutter run` và tận hưởng! 🎉**


