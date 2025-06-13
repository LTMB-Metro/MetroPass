import 'package:flutter/material.dart';
import 'package:metropass/services/weather_service.dart';
import 'package:metropass/themes/colors/colors.dart';
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

    return Card(
      color: Colors.transparent,
      elevation: 3,
      shadowColor: Color(MyColor.pr5),
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Image.network(iconUrl, 
              scale: 2.5,
            ),
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.center,
              child: Text("${temp.toString()}°C", 
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              )
              ),
            ),
          ],
        ),
      ),
    );
  }

}
