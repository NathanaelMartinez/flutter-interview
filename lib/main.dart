import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          onPressed: () {},
          backgroundColor: Colors.blue,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 50),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 94, 93, 93),
              width: 2.0,
            ),
          )),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Icon(
                    Icons.home_outlined,
                    size: 50,
                    color: Color.fromARGB(255, 94, 93, 93),
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.place_outlined,
                  size: 50,
                  color: Colors.blue,
                ),
                label: 'Location',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(right: 50.0),
                  child: Icon(
                    Icons.person_outline,
                    size: 50,
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
      ),
    );
  }
}

class WeatherForemostIcon extends StatelessWidget {
  const WeatherForemostIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // return Image.asset("images/logo.png"); //TODO: create custom Icon
    return const Icon(Icons.cloud);
  }
}

class WeatherForemostIconNotFound extends StatelessWidget {
  const WeatherForemostIconNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    // return const ImageIcon(AssetImage(
    //     "icons/logoSearch.png")); //TODO: create custom not Found Icon
    return const Icon(Icons.cloud);
  }
}
