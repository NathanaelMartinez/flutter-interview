import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCityModal extends StatefulWidget {
  final TextEditingController cityController;
  final FocusNode cityFocusNode;
  final TextEditingController descriptionController;
  final FocusNode descriptionFocusNode;
  final List<Map<String, String>> filteredCities;
  final bool isCitySelected;
  final Function(String) filterCities;
  final Function() onSaveCity;
  final Function() onClearCitySelection;

  const AddCityModal({
    Key? key,
    required this.cityController,
    required this.cityFocusNode,
    required this.descriptionController,
    required this.descriptionFocusNode,
    required this.filteredCities,
    required this.isCitySelected,
    required this.filterCities,
    required this.onSaveCity,
    required this.onClearCitySelection,
  }) : super(key: key);

  @override
  _AddCityModalState createState() => _AddCityModalState();
}

class _AddCityModalState extends State<AddCityModal> {
  @override
  Widget build(BuildContext context) {
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
                    controller: widget.cityController,
                    focusNode: widget.cityFocusNode,
                    onChanged: (value) {
                      setState(() {
                        widget.filterCities(value);
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      label: Text(
                        'Add City',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: widget.cityFocusNode.hasFocus
                              ? Colors.blue
                              : const Color.fromARGB(255, 73, 69, 79),
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.blue),
                      ),
                      labelStyle: TextStyle(
                        color: widget.cityFocusNode.hasFocus
                            ? Colors.blue
                            : const Color.fromARGB(255, 73, 69, 79),
                      ),
                      suffixIcon: widget.cityController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(CupertinoIcons.clear_circled),
                              onPressed: () {
                                widget.cityController.clear();
                                setState(() {
                                  widget.onClearCitySelection();
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  widget.filteredCities.isNotEmpty
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
                            itemCount: widget.filteredCities.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(widget.filteredCities[index]['name']!),
                                onTap: () {
                                  widget.cityController.text =
                                      widget.filteredCities[index]['name']!;
                                  widget.onClearCitySelection();
                                },
                              );
                            },
                          ),
                        )
                      : Column(
                          children: [
                            TextField(
                              controller: widget.descriptionController,
                              focusNode: widget.descriptionFocusNode,
                              maxLines: 4,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: Text(
                                  'Description',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: widget.descriptionFocusNode.hasFocus
                                        ? Colors.blue
                                        : const Color.fromARGB(255, 73, 69, 79),
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
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.blue),
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
                          widget.isCitySelected
                              ? Colors.blue
                              : const Color.fromARGB(255, 153, 153, 153),
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      onPressed: widget.isCitySelected
                          ? () async {
                              widget.onSaveCity();
                              Navigator.of(context).pop();
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
  }
}
