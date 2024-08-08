import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_flutter/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Hello World'), findsOneWidget);
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
}
