import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';

void main() {
  group('CalcularDivision - Modo Exacto', () {
    final calcular = CalcularDivision();
    final exacto = RedondeoExacto();

    test('Escenario 1: 100.00, 4 personas, 10% propina -> 27.50 por persona', () {
      final cuenta = Cuenta(
        montoTotal: 100.00,
        numeroPersonas: 4,
        porcentajePropina: 10.0,
      );

      final resultado = calcular.ejecutar(cuenta: cuenta, estrategia: exacto);

      expect(resultado.totalConPropina, 110.00);
      expect(resultado.montoPropina, 10.00);
      expect(resultado.montoPorPersona, 27.50);
    });

    test('Escenario 2: 90.00, 3 personas, 0% propina -> 30.00 por persona', () {
      final cuenta = Cuenta(
        montoTotal: 90.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
      );

      final resultado = calcular.ejecutar(cuenta: cuenta, estrategia: exacto);

      expect(resultado.totalConPropina, 90.00);
      expect(resultado.montoPropina, 0.0);
      expect(resultado.montoPorPersona, 30.00);
    });

    test('Escenario 5: 10.00, 3 personas, 0% propina -> 3.33 por persona', () {
      final cuenta = Cuenta(
        montoTotal: 10.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
      );

      final resultado = calcular.ejecutar(cuenta: cuenta, estrategia: exacto);

      expect(resultado.totalConPropina, 10.00);
      expect(resultado.montoPorPersona, closeTo(3.33, 0.001));
    });
  });
}
