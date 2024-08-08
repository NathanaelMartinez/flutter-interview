import 'package:flutter/material.dart';

class CityList extends StatelessWidget {
  final List<Map<String, dynamic>> cities;

  const CityList({
    Key? key,
    required this.cities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        final weatherIcon = city['weatherIcon'];
        final localObservationDateTime = city['localObservationDateTime'];
        final time = DateTime.parse(localObservationDateTime)
            .toLocal()
            .toString()
            .substring(11, 16);

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(225, 29, 27, 32),
                        ),
                      ),
                      Text(
                        city['description'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(225, 29, 27, 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 92,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 201, 229, 255),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/sun.png', scale: 1.30),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
