/// Contrato abstracto para implementar estrategias de redondeo numérico.
///
/// **Por qué existe:** Aplica el Principio de Abierto/Cerrado (OCP) e Interface
/// Segregation (ISP), permitiendo añadir nuevas formas de redondeo sin modificar
/// el caso de uso de cálculo existente.
/// **Qué recibe:** Un valor fraccionario de tipo [double].
/// **Qué devuelve:** El valor ajustado según la regla de redondeo correspondiente.
/// **Qué errores produce:** No produce errores en condiciones estándar de números válidos.
abstract interface class EstrategiaRedondeo {
  double redondear(double valor);
}
