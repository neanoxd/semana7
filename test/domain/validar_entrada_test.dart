import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

void main() {
  group('ValidarEntrada', () {
    final validador = ValidarEntrada();

    test('Escenario 4: Monto "abc" retorna "Monto inválido"', () {
      expect(validador.validarMonto('abc'), 'Monto inválido');
      expect(validador.validarMonto(''), 'Monto inválido');
      expect(validador.validarMonto('-10'), 'Monto inválido');
      expect(validador.validarMonto('100.00'), isNull);
      expect(validador.validarMonto('100,00'), isNull);
    });

    test('Escenario 3: 0 personas retorna "Debe haber al menos una persona"', () {
      expect(validador.validarPersonas('0'), 'Debe haber al menos una persona');
      expect(validador.validarPersonas('-2'), 'Debe haber al menos una persona');
      expect(validador.validarPersonas(''), 'Debe haber al menos una persona');
      expect(validador.validarPersonas('abc'), 'Debe haber al menos una persona');
      expect(validador.validarPersonas('4'), isNull);
    });

    test('Clarificación: Propina vacía se considera válida y se parsea a 0.0', () {
      expect(validador.validarPropina(''), isNull);
      expect(validador.validarPropina(null), isNull);
      expect(validador.parsearPropina(''), 0.0);
      expect(validador.parsearPropina('10'), 10.0);
      expect(validador.validarPropina('-5'), 'Propina inválida');
    });
  });
}
