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

  Future<Weather> getWeather(String city) async {
    final Uri url = Uri.parse(
            'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no');

    try {
      final response = await http.get((url));
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonData);
      } else {
        final errorMsg =
            jsonData['error']['message'] ?? "Unknown error occurred.";
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception("Network error occurred: ${e.toString()}");
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // get permission from user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permission denied permanently.");
        return "New York"; // Default fallback city
      }
      // fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // convert current location into a list of placemark object
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // extract placemark objects
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? "Unknown";
      } else {
        return "Unknown";
      }
    } catch (e) {
      print("Error getting location: $e");
      return "Unknown";
    }
  }
}
