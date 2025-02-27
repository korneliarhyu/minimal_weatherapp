import 'package:flutter/material.dart';
import 'package:minimalist_weather_app/model/weather_model.dart';
import 'package:minimalist_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<WeatherPage> {
  // api key from weatherapi.com
  final _weatherService = WeatherService('11251a4549ca4ab9a0394342252502');
  Weather? _weather;
  bool _isLoading = true;
  String _errMsg = '';

  //fetch weather
  Future<void> _fetchWeather() async {
    try {
      // get city name
      String? cityName = await _weatherService.getCurrentCity();

      if (cityName == null || cityName.isEmpty) {
        throw Exception("Failed to detect city.");
      }

      // get weather name
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errMsg = "Failed to fetch weather data. Please try again.";
        _isLoading = false;
      });
      debugPrint("Error fetching weather: ${e.toString()}");
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errMsg.isNotEmpty
                ? Text(_errMsg, style: const TextStyle(color: Colors.red))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weather?.city ?? "Unknown City",
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _weather?.temperature != null
                            ? "${_weather!.temperature.round()}°C"
                            : "Loading temprature ...",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
      ),
    );
  }
}
