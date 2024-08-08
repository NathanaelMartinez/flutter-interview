import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interview_flutter/services/city_service.dart';
import 'package:interview_flutter/services/database_helper.dart';

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
    for (var city in cities) {
      final weatherData =
          await widget.cityService.fetchCurrentConditions(city['locationKey']);
      city['weatherIcon'] = weatherData['WeatherIcon'];
      city['localObservationDateTime'] =
          weatherData['LocalObservationDateTime'];
    }
    setState(() {
      _cities = cities;
    });
  }

  void _showAddCityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28.0),
                topRight: Radius.circular(28.0),
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                      TextField(
                        controller: _cityController,
                        focusNode: _cityFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _filterCities(value);
                          });
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text(
                            'Add City',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: _cityFocusNode.hasFocus
                                  ? Colors.blue
                                  : const Color.fromARGB(255, 73, 69, 79),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                          labelStyle: TextStyle(
                            color: _cityFocusNode.hasFocus
                                ? Colors.blue
                                : const Color.fromARGB(255, 73, 69, 79),
                          ),
                          suffixIcon: _cityController.text.isNotEmpty
                              ? IconButton(
                                  icon:
                                      const Icon(CupertinoIcons.clear_circled),
                                  onPressed: () {
                                    _cityController.clear();
                                    setState(() {
                                      _filteredCities = [];
                                      _isCitySelected = false;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _filteredCities.isNotEmpty
                          ? Container(
                              constraints: const BoxConstraints(
                                maxHeight: 200, // Limit to 4 items
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: -8,
                                    blurRadius: 7,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                itemCount: _filteredCities.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(_filteredCities[index]['name']!),
                                    onTap: () {
                                      _cityController.text =
                                          _filteredCities[index]['name']!;
                                      _selectedLocationKey =
                                          _filteredCities[index]
                                              ['locationKey']!;
                                      setState(() {
                                        _filteredCities = [];
                                        _isCitySelected = true;
                                      });
                                    },
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                TextField(
                                  controller: _descriptionController,
                                  focusNode: _descriptionFocusNode,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: _descriptionFocusNode.hasFocus
                                            ? Colors.blue
                                            : const Color.fromARGB(
                                                255, 73, 69, 79),
                                      ),
                                    ),
                                    hintText: 'Add a description',
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                      color: Color.fromARGB(255, 153, 153, 153),
                                    ),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 79),
                              ],
                            ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              _isCitySelected
                                  ? Colors.blue
                                  : const Color.fromARGB(255, 153, 153, 153),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          onPressed: _isCitySelected
                              ? () async {
                                  await widget.databaseHelper.insertCity(
                                    _cityController.text,
                                    _descriptionController.text,
                                    _selectedLocationKey!,
                                  );
                                  Navigator.of(context).pop();
                                  _loadCities();
                                }
                              : null,
                          child: const Text(
                            'Save City',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
          : ListView.builder(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                final city = _cities[index];
                final weatherIcon = city['weatherIcon'];
                final localObservationDateTime =
                    city['localObservationDateTime'];
                final time = DateTime.parse(localObservationDateTime)
                    .toLocal()
                    .toString()
                    .substring(11, 16);

                return Card(
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
                        width: 90,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons
                                  .wb_sunny, // You can replace this with appropriate weather icons
                              color: Colors.orange,
                              size: 40,
                            ),
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

class WeatherForemostIcon extends StatelessWidget {
  const WeatherForemostIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/logo.png');
  }
}

class WeatherForemostIconNotFound extends StatelessWidget {
  const WeatherForemostIconNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/logosearch.png');
  }
}
