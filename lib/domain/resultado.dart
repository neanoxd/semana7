/// Value object inmutable que representa el resultado del cálculo de división.
///
/// **Por qué existe:** Comunica de manera limpia y tipada el desglose final
/// de la cuenta calculada hacia las capas superiores sin acoplarlas.
/// **Qué contiene:**
/// - [totalConPropina]: La suma del monto original más la propina calculada.
/// - [montoPropina]: El valor monetario de la propina aplicada.
/// - [montoPorPersona]: Cuota final asignada a cada persona tras aplicar el redondeo.
/// **Qué devuelve:** Valores de tipo `double` inmutables.
class Resultado {
  final double totalConPropina;
  final double montoPropina;
  final double montoPorPersona;

  const Resultado({
    required this.totalConPropina,
    required this.montoPropina,
    required this.montoPorPersona,
  });
}
