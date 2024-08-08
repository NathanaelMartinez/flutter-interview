import 'package:flutter/material.dart';
import 'city_service.dart';

void main() => runApp(
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
        ),
      ),
    );

class MyApp extends StatefulWidget {
  final CityService cityService;
  const MyApp({super.key, required this.cityService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _cityFocusNode.addListener(() {
      setState(() {});
    });
    _descriptionFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _filterCities(String query) async {
    final List<String> matches = await widget.cityService.fetchCities(query);
    setState(() {
      _filteredCities = matches;
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
                child: SingleChildScrollView(
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        _filteredCities.isNotEmpty
                            ? Container(
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
                                  shrinkWrap: true,
                                  itemCount: _filteredCities.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(_filteredCities[index]),
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
                                        color:
                                            Color.fromARGB(255, 153, 153, 153),
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
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 153, 153, 153),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )),
                            onPressed: () {
                              // TODO: Handle save action
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
