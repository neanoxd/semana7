# Análisis de la Especificación y Constitución: QUÉ vs CÓMO

**Proyecto:** Divisor de Cuenta  
**Origen:** Flutter (móvil) → **Destino:** React (web)  
**Metodología:** Spec-Driven Development (SDD)

---

## 1. Análisis de la Especificación (`spec.md`)

Pregunta central para cada enunciado:  
> **¿Este enunciado seguiría siendo válido si la app estuviera hecha en React?**

| # | Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
|---|---|:---:|:---:|---|
| 1 | El usuario ingresa el monto total de la cuenta | **QUÉ** | ✅ Intacto | Requisito de entrada del usuario independiente de la tecnología. |
| 2 | El usuario ingresa el número de personas | **QUÉ** | ✅ Intacto | Requisito de entrada funcional del usuario. |
| 3 | El usuario ingresa el porcentaje de propina | **QUÉ** | ✅ Intacto | Parámetro de cálculo del negocio. |
| 4 | Al tocar/hacer clic en "Calcular", ve cuánto paga cada persona con dos decimales | **QUÉ** | ✅ Intacto | Comportamiento esperado de salida con precisión monetaria. |
| 5 | Hay dos modos de redondeo elegibles: exacto y hacia arriba al entero más cercano | **QUÉ** | ✅ Intacto | Regla de negocio de la lógica financiera. |
| 6 | La aplicación funciona sin conexión: no hay red ni base de datos | **QUÉ** | ✅ Intacto | Restricción arquitectónica de autonomía (offline). |
| 7 | Si el campo de propina está vacío, asumir automáticamente 0% de propina sin error | **QUÉ** | ✅ Intacto | Clarificación de regla de negocio ante omisión de entrada. |
| 8 | Escenario 1: 100.00, 4 personas, 10% propina, exacto → 27.50 por persona | **QUÉ** | ✅ Intacto | Criterio de aceptación y caso de prueba verificable. |
| 9 | Escenario 2: 90.00, 3 personas, 0% propina, exacto → 30.00 por persona | **QUÉ** | ✅ Intacto | Criterio de aceptación verificable. |
| 10 | Escenario 3: 50.00 y 0 personas → error "Debe haber al menos una persona" y sin resultado | **QUÉ** | ✅ Intacto | Criterio de validación de comensales. |
| 11 | Escenario 4: Monto "abc" → error "Monto inválido" y sin resultado | **QUÉ** | ✅ Intacto | Criterio de validación de formato numérico. |
| 12 | Escenario 5: 10.00, 3 personas, 0% propina, exacto → 3.33 por persona | **QUÉ** | ✅ Intacto | Criterio de aceptación con redondeo monetario a 2 decimales. |
| 13 | Escenario 6: 10.00, 3 personas, 0% propina, hacia arriba → 4.00 por persona | **QUÉ** | ✅ Intacto | Criterio de aceptación con redondeo techo entero. |
| 14 | Monto igual a 0.00 se procesa sin error dando 0.00 por persona | **QUÉ** | ✅ Intacto | Caso borde matemático. |
| 15 | Número de personas negativo muestra "Debe haber al menos una persona" | **QUÉ** | ✅ Intacto | Caso borde de validación. |
| 16 | Aceptación de separadores decimales alternativos (coma o punto) | **QUÉ** | ✅ Intacto | Robustez de entrada numérica. |
| 17 | Propina de 0% omite adición de propina y divide el monto base | **QUÉ** | ✅ Intacto | Regla aritmética de negocio. |
| 18 | FR-001: El sistema DEBE proveer un campo para ingresar el monto total | **QUÉ** | ✅ Intacto | Requisito funcional de interfaz abstracta. |
| 19 | FR-002: El sistema DEBE proveer un campo/selector para el número de personas | **QUÉ** | ✅ Intacto | Requisito funcional abstracto. |
| 20 | FR-003: El sistema DEBE proveer un campo/selector para el porcentaje de propina | **QUÉ** | ✅ Intacto | Requisito funcional abstracto. |
| 21 | FR-004: El sistema DEBE permitir elegir entre modo exacto y hacia arriba | **QUÉ** | ✅ Intacto | Requisito funcional de selección de modo. |
| 22 | FR-005: El sistema DEBE contar con un botón "Calcular" que dispare la operación | **QUÉ** | ✅ Intacto | Control de acción del usuario. |
| 23 | FR-006: Mostrar resultado por persona formateado estrictamente con dos decimales | **QUÉ** | ✅ Intacto | Formato de presentación comercial. |
| 24 | FR-007: Si personas <= 0, mostrar mensaje y no resultado numérico | **QUÉ** | ✅ Intacto | Requisito funcional de retroalimentación de error. |
| 25 | FR-008: Si monto no es numérico, mostrar mensaje y no resultado numérico | **QUÉ** | ✅ Intacto | Requisito funcional de retroalimentación de error. |
| 26 | FR-009: Toda la funcionalidad DEBE operar en una única pantalla autocontenida | **QUÉ** | ✅ Intacto | Alcance de la experiencia de usuario (Single Page / Single Screen). |
| 27 | FR-010: Funcionamiento 100% desconectado, sin llamadas de red ni base de datos | **QUÉ** | ✅ Intacto | Atributo de calidad funcional. |
| 28 | FR-011: Campo de propina vacío asume 0% de propina sin error | **QUÉ** | ✅ Intacto | Requisito funcional derivado de clarificación. |
| 29 | SC-001: El 100% de los 6 escenarios de aceptación producen exactamente el resultado y mensaje | **QUÉ** | ✅ Intacto | Criterio de éxito y cobertura de pruebas. |
| 30 | SC-002: Tiempo de respuesta al calcular menor a 50 ms | **QUÉ** | ✅ Intacto | Métrica de rendimiento de interfaz. |
| 31 | SC-003: Cero solicitudes de red salientes y sin persistencia en BD | **QUÉ** | ✅ Intacto | Métrica de verificación offline. |
| 32 | SC-004: Completar la interacción en menos de 15 segundos | **QUÉ** | ✅ Intacto | Métrica de usabilidad. |
| 33 | Interacción sin navegación secundaria ni menús contextuales | **QUÉ** | ✅ Intacto | Supuesto de diseño de interacción. |
| 34 | No persistencia de historial entre sesiones | **QUÉ** | ✅ Intacto | Supuesto de ciclo de vida del estado. |
| 35 | Porcentaje de propina es número no negativo | **QUÉ** | ✅ Intacto | Restricción de dominio de valores. |
| 36 | Cifras monetarias visualizadas con dos posiciones decimales estándar | **QUÉ** | ✅ Intacto | Convención de presentación monetaria. |

