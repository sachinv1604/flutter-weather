import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  // ⚠️ REPLACE THIS WITH YOUR ACTUAL API KEY FROM OPENWEATHERMAP
  static const String _apiKey = 'your api key here';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Fetch current weather by city name
  Future<Weather> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please check the city name.');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch current weather by coordinates
  Future<Weather> getCurrentWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch 5-day forecast by city name
  Future<Forecast> getForecastByCity(String cityName) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Forecast.fromJson(data);
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch 5-day forecast by coordinates
  Future<Forecast> getForecastByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Forecast.fromJson(data);
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}