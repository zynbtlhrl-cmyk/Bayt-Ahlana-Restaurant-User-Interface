import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // جلب توكن الحساب الحالي
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('يرجى تسجيل الدخول أولاً');
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // جلب طلبات الحساب الحالي
  static Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: await _headers(),
      );

      print('GET ORDERS STATUS: ${response.statusCode}');
      print('GET ORDERS RESPONSE: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('فشل جلب الطلبات: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data is List) return data;

      if (data is Map) {
        final orders = data['orders'] ?? data['data'];
        if (orders is List) return orders;
      }

      return [];
    } catch (e) {
      print('GET ORDERS ERROR: $e');
      rethrow;
    }
  }

  // إنشاء طلب للحساب الحالي
  static Future<bool> createOrder({
    required String customerName,
    required String phone,
    required String address,
    required String foodName,
    required int quantity,
    required double totalPrice,
    String orderType = 'normal',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: await _headers(),
        body: jsonEncode({
          'customer_name': customerName,
          'phone': phone,
          'address': address,
          'food_name': foodName,
          'quantity': quantity,
          'total_price': totalPrice,
          'order_type': orderType,
        }),
      );

      print('CREATE ORDER STATUS: ${response.statusCode}');
      print('CREATE ORDER RESPONSE: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('CREATE ORDER ERROR: $e');
      return false;
    }
  }

  // إلغاء طلب من الحساب الحالي
  static Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: await _headers(),
      );

      print('CANCEL ORDER STATUS: ${response.statusCode}');
      print('CANCEL ORDER RESPONSE: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('CANCEL ORDER ERROR: $e');
      return false;
    }
  }
}
