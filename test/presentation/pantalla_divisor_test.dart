import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';
import 'package:divisor_cuenta/presentation/pantalla_divisor.dart';

void main() {
  late DivisorController controller;

  setUp(() {
    controller = DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      formateador: FormateadorMoneda(),
      estrategias: <String, EstrategiaRedondeo>{
        'exacto': RedondeoExacto(),
        'haciaArriba': RedondeoHaciaArriba(),
      },
    );
  });

  Widget crearWidgetDePrueba() {
    return MaterialApp(
      home: PantallaDivisor(controller: controller),
    );
  }

  group('Escenarios de Aceptación - PantallaDivisor', () {
    testWidgets('Escenario 1: 100.00, 4 personas, 10% de propina, modo exacto -> 27.50 por persona',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), '100.00');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '4');
      await tester.enterText(find.byKey(const Key('campoPropina')), '10');
      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
      expect(find.text('27.50'), findsOneWidget);
    });

    testWidgets('Escenario 2: 90.00, 3 personas, 0% de propina, modo exacto -> 30.00 por persona',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), '90.00');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
      await tester.enterText(find.byKey(const Key('campoPropina')), '0');
      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
      expect(find.text('30.00'), findsOneWidget);
    });

    testWidgets('Escenario 3: 50.00 y 0 personas -> mensaje "Debe haber al menos una persona" y NO se muestra resultado',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), '50.00');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '0');
      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.text('Debe haber al menos una persona'), findsOneWidget);
      expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
    });

    testWidgets('Escenario 4: monto "abc" -> mensaje "Monto inválido" y NO se muestra resultado',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), 'abc');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '2');
      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.text('Monto inválido'), findsOneWidget);
      expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
    });

    testWidgets('Escenario 5: 10.00, 3 personas, 0%, modo exacto -> 3.33 por persona',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), '10.00');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
      await tester.enterText(find.byKey(const Key('campoPropina')), '0');
      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
      expect(find.text('3.33'), findsOneWidget);
    });

    testWidgets('Escenario 6: 10.00, 3 personas, 0%, modo hacia arriba -> 4.00 por persona',
        (tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(find.byKey(const Key('campoMonto')), '10.00');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
      await tester.enterText(find.byKey(const Key('campoPropina')), '0');
      await tester.tap(find.text('Hacia arriba'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('botonCalcular')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
      expect(find.text('4.00'), findsOneWidget);
    });
  });
}
