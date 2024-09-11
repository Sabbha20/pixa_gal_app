import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PixabayService {
  static final String? _apiKey = dotenv.env['PIXABAY_API_KEY'];
  static const String _baseUrl = 'https://pixabay.com/api/';

  Future<List<Map<String, dynamic>>> searchImages(
      String query, int page) async {
    if (_apiKey == null) {
      throw Exception('Pixabay API key not found in .env file');
    }

    final response = await http.get(
      Uri.parse(
          '$_baseUrl?key=$_apiKey&q=${Uri.encodeComponent(query)}&page=$page&per_page=20'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['hits']);
    } else {
      throw Exception('Failed to load images');
    }
  }
}
