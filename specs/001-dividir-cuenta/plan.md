# Implementation Plan: Dividir Cuenta de Restaurante

**Branch**: `001-dividir-cuenta` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-dividir-cuenta/spec.md`

---

## Summary

Desarrollar una aplicación móvil en Flutter de una sola pantalla para dividir la cuenta de un restaurante entre varias personas, calculando propinas y cuotas por persona con dos modos de redondeo (`exacto` y `hacia arriba al entero más cercano`). La arquitectura respeta rigurosamente los principios SOLID y la separación en capas (`presentation -> domain <- data`), donde `lib/domain/` es Dart puro y `main.dart` es el único punto de composición e inyección de dependencias.

---

## Technical Context

- **Language/Version**: Dart 3.13+ / Flutter 3.47+ (SDK estable)
- **Primary Dependencies**: Ninguna dependencia externa (cero paquetes en `pubspec.yaml`; uso exclusivo de Flutter SDK y Material Design nativo)
- **Storage**: N/A (aplicación 100% desconectada y en memoria; sin base de datos ni red)
- **Testing**: `flutter_test` (pruebas unitarias para `domain` y `data`, y pruebas de widgets para `presentation`)
- **Target Platform**: Multiplataforma (Android, iOS, Web, Windows Desktop)
- **Project Type**: Aplicación móvil/escritorio de una sola pantalla
- **Performance Goals**: Cálculo y renderizado reactivo en $< 50$ milisegundos tras accionar "Calcular"
- **Constraints**:
  - `lib/domain/` NO debe importar nada de `package:flutter`.
  - Capas estrictas: `presentation -> domain <- data`.
  - Gestión de estado local con `setState` en la pantalla.
  - Formato estricto con dos decimales para montos monetarios.
- **Scale/Scope**: 1 pantalla, 6 escenarios de aceptación fundamentales, ~10 clases bien delimitadas.

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **SOLID - Single Responsibility Principle (SRP):**
  - `ValidarEntrada`: Solo valida texto crudo y genera mensajes de error.
  - `CalcularDivision`: Solo realiza la lógica matemática; no valida cadenas ni formatea para vista.
  - `FormateadorMoneda`: Solo da formato visual con dos decimales.
  - `DivisorController`: Solo orquesta el flujo entre capas.
- [x] **SOLID - Open/Closed Principle (OCP):**
  - La interfaz `EstrategiaRedondeo` permite añadir nuevas estrategias en `data/` sin modificar `CalcularDivision` ni clases existentes.
- [x] **SOLID - Liskov Substitution Principle (LSP):**
  - `RedondeoExacto` y `RedondeoHaciaArriba` son intercambiables como `EstrategiaRedondeo` sin verificaciones de tipo (`is` o `as`).
- [x] **SOLID - Interface Segregation Principle (ISP):**
  - `EstrategiaRedondeo` contiene exactamente un método (`double redondear(double valor)`).
- [x] **SOLID - Dependency Inversion Principle (DIP):**
  - `presentation/` (`DivisorController`) depende de las abstracciones de `domain/`, nunca de las clases concretas de `data/`.
- [x] **Arquitectura y Regla de Dependencia:**
  - `presentation -> domain <- data`.
  - `lib/domain/` es Dart puro y NO importa `package:flutter`.
- [x] **Punto Único de Composición:**
  - `main.dart` es el ÚNICO lugar donde se instancian las implementaciones concretas e inyectan hacia la presentación.
- [x] **Seguridad:**
  - Cero secretos o claves de API.
- [x] **Calidad y Pruebas:**
  - Pruebas automatizadas de los 6 escenarios de aceptación en `test/`.
- [x] **Regla de la Materia:**
  - Cada función posee un propósito claro y parámetros/retornos explicables didácticamente.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── spec.md              # Especificación funcional y de requisitos
├── plan.md              # Este plan de implementación arquitectónica
├── research.md          # Investigación técnica y decisiones de diseño
├── data-model.md        # Entidades, casos de uso y contratos de datos
├── quickstart.md        # Guía de verificación rápida de los 6 escenarios
├── contracts/           # Definición de interfaces y firmas públicas
│   └── divisor_contracts.md
└── checklists/          # Lista de verificación de requisitos
    └── requirements.md
```

### Source Code (repository layout)

```text
lib/
├── domain/                          # Dart puro (sin package:flutter)
│   ├── cuenta.dart                  # Entidad de datos base
│   ├── resultado.dart               # Value object del resultado de división
│   ├── estrategia_redondeo.dart     # Interfaz abstracta (OCP)
│   ├── calcular_division.dart       # Caso de uso de cálculo matemático (SRP)
│   └── validar_entrada.dart         # Servicio de validación de entradas crudas (SRP)
│
├── data/                            # Implementaciones de estrategias (Dart puro)
│   ├── redondeo_exacto.dart         # Redondeo exacto (LSP)
│   └── redondeo_hacia_arriba.dart   # Redondeo techo (LSP)
│
├── presentation/                    # Capa visual (con package:flutter)
│   ├── divisor_controller.dart      # Controlador inyectado (DIP)
│   ├── formateador_moneda.dart      # Formateo visual a dos decimales (SRP)
│   └── pantalla_divisor.dart        # Única pantalla con setState local
│
└── main.dart                        # Punto único de composición e inyección
```

---

## Complexity Tracking

*No violations to justify. Architecture complies 100% with project Constitution.*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| *Ninguna* | *Cumplimiento total de SOLID y arquitectura limpia* | *N/A* |
