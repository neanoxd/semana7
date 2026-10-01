# Feature Specification: Dividir Cuenta de Restaurante

**Feature Branch**: `001-dividir-cuenta`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar 'Calcular' ve cuánto paga cada persona con dos decimales. Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al entero más cercano. La app funciona sin conexión: no hay red ni base de datos."

---

## Clarifications

### Session 2026-10-01
- Q: ¿Cómo debe comportarse la aplicación si el usuario deja el campo de propina vacío al presionar "Calcular"? → A: Asumir automáticamente 0% de propina y proceder con el cálculo sin mostrar error.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - División de Cuenta en Modo Exacto (Priority: P1)

Como usuario en un restaurante, quiero ingresar el monto total de la cuenta, el número de comensales y el porcentaje de propina para conocer rápidamente la cantidad exacta con dos decimales que le corresponde pagar a cada persona.

**Why this priority**: Representa la funcionalidad medular (MVP) de la aplicación. Sin este cálculo, la aplicación no aporta valor al usuario.

**Independent Test**: Puede probarse de manera aislada ingresando montos, comensales y propinas válidas en modo exacto, comprobando que el monto resultante por persona coincida con la división matemática precisa con dos decimales.

**Acceptance Scenarios**:

1. **Given** un monto de `100.00`, `4` personas, `10%` de propina y modo de redondeo `exacto`, **When** el usuario toca "Calcular", **Then** se muestra un resultado de `27.50` por persona.
2. **Given** un monto de `90.00`, `3` personas, `0%` de propina y modo de redondeo `exacto`, **When** el usuario toca "Calcular", **Then** se muestra un resultado de `30.00` por persona.
3. **Given** un monto de `10.00`, `3` personas, `0%` de propina y modo de redondeo `exacto`, **When** el usuario toca "Calcular", **Then** se muestra un resultado de `3.33` por persona.

---

### User Story 2 - División con Redondeo hacia Arriba (Priority: P2)

Como usuario que paga en efectivo o prefiere evitar fracciones de centavos, quiero seleccionar la opción de redondear hacia arriba al entero más cercano para que cada persona aporte un monto entero conveniente que cubra la totalidad de la cuenta.

**Why this priority**: Complementa el cálculo exacto ofreciendo flexibilidad práctica al momento de realizar pagos físicos sin lidiar con monedas sueltas.

**Independent Test**: Puede probarse ingresando una cuenta con resultado fraccionario y seleccionando el modo "hacia arriba", verificando que la cuota individual se aproxime al entero inmediato superior.

**Acceptance Scenarios**:

1. **Given** un monto de `10.00`, `3` personas, `0%` de propina y modo de redondeo `hacia arriba al entero más cercano`, **When** el usuario toca "Calcular", **Then** se muestra un resultado de `4.00` por persona.

---

### User Story 3 - Validación de Datos de Entrada y Mensajes de Error (Priority: P1)

Como usuario de la aplicación, quiero recibir advertencias claras cuando los valores introducidos sean inválidos o inconsistentes para corregirlos de inmediato y evitar cálculos erróneos.

**Why this priority**: La robustez en la validación previene divisiones por cero, cálculos matemáticos imposibles y estados inconsistentes en la interfaz de usuario.

**Independent Test**: Puede probarse ingresando caracteres no numéricos o cantidades de personas menores a 1, verificando que la aplicación despliegue el mensaje de error correspondiente y no presente un resultado.

**Acceptance Scenarios**:

1. **Given** un monto de `50.00` y `0` personas, **When** el usuario intenta calcular, **Then** se muestra el mensaje `"Debe haber al menos una persona"` y NO se muestra ningún resultado.
2. **Given** un campo de monto que contiene `"abc"`, **When** el usuario intenta calcular o introduce el texto, **Then** se muestra el mensaje `"Monto inválido"` y NO se muestra ningún resultado.

---

### Edge Cases

- **Monto igual a cero**: El cálculo debe procesar `0.00` sin arrojar errores, dando como resultado `0.00` por persona.
- **Número de personas negativo**: Debe tratarse bajo la misma regla de validación mostrando `"Debe haber al menos una persona"`.
- **Valores con separadores decimales alternativos (coma o punto)**: El sistema debe aceptar entradas numéricas estándar garantizando que `"10.00"` o `"10,00"` se interpreten correctamente o notifiquen formato inválido según corresponda.
- **Propina de 0%**: El cálculo debe omitir cualquier adición de propina y dividir únicamente el monto base.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer un campo para ingresar el monto total de la cuenta.
- **FR-002**: El sistema DEBE proveer un campo o selector para ingresar el número de personas.
- **FR-003**: El sistema DEBE proveer un campo o selector para ingresar el porcentaje de propina.
- **FR-004**: El sistema DEBE permitir al usuario elegir entre dos modos de redondeo: `exacto` y `hacia arriba al entero más cercano`.
- **FR-005**: El sistema DEBE contar con un botón "Calcular" que dispare la operación de división.
- **FR-006**: Al presionar "Calcular" con datos válidos, el sistema DEBE mostrar el valor que corresponde pagar a cada persona formateado estrictamente con dos decimales (ej. `27.50`, `30.00`, `3.33`, `4.00`).
- **FR-007**: Si el número de personas es menor o igual a cero, el sistema DEBE mostrar el mensaje `"Debe haber al menos una persona"` y NO debe mostrar ningún resultado numérico.
- **FR-008**: Si el monto ingresado contiene caracteres no numéricos inválidos (por ejemplo `"abc"`), el sistema DEBE mostrar el mensaje `"Monto inválido"` y NO debe mostrar ningún resultado numérico.
- **FR-009**: Toda la funcionalidad DEBE operar en una única pantalla de manera autocontenida.
- **FR-010**: La aplicación DEBE funcionar 100% desconectada (offline), sin dependencias de red, servicios web ni bases de datos externas o locales.
- **FR-011**: Si el usuario deja el campo de porcentaje de propina vacío al tocar "Calcular", el sistema DEBE asumir automáticamente un valor de 0% de propina y proceder con el cálculo sin mostrar mensaje de error.

---

### Key Entities

- **Cuenta / Consumo**: Representa la obligación financiera inicial (monto base y porcentaje de propina aplicable).
- **Criterio de División**: Especifica el número de participantes (entero positivo) y la regla de redondeo seleccionada (`exacto` o `hacia arriba`).
- **Liquidación Individual**: Resultado calculado que contiene el monto asignado a cada comensal con precisión de dos decimales.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de los 6 escenarios de aceptación descritos producen exactamente el resultado y mensaje esperado.
- **SC-002**: El tiempo de respuesta entre el toque del botón "Calcular" y la actualización del resultado en pantalla es menor a 50 milisegundos.
- **SC-003**: La aplicación se ejecuta de forma autónoma con cero solicitudes de red salientes y sin persistencia en base de datos.
- **SC-004**: Los usuarios pueden ingresar los datos y obtener el resultado final en menos de 15 segundos en una única pantalla interactiva.

---

## Assumptions

- Toda la interacción ocurre dentro de una única pantalla sin navegación secundaria ni menús contextuales obligatorios.
- No se requiere persistir el historial de cálculos entre sesiones de la aplicación.
- El porcentaje de propina se ingresa o selecciona como un número no negativo (ej. `0`, `10`, etc.).
- Las cifras monetarias se visualizan con dos posiciones decimales estándar.
