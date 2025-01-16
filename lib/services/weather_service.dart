// service to fetch the data
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // base url ini harusnya udah mati, akan cari reference API weather lain
  static const BASE_URL = 'http://api/openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weathers data");
    }
  }

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    // convert current location into a list of placemark object
    List<Placemark> placemarks = await placemarkFromCoordinates(position.altitude, position.longitude);

    // extract placemark objects
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
