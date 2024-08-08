import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityService {
  final String apiKey = dotenv.env['ACCUWEATHER_API_KEY'] ?? '';

  Future<List<Map<String, String>>> fetchCities(String query) async {
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
          return data.map<Map<String, String>>((city) {
            return {
              'name': city['LocalizedName'] as String,
              'locationKey': city['Key'] as String,
            };
          }).toList();
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

  Future<Map<String, dynamic>> fetchCurrentConditions(
      String locationKey) async {
    final url = Uri.parse(
        'http://dataservice.accuweather.com/currentconditions/v1/$locationKey?apikey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0];
        } else {
          throw Exception('No data available');
        }
      } catch (e) {
        throw Exception('Failed to parse current conditions');
      }
    } else {
      throw Exception('Failed to load current conditions');
    }
  }
}
