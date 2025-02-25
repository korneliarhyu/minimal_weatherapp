// service to fetch the data
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/weather_model.dart';
import 'api_services.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // base url ini menggunakan weatherapi.com
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final String url = '${baseUrl}current.json?key=$apiKey&q=$cityName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weathers data");
    }
  }

  Future<String> getCurrentCity() async {
    try {
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      // extract placemark objects
      String? city = placemarks[0].locality;

      return placemarks.isNotEmpty ? placemarks[0].locality ?? "Unknown" : "Unknown";
    } catch (e){
      print("Error getting location: $e");
      return "Unknown";
    }
  }
}
