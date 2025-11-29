import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// QUAN TRỌNG: Import DangNhap từ file dang_nhap.dart
import 'package:proup/dang_nhap.dart';
// Import Firebase options
import 'firebase_options.dart';
// Import Firebase options

// ******* GLOBAL FIREBASE INSTANCES *******
// Khai báo các biến toàn cục để các màn hình khác có thể sử dụng
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
// *****************************************

void main() async {
  // BẮT BUỘC: Đảm bảo Flutter bindings đã được khởi tạo trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized(); 

  // KHỞI TẠO FIREBASE CORE
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); 
    print("Firebase đã khởi tạo thành công!");
  } catch (e) {
    print(" Lỗi Khởi tạo Firebase: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Color primaryColor = const Color(0xFF2196F3); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProgUp App',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      // Màn hình bắt đầu của ứng dụng là DangNhap
      home: const DangNhap(), 
    );
  }
}