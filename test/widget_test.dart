import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));
    expect(find.text('No data Found'), findsOneWidget);
  });

  testWidgets('Leading icon is present in the AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));
    expect(find.byType(WeatherForemostIcon),
        findsOneWidget); // Update with your custom icon finder
  });

  testWidgets('AppBar title is styled correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));
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
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));
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
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));
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
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));

    // check the BottomNavigationBar is present
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    final BottomNavigationBar widget = tester.widget(bottomNavBar);
    expect(widget.items.length, 3);

    // check the first item
    final firstItemIcon = widget.items[0].icon as Padding;
    final firstIcon = firstItemIcon.child as Icon;
    expect(firstIcon.icon, Icons.home_outlined);
    expect(firstIcon.size, 32);
    expect(firstIcon.color, const Color.fromARGB(255, 94, 93, 93));

    // check the second item
    final secondIcon = widget.items[1].icon as Icon;
    expect(secondIcon.icon, Icons.place_outlined);
    expect(secondIcon.size, 32);
    expect(secondIcon.color, Colors.blue);

    // check the third item
    final thirdItemIcon = widget.items[2].icon as Padding;
    final thirdIcon = thirdItemIcon.child as Icon;
    expect(thirdIcon.icon, Icons.person_outline);
    expect(thirdIcon.size, 32);
    expect(thirdIcon.color, const Color.fromARGB(255, 94, 93, 93));
  });

  testWidgets('Custom border on BottomNavigationBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));

    // check that Container of BottomNavigationBar exists
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
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));

    // verify FAB exists and tap it
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();
    // wait for modal bottom sheet to appear

    // verify modal bottom sheet contains form
    expect(find.text('Add City'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Add a description'), findsOneWidget);
    expect(find.text('Save City'), findsOneWidget);
  });
  testWidgets('Modal bottom sheet form elements have correct properties',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyApp(),
    ));

    /// verify FAB exists and tap it
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();
    // wait for modal bottom sheet to appear

    // check properties of 'Add City' input
    final addCityField = find.widgetWithText(TextField, 'Add City');
    expect(addCityField, findsOneWidget);

    final addCityFieldWidget = tester.widget<TextField>(addCityField);
    final addCityLabel = addCityFieldWidget.decoration?.label as Text?;
    expect(addCityLabel?.data, 'Add City');
    expect(addCityFieldWidget.decoration?.border,
        isInstanceOf<OutlineInputBorder>());

    // check properties of 'Description' input
    final descriptionField = find.widgetWithText(TextField, 'Description');
    expect(descriptionField, findsOneWidget);

    final descriptionFieldWidget = tester.widget<TextField>(descriptionField);
    final descriptionLabel = descriptionFieldWidget.decoration?.label as Text?;
    expect(descriptionLabel?.data, 'Description');
    expect(descriptionFieldWidget.decoration?.hintText, 'Add a description');
    expect(descriptionFieldWidget.decoration?.hintStyle?.color,
        const Color.fromARGB(255, 153, 153, 153));
    expect(descriptionFieldWidget.decoration?.hintStyle?.fontSize, 24);
    expect(descriptionFieldWidget.decoration?.border,
        isInstanceOf<OutlineInputBorder>());
    expect(descriptionFieldWidget.maxLines, 4);

    // check properties of 'Save City' button
    final saveButton = find.widgetWithText(ElevatedButton, 'Save City');
    expect(saveButton, findsOneWidget);

    final saveButtonWidget = tester.widget<ElevatedButton>(saveButton);
    expect(saveButtonWidget.style?.backgroundColor?.resolve({}),
        const Color.fromARGB(255, 153, 153, 153));
    final shape =
        saveButtonWidget.style?.shape?.resolve({}) as RoundedRectangleBorder?;
    expect(shape?.borderRadius, BorderRadius.circular(4));
  });
}
