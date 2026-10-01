# Quickstart & Guía de Validación: Dividir Cuenta

**Feature**: `001-dividir-cuenta`
**Date**: 2026-10-01

---

## 1. Prerrequisitos y Comandos de Verificación

Asegurarse de estar en la raíz del proyecto:
```powershell
cd C:\Users\Leandro\Documents\USFQ\divisor_cuenta
```

Comandos base de validación:
- **Análisis estático:** `flutter analyze`
- **Ejecución de pruebas automatizadas:** `flutter test`
- **Ejecución en navegador / escritorio:** `flutter run -d chrome` o `flutter run -d windows`

---

## 2. Escenarios de Aceptación para Validación

### Escenario 1: Monto 100.00 con propina estándar en modo exacto
- **Entrada:** Monto: `100.00` | Personas: `4` | Propina: `10%` | Modo: `Exacto`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Monto por persona: `27.50`
  - Sin mensajes de error

### Escenario 2: Monto 90.00 sin propina en modo exacto
- **Entrada:** Monto: `90.00` | Personas: `3` | Propina: `0%` | Modo: `Exacto`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Monto por persona: `30.00`
  - Sin mensajes de error

### Escenario 3: Validación de cero personas
- **Entrada:** Monto: `50.00` | Personas: `0` | Propina: `10%` | Modo: `Exacto`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Mensaje de error visible: `"Debe haber al menos una persona"`
  - NO se muestra ningún resultado de cálculo

### Escenario 4: Monto con caracteres no numéricos
- **Entrada:** Monto: `abc` | Personas: `2` | Propina: `10%` | Modo: `Exacto`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Mensaje de error visible: `"Monto inválido"`
  - NO se muestra ningún resultado de cálculo

### Escenario 5: División periódica en modo exacto
- **Entrada:** Monto: `10.00` | Personas: `3` | Propina: `0%` | Modo: `Exacto`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Monto por persona: `3.33` (formateado a 2 decimales)

### Escenario 6: División con redondeo hacia arriba al entero más cercano
- **Entrada:** Monto: `10.00` | Personas: `3` | Propina: `0%` | Modo: `Hacia arriba`
- **Acción:** Presionar botón "Calcular"
- **Resultado esperado:**
  - Monto por persona: `4.00` (redondeo de 3.333... a entero superior)
