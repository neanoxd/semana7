/// Clase de utilidad para dar formato visual de moneda a valores numéricos.
///
/// **Por qué existe:** Cumple con el Principio de Responsabilidad Única (SRP),
/// asegurando que la lógica de cálculo matemático nunca se encargue de concatenar
/// o formatear texto para la interfaz de usuario.
/// **Qué recibe:** Un valor de tipo [double].
/// **Qué devuelve:** Una cadena con formato exacto de dos cifras decimales (ej. "27.50", "4.00").
/// **Qué errores produce:** No produce errores; ante valores no finitos devuelve "0.00".
class FormateadorMoneda {
  String formatear(double valor) {
    if (!valor.isFinite) return '0.00';
    return valor.toStringAsFixed(2);
  }
}
