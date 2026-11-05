import '../domain/estrategia_redondeo.dart';

/// Implementación concreta de la estrategia de redondeo exacto.
///
/// **Por qué existe:** Cumple con el Principio de Sustitución de Liskov (LSP),
/// permitiendo calcular la cuota por persona con precisión de dos decimales (centavos)
/// según la especificación del dominio financiero.
/// **Qué recibe:** Un valor de tipo [double].
/// **Qué devuelve:** El valor redondeado a dos decimales.
/// **Qué errores produce:** No produce errores.
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double valor) {
    return double.parse(valor.toStringAsFixed(2));
  }
}
