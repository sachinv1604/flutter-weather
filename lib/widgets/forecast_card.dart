import 'package:flutter/material.dart';
import '../models/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;
  final bool isCelsius;

  const ForecastCard({
    Key? key,
    required this.forecast,
    required this.isCelsius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyForecasts = forecast.getDailyForecasts();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5-Day Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...dailyForecasts.map((item) => _buildForecastItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(ForecastItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 50,
            child: Text(
              item.getDayName(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Weather icon
          Image.network(
            item.getIconUrl(),
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud, size: 50);
            },
          ),
          const SizedBox(width: 12),
          
          // Description
          Expanded(
            child: Text(
              item.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Temperature range
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTemp(item.tempMax),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatTemp(item.tempMin),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTemp(double temp) {
    if (isCelsius) {
      return '${temp.round()}°';
    } else {
      final fahrenheit = (temp * 9 / 5) + 32;
      return '${fahrenheit.round()}°';
    }
  }
}