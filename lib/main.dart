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
          title: const Text('NetForemost'),
        ),
        body: const Center(
          child: Text('Hello World'),
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
