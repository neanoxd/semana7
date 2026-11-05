import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';

void main() {
  group('CalcularDivision - Modo Hacia Arriba', () {
    final calcular = CalcularDivision();
    final haciaArriba = RedondeoHaciaArriba();

    test('Escenario 6: 10.00, 3 personas, 0% propina, modo hacia arriba -> 4.00 por persona', () {
      final cuenta = Cuenta(
        montoTotal: 10.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
      );

      final resultado = calcular.ejecutar(cuenta: cuenta, estrategia: haciaArriba);

      expect(resultado.totalConPropina, 10.00);
      expect(resultado.montoPorPersona, 4.00);
    });
  });
}
