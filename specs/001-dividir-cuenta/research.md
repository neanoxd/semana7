# Research & Technical Decisions: Dividir Cuenta

**Feature**: `001-dividir-cuenta`
**Date**: 2026-10-01

---

## Decisiones Técnicas y Arquitectónicas

### 1. Gestión de Estado: `setState` en pantalla única
- **Decisión**: Utilizar `StatefulWidget` con `setState` local en `PantallaDivisor`, delegando la orquestación a un `DivisorController`.
- **Razón**: La aplicación consta de una sola pantalla sin flujos de navegación complejos ni persistencia. Incorporar librerías externas de gestión de estado (Provider, Riverpod, Bloc) violaría el principio de "sin paquetes externos" y añadiría sobreingeniería innecesaria.
- **Alternativas consideradas**:
  - *ChangeNotifier / ValueNotifier*: Válido con el SDK de Flutter, pero para una sola pantalla `setState` desacoplado a través de un controlador puro es más directo y fácil de explicar para el estudiante.
  - *Riverpod / Bloc*: Descartados por requerir dependencias externas de terceros y complejidad innecesaria.

---

### 2. Principio Abierto/Cerrado (OCP) para Estrategias de Redondeo
- **Decisión**: Crear una interfaz abstracta `EstrategiaRedondeo` en `domain/` con un único método `double redondear(double valor)`. Las implementaciones concretas `RedondeoExacto` y `RedondeoHaciaArriba` residen en `data/`.
- **Razón**: Permite que en el futuro se agreguen nuevas reglas de redondeo (ej. redondeo bancario, redondeo al múltiplo de 5, truncamiento) creando una nueva clase en `data/` sin modificar el caso de uso `CalcularDivision` ni las clases existentes.
- **Alternativas consideradas**:
  - *Enum con `switch` en el cálculo*: Violaría OCP, ya que agregar un nuevo modo de redondeo obligaría a modificar el código del cálculo.
  - *Funciones anónimas / callbacks*: Menos estructurado para cumplir con la sustitución de Liskov (LSP) y patrones orientados a objetos didácticos.

---

### 3. Separación Estricta de Responsabilidades (SRP)
- **Decisión**:
  - `ValidarEntrada`: Única responsabilidad de validar texto crudo (monto, comensales, propina) y emitir mensajes de error o valores parseados.
  - `CalcularDivision`: Única responsabilidad de realizar la operación matemática aplicando la propina y la estrategia de redondeo recibida. No valida cadenas ni formatea para la vista.
  - `FormateadorMoneda`: Única responsabilidad de transformar valores numéricos a cadenas con dos decimales (`27.50`, `3.33`, etc.).
  - `DivisorController`: Orquesta la interacción entre la validación, el cálculo y la interfaz de usuario.
- **Razón**: Cumple estrictamente con el principio SRP de la Constitución ("El cálculo no valida ni formatea").

---

### 4. Aislamiento Absoluto de `lib/domain/` y `lib/data/`
- **Decisión**: Ningún archivo en `lib/domain/` ni en `lib/data/` importará `package:flutter`. Todo el código será Dart puro estándar.
- **Razón**: Mandato directo de la Constitución. Facilita pruebas unitarias instantáneas con cero dependencias del framework gráfico y alta portabilidad.

---

### 5. Inversión de Dependencias (DIP) y Punto Único de Composición
- **Decisión**: `main.dart` es el único lugar donde se crean las instancias concretas (`RedondeoExacto`, `RedondeoHaciaArriba`, `CalcularDivision`, `ValidarEntrada`, `DivisorController`) y se inyectan a `PantallaDivisor`.
- **Razón**: `presentation/` depende exclusivamente de las abstracciones del dominio y no conoce cómo se implementan los redondeos en `data/`.
