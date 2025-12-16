import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:first_flutter_project/models/weather_model.dart';
import 'package:first_flutter_project/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key here
  final _weatherService = WeatherService("0a428c33d880ef5798145243b047d322");
  Weather? _weather;

  //fetch weather data here
  _fetchWeather() async{

  //get the current city
  try{
    String cityName = await _weatherService.getCurrentCity();
    print("City: $cityName"); // debug line
    
    // Fallback city if location fails (especially for web)
    if(cityName.isEmpty){
      cityName = "Manila"; // default city
      print("Using fallback city: $cityName");
    }

    //get weather for that city
    final weather = await _weatherService.getWeather(cityName);
    setState(() {
      _weather = weather;
    });
  }

  catch(e){
    print("ERROR: $e"); // show full error
  }
  }
  //weather animations
String getWeatherAnimation(String? mainCondition){
  if(mainCondition == null) return 'assets/Sun.json';

  switch(mainCondition.toLowerCase()){
    case 'clouds':
      return 'assets/Cloud.json';
    case 'rain':
      return 'assets/Rain.json';
    case 'snow':
      return 'assets/Snow.json';
    case 'thunderstorm':
      return 'assets/Heavy Rain.json';
    case 'sun and rain':
      return 'assets/Sun & Rain.json';
    default:
      return 'assets/Sun.json';
  }
}
  //init state
  @override
  void initState() {
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
      Text(_weather?.cityName ?? "Loading...", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),         

      //animation
      Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

      //temperature
      Text('${_weather?.temperature.round()} °C', style: TextStyle(fontSize: 28),),

      //weather condition
      Text(_weather?.mainCondition ?? "", style: TextStyle(fontSize: 25),),
        ],
        )
       )
      );
    }  
  }
