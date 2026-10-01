import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';

void main() {
  testWidgets('Smoke test inicial de DivisorCuentaApp', (WidgetTester tester) async {
    final controller = DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      formateador: FormateadorMoneda(),
      estrategias: <String, EstrategiaRedondeo>{
        'exacto': RedondeoExacto(),
        'haciaArriba': RedondeoHaciaArriba(),
      },
    );

    await tester.pumpWidget(DivisorCuentaApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Divisor de Cuenta'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });
}
