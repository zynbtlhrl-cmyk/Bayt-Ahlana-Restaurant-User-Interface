import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> getCategories() async {
    try {
      final url = Uri.parse('$baseUrl/api/categories');

      print('REQUEST URL: $url');

      final response = await http.get(url);

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('SUCCESS: ${data['success']}');
        print('CATEGORIES: ${data['categories']}');

        if (data['success'] == true) {
          return data['categories'] ?? [];
        }

        throw Exception('Laravel لم يرجع success');
      }

      throw Exception('فشل جلب الأقسام. Status: ${response.statusCode}');
    } catch (e) {
      print('CATEGORY ERROR: $e');
      rethrow;
    }
  }
}
