// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('Welcome page renders main actions', (WidgetTester tester) async {
    await tester.pumpWidget(const EuronicApp());

    expect(find.text('Activar Licencia'), findsOneWidget);
    expect(find.text('Iniciar Sesion'), findsOneWidget);

    await tester.tap(find.text('Iniciar Sesion'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('INICIAR SESION'), findsWidgets);
    expect(find.text('Bienvenido a Euronic Ai'), findsOneWidget);
  });
}
