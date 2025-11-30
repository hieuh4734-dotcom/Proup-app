import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proup/main.dart';
import 'package:proup/trang_chu_hoc_sinh.dart';
import 'package:proup/trang_chu_giao_vien.dart';

class ChonVaiTro extends StatefulWidget {
  const ChonVaiTro({super.key});

  @override
  State<ChonVaiTro> createState() => _ChonVaiTroState();
}

class _ChonVaiTroState extends State<ChonVaiTro> {
  String? _selectedRole;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF2196F3);
  final Color secondaryColor = const Color(0xFF1E88E5);
  final Color accentColor = const Color(0xFF00C853);
  final Color studentColor = const Color(0xFF4CAF50);
  final Color teacherColor = const Color(0xFF9C27B0);

  Future<void> _saveRoleAndNavigate() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn vai trò của bạn'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final user = auth.currentUser;
      if (user != null) {
        const appId = String.fromEnvironment('__app_id', defaultValue: 'default-app-id');
        
        // Cập nhật vai trò vào Firestore
        await db.collection('artifacts/$appId/public/data/users').doc(user.uid).update({
          'role': _selectedRole,
          'roleSelectedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          // Chuyển hướng dựa trên vai trò
          if (_selectedRole == 'hoc_sinh') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TrangChuHocSinh()),
              (route) => false,
            );
          } else if (_selectedRole == 'giao_vien') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TrangChuGiaoVien()),
              (route) => false,
            );
          }
        }
      }
    } catch (e) {
      print('Lỗi khi lưu vai trò: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? color.withOpacity(0.3) : Colors.black12,
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 15),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            // Checkmark
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 30,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: size.height * 0.30,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Chọn Vai Trò',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bạn là ai trong hệ thống?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Role Selection Cards
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // Học sinh card
                  _buildRoleCard(
                    role: 'hoc_sinh',
                    title: '🎓 Học Sinh',
                    description: 'Tham gia học tập, làm bài tập và theo dõi tiến độ học',
                    icon: Icons.school,
                    color: studentColor,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Giáo viên card
                  _buildRoleCard(
                    role: 'giao_vien',
                    title: '👨‍🏫 Giáo Viên',
                    description: 'Quản lý lớp học, tạo bài tập và theo dõi học sinh',
                    icon: Icons.person,
                    color: teacherColor,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(color: accentColor))
                        : ElevatedButton(
                            onPressed: _selectedRole != null ? _saveRoleAndNavigate : null,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _selectedRole != null ? accentColor : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Xác Nhận Vai Trò',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Note
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Lưu ý: Vai trò này sẽ được gán vĩnh viễn cho tài khoản của bạn.',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