### Métricas de la Especificación:
- **Total de enunciados analizados:** 36
- **Enunciados clasificados como QUÉ:** 36 (100.0%)
- **Enunciados clasificados como CÓMO:** 0 (0.0%)
- **Enunciados clasificados como MIXTO:** 0 (0.0%)
- **% CÓMO:** `(0 / 36) * 100 = 0.0%`

> [!NOTE]
> El porcentaje de decisiones CÓMO en la especificación es **0.0%**, encontrándose muy por debajo del umbral pedagógico del **30%**. La especificación estuvo completamente libre de menciones a Flutter, widgets o clases concretas, lo que permitió que **viajara 100% intacta** a React.

---

## 2. Análisis de la Constitución (`constitution.md`)

| # | Regla de la Constitución original (Flutter) | Equivalente en React | Clasificación | Justificación |
|---|---|---|:---:|---|
| 1 | **SRP:** Una clase, una razón de cambio. El cálculo no valida ni formatea. | **SRP:** Una función o módulo, una razón de cambio. El cálculo no valida ni formatea. | **Adaptada en redacción** | En JavaScript se habla de módulos y funciones en lugar de clases obligatorias, pero la separación de responsabilidades se mantiene idéntica. |
| 2 | **OCP:** Agregar una nueva regla de redondeo no obliga a editar las clases que ya existen. | **OCP:** Agregar una nueva regla de redondeo no obliga a editar los módulos que ya existen. | **Adaptada en redacción** | Se sustituye "clases" por "módulos/funciones"; la extensibilidad sin modificación permanece intacta. |
| 3 | **LSP:** Cualquier implementación de una interfaz puede sustituir a otra sin preguntar de qué tipo es. | **LSP:** Cualquier implementación de la interfaz de redondeo puede sustituir a otra sin preguntar de qué tipo es. | **Adaptada en redacción** | En JS el polimorfismo se basa en el contrato `aplicar(valor)`; el principio de sustitución se conserva intacto. |
| 4 | **ISP:** Interfaces pequeñas; nadie depende de métodos que no usa. | **ISP:** Interfaces pequeñas; nadie depende de funciones que no usa. | **Adaptada en redacción** | Se adapta la terminología de métodos a contratos de funciones pequeñas. |
| 5 | **DIP:** `presentation` depende de abstracciones de `domain`, nunca de clases concretas de `data`. | **DIP:** `presentation` depende de abstracciones del `domain`, nunca de implementaciones concretas de `data`. | **Adaptada en redacción** | La regla de inversión de dependencias se mantiene íntegra mediante inyección de dependencias. |
| 6 | **Capas:** `presentation` / `domain` / `data`. | **Capas:** `src/presentation` / `src/domain` / `src/data`. | **Adaptada en redacción** | Solo cambia el prefijo de carpeta de `lib/` a `src/`. |
| 7 | **Regla de dependencia:** `presentation -> domain <- data`. | **Regla de dependencia:** `presentation -> domain <- data`. | **Idéntica** | La dirección de dependencias de la Arquitectura Limpia es universal e independiente del lenguaje. |
| 8 | **Aislamiento del dominio:** `lib/domain/` no importa `package:flutter` (es Dart puro). | **Aislamiento del dominio:** `src/domain/` NO importa `react` ni nada del DOM (es JavaScript puro). | **Adaptada en redacción** | El principio de desacoplar el núcleo de negocio del framework se preserva adaptando la tecnología (`package:flutter` → `react`/DOM). |
| 9 | **Inyección de dependencias:** `main.dart` es el ÚNICO lugar donde se instancian implementaciones concretas. | **Inyección de dependencias:** `src/main.jsx` es el ÚNICO lugar donde se instancian implementaciones concretas. | **Adaptada en redacción** | El patrón Composition Root se mantiene intacto, cambiando únicamente el archivo de entrada (`main.dart` → `src/main.jsx`). |
| 10 | **Seguridad:** Nunca guardar secretos ni API keys en el repositorio. | **Seguridad:** Nunca guardar secretos ni API keys en el repositorio. | **Idéntica** | Regla de seguridad universal. |
| 11 | **Calidad y Pruebas:** Toda funcionalidad crítica tiene pruebas. | **Calidad y Pruebas:** Toda funcionalidad crítica tiene pruebas. | **Idéntica** | Principio de calidad agnóstico a la tecnología. |
| 12 | **Calidad y Pruebas:** Los criterios de aceptación de la spec se convierten en pruebas ejecutables. | **Calidad y Pruebas:** Los criterios de aceptación de la spec se convierten en pruebas ejecutables. | **Idéntica** | Principio medular de SDD. |
| 13 | **Regla de la Materia:** Toda función generada por el agente debe poder explicarla el estudiante... | **Regla de la Materia:** Toda función generada por el agente debe poder explicarla el estudiante... | **Idéntica** | Regla pedagógica permanente. |

### Resumen de la Constitución:
- **Reglas idénticas:** 5 (38.5%)
- **Reglas adaptadas en redacción:** 8 (61.5%)
- **Reglas reemplazadas:** 0 (0.0%)
- **Reglas no reusables:** 0 (0.0%)
