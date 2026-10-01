import '../domain/estrategia_redondeo.dart';

/// Implementación concreta de la estrategia de redondeo hacia arriba.
///
/// **Por qué existe:** Cumple con el Principio de Sustitución de Liskov (LSP)
/// y Abierto/Cerrado (OCP), permitiendo redondear la cuota de cada persona
/// al entero superior más cercano (usando la función techo matemática).
/// **Qué recibe:** Un valor de tipo [double].
/// **Qué devuelve:** El entero superior inmediato expresado como [double] (ej. 3.33 -> 4.0).
/// **Qué errores produce:** No produce errores.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  double redondear(double valor) => valor.ceilToDouble();
}
