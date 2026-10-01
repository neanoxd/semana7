# Tasks: Dividir Cuenta de Restaurante

**Feature**: `001-dividir-cuenta`
**Date**: 2026-10-01
**Spec**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Preparación de la estructura del proyecto y herramientas de análisis

- [X] T001 Crear estructura limpia de carpetas `lib/domain/`, `lib/data/`, `lib/presentation/` y `test/` según el plan de implementación
- [X] T002 [P] Verificar configuración de linter y reglas de null safety en `analysis_options.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Modelos base e interfaces de dominio que bloquean el inicio de las historias de usuario

- [X] T003 [P] Crear entidad inmutable `Cuenta` en `lib/domain/cuenta.dart` con campos `montoTotal`, `numeroPersonas` y `porcentajePropina`
- [X] T004 [P] Crear value object `Resultado` en `lib/domain/resultado.dart` con campos `totalConPropina`, `montoPropina` y `montoPorPersona`
- [X] T005 [P] Crear interfaz abstracta pura `EstrategiaRedondeo` en `lib/domain/estrategia_redondeo.dart` con método `double redondear(double valor)`
- [X] T006 [P] Crear clase `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` para formatear valores numéricos a texto con dos decimales
- [X] T007 Crear clase `EstadoDivision` en `lib/presentation/divisor_controller.dart` para representar el estado de la vista (resultado formateado y mensajes de error)

**Checkpoint**: Base lista e independiente de Flutter en `domain/`. Se puede iniciar la implementación de historias de usuario.

---

## Phase 3: User Story 1 - División de Cuenta en Modo Exacto (Priority: P1) 🎯 MVP

**Goal**: Permitir al usuario ingresar monto, personas y propina, y presionar "Calcular" para obtener la división exacta con dos decimales (Escenarios 1, 2 y 5).

**Independent Test**: Ingresar `100.00`, 4 personas, 10% propina y verificar `27.50` por persona; ingresar `90.00`, 3 personas, 0% propina y verificar `30.00`; ingresar `10.00`, 3 personas, 0% propina y verificar `3.33`.

### Tests para User Story 1
- [X] T008 [P] [US1] Pruebas unitarias de `RedondeoExacto` en `test/data/redondeo_exacto_test.dart`
- [X] T009 [P] [US1] Pruebas unitarias del caso de uso `CalcularDivision` en modo exacto en `test/domain/calcular_division_test.dart` (Escenarios 1, 2 y 5)

### Implementation para User Story 1
- [X] T010 [P] [US1] Implementar `RedondeoExacto` en `lib/data/redondeo_exacto.dart` implementando `EstrategiaRedondeo`
- [X] T011 [US1] Implementar caso de uso `CalcularDivision` en `lib/domain/calcular_division.dart`
- [X] T012 [US1] Implementar `DivisorController` en `lib/presentation/divisor_controller.dart` conectando cálculo y formateo
- [X] T013 [US1] Construir interfaz de usuario en `lib/presentation/pantalla_divisor.dart` con campos de entrada, botón "Calcular" y visualización del resultado
- [X] T014 [US1] Configurar inyección de dependencias en `lib/main.dart` instanciando las implementaciones e iniciando la aplicación

**Checkpoint**: User Story 1 (MVP) completamente funcional y verificable de manera aislada.

---

## Phase 4: User Story 2 - División con Redondeo hacia Arriba (Priority: P2)

**Goal**: Permitir al usuario seleccionar el modo de redondeo hacia arriba al entero más cercano (Escenario 6: 10.00, 3 personas, 0% -> 4.00 por persona).

**Independent Test**: Seleccionar modo "hacia arriba" con monto `10.00`, 3 personas y 0% propina, presionar "Calcular" y verificar que el resultado mostrado sea `4.00`.

### Tests para User Story 2
- [X] T015 [P] [US2] Pruebas unitarias de `RedondeoHaciaArriba` en `test/data/redondeo_hacia_arriba_test.dart`
- [X] T016 [P] [US2] Pruebas unitarias de `CalcularDivision` con `RedondeoHaciaArriba` en `test/domain/calcular_division_redondeo_test.dart` (Escenario 6)

### Implementation para User Story 2
- [X] T017 [P] [US2] Implementar `RedondeoHaciaArriba` en `lib/data/redondeo_hacia_arriba.dart` usando `ceilToDouble()`
- [X] T018 [US2] Registrar la estrategia `RedondeoHaciaArriba` en el mapa de estrategias de `DivisorController` e inyectarla desde `lib/main.dart`
- [X] T019 [US2] Agregar selector de modo de redondeo (`Exacto` / `Hacia arriba`) en `lib/presentation/pantalla_divisor.dart`

**Checkpoint**: User Story 1 y User Story 2 funcionales y conmutables sin modificar el cálculo base (OCP).

---

## Phase 5: User Story 3 - Validación de Datos de Entrada y Mensajes de Error (Priority: P1)

**Goal**: Validar entradas y mostrar mensajes de error específicos ("Debe haber al menos una persona", "Monto inválido") sin mostrar resultado numérico cuando los datos sean incorrectos (Escenarios 3 y 4).

**Independent Test**: Probar con 0 personas y verificar mensaje "Debe haber al menos una persona" y sin resultado; probar con monto "abc" y verificar mensaje "Monto inválido" y sin resultado.

### Tests para User Story 3
- [X] T020 [P] [US3] Pruebas unitarias de `ValidarEntrada` en `test/domain/validar_entrada_test.dart` verificando montos inválidos, personas <= 0 y propina vacía por defecto 0%
- [X] T021 [P] [US3] Pruebas de widgets completas en `test/presentation/pantalla_divisor_test.dart` cubriendo los 6 escenarios de aceptación de extremo a extremo

### Implementation para User Story 3
- [X] T022 [US3] Implementar clase de dominio `ValidarEntrada` en `lib/domain/validar_entrada.dart`
- [X] T023 [US3] Integrar `ValidarEntrada` en `DivisorController` en `lib/presentation/divisor_controller.dart` para bloquear el cálculo y emitir errores
- [X] T024 [US3] Desplegar mensajes de error en rojo en `lib/presentation/pantalla_divisor.dart` y ocultar resultado numérico cuando el estado tenga errores

**Checkpoint**: Todos los escenarios de validación y cálculo completados y probados.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verificación de calidad, análisis estático y cumplimiento de la Constitución

- [X] T025 [P] Ejecutar análisis estático con `flutter analyze` asegurando 0 errores y 0 advertencias en todo el proyecto
- [X] T026 [P] Ejecutar suite de pruebas completa con `flutter test` verificando que el 100% de las pruebas pasen
- [X] T027 [P] Auditar que `lib/domain/` no contenga ningún import de `package:flutter` y que `main.dart` sea el único punto de instanciación
- [X] T028 Ejecutar validación final según los escenarios de `specs/001-dividir-cuenta/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (Phase 1)**: Sin dependencias, inicio inmediato.
- **Foundational (Phase 2)**: Depende de Phase 1. Bloquea las historias de usuario.
- **User Story 1 (Phase 3)**: Depende de Phase 2. Entrega el MVP funcional.
- **User Story 2 (Phase 4)**: Depende de Phase 2 y Phase 3 (agrega la estrategia de redondeo techo).
- **User Story 3 (Phase 5)**: Depende de Phase 2 y se integra con la UI de Phase 3.
- **Polish (Phase 6)**: Depende de todas las historias completadas.

### Parallel Opportunities
- T003, T004, T005, T006 pueden implementarse en paralelo (archivos independientes).
- T008 y T009 (tests de US1) pueden escribirse en paralelo.
- T015 y T016 (tests de US2) pueden escribirse en paralelo.
- T020 y T021 (tests de US3) pueden escribirse en paralelo.
- T025, T026, T027 pueden ejecutarse en paralelo en la fase final.
