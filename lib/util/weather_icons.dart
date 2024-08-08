import 'package:flutter/material.dart';

class WeatherForemostIcon extends StatelessWidget {
  const WeatherForemostIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/logo.png', scale: 2);
  }
}

class WeatherForemostIconNotFound extends StatelessWidget {
  const WeatherForemostIconNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/logosearch.png', scale: 1.7);
  }
}
