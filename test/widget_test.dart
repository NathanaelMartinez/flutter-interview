import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/main.dart';
import 'package:interview_flutter/services/city_service.dart';
import 'package:interview_flutter/services/database_helper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([CityService, Database, DatabaseHelper])
void main() {
  final mockCityService = MockCityService();
  final mockDatabaseHelper = MockDatabaseHelper();

  when(mockCityService.fetchCities(any)).thenAnswer(
    (_) async => [],
  );

  // Specific query examples
  when(mockCityService.fetchCities('Mi')).thenAnswer(
    (_) async => ['Miami', 'Milwaukee', 'Minneapolis', 'Miramar'],
  );

  when(mockDatabaseHelper.getAllCities()).thenAnswer(
    (_) async => [
      {'name': 'Test City', 'description': 'Test Description'},
    ],
  );

  when(mockDatabaseHelper.insertCity(any, any)).thenAnswer(
    (_) async => 1,
  );

  Widget createTestWidget() {
    return MaterialApp(
      home: MyApp(
        cityService: mockCityService,
        databaseHelper: mockDatabaseHelper,
      ),
    );
  }

  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text('No data Found'), findsOneWidget);
  });

  testWidgets('Leading icon is present in the AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(WeatherForemostIcon), findsOneWidget);
  });

  testWidgets('AppBar title is styled correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final appBarTitle = find.text('WeatherForemost');
    expect(appBarTitle, findsOneWidget);
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, Colors.black);
    expect(appBar.centerTitle, isFalse);

    final textStyle = tester.widget<Text>(appBarTitle).style;
    expect(textStyle?.color, Colors.white);
    expect(textStyle?.fontWeight, FontWeight.bold);
  });

  testWidgets('Body displays correct initial content',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(WeatherForemostIconNotFound), findsOneWidget);

    final noDataText = find.text('No data Found');
    expect(noDataText, findsOneWidget);
    final textStyleNoData = tester.widget<Text>(noDataText).style;
    expect(textStyleNoData?.color, const Color.fromARGB(255, 94, 93, 93));
    expect(textStyleNoData?.fontWeight, FontWeight.w600);

    final pleaseAddCity = find.text('Please add a city to track its weather');
    expect(pleaseAddCity, findsOneWidget);
    final textStylePleaseAddCity = tester.widget<Text>(pleaseAddCity).style;
    expect(
        textStylePleaseAddCity?.color, const Color.fromARGB(255, 94, 93, 93));
  });

  testWidgets('Floating action button is displayed and styled correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final fab = find.byType(FloatingActionButton);

    final FloatingActionButton fabWidget =
        tester.widget<FloatingActionButton>(fab);
    expect(fabWidget.backgroundColor, Colors.blue);

    final icon = fabWidget.child as Icon;
    expect(icon.icon, Icons.add);
    expect(icon.color, Colors.white);
    expect(icon.size, 42.0);
    expect(fabWidget.elevation, 0.0);
  });

  testWidgets('Add styled BottomNavigationBar with 3 styled icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    final BottomNavigationBar widget = tester.widget(bottomNavBar);
    expect(widget.items.length, 3);

    final firstItemIcon = widget.items[0].icon as Padding;
    final firstIcon = firstItemIcon.child as Icon;
    expect(firstIcon.icon, Icons.home_outlined);
    expect(firstIcon.size, 32);
    expect(firstIcon.color, const Color.fromARGB(255, 94, 93, 93));

    final secondIcon = widget.items[1].icon as Icon;
    expect(secondIcon.icon, Icons.place_outlined);
    expect(secondIcon.size, 32);
    expect(secondIcon.color, Colors.blue);

    final thirdItemIcon = widget.items[2].icon as Padding;
    final thirdIcon = thirdItemIcon.child as Icon;
    expect(thirdIcon.icon, Icons.person_outline);
    expect(thirdIcon.size, 32);
    expect(thirdIcon.color, const Color.fromARGB(255, 94, 93, 93));
  });

  testWidgets('Custom border on BottomNavigationBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final container = find.byType(Container);
    bool found = false;
    for (var containerWidget in container.evaluate()) {
      final containerElement = containerWidget.widget as Container;
      if (containerElement.decoration is BoxDecoration) {
        final BoxDecoration decoration =
            containerElement.decoration as BoxDecoration;
        if (decoration.border?.top.width == 2.0 &&
            decoration.border?.top.color ==
                const Color.fromARGB(255, 94, 93, 93)) {
          found = true;
          break;
        }
      }
    }
    expect(found, isTrue);
  });

  testWidgets('FloatingActionButton opens modal bottom sheet with form',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.text('Add City'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Add a description'), findsOneWidget);
    expect(find.text('Save City'), findsOneWidget);
  });

  testWidgets('Modal bottom sheet form elements have correct properties',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final addCityField = find.widgetWithText(TextField, 'Add City');
    expect(addCityField, findsOneWidget);

    final addCityFieldWidget = tester.widget<TextField>(addCityField);
    expect(addCityFieldWidget.focusNode, isNotNull);
    expect(addCityFieldWidget.controller, isNotNull);

    final addCityLabel = addCityFieldWidget.decoration?.label as Text?;
    expect(addCityLabel?.data, 'Add City');
    expect(addCityFieldWidget.decoration?.border,
        isInstanceOf<OutlineInputBorder>());

    final descriptionField = find.widgetWithText(TextField, 'Description');
    expect(descriptionField, findsOneWidget);

    final descriptionFieldWidget = tester.widget<TextField>(descriptionField);
    expect(descriptionFieldWidget.focusNode, isNotNull);
    expect(descriptionFieldWidget.controller, isNotNull);

    final descriptionLabel = descriptionFieldWidget.decoration?.label as Text?;
    expect(descriptionLabel?.data, 'Description');
    expect(descriptionFieldWidget.decoration?.hintText, 'Add a description');
    expect(descriptionFieldWidget.decoration?.hintStyle?.color,
        const Color.fromARGB(255, 153, 153, 153));
    expect(descriptionFieldWidget.decoration?.hintStyle?.fontSize, 24);
    expect(descriptionFieldWidget.decoration?.border,
        isInstanceOf<OutlineInputBorder>());
    expect(descriptionFieldWidget.maxLines, 4);

    final saveButton = find.widgetWithText(ElevatedButton, 'Save City');
    expect(saveButton, findsOneWidget);

    final saveButtonWidget = tester.widget<ElevatedButton>(saveButton);
    expect(saveButtonWidget.style?.backgroundColor?.resolve({}),
        const Color.fromARGB(255, 153, 153, 153));
    final shape =
        saveButtonWidget.style?.shape?.resolve({}) as RoundedRectangleBorder?;
    expect(shape?.borderRadius, BorderRadius.circular(4));
  });

  testWidgets('City search displays filtered results',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final addCityField = find.widgetWithText(TextField, 'Add City');
    await tester.enterText(addCityField, 'Mi');
    await tester.pumpAndSettle();

    expect(find.text('Miami'), findsOneWidget);
    expect(find.text('Milwaukee'), findsOneWidget);
    expect(find.text('Minneapolis'), findsOneWidget);
    expect(find.text('Miramar'), findsOneWidget);
  });

  testWidgets('Bottom sheet adjusts height with keyboard visibility',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsAtLeast(1));
    expect(find.text('Save City'), findsOneWidget);

    final addCityField = find.widgetWithText(TextField, 'Add City');
    await tester.tap(addCityField);
    await tester.pumpAndSettle();

    await tester.showKeyboard(addCityField);
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isTrue,
        reason: 'Keyboard should be visible');
    expect(find.text('Save City'), findsOneWidget);
  });

  testWidgets('Save city and description to database',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final addCityField = find.widgetWithText(TextField, 'Add City');
    final descriptionField = find.widgetWithText(TextField, 'Description');
    final saveButton = find.widgetWithText(ElevatedButton, 'Save City');

    await tester.enterText(addCityField, 'Test City');
    await tester.enterText(descriptionField, 'Test Description');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    when(mockDatabaseHelper.getAllCities()).thenAnswer(
      (_) async => [
        {'name': 'Test City', 'description': 'Test Description'},
      ],
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final listView = find.byType(ListView);
    expect(listView, findsOneWidget);

    // check that ListView contains 'Test City' entry
    expect(find.descendant(of: listView, matching: find.text('Test City')),
        findsOneWidget);
    expect(
        find.descendant(of: listView, matching: find.text('Test Description')),
        findsOneWidget);
  });
}
