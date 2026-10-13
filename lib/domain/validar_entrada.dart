/// Servicio de dominio para la validación y análisis de entradas textuales crudas.
///
/// **Por qué existe:** Cumple con el Principio de Responsabilidad Única (SRP),
/// aislando completamente la comprobación y saneamiento de cadenas de texto
/// de la lógica de cálculo y de los widgets de presentación.
/// **Qué recibe:** Cadenas de texto opcionales provenientes de la interfaz.
/// **Qué devuelve:** Mensajes de error en caso de fallo, o `null` si la entrada es válida.
class ValidarEntrada {
  /// Valida los valores numéricos de una cuenta a nivel de dominio.
  ///
  /// **Por qué existe:** Cumple con el Principio de Responsabilidad Única (SRP),
  /// permitiendo verificar los datos antes de ejecutar la lógica de cálculo sin acoplarse a la UI.
  /// **Qué recibe:**
  /// - [monto]: Monto total numérico de la cuenta.
  /// - [personas]: Número entero de comensales.
  /// - [propina]: Porcentaje opcional de propina (por defecto 0.0).
  /// **Qué devuelve:** Mensaje de error si algún valor es inválido, o `null` si son correctos.
  /// **Qué errores produce:** No lanza excepciones.
  String? validar(double monto, int personas, [double propina = 0.0]) {
    if (monto.isNaN || monto.isInfinite || monto < 0) {
      return 'Monto inválido';
    }
    if (personas < 1) {
      return 'Debe haber al menos una persona';
    }
    if (propina.isNaN || propina.isInfinite || propina < 0) {
      return 'Propina inválida';
    }
    if (propina > 100) {
      return 'La propina no puede superar el 100%';
    }
    return null;
  }

  /// Valida que el texto del monto sea un número válido y no negativo.
  /// Retorna "Monto inválido" en caso de error, o `null` si es correcto.
  String? validarMonto(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Monto inválido';
    }
    final normalizado = texto.trim().replaceAll(',', '.');
    final valor = double.tryParse(normalizado);
    if (valor == null || valor.isNaN || valor.isInfinite || valor < 0) {
      return 'Monto inválido';
    }
    return null;
  }

  /// Valida que el texto de personas sea un entero positivo mayor o igual a 1.
  /// Retorna "Debe haber al menos una persona" en caso de error, o `null` si es correcto.
  String? validarPersonas(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Debe haber al menos una persona';
    }
    final valor = int.tryParse(texto.trim());
    if (valor == null || valor < 1) {
      return 'Debe haber al menos una persona';
    }
    return null;
  }

  /// Valida el porcentaje de propina. Si está vacío se asume válido (0.0%).
  String? validarPropina(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return null;
    }
    final normalizado = texto.trim().replaceAll(',', '.');
    final valor = double.tryParse(normalizado);
    if (valor == null || valor < 0) {
      return 'Propina inválida';
    }
    if (valor > 100) {
      return 'La propina no puede superar el 100%';
    }
    return null;
  }

  /// Parsea el monto a double, asumiendo validación previa.
  double? parsearMonto(String? texto) {
    if (validarMonto(texto) != null) return null;
    return double.parse(texto!.trim().replaceAll(',', '.'));
  }

  /// Parsea el número de personas a int, asumiendo validación previa.
  int? parsearPersonas(String? texto) {
    if (validarPersonas(texto) != null) return null;
    return int.parse(texto!.trim());
  }

  /// Parsea la propina a double. Si está vacía retorna 0.0.
  double parsearPropina(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 0.0;
    final normalizado = texto.trim().replaceAll(',', '.');
    return double.tryParse(normalizado) ?? 0.0;
  }
}
