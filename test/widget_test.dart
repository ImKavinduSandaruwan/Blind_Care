import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projectblindcare/screens/customer_support.dart';
import 'package:projectblindcare/screens/home_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class MockAlanVoice extends Mock implements AlanVoice {}

extension PumpUntilFound on WidgetTester {
  Future<void> pumpUntilFound(
      Finder finder, {
        Duration duration = const Duration(milliseconds: 100),
        int tries = 10,
      }) async {
    for (var i = 0; i < tries; i++) {
      await pump(duration);

      final result = finder.precache();

      if (result) {
        finder.evaluate();
        break;
      }
    }
  }
}

void main() {

  testWidgets('HomeScreen displays title and message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.text('Blind Care'), findsOneWidget);
    expect(find.text('Set Your Destination'), findsOneWidget);
  });

  testWidgets('CustomerService displays title and message', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await tester.pumpWidget(MaterialApp(home: CustomerService()));
    expect(find.text('Customer Support'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
  });
}


