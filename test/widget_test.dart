import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('Divisor de Cuenta loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DivisorCuentaApp());
    await tester.pumpAndSettle();

    expect(find.text('Divisor de Cuenta'), findsOneWidget);
    expect(find.text('División Rápida'), findsOneWidget);
    expect(find.text('Por Ítems / Amigos'), findsOneWidget);
    expect(find.text('Total por persona'), findsOneWidget);
    expect(find.text('Monto de la Cuenta'), findsOneWidget);

    await tester.tap(find.text('Por Ítems / Amigos'));
    await tester.pumpAndSettle();

    expect(find.text('Total de la Mesa'), findsOneWidget);
    expect(find.textContaining('Amigos en la mesa'), findsOneWidget);
  });

  testWidgets('Muestra mensaje de error cuando se ingresan caracteres no numéricos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DivisorCuentaApp());
    await tester.pumpAndSettle();

    // Localizar el campo de texto del monto de la cuenta
    final amountField = find.byType(TextField).first;

    // Ingresar caracteres no numéricos (ej. 'abc')
    await tester.enterText(amountField, 'abc');
    await tester.pumpAndSettle();

    // Debe mostrarse el mensaje de error para caracteres no numéricos
    expect(find.text('Error: solo se permiten números (ej. 25.50)'), findsOneWidget);

    // Ingresar un valor alfanumérico mixto (ej. '25a.5')
    await tester.enterText(amountField, '25a.5');
    await tester.pumpAndSettle();
    expect(find.text('Error: solo se permiten números (ej. 25.50)'), findsOneWidget);

    // Ingresar un número válido (ej. '60.00')
    await tester.enterText(amountField, '60.00');
    await tester.pumpAndSettle();

    // El error debe desaparecer
    expect(find.text('Error: solo se permiten números (ej. 25.50)'), findsNothing);
  });
}
