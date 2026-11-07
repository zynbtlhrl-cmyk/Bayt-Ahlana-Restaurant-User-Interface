import 'dart:convert';
import 'package:http/http.dart' as http;

class OfferService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> getOffers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/offers'));

    print('OFFERS STATUS: ${response.statusCode}');
    print('OFFERS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return data['offers'] ?? [];
      }

      return [];
    } else {
      throw Exception('فشل جلب العروض: ${response.statusCode}');
    }
  }
}
