import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // حفظ بيانات الحساب والتوكن
  static Future<void> saveSession(Map<String, dynamic> result) async {
    final prefs = await SharedPreferences.getInstance();

    if (result['token'] != null) {
      await prefs.setString('auth_token', result['token'].toString());
    }

    if (result['user'] != null) {
      await prefs.setString('user', jsonEncode(result['user']));
    }
  }

  // إنشاء حساب
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final result = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      await saveSession(result);
    }

    return result;
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final result = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode == 200) {
      await saveSession(result);
    }

    return result;
  }

  // جلب بيانات المستخدم المحفوظة
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData == null) return null;

    return Map<String, dynamic>.from(jsonDecode(userData));
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('user');
  }
}
