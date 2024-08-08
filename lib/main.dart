import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interview_flutter/services/city_service.dart';
import 'package:interview_flutter/services/database_helper.dart';
import 'package:interview_flutter/widgets/add_city_modal.dart';
import 'package:interview_flutter/widgets/city_list.dart';
import 'package:interview_flutter/widgets/weather_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      title: 'WeatherForemost',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color.fromARGB(255, 73, 69, 79),
          ),
        ),
      ),
      home: MyApp(
        cityService: CityService(),
        databaseHelper: DatabaseHelper(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final CityService cityService;
  final DatabaseHelper databaseHelper;
  const MyApp(
      {super.key, required this.cityService, required this.databaseHelper});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, String>> _filteredCities = [];
  bool _isCitySelected = false;
  String? _selectedLocationKey;

  @override
  void initState() {
    super.initState();
    _cityFocusNode.addListener(() {
      setState(() {});
    });
    _descriptionFocusNode.addListener(() {
      setState(() {});
    });
    _loadCities();
  }

  void _filterCities(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredCities = [];
        _isCitySelected = false;
      });
      return;
    }

    final matches = await widget.cityService.fetchCities(query);
    setState(() {
      _filteredCities = matches;
    });
  }

  Future<void> _loadCities() async {
    final cities = await widget.databaseHelper.getAllCities();
    final List<Map<String, dynamic>> updatedCities = [];

    for (var city in cities) {
      final weatherData =
          await widget.cityService.fetchCurrentConditions(city['locationKey']);
      final updatedCity = Map<String, dynamic>.from(city);
      updatedCity['weatherIcon'] = weatherData['WeatherIcon'];
      updatedCity['localObservationDateTime'] =
          weatherData['LocalObservationDateTime'];
      updatedCities.add(updatedCity);
    }

    setState(() {
      _cities = updatedCities;
    });
  }

  void _showAddCityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddCityModal(
          cityController: _cityController,
          cityFocusNode: _cityFocusNode,
          descriptionController: _descriptionController,
          descriptionFocusNode: _descriptionFocusNode,
          filteredCities: _filteredCities,
          isCitySelected: _isCitySelected,
          filterCities: _filterCities,
          onSaveCity: () async {
            await widget.databaseHelper.insertCity(
              _cityController.text,
              _descriptionController.text,
              _selectedLocationKey!,
            );
            _loadCities();
          },
          onClearCitySelection: () {
            _filteredCities = [];
            _isCitySelected = false;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _cityFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const WeatherForemostIcon(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(
                  -22, 0), // Adjust this value to fine-tune the spacing
              child: const Text(
                'WeatherForemost',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.black,
      ),
      body: _cities.isEmpty
          ? const Center(
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
            )
          : CityList(cities: _cities),
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
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(left: 90.0),
                child: Image.asset('assets/icons/house_filled_outlined.png',
                    scale: 2),
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.place_outlined,
                size: 32,
                color: Colors.blue,
              ),
              label: 'Location',
            ),
            const BottomNavigationBarItem(
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
}
