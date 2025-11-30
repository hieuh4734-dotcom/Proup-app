import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proup/chon_vai_tro.dart'; 
import 'package:proup/dang_nhap.dart'; 
import 'package:proup/main.dart'; // Giả định chứa các biến global 'auth' và 'db'

// Class phải khớp với tên được gọi (DangKy)
class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final TextEditingController _nameController = TextEditingController(); 
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF2196F3);
  final Color secondaryColor = const Color(0xFF1E88E5);
  final Color accentColor = const Color(0xFF00C853); 

  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin.');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Mật khẩu và Xác nhận mật khẩu không khớp.');
      return;
    }
    
    if (password.length < 6) {
      _showSnackBar('Mật khẩu phải tối thiểu 6 ký tự.');
      return;
    }
    
    if (!email.contains('@') || !email.contains('.')) {
        _showSnackBar('Vui lòng nhập định dạng Email hợp lệ.', isError: true);
        return;
    }

    setState(() { _isLoading = true; });

    try {
      // 1. ĐĂNG KÝ BẰNG EMAIL/PASSWORD
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Cập nhật tên hiển thị
        await user.updateDisplayName(name);

        // Lấy __app_id từ môi trường (hoặc dùng giá trị mặc định)
        const appId = String.fromEnvironment('__app_id', defaultValue: 'default-app-id');
        
        // 2. LƯU THÔNG TIN CƠ BẢN VÀO FIRESTORE (PUBLIC data)
        await db.collection('artifacts/$appId/public/data/users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(), 
          'level': 1, // Khởi tạo level cho người dùng mới
          'score': 0, // Khởi tạo điểm
        });
        
        _showSnackBar('Đăng ký thành công! Vui lòng chọn vai trò của bạn.', isError: false);
        
        // Điều hướng đến trang Chọn Vai Trò
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const ChonVaiTro()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Địa chỉ email không hợp lệ.';
      } else {
        errorMessage = 'Lỗi đăng ký: ${e.message}';
        print('LỖI FIREBASE AUTH (CODE: ${e.code}): ${e.message}');
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      // ĐÃ SỬA: In lỗi chi tiết ra console để debug
      print('LỖI KHÔNG XÁC ĐỊNH KHI ĐĂNG KÝ: $e'); 
      _showSnackBar('Đã xảy ra lỗi không xác định. Vui lòng thử lại. (Kiểm tra Console Log)');
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Widget con để tạo trường nhập liệu (TextField) - GIỮ NGUYÊN UI CỦA BẠN
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required TextInputType keyboardType,
  }) {
    // Chỉ kiểm soát visibility cho trường mật khẩu
    bool isPasswordEntry = (controller == _passwordController || controller == _confirmPasswordController);
    
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
        suffixIcon: isPasswordEntry && controller == _passwordController // Chỉ cho phép toggle mật khẩu chính
          ? IconButton(
              icon: Icon( _isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: primaryColor, ),
              onPressed: () { setState(() { _isPasswordVisible = !_isPasswordVisible; }); },
            )
          : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // PHẦN HEADER UI (GIỮ NGUYÊN UI CỦA BẠN)
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
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flash_on, color: Colors.white, size: 40),
                        SizedBox(width: 8),
                        Text(
                          'ProgUp', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Tạo Tài Khoản Mới',
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
            
            // PHẦN BODY CHỨA FORM (GIỮ NGUYÊN UI CỦA BẠN)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Trường Họ và tên
                  _buildInputField(
                    controller: _nameController,
                    hintText: 'Nhập Họ và tên',
                    icon: Icons.person_pin, isPassword: false, 
                    keyboardType: TextInputType.text
                  ),
                  
                  const SizedBox(height: 15),

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
                    hintText: 'Nhập mật khẩu (tối thiểu 6 ký tự)',
                    icon: Icons.lock_outline, isPassword: true, 
                    keyboardType: TextInputType.text
                  ),
                  
                  const SizedBox(height: 15),

                  // Trường Xác nhận Mật khẩu
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Xác nhận lại mật khẩu',
                    icon: Icons.lock_reset, isPassword: true, 
                    keyboardType: TextInputType.text
                  ),

                  const SizedBox(height: 40),

                  // Nút Tạo Tài Khoản
                  SizedBox(
                    height: 50,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(color: accentColor))
                        : ElevatedButton(
                            onPressed: _handleSignup, 
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, 
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ),
                              elevation: 5,
                            ),
                            child: const Text('Tạo Tài Khoản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                          ),
                  ),

                  const SizedBox(height: 20),
                  
                  // LIÊN KẾT CHUYỂN SANG ĐĂNG NHẬP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đã có tài khoản? ', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          // Điều hướng sang màn hình Đăng nhập (DangNhap)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DangNhap()),
                          );
                        },
                        child: Text(
                          'Đăng Nhập', 
                          style: TextStyle(
                            color: primaryColor, // Dùng màu xanh dương để phân biệt
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
}