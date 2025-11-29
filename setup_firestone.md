# 🔥 HƯỚNG DẪN TẠO FIREBASE PROJECT

---

## Bước 1: Truy Cập Firebase Console

1. Mở trình duyệt và vào: https://console.firebase.google.com/
2. Đăng nhập bằng tài khoản Google của bạn
3. Bạn sẽ thấy màn hình Firebase Console

---

## Bước 2: Tạo Project Mới

1. Click vào nút **"Add project"** (hoặc "Thêm dự án" nếu tiếng Việt)

2. **Màn hình 1 - Đặt tên project:**
   - Nhập tên project: `ProUp-App` (hoặc tên bạn thích)
   - Bạn sẽ thấy Project ID tự động tạo (ví dụ: `proup-app-xxxxx`)
   - Click **"Continue"**

3. **Màn hình 2 - Google Analytics:**
   - Tắt toggle "Enable Google Analytics for this project" (không cần thiết cho bây giờ)
   - Click **"Create project"**

4. Đợi Firebase tạo project (khoảng 10-30 giây)

5. Click **"Continue"** khi thấy "Your new project is ready"

---

## Bước 3: Tổng Quan Project

Bây giờ bạn đang ở **Dashboard** của Firebase project. Bạn sẽ thấy:
- Tên project ở góc trên bên trái
- Menu bên trái với các tùy chọn: Authentication, Firestore Database, Storage, etc.

---

## Bước 4: Bật Authentication (Xác Thực)

1. Trong menu bên trái, click vào **"Authentication"**
2. Click nút **"Get started"**
3. Chọn tab **"Sign-in method"** (phương thức đăng nhập)
4. Tìm **"Email/Password"** trong danh sách
   - Click vào dòng "Email/Password"
   - Toggle **"Enable"** (bật lên)
   - Click **"Save"**

✅ **Xong!** Bây giờ app của bạn có thể đăng ký/đăng nhập bằng email và mật khẩu.

---

## Bước 5: Tạo Firestore Database

1. Trong menu bên trái, click vào **"Firestore Database"**
2. Click nút **"Create database"**
3. **Chọn chế độ bảo mật:**
   - Chọn **"Start in test mode"** (chế độ test - cho phép đọc/ghi tự do trong 30 ngày)
   - Click **"Next"**
4. **Chọn vị trí (Location):**
   - Chọn **"asia-southeast1 (Singapore)"** hoặc gần Việt Nam nhất
   - Click **"Enable"**
5. Đợi Firestore khởi tạo (khoảng 10-20 giây)

✅ **Xong!** Firestore database đã được tạo.

---

## Bước 6: Cấu Hình Firestore Security Rules

1. Trong Firestore Database, click tab **"Rules"** (ở trên cùng)

2. Bạn sẽ thấy rules mặc định:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 30);
    }
  }
}
```

3. **Thay thế bằng rules này** (để bảo mật hơn):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cho phép đọc/ghi user data khi đã đăng nhập
    match /artifacts/{appId}/public/data/users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

4. Click **"Publish"** để lưu

✅ **Xong!** Firestore rules đã được cấu hình.

---

## Bước 7: Thêm Android App vào Project

1. Quay lại **Project Overview** (click logo Firebase ở góc trên bên trái)

2. Click vào biểu tượng **Android** (`</>` với logo Android)

3. **Điền thông tin app:**
   - **Android package name:** `com.example.proup`
     - ⚠️ **QUAN TRỌNG:** Phải giống với `applicationId` trong file `android/app/build.gradle.kts` của bạn
   - **App nickname (optional):** `ProUp Android`
   - **Debug signing certificate SHA-1 (optional):** Để trống
   - Click **"Register app"**

4. **Download google-services.json:**
   - Click nút **"Download google-services.json"**
   - Lưu file này vào máy tính

5. Click **"Next"** → Click **"Next"** → Click **"Continue to console"**

---

## ✅ HOÀN TẤT!

Bây giờ Firebase project của bạn đã có:
- ✅ Authentication (Email/Password enabled)
- ✅ Firestore Database (đã tạo và cấu hình rules)
- ✅ Android App (đã đăng ký)
- ✅ File `google-services.json` (đã download)

