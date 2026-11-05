import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Caso de uso de dominio que ejecuta la división matemática de una cuenta.
///
/// **Por qué existe:** Cumple con el Principio de Responsabilidad Única (SRP).
/// Su única responsabilidad es ejecutar la fórmula aritmética de adición de propina,
/// división entre comensales y aplicación de la estrategia de redondeo recibida.
/// No valida texto de entrada ni da formato para pantalla.
/// **Qué recibe:**
/// - [cuenta]: Instancia de [Cuenta] con los valores base validados.
/// - [estrategia]: Instancia de [EstrategiaRedondeo] que define la política de redondeo.
/// **Qué devuelve:** Una instancia inmutable de [Resultado].
/// **Qué errores produce:** No produce errores directamente, delegando validaciones previas a la entidad [Cuenta].
class CalcularDivision {
  Resultado ejecutar({
    required Cuenta cuenta,
    required EstrategiaRedondeo estrategia,
  }) {
    final montoPropina = cuenta.montoTotal * (cuenta.porcentajePropina / 100.0);
    final totalConPropina = cuenta.montoTotal + montoPropina;
    final cuotaBase = totalConPropina / cuenta.numeroPersonas;
    final cuotaFinal = estrategia.redondear(cuotaBase);

    return Resultado(
      totalConPropina: totalConPropina,
      montoPropina: montoPropina,
      montoPorPersona: cuotaFinal,
    );
  }
}
