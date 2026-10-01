import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';

void main() {
  group('RedondeoHaciaArriba', () {
    final estrategia = RedondeoHaciaArriba();

    test('redondea hacia arriba al entero más cercano', () {
      expect(estrategia.redondear(3.3333), 4.0);
      expect(estrategia.redondear(3.01), 4.0);
      expect(estrategia.redondear(4.00), 4.0);
      expect(estrategia.redondear(27.50), 28.0);
    });
  });
}
