# Contratos de Interfaz: Dividir Cuenta

**Feature**: `001-dividir-cuenta`
**Date**: 2026-10-01

---

## 1. Contratos de Dominio (`lib/domain/`)

### `EstrategiaRedondeo` (Interfaz Abstracta)
```dart
abstract interface class EstrategiaRedondeo {
  double redondear(double valor);
}
```

### `CalcularDivision` (Caso de Uso)
```dart
class CalcularDivision {
  Resultado ejecutar({
    required Cuenta cuenta,
    required EstrategiaRedondeo estrategia,
  });
}
```

### `ValidarEntrada` (Validador)
```dart
class ValidarEntrada {
  String? validarMonto(String? texto);
  String? validarPersonas(String? texto);
  String? validarPropina(String? texto);

  double? parsearMonto(String? texto);
  int? parsearPersonas(String? texto);
  double parsearPropina(String? texto);
}
```

---

## 2. Contratos de Datos (`lib/data/`)

### `RedondeoExacto`
```dart
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double valor) => valor;
}
```

### `RedondeoHaciaArriba`
```dart
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  double redondear(double valor) => valor.ceilToDouble();
}
```

---

## 3. Contratos de Presentación (`lib/presentation/`)

### `FormateadorMoneda`
```dart
class FormateadorMoneda {
  /// Convierte un valor numérico a texto con dos decimales fijos (ej. 27.50, 4.00, 3.33).
  String formatear(double valor);
}
```

### `DivisorController`
```dart
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

  /// Ejecuta la validación y el cálculo.
  /// Retorna un estado con el mensaje de error o con el resultado formateado.
  EstadoDivision procesar({
    required String textoMonto,
    required String textoPersonas,
    required String textoPropina,
    required String claveEstrategia,
  });
}
```

### `EstadoDivision`
```dart
class EstadoDivision {
  final String? errorMonto;
  final String? errorPersonas;
  final String? resultadoPorPersona;
  final bool tieneResultado;

  EstadoDivision({
    this.errorMonto,
    this.errorPersonas,
    this.resultadoPorPersona,
    this.tieneResultado = false,
  });
}
```

---

## 4. Composición en `main.dart`
```dart
void main() {
  // Instanciación de dependencias (DIP)
  final calcularDivision = CalcularDivision();
  final validarEntrada = ValidarEntrada();
  final formateador = FormateadorMoneda();
  final estrategias = <String, EstrategiaRedondeo>{
    'exacto': RedondeoExacto(),
    'haciaArriba': RedondeoHaciaArriba(),
  };

  final controller = DivisorController(
    calcularDivision: calcularDivision,
    validarEntrada: validarEntrada,
    formateador: formateador,
    estrategias: estrategias,
  );

  runApp(DivisorCuentaApp(controller: controller));
}
```
