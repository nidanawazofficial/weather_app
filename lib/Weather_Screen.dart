import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projects/secrets.dart';
import 'WeatherForecast.dart';
import 'AdditionalInfoItem.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
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
      return data;
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
              getCurrentWeather();
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
            final data = snapshot.data!;
            final currentData = data['list'][0];
            final currentWeatherTemp = currentData['main']['temp'];
            final currentSky = currentData['weather'][0]['main'];
            final currentPressure = currentData['main']['pressure'];
            final windSpeed = currentData['wind']['speed'];
            final currentHumidity = currentData['main']['humidity'];

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
                                "$currentWeatherTemp k",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 84,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$currentSky',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weather Forecast',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: 39,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final hourlyForecast = data['list'][index + 1];
                              final hourlySky =
                              data['list'][index + 1]['weather'][0]['main'];
                              final hourlyTemp =
                              hourlyForecast['main']['temp'].toString();
                              final time =
                              DateTime.parse(hourlyForecast['dt_txt']);
                              return WeatherForecastItem(
                                time: DateFormat('Hm').format(time),
                                temp: hourlyTemp,
                                icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AddInfoItem(
                                label: 'Humidity',
                                icon: Icons.water_drop,
                                value: currentHumidity.toString()),
                            AddInfoItem(
                                label: 'Wind',
                                icon: Icons.wind_power,
                                value: windSpeed.toString()),
                            AddInfoItem(
                                label: 'Pressure',
                                icon: Icons.umbrella,
                                value: currentPressure.toString()),
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



