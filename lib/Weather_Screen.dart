import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projects/secrets.dart'; 
import 'WeatherForecast.dart';
import 'AdditionalInfoItem.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<void> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Unexpected error occurred';
      }

      data['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              getCurrentWeather(); // Refresh weather data
            },
            child: const Icon(Icons.refresh),
          ),
        ],
        backgroundColor: Colors.grey,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '400 K',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Icon(Icons.cloud, size: 84),
                              SizedBox(height: 10),
                              Text(
                                'Rain',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Weather Forecast',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              WeatherForecastItem('12:00 PM', Icons.cloud, '25°C'),
                              WeatherForecastItem('03:00 PM', Icons.cloud, '28°C'),
                              WeatherForecastItem('06:00 PM', Icons.cloud, '40°C'),
                              WeatherForecastItem('05:00 PM', Icons.cloud, '35°C'),
                              WeatherForecastItem('07:00 PM', Icons.cloud, '39°C'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AddInfoItem(type: 'Humidity', icon: Icons.water_drop, value: '3012'),
                            AddInfoItem(type: 'Wind', icon: Icons.wind_power, value: '4029'),
                            AddInfoItem(type: 'Pressure', icon: Icons.umbrella, value: '4430'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


