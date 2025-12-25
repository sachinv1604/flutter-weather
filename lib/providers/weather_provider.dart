import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Weather? _currentWeather;
  Forecast? _forecast;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCelsius = true;
  String _lastSearchedCity = 'London'; // Default city

  Weather? get currentWeather => _currentWeather;
  Forecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCelsius => _isCelsius;

  WeatherProvider() {
    _loadPreferences();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isCelsius = prefs.getBool('isCelsius') ?? true;
    _lastSearchedCity = prefs.getString('lastCity') ?? 'London';
    notifyListeners();
    
    // Load weather for last searched city
    await fetchWeatherByCity(_lastSearchedCity);
  }

  // Save preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCelsius', _isCelsius);
    if (_currentWeather != null) {
      await prefs.setString('lastCity', _currentWeather!.cityName);
    }
  }

  // Toggle temperature unit
  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    _savePreferences();
    notifyListeners();
  }

  // Fetch weather by city name
  Future<void> fetchWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      _errorMessage = 'Please enter a city name';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecastByCity(cityName);
      _lastSearchedCity = cityName;
      await _savePreferences();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _currentWeather = null;
      _forecast = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      
      _currentWeather = await _weatherService.getCurrentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      
      _forecast = await _weatherService.getForecastByLocation(
        position.latitude,
        position.longitude,
      );

      await _savePreferences();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // If location fails, try loading last searched city
      if (_lastSearchedCity.isNotEmpty) {
        await fetchWeatherByCity(_lastSearchedCity);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh current weather
  Future<void> refresh() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}