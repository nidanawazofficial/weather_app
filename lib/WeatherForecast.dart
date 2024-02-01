import 'package:flutter/material.dart';

class WeatherForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const WeatherForecastItem(this.time, this.icon, this.temp, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Icon(icon, size: 32),
              Text(
                temp,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

