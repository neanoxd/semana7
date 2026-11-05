# Respuestas — Deber 3

**Estudiante:** Leandro  
**Materia:** Programación Asistida de Aplicaciones · USFQ  
**Proyecto:** Divisor de Cuenta (Flutter)

---

### 1. Rojo antes de verde

- **Mensaje de error mostrado por `flutter test` en la Parte 2:**
  ```text
  Expected: 'La propina no puede superar el 100%'
    Actual: <null>
     Which: not an <Instance of 'String'>
  ```
  Ocurrió en la prueba:
  `Propina mayor a 100%: con monto 100, 4 personas y propina 150, la validación devuelve "La propina no puede superar el 100%"`

- **¿Por qué era importante ver esa prueba fallar antes de escribir el código?**  
  Porque si una prueba nunca se ve fallar, no existe garantía real de que esté evaluando lo que creemos que evalúa. Ver el "rojo" demuestra empíricamente que la prueba detecta la ausencia de la regla de negocio y que no está pasando por accidente (falso positivo). Solo cuando falla por la razón correcta podemos confiar en que el paso a "verde" valida la implementación.

---

### 2. Linter vs. IA

- **Aviso mostrado por `flutter analyze`:**
  `warning - The value of the local variable 'variableSinUso' isn't used - unused_local_variable`  
  (y también `info - Don't invoke 'print' in production code - avoid_print`).

- **Code smell señalado por la IA:**
  **Número mágico**: presencia de literales numéricos sin contexto como `100` y `100.0` hardcodeados en las validaciones (`if (propina > 100)` y `if (valor > 100)`) y en el cálculo de propina (`/ 100.0`), en lugar de utilizar constantes descriptivas con intención de negocio.

- **¿Por qué el linter no encontró el code smell?**  
  El linter es una herramienta de análisis estático basada en reglas sintácticas y directivas fijas (reglas del compilador y convenciones estrictas de lenguaje). No comprende la semántica del problema, las reglas de negocio ni la intención del dominio: para el linter, comparar contra `100` es sintácticamente válido. La IA, en cambio, analiza el significado, la arquitectura y la mantenibilidad del código, identificando olores de diseño que un conjunto rígido de reglas sintácticas pasa por alto.

---

### 3. Tu refactorización

- **Code smell elegido:**  
  **Número mágico** (`100` / `100.0` para la propina máxima permitida).

- **¿Qué cambió en el código?**  
  En `lib/domain/validar_entrada.dart`, se declaró una constante estática con nombre claro a nivel de clase:
  ```dart
  static const double propinaMaxima = 100.0;
  ```
  Y se reemplazaron las comparaciones literales directas `propina > 100` y `valor > 100` por `propina > propinaMaxima` y `valor > propinaMaxima`.

- **¿Cómo sabes que la app sigue haciendo exactamente lo mismo?**  
  Porque después de aplicar el cambio se ejecutó de nuevo la batería completa de pruebas unitarias y de widgets con `flutter test`, y las 25 pruebas pasaron en verde (`All tests passed!`). Al no modificarse las pruebas y seguir pasando el 100%, queda demostrado que el comportamiento observable no cambió.

---

### 4. Coverage

- **¿Qué archivo de `lib/` tiene el porcentaje más bajo?**  
  El archivo `lib/main.dart` con un **40.0%** de líneas cubiertas (6 de 15 líneas ejecutadas).

- **¿Significa eso que ese archivo tiene errores? Explica.**  
  No, en absoluto. La métrica de cobertura (coverage) únicamente registra qué líneas fueron transitadas durante la ejecución de las pruebas; no evalúa la corrección del código ni la ausencia de bugs. En el caso de `lib/main.dart`, contiene la función `main()` y el arranque de Flutter (`runApp`), componentes de inicialización de la plataforma que típicamente no se invocan en pruebas unitarias y de integración de widgets aislados, pero que funcionan correctamente al correr la aplicación.
