## 📱 Giới thiệu

**MetroPass** là một ứng dụng di động được phát triển bằng Flutter, giúp người dùng:

- Đặt vé tàu điện Metro trực tuyến dễ dàng
- Tra cứu tuyến metro tại TP.HCM
- Thanh toán nhanh chóng qua VNPAY
- Theo dõi lịch trình đoàn tàu theo thời gian thực

Ứng dụng hướng tới trải nghiệm **mượt mà, tiện lợi, và dễ sử dụng cho mọi đối tượng**.

---

## 🚀 Tính năng chính

- 🎫 **Đặt vé điện tử**: Chọn loại vé → chọn tuyến → xem thông tin vé → thanh toán
- 🔍 **Tìm tuyến đường**: Gợi ý tuyến metro gần bạn bằng bản đồ Mapbox
- 💳 **Thanh toán VNPAY**: Tích hợp cổng thanh toán VNPAY bảo mật, nhanh chóng
- 📜 **Lịch sử chuyến đi**: Lưu lại vé đã mua để tra cứu hoặc dùng khi kiểm tra
- 👤 **Quản lý tài khoản**: Đăng ký, đăng nhập (Google/Firebase), cập nhật hồ sơ
- 🧠 **Trợ lý AI**: Gợi ý loại vé phù hợp theo thói quen sử dụng
- 🌗 **Đổi màu giao diện**: Hỗ trợ chuyển đổi giữa chế độ sáng và tối (Light/Dark Mode)
- 🌐 **Đổi ngôn ngữ**: Hỗ trợ đa ngôn ngữ (ví dụ: tiếng Việt, tiếng Anh)
- 🚌 **Xem thông tin xe**: Hiển thị thông tin thời gian đến của các chuyến tàu tiếp theo
- ☁️ **Dự báo thời tiết**: Tích hợp dự báo thời tiết theo vị trí của người dùng
- 📷 **Quét mã QR**: Quét mã vé QR để kiểm tra thông tin vé và vào trạm nhanh chóng


--- 

## 🛠️ Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng di động đa nền tảng (Android & iOS) với hiệu suất cao và UI hiện đại
- **Firebase Auth**: Hệ thống xác thực cho phép đăng nhập bằng Google, Email/Password
- **Cloud Firestore**: Cơ sở dữ liệu thời gian thực dùng để lưu trữ thông tin người dùng, vé, lịch sử, hành vi
- **VNPAY SDK**: Tích hợp thanh toán điện tử nội địa, hỗ trợ đa ngân hàng tại Việt Nam
- **Mapbox SDK**: Hiển thị bản đồ tương tác, tìm kiếm tuyến metro, định vị người dùng
- **Provider**: Quản lý trạng thái ứng dụng theo mô hình MVVM, đơn giản nhưng hiệu quả
- **SharedPreferences**: Lưu dữ liệu tạm (session, ngôn ngữ, chủ đề màu) trên thiết bị người dùng
- **Intl**: Hỗ trợ đa ngôn ngữ
- **Dio / http**: Gửi yêu cầu API, kết nối với server thời tiết, AI, đặt vé
- **QRCode Scanner**: Quét mã QR từ camera để xác nhận thông tin vé tại trạm


---

## 📦 Hướng dẫn cài đặt

> **Yêu cầu**: Flutter 3.13+, Dart SDK, thiết bị/emulator đã cấu hình.

```bash
# 1. Clone dự án
git clone https://github.com/LTMB-Metro/MetroPass.git
cd MetroPass

# 2. Cài đặt thư viện
flutter pub get

# 3. Tạo file cấu hình môi trường
cp .env.example .env
# rồi sửa file `.env` với các API Key cá nhân

# 4. Chạy ứng dụng
flutter run
