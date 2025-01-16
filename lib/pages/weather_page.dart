import 'package:flutter/material.dart';
import 'package:minimalist_weather_app/model/weather_model.dart';
import 'package:minimalist_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('609900bb77eb04cb68f79ab45bf73d1d');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any error
    catch (e) {
      print(e);
    }
  }

  // weather animation

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
