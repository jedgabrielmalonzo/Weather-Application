import 'dart:convert';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final url = Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
Future<String> getCurrentCity() async {

  //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }


  //fetch the current location
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //convert the location into a list of placemark objects
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  //extract the city name from the placemark object
  String? city = placemarks[0].locality;

  return city?? "";
  }
}