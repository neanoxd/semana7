import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'casos_de_prueba.dart';

void main() {
  final estrategias = <String, EstrategiaRedondeo>{
    'exacto': RedondeoExacto(),
    'arriba': RedondeoHaciaArriba(),
  };

  final validador = ValidarEntrada();
  final calcular = CalcularDivision();

  for (final caso in casos) {
    test(caso.nombre, () {
      final error = validador.validar(caso.monto, caso.personas, caso.propina);

      if (caso.errorEsperado != null) {
        expect(error, equals(caso.errorEsperado));
        // Si hay error esperado, no se procede a calcular
      } else {
        expect(error, isNull);
        final estrategia = estrategias[caso.modo]!;
        final cuenta = Cuenta(
          montoTotal: caso.monto,
          numeroPersonas: caso.personas,
          porcentajePropina: caso.propina,
        );
        final resultado = calcular.ejecutar(
          cuenta: cuenta,
          estrategia: estrategia,
        );
        expect(resultado.montoPorPersona, closeTo(caso.esperado!, 0.001));
      }
    });
  }

  test('Demostración de LSP: CalcularDivision funciona con RedondeoExacto y RedondeoHaciaArriba sin if ni cast', () {
    final cuenta = Cuenta(
      montoTotal: 10.00,
      numeroPersonas: 3,
      porcentajePropina: 0.0,
    );

    // Ambas implementaciones son intercambiables como subtipos de EstrategiaRedondeo
    // sin que CalcularDivision requiera verificar el tipo concreto ni realizar casts.
    EstrategiaRedondeo estrategia = RedondeoExacto();
    final resultadoExacto = calcular.ejecutar(
      cuenta: cuenta,
      estrategia: estrategia,
    );
    expect(resultadoExacto.montoPorPersona, isA<double>());

    estrategia = RedondeoHaciaArriba();
    final resultadoArriba = calcular.ejecutar(
      cuenta: cuenta,
      estrategia: estrategia,
    );
    expect(resultadoArriba.montoPorPersona, isA<double>());
    expect(resultadoArriba.montoPorPersona, 4.00);
  });

  test('Propina mayor a 100%: con monto 100, 4 personas y propina 150, la validación devuelve "La propina no puede superar el 100%"', () {
    final error = validador.validar(100.0, 4, 150.0);
    expect(error, equals('La propina no puede superar el 100%'));
  });

  test('Propina en límite exacto (100%): con monto 100, 4 personas y propina 100, la validación NO devuelve error', () {
    final error = validador.validar(100.0, 4, 100.0);
    expect(error, isNull);
  });
}
