import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('No data Found'), findsOneWidget);
  });

  testWidgets('Leading icon is present in the AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(WeatherForemostIcon),
        findsOneWidget); // Update with your custom icon finder
  });

  testWidgets('AppBar title is styled correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
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
    await tester.pumpWidget(const MyApp());
    expect(find.byType(WeatherForemostIconNotFound), findsOneWidget);

    final noDataText = find.text('No data Found');
    expect(noDataText, findsOneWidget);
    final textStyleNoData = tester.widget<Text>(noDataText).style;
    expect(textStyleNoData?.color, const Color.fromARGB(255, 90, 90, 90));
    expect(textStyleNoData?.fontWeight, FontWeight.bold);

    final pleaseAddCity = find.text('Please add a city to track its weather');
    expect(pleaseAddCity, findsOneWidget);
    final textStylePleaseAddCity = tester.widget<Text>(pleaseAddCity).style;
    expect(textStylePleaseAddCity?.color,
        const Color.fromARGB(255, 125, 125, 125));
  });

  testWidgets('Floating action button is displayed and styled correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final fab = find.byType(FloatingActionButton);

    final FloatingActionButton fabWidget =
        tester.widget<FloatingActionButton>(fab);
    expect(fabWidget.backgroundColor, Colors.blue);

    final icon = fabWidget.child as Icon;
    expect(icon.icon, Icons.add);
    expect(icon.color, Colors.white);
    expect(icon.size, 50.0);
    expect(fabWidget.elevation, 0.0);
  });

  testWidgets('Add styled BottomNavigationBar with 3 styled icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check the BottomNavigationBar is present
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    final BottomNavigationBar widget = tester.widget(bottomNavBar);
    expect(widget.items.length, 3);

    // Check the first item
    final firstItemIcon = widget.items[0].icon as Padding;
    final firstIcon = firstItemIcon.child as Icon;
    expect(firstIcon.icon, Icons.home_outlined);
    expect(firstIcon.size, 50);
    expect(firstIcon.color, const Color.fromARGB(255, 90, 90, 90));

    // Check the second item
    final secondIcon = widget.items[1].icon as Icon;
    expect(secondIcon.icon, Icons.place_outlined);
    expect(secondIcon.size, 50);
    expect(secondIcon.color, Colors.blue);

    // Check the third item
    final thirdItemIcon = widget.items[2].icon as Padding;
    final thirdIcon = thirdItemIcon.child as Icon;
    expect(thirdIcon.icon, Icons.person_outline);
    expect(thirdIcon.size, 50);
    expect(thirdIcon.color, const Color.fromARGB(255, 90, 90, 90));
  });

  testWidgets('Divider styling', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final divider = find.byType(Divider);
    expect(divider, findsOneWidget);

    final Divider dividerWidget = tester.widget<Divider>(divider);
    expect(dividerWidget.color, const Color.fromARGB(255, 90, 90, 90));
  });
}
