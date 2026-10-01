import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';

void main() {
  group('RedondeoExacto', () {
    final estrategia = RedondeoExacto();

    test('devuelve el valor con dos decimales exactos', () {
      expect(estrategia.redondear(27.50), 27.50);
      expect(estrategia.redondear(30.00), 30.00);
      expect(estrategia.redondear(10.0 / 3), 3.33);
    });
  });
}
