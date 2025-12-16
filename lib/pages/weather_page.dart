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
  String cityName = await _weatherService.getCurrentCity();

  //get weather for that city
  try{
    final weather = await _weatherService.getWeather(cityName);
    setState(() {
      _weather = weather;
    });
  }

  catch(e){
    print(e);
  }
  }
  //weather animations
String getWeatherAnimation(String? mainCondition){
  if(mainCondition == null) return 'assets/Sun.json';

  switch(mainCondition){
    case 'Clouds':
      return 'assets/Cloud.json';
    case 'Rain':
      return 'assets/Rain.json';
    case 'Snow':
      return 'assets/Snow.json';
    case 'Thunderstorm':
      return 'assets/Thunderstorm.json';
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
      Text(_weather?.cityName ?? "Loading..."),         

      //animation
      Lottie.asset('assets/Cloud.json'),

      //temperature
      Text('${_weather?.temperature.round()} °C')

      //weather condition
      Text(_weather?.mainCondition ?? "")
        ],
        )
       )
      );
    }  
  }
