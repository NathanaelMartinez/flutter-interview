import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          leading: const WeatherForemostIcon(),
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'WeatherForemost',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.black,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeatherForemostIconNotFound(),
              Text(
                'No data Found',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 90, 90, 90)),
              ),
              Text(
                'Please add a city to track its weather',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 125, 125, 125)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherForemostIcon extends StatelessWidget {
  const WeatherForemostIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.cloud); //TODO: create custom Icon
  }
}

class WeatherForemostIconNotFound extends StatelessWidget {
  const WeatherForemostIconNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.cloud); //TODO: create custom not Found Icon
  }
}
