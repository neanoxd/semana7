# 🧾 Divisor de Cuenta (Split the Bill)

Una aplicación moderna y completa construida con **Flutter** (Material 3) diseñada para dividir cuentas de restaurantes, salidas con amigos, comidas grupales y eventos.

---

## ✨ Características Principales

### ⚡ 1. Modo División Rápida (Equitativa)
- **Cálculo instantáneo:** Ingreso rápido del monto total de la cuenta.
- **Selector de personas:** Selector rápido con botones `+` / `-`, deslizador interactivo o chips predeterminados (2, 3, 4, 5, 6, 8 personas).
- **Propinas inteligentes:** Chips con porcentajes típicos (0%, 10%, 12%, 15%, 20%) y opción de porcentaje personalizado.
- **Impuestos / IVA configurable:** Soporte para calcular IVA (por defecto 15% para Ecuador / USFQ), con opción de indicar si el valor ingresado ya lo incluye o si debe sumarse.
- **Redondeo hacia arriba:** Opción para redondear centavos al entero superior para pagos cómodos en efectivo.
- **Resumen en vivo:** Muestra subtotal, impuestos, propinas y el **monto exacto por persona**.
- **Copiar a WhatsApp:** Botón para copiar un resumen listo para enviar por chat.

### 📋 2. Modo Por Ítems / Amigos (Detallado)
- **Gestión de Comensales:** Agrega amigos con su nombre y color distintivo con avatar.
- **Registro de Platos y Bebidas:** Registra cada plato con nombre, precio unitario y cantidad.
- **Asignación flexible:** Asigna quién o quiénes consumieron cada ítem (puede ser compartido por varios o por todos con el botón rápido "Todos").
- **Distribución justa de Propina e Impuestos:** Reparte la propina y el IVA de forma matemáticamente proporcional al consumo de cada comensal.
- **"¿Quién pagó la cuenta?":** Selecciona a la persona que pagó con su tarjeta o efectivo y la app genera las instrucciones de transferencia individual (ej: *"Transferir \$14.50 a Juan"*).
- **Desglose expandible:** Cada comensal puede revisar exactamente qué platos compartió, su subtotal, sus extras y su total.
- **Exportación a WhatsApp:** Genera un texto detallado y con formato para pegar en el grupo de WhatsApp.

### 🎨 3. Experiencia de Usuario y Ajustes
- **Tema Claro / Oscuro:** Conmutador directo en el AppBar.
- **Selector de Moneda:** Soporte para `$` (USD), `€` (EUR), `£` (GBP), `S/` (PEN), `MXN $`, `COP $`, `ARS $`, `CLP $`.
- **Diseño Responsivo:** Funciona perfectamente en Windows Desktop, Navegadores Web (Chrome, Edge) y dispositivos móviles (Android / iOS).

---

## 🚀 Cómo Ejecutar la Aplicación

Desde la terminal en la carpeta del proyecto (`C:\Users\Leandro\Documents\USFQ\divisor_cuenta`):

### 1. Ejecutar en Windows (Aplicación de Escritorio)
```powershell
flutter run -d windows
```

### 2. Ejecutar en el Navegador Web (Chrome)
```powershell
flutter run -d chrome
```

### 3. Ejecutar en Edge
```powershell
flutter run -d edge
```

### 4. Ejecutar en Dispositivo o Emulador Android
```powershell
flutter run
```

---

## 🧪 Pruebas y Calidad de Código
- Para verificar el código con el linter de Flutter:
  ```powershell
  flutter analyze
  ```
- Para correr las pruebas unitarias y de widgets:
  ```powershell
  flutter test
  ```
