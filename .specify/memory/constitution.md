<!--
Sync Impact Report:
- Version change: Template -> 1.0.0
- Ratification: Initial project constitution ratified
- Principles defined:
  1. Calidad de Código (SOLID)
  2. Arquitectura
  3. Seguridad
  4. Calidad y Pruebas
  5. Regla de la Materia
- Added sections: None (restricted strictly to requested principles)
- Removed sections: Placeholder sections 2 & 3 (not requested)
- Follow-up TODOs: None
-->

# Divisor de Cuenta Constitution

## Core Principles

### I. Calidad de Código (SOLID)
El código debe respetar estrictamente los principios SOLID:
- **SRP (Single Responsibility):** Una clase, una razón de cambio. El cálculo no valida ni formatea.
- **OCP (Open/Closed):** Agregar una nueva regla de redondeo no obliga a editar las clases que ya existen.
- **LSP (Liskov Substitution):** Cualquier implementación de una interfaz puede sustituir a otra sin que quien la usa tenga que preguntar de qué tipo es.
- **ISP (Interface Segregation):** Interfaces pequeñas; nadie depende de métodos que no usa.
- **DIP (Dependency Inversion):** `presentation` depende de abstracciones de `domain`, nunca de clases concretas de `data`.

### II. Arquitectura
- **Capas:** `presentation` / `domain` / `data`.
- **Regla de dependencia:** `presentation -> domain <- data`.
- **Aislamiento del dominio:** `lib/domain/` no importa `package:flutter` (es Dart puro).
- **Inyección de dependencias:** `main.dart` es el ÚNICO lugar donde se instancian implementaciones concretas.

### III. Seguridad
- Nunca guardar secretos ni API keys en el repositorio.

### IV. Calidad y Pruebas
- Toda funcionalidad crítica tiene pruebas.
- Los criterios de aceptación de cada spec se convierten en pruebas ejecutables.

### V. Regla de la Materia
- Toda función generada por el agente debe poder explicarla el estudiante: qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.

## Governance

Esta constitución rige todo el desarrollo del proyecto. Cualquier modificación a sus principios requiere documentación explícita, actualización de la versión semántica y aprobación. Toda especificación, implementación y revisión de código debe verificar el cumplimiento de estas reglas.

**Version**: 1.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-01
