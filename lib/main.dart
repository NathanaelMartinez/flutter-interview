import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() =>
    runApp(const MaterialApp(title: 'WeatherForemost', home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const WeatherForemostIcon(),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'WeatherForemost',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color.fromARGB(255, 94, 93, 93),
              ),
            ),
            Text(
              'Please add a city to track its weather',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color.fromARGB(255, 94, 93, 93)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCityModal(context);
        },
        backgroundColor: Colors.blue,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 42),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 94, 93, 93),
              width: 2.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(left: 90.0),
                child: Icon(
                  Icons.home_outlined,
                  size: 32,
                  color: Color.fromARGB(255, 94, 93, 93),
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.place_outlined,
                size: 32,
                color: Colors.blue,
              ),
              label: 'Location',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(right: 90.0),
                child: Icon(
                  Icons.person_outline,
                  size: 32,
                  color: Color.fromARGB(255, 94, 93, 93),
                ),
              ),
              label: 'Profile',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  void _showAddCityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16.0),
                    Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 121, 116, 126),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 56.0),
                    const TextField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(
                          'Add City',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromARGB(255, 73, 69, 79),
                          ),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromARGB(255, 73, 69, 79),
                          ),
                        ),
                        hintText: 'Add a description',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Color.fromARGB(255, 153, 153, 153),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 79),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                              Color.fromARGB(255, 153, 153, 153),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )),
                        onPressed: () {
                          // Handle save action
                        },
                        child: const Text(
                          'Save City',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WeatherForemostIcon extends StatelessWidget {
  const WeatherForemostIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.cloud);
  }
}

class WeatherForemostIconNotFound extends StatelessWidget {
  const WeatherForemostIconNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.cloud);
  }
}
