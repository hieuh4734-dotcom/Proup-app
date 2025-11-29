import 'package:flutter/material.dart';
import 'package:proup/main.dart'; // Truy cập auth
import 'package:proup/dang_nhap.dart'; // Chuyển về Login (dang_nhap)

class TrangChu extends StatelessWidget {
  const TrangChu({super.key});

  void _logout(BuildContext context) async {
    // SỬ DỤNG BIẾN 'auth' từ main.dart
    await auth.signOut();
    // Chuyển người dùng về màn hình Đăng nhập và xóa stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DangNhap()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng đang đăng nhập
    final user = auth.currentUser;
    final primaryColor = const Color(0xFF2196F3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Đăng Xuất',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.check_circle_outline, color: Color(0xFF00C853), size: 100),
              const SizedBox(height: 20),
              const Text(
                'Đăng nhập thành công!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Chào mừng ${user?.email ?? 'Người dùng'}!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Đăng Xuất'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}