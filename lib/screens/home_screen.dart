import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
 const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Temperature unit toggle
          Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Text(
                  provider.isCelsius ? '°C' : '°F',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  provider.toggleTemperatureUnit();
                },
                tooltip: 'Toggle temperature unit',
              );
            },
          ),
          
          // Location button
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              Provider.of<WeatherProvider>(context, listen: false)
                  .fetchWeatherByLocation();
            },
            tooltip: 'Use current location',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<WeatherProvider>(context, listen: false).refresh();
        },
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search bar
                    SearchBarWidget(
                      onSearch: (city) {
                        provider.fetchWeatherByCity(city);
                      },
                    ),
                    const SizedBox(height: 20),

                    // Loading state
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: SpinKitFadingCircle(
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                      ),

                    // Error state
                    if (provider.errorMessage != null && !provider.isLoading)
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: Colors.red.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Current weather
                    if (provider.currentWeather != null && !provider.isLoading)
                      CurrentWeatherCard(
                        weather: provider.currentWeather!,
                        isCelsius: provider.isCelsius,
                      ),

                    const SizedBox(height: 20),

                    // Forecast
                    if (provider.forecast != null && !provider.isLoading)
                      ForecastCard(
                        forecast: provider.forecast!,
                        isCelsius: provider.isCelsius,
                      ),

                    // Empty state
                    if (provider.currentWeather == null &&
                        !provider.isLoading &&
                        provider.errorMessage == null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Icon(
                              Icons.cloud_queue,
                              size: 100,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Search for a city',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'or use current location',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}