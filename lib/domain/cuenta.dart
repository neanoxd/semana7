/// Entidad de dominio que representa los datos financieros de una cuenta
/// para ser dividida entre varias personas.
///
/// **Por qué existe:** Encapsula y transporta de forma inmutable los valores
/// necesarios para el cálculo de la división (monto, personas y propina).
/// **Qué recibe:**
/// - [montoTotal]: Valor numérico de la cuenta antes de propinas.
/// - [numeroPersonas]: Cantidad de comensales (debe ser mayor o igual a 1).
/// - [porcentajePropina]: Porcentaje de propina (por defecto 0.0).
/// **Qué errores produce:** Lanza [ArgumentError] si `numeroPersonas` es menor a 1
/// o si `montoTotal` es negativo.
class Cuenta {
  final double montoTotal;
  final int numeroPersonas;
  final double porcentajePropina;

  Cuenta({
    required this.montoTotal,
    required this.numeroPersonas,
    this.porcentajePropina = 0.0,
  }) {
    if (numeroPersonas < 1) {
      throw ArgumentError('El número de personas debe ser al menos 1.');
    }
    if (montoTotal < 0) {
      throw ArgumentError('El monto total no puede ser negativo.');
    }
    if (porcentajePropina < 0) {
      throw ArgumentError('El porcentaje de propina no puede ser negativo.');
    }
  }
}
