import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/validar_entrada.dart';
import 'formateador_moneda.dart';

/// Estado inmutable para la pantalla del divisor de cuenta.
///
/// **Por qué existe:** Transporta de manera segura los datos hacia la vista
/// indicando si existen errores de validación o un resultado calculado válido.
/// **Qué contiene:**
/// - [errorMonto]: Mensaje de error para el campo de monto (o `null`).
/// - [errorPersonas]: Mensaje de error para el campo de comensales (o `null`).
/// - [errorPropina]: Mensaje de error para la propina (o `null`).
/// - [resultadoPorPersona]: Texto formateado con dos decimales de la cuota (o `null`).
/// - [tieneResultado]: `true` si el cálculo fue exitoso y no hay errores.
class EstadoDivision {
  final String? errorMonto;
  final String? errorPersonas;
  final String? errorPropina;
  final String? resultadoPorPersona;
  final bool tieneResultado;

  const EstadoDivision({
    this.errorMonto,
    this.errorPersonas,
    this.errorPropina,
    this.resultadoPorPersona,
    this.tieneResultado = false,
  });

  const EstadoDivision.inicial()
      : errorMonto = null,
        errorPersonas = null,
        errorPropina = null,
        resultadoPorPersona = null,
        tieneResultado = false;
}

/// Controlador de presentación que orquesta el flujo entre la UI y el Dominio.
///
/// **Por qué existe:** Aplica el Principio de Inversión de Dependencias (DIP) y
/// Responsabilidad Única (SRP). Recibe sus dependencias por constructor y coordina
/// la validación y el cálculo sin acoplar la pantalla a detalles de implementación.
/// **Qué recibe en constructor:**
/// - [calcularDivision]: Caso de uso de cálculo matemático.
/// - [validarEntrada]: Servicio de validación de cadenas crudas.
/// - [formateador]: Utilidad de formateo a dos decimales.
/// - [estrategias]: Mapa de estrategias disponibles que implementan [EstrategiaRedondeo].
class DivisorController {
  final CalcularDivision calcularDivision;
  final ValidarEntrada validarEntrada;
  final FormateadorMoneda formateador;
  final Map<String, EstrategiaRedondeo> estrategias;

  DivisorController({
    required this.calcularDivision,
    required this.validarEntrada,
    required this.formateador,
    required this.estrategias,
  });

  /// Procesa los datos ingresados por el usuario.
  /// Si alguna validación falla, devuelve un [EstadoDivision] con los errores y sin resultado.
  /// Si los datos son correctos, realiza el cálculo y devuelve la cuota formateada.
  EstadoDivision procesar({
    required String textoMonto,
    required String textoPersonas,
    required String textoPropina,
    required String claveEstrategia,
  }) {
    final errorMonto = validarEntrada.validarMonto(textoMonto);
    final errorPersonas = validarEntrada.validarPersonas(textoPersonas);
    final errorPropina = validarEntrada.validarPropina(textoPropina);

    if (errorMonto != null || errorPersonas != null || errorPropina != null) {
      return EstadoDivision(
        errorMonto: errorMonto,
        errorPersonas: errorPersonas,
        errorPropina: errorPropina,
        resultadoPorPersona: null,
        tieneResultado: false,
      );
    }

    final monto = validarEntrada.parsearMonto(textoMonto)!;
    final personas = validarEntrada.parsearPersonas(textoPersonas)!;
    final propina = validarEntrada.parsearPropina(textoPropina);

    final estrategia = estrategias[claveEstrategia] ??
        estrategias.values.first;

    final cuenta = Cuenta(
      montoTotal: monto,
      numeroPersonas: personas,
      porcentajePropina: propina,
    );

    final resultado = calcularDivision.ejecutar(
      cuenta: cuenta,
      estrategia: estrategia,
    );

    return EstadoDivision(
      resultadoPorPersona: formateador.formatear(resultado.montoPorPersona),
      tieneResultado: true,
    );
  }
}
