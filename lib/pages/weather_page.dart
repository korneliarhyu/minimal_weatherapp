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

  //fetch weather
  Future<void> _fetchWeather() async {
    try {
      // get city name
      String cityName = await _weatherService.getCurrentCity();

      // get weather name
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation


  // init state
  void initState(){
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "City ... "),


            // temprature
            Text('${_weather?.temprature.round()} Celcius'),
          ],
        ),
      )
    );
  }
}
