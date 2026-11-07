import 'dart:convert';
import 'package:http/http.dart' as http;

class MealService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // جلب جميع الأكلات
  static Future<List<dynamic>> getMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/api/meals'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['meals'] ?? [];
    }

    throw Exception('فشل جلب الأكلات');
  }

  // جلب أكلات قسم معين
  static Future<List<dynamic>> getMealsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories/$categoryId/meals'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['meals'] ?? [];
    }

    throw Exception('فشل جلب أكلات القسم');
  }
}
