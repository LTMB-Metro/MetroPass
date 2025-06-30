import 'package:flutter/material.dart';
import 'package:metropass/services/weather_service.dart';
import 'package:metropass/widgets/skeleton/weather_skeleton.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Map<String, dynamic>? weatherData;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    final data = await _weatherService.fetchWeather();
    setState(() {
      weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) {
      return WeatherSkeleton();
    }

    final temp = weatherData!['main']['temp'];
    final iconCode = weatherData!['weather'][0]['icon'];
    print('aaaaaaaaaaaaaaaa $iconCode');
    final iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';

    return Container(
      height: 30,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color.fromARGB(166, 114, 162, 202),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.network(iconUrl, scale: 2.5),
          ),
          Center(
            child: Text(
              "${temp.toString()}°C",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
    
    );
  }

}
