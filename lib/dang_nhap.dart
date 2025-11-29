import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proup/main.dart'; // Truy cập auth và db
import 'package:proup/trang_chu.dart'; // Trang chủ sau khi đăng nhập
import 'package:proup/dang_ky.dart'; // Trang Đăng ký

// Class DangNhap
class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF2196F3);
  final Color secondaryColor = const Color(0xFF1E88E5);
  final Color accentColor = const Color(0xFF00C853); 

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ Email và Mật khẩu.');
      return;
    }
    
    // Kiểm tra định dạng email cơ bản
    if (!email.contains('@') || !email.contains('.')) {
        _showSnackBar('Vui lòng nhập định dạng Email hợp lệ.', isError: true);
        return;
    }

    setState(() { _isLoading = true; });

    try {
      // 1. ĐĂNG NHẬP BẰNG EMAIL/PASSWORD
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _showSnackBar('Đăng nhập thành công! Chuyển sang Trang Chủ.', isError: false);
      
      // 2. Điều hướng đến Trang Chủ và xóa stack 
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const TrangChu()), 
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy tài khoản với Email này.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không đúng.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Địa chỉ email không hợp lệ.';
      } else {
        errorMessage = 'Lỗi đăng nhập: ${e.message}';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : accentColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // PHẦN HEADER UI
            Container(
              height: size.height * 0.45, 
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
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))],
              ),
              child: const SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: Colors.white, size: 40),
                        SizedBox(width: 8),
                        Text(
                          'ProUp', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Học Đi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // PHẦN BODY CHỨA FORM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Trường Email
                  _buildInputField(
                    controller: _emailController,
                    hintText: 'Nhập Email',
                    icon: Icons.email_outlined, isPassword: false, 
                    keyboardType: TextInputType.emailAddress
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Trường Mật khẩu
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Nhập mật khẩu',
                    icon: Icons.lock_outline, isPassword: true, 
                    keyboardType: TextInputType.text
                  ),
                  
                  const SizedBox(height: 20),

                  // Nút Đăng Nhập
                  SizedBox(
                    height: 50,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(color: accentColor))
                        : ElevatedButton(
                            onPressed: _handleLogin, 
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, 
                              backgroundColor: primaryColor, // Màu xanh dương
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ),
                              elevation: 5,
                            ),
                            child: const Text('Đăng Nhập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                          ),
                  ),

                  const SizedBox(height: 20),
                  
                  // Chuyển sang Đăng ký
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có tài khoản? ', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          // Điều hướng sang màn hình Đăng ký
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DangKy()), // Dùng class DangKy
                          );
                        },
                        child: Text(
                          'Tạo Tài Khoản Mới', 
                          style: TextStyle(
                            color: accentColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để tạo trường nhập liệu (TextField)
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required TextInputType keyboardType,
  }) {
    // Chỉ kiểm soát visibility cho trường mật khẩu
    bool isPasswordEntry = controller == _passwordController;
    
    return TextField(
      controller: controller, 
      obscureText: isPassword && !_isPasswordVisible, 
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        prefixIcon: Icon( icon, color: primaryColor, size: 24, ),
        suffixIcon: isPasswordEntry
          ? IconButton(
              icon: Icon( _isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: primaryColor, ),
              onPressed: () { setState(() { _isPasswordVisible = !_isPasswordVisible; }); },
            )
          : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
    );
  }
}


