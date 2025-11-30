import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proup/main.dart';
import 'package:proup/dang_nhap.dart';

class TrangChuGiaoVien extends StatefulWidget {
  const TrangChuGiaoVien({super.key});

  @override
  State<TrangChuGiaoVien> createState() => _TrangChuGiaoVienState();
}

class _TrangChuGiaoVienState extends State<TrangChuGiaoVien> {
  final Color primaryColor = const Color(0xFF9C27B0); // Màu tím cho giáo viên
  final Color secondaryColor = const Color(0xFF7B1FA2);
  final Color accentColor = const Color(0xFFE040FB);

  String _userName = 'Giáo viên';
  int _totalStudents = 0;
  int _totalClasses = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        const appId = String.fromEnvironment('__app_id', defaultValue: 'default-app-id');
        final doc = await db.collection('artifacts/$appId/public/data/users').doc(user.uid).get();
        
        if (doc.exists && mounted) {
          final data = doc.data();
          setState(() {
            _userName = data?['name'] ?? user.displayName ?? 'Giáo viên';
            _totalStudents = data?['totalStudents'] ?? 0;
            _totalClasses = data?['totalClasses'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu người dùng: $e');
    }
  }

  void _logout(BuildContext context) async {
    await auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DangNhap()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          '👨‍🏫 Trang Chủ Giáo Viên',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Thông báo
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Đăng Xuất',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header với thông tin user
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Xin chào, $_userName!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '👨‍🏫 Giáo Viên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Học sinh',
                      value: '$_totalStudents',
                      icon: Icons.people,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Lớp học',
                      value: '$_totalClasses',
                      icon: Icons.class_,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quản lý',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildMenuCard(
                        title: 'Quản Lý Lớp',
                        icon: Icons.class_outlined,
                        color: const Color(0xFF2196F3),
                        onTap: () {
                          // TODO: Navigate to class management
                        },
                      ),
                      _buildMenuCard(
                        title: 'Tạo Bài Tập',
                        icon: Icons.add_task,
                        color: const Color(0xFFFF9800),
                        onTap: () {
                          // TODO: Navigate to create exercise
                        },
                      ),
                      _buildMenuCard(
                        title: 'Danh Sách Học Sinh',
                        icon: Icons.people_outline,
                        color: const Color(0xFF4CAF50),
                        onTap: () {
                          // TODO: Navigate to student list
                        },
                      ),
                      _buildMenuCard(
                        title: 'Thống Kê',
                        icon: Icons.analytics_outlined,
                        color: const Color(0xFFE91E63),
                        onTap: () {
                          // TODO: Navigate to statistics
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Tạo lớp học mới
        },
        backgroundColor: accentColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tạo Lớp Mới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

