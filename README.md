# 🎯 E-Trainer Mobile

> **Nền tảng học tập tương tác Flutter với giao diện tiếng Việt và thiết kế Material 3 hiện đại**

[![Flutter](https://img.shields.io/badge/Flutter-3.32.7-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](#)

## 📱 Giới thiệu E-Trainer

E-Trainer là một nền tảng học tập di động toàn diện được xây dựng bằng Flutter, có tính năng hệ thống học tập theo hành trình tương tác, giao diện tiếng Việt và thiết kế Material 3 hiện đại. Ứng dụng cung cấp trải nghiệm giáo dục hấp dẫn với hiệu ứng động, câu đố và theo dõi tiến độ.

## ✨ Tính năng

### 🔐 **Hệ thống xác thực**
- Tích hợp đăng nhập Google
- Xác thực người dùng an toàn
- Quản lý hồ sơ cá nhân

### 🗺️ **Học tập theo hành trình**
- Các giai đoạn học tập tương tác
- Hệ thống theo dõi tiến độ
- Gợi ý bài học hàng ngày
- Phần thưởng hoàn thành giai đoạn

### 🧠 **Câu đố tương tác**
- Hệ thống quiz có timer
- Phản hồi thời gian thực
- Câu hỏi trắc nghiệm
- Hiệu ứng chuyển tiếp mượt mà
- Phân tích hiệu suất

### 🎨 **UI/UX hiện đại**
- Hệ thống thiết kế Material 3
- Giao diện tiếng Việt
- Hỗ trợ chế độ tối/sáng
- Hiệu ứng động và chuyển tiếp mượt mà
- Thiết kế đáp ứng

### 📊 **Chế độ luyện tập**
- Hiệu ứng loading shimmer
- Ngân hàng câu hỏi toàn diện
- Phản hồi kết quả ngay lập tức
- Trực quan hóa tiến độ

### 🔧 **Tính năng kỹ thuật**
- Hỗ trợ offline với cơ sở dữ liệu Hive
- Quản lý state với Riverpod
- Điều hướng hiện đại với go_router
- Tích hợp Firebase
- Tối ưu hiệu suất (0 vấn đề phân tích)

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|-----------|----------|
| **Flutter 3.32.7** | Framework mobile đa nền tảng |
| **Dart 3.5.0** | Ngôn ngữ lập trình |
| **Riverpod 2.5.1** | Quản lý state |
| **go_router 13.2.5** | Điều hướng và routing |
| **Hive 2.2.3** | Cơ sở dữ liệu local cho hỗ trợ offline |
| **Firebase** | Xác thực và dịch vụ backend |
| **Material 3** | Hệ thống thiết kế hiện đại |

## 📦 Thư viện phụ thuộc

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  go_router: ^13.2.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  google_sign_in: ^6.1.6
  connectivity_plus: ^5.0.2
  flutter_local_notifications: ^16.3.2
```

## 🚀 Bắt đầu

### Yêu cầu hệ thống
- Flutter SDK (3.32.7 trở lên)
- Dart SDK (3.5.0 trở lên)
- Android Studio / VS Code
- Android SDK cho phát triển Android
- Xcode cho phát triển iOS (chỉ macOS)

### Cài đặt

1. **Clone repository**
   ```bash
   git clone https://github.com/quytttb/etrainer-mobile.git
   cd etrainer-mobile
   ```

2. **Cài đặt dependencies**
   ```bash
   flutter pub get
   ```

3. **Tạo Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Cấu hình Firebase** (Tùy chọn)
   - Thêm file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
   - Cập nhật `firebase_options.dart` với cấu hình của bạn

5. **Chạy ứng dụng**
   ```bash
   # Chế độ debug
   flutter run
   
   # Chế độ release
   flutter run --release
   ```

## 📱 Build & Triển khai

### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

### iOS App
```bash
# iOS build
flutter build ios --release
```

## 📁 Cấu trúc dự án

```
lib/
├── core/
│   ├── constants/          # Hằng số ứng dụng và themes
│   ├── providers/          # Global state providers
│   ├── routing/            # Điều hướng và routing
│   ├── services/           # Dịch vụ cốt lõi (API, Auth, v.v.)
│   └── themes/             # Cấu hình theme Material 3
├── data/
│   └── models/             # Models dữ liệu và Hive entities
├── presentation/
│   ├── providers/          # Providers riêng cho từng màn hình
│   ├── screens/            # Các màn hình UI
│   └── widgets/            # Components UI có thể tái sử dụng
└── main.dart               # Điểm khởi đầu ứng dụng
```

## 🎯 Tính năng chính đã triển khai

- ✅ **Luồng xác thực hoàn chỉnh** - Đăng nhập Google với Firebase
- ✅ **Hệ thống học tập theo hành trình** - Các giai đoạn tương tác và theo dõi tiến độ
- ✅ **Hệ thống Quiz** - Quiz có timer với hiệu ứng động
- ✅ **Chế độ luyện tập** - Luyện tập câu hỏi toàn diện
- ✅ **Giao diện tiếng Việt** - Hỗ trợ bản địa hóa đầy đủ
- ✅ **Thiết kế Material 3** - UI hiện đại với theme tối/sáng
- ✅ **Hỗ trợ Offline** - Cơ sở dữ liệu Hive cho lưu trữ local
- ✅ **Tối ưu hiệu suất** - Không có vấn đề phân tích, sẵn sàng production
- ✅ **Hiệu ứng động nâng cao** - Chuyển tiếp mượt mà và trạng thái loading

## 🔧 Cấu hình

### Tùy chỉnh Theme
Chỉnh sửa `lib/core/themes/app_theme.dart` để tùy chỉnh màu sắc và kiểu dáng.

### Thêm màn hình mới
1. Tạo màn hình trong `lib/presentation/screens/`
2. Thêm route trong `lib/core/routing/app_router.dart`
3. Cập nhật logic điều hướng

### Models cơ sở dữ liệu
1. Tạo model trong `lib/data/models/`
2. Thêm Hive annotations
3. Chạy `flutter packages pub run build_runner build`

## 🤝 Đóng góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/TinhNangTuyetVoi`)
3. Commit các thay đổi (`git commit -m 'Thêm tính năng tuyệt vời'`)
4. Push lên branch (`git push origin feature/TinhNangTuyetVoi`)
5. Mở Pull Request

## 📄 Giấy phép

Dự án này được cấp phép theo giấy phép MIT - xem file [LICENSE](LICENSE) để biết chi tiết.

## 👨‍💻 Nhà phát triển

**Quý Trần** - [@quytttb](https://github.com/quytttb)

## 🙏 Lời cảm ơn

- Đội ngũ Flutter vì framework tuyệt vời
- Đội ngũ Material Design vì hệ thống thiết kế
- Riverpod vì quản lý state xuất sắc
- Firebase vì các dịch vụ backend

---

**⭐ Nếu bạn thấy dự án này hữu ích, hãy cho một ngôi sao nhé!**
