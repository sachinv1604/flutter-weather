import 'package:flutter/material.dart';
import '../models/weather.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;
  final bool isCelsius;

  const CurrentWeatherCard({
    Key? key,
    required this.weather,
    required this.isCelsius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(),
          ),
        ),
        child: Column(
          children: [
            // City name
            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // Weather icon and temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weather.getIconUrl(),
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.cloud,
                      size: 120,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(width: 20),
                Text(
                  weather.getFormattedTemp(isCelsius),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Additional info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.thermostat,
                  'Feels Like',
                  isCelsius
                      ? '${weather.feelsLike.round()}°C'
                      : '${((weather.feelsLike * 9 / 5) + 32).round()}°F',
                ),
                _buildInfoItem(
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity}%',
                ),
                _buildInfoItem(
                  Icons.air,
                  'Wind',
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors() {
    // Different gradients based on weather description
    final desc = weather.description.toLowerCase();
    
    if (desc.contains('clear') || desc.contains('sun')) {
      return [Colors.orange.shade400, Colors.deepOrange.shade600];
    } else if (desc.contains('cloud')) {
      return [Colors.grey.shade600, Colors.blueGrey.shade700];
    } else if (desc.contains('rain') || desc.contains('drizzle')) {
      return [Colors.blue.shade600, Colors.indigo.shade700];
    } else if (desc.contains('snow')) {
      return [Colors.lightBlue.shade300, Colors.blue.shade500];
    } else if (desc.contains('thunder')) {
      return [Colors.purple.shade700, Colors.deepPurple.shade900];
    } else {
      return [Colors.blue.shade500, Colors.blue.shade700];
    }
  }
}