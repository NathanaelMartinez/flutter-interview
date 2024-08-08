import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityService {
  final String apiKey = dotenv.env['ACCUWEATHER_API_KEY'] ?? '';

  Future<List<String>> fetchCities(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final url = Uri.parse(
        'http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=$apiKey&q=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        if (data is List) {
          return data
              .map<String>((city) => city['LocalizedName'] as String)
              .toList();
        } else {
          throw Exception('Unexpected JSON format');
        }
      } catch (e) {
        throw Exception('Failed to parse cities');
      }
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
