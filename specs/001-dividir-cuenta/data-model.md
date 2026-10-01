# Data Model & Entidades de Dominio: Dividir Cuenta

**Feature**: `001-dividir-cuenta`
**Date**: 2026-10-01

---

## 1. Entidades y Modelos de Dominio (`lib/domain/`)

### `Cuenta`
Representa los datos financieros base de la cuenta antes de la división.
- **Atributos:**
  - `montoTotal` (`double`): Monto original facturado (no negativo).
  - `numeroPersonas` (`int`): Cantidad de comensales que dividen la cuenta (debe ser $\ge 1$).
  - `porcentajePropina` (`double`): Porcentaje de propina voluntaria (típicamente $\ge 0$, ej. 10.0 para 10%).

### `Resultado`
Representa el resultado final del cálculo de la división.
- **Atributos:**
  - `totalConPropina` (`double`): Monto total que incluye la propina calculada (`montoTotal + propina`).
  - `montoPropina` (`double`): Monto equivalente a la propina calculada.
  - `montoPorPersona` (`double`): Valor final que corresponde pagar a cada persona tras aplicar la estrategia de redondeo.

### `EstrategiaRedondeo` (Interfaz Abstracta)
Contrato único para cualquier algoritmo o regla de redondeo.
- **Métodos:**
  - `double redondear(double valor)`: Recibe un valor fraccionario y devuelve el valor procesado según la regla.

---

## 2. Implementaciones Concretas (`lib/data/`)

### `RedondeoExacto`
Implementa `EstrategiaRedondeo`.
- **Comportamiento:** Retorna el valor numérico manteniendo la precisión decimal exacta (la vista se encarga del formateo visual a dos decimales).
- **Ejemplo:** `10.0 / 3` $\rightarrow$ `3.3333333333333335` (en presentación formateado como `3.33`).

### `RedondeoHaciaArriba`
Implementa `EstrategiaRedondeo`.
- **Comportamiento:** Aplica la función techo (`ceilToDouble()`) para redondear al entero más cercano hacia arriba.
- **Ejemplo:** `10.0 / 3 = 3.333...` $\rightarrow$ `4.0`.

---

## 3. Servicios y Casos de Uso (`lib/domain/`)

### `ValidarEntrada`
Servicio puro encargado de analizar cadenas de texto crudas provenientes de la interfaz.
- **Reglas de validación:**
  - `validarMonto(String? texto)`:
    - Vacío o no parseable a número $\rightarrow$ `"Monto inválido"`
    - Negativo $\rightarrow$ `"Monto inválido"`
    - Válido $\rightarrow$ `null` (sin error)
  - `validarPersonas(String? texto)`:
    - Vacío, no entero o valor $\le 0$ $\rightarrow$ `"Debe haber al menos una persona"`
    - Válido $\rightarrow$ `null` (sin error)
  - `validarPropina(String? texto)`:
    - Vacío $\rightarrow$ Se asume `0.0`
    - No numérico o negativo $\rightarrow$ `"Propina inválida"`
    - Válido $\rightarrow$ `null` (sin error)

### `CalcularDivision`
Caso de uso puro encargado del cálculo matemático:
1. `montoPropina = cuenta.montoTotal * (cuenta.porcentajePropina / 100.0)`
2. `totalConPropina = cuenta.montoTotal + montoPropina`
3. `cuotaBase = totalConPropina / cuenta.numeroPersonas`
4. `cuotaFinal = estrategia.redondear(cuotaBase)`
5. Retorna una instancia inmutable de `Resultado`.
