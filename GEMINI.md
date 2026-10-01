# Instrucciones del Proyecto: Divisor de Cuenta

## 📌 Descripción del Proyecto
Aplicación móvil en Flutter de **una sola pantalla** diseñada para dividir una cuenta de restaurante o consumo grupal entre varias personas de manera rápida, clara y equitativa.

---

## 🏗️ Estructura del Código
El proyecto sigue una arquitectura limpia modular organizada en:

```
lib/
├── domain/        # Entidades, modelos puros y lógica de negocio
├── data/          # Fuentes de datos o repositorios (si aplica)
└── presentation/  # Widgets, pantallas y controladores de interfaz
```

### Reglas de Dependencia:
- **Flujo:** `presentation -> domain <- data`
- **Aislamiento del dominio:** La capa `lib/domain` **NO debe importar nada** proveniente de `package:flutter`. Debe contener únicamente código Dart puro.

---

## 📐 Estándares y Convenciones
- **Null Safety:** Respetar estrictamente el sistema de tipos y null safety de Dart.
- **Nombres en español:** Utilizar nombres de variables, funciones, clases, comentarios y textos de la interfaz en español.
- **Sin paquetes externos:** Utilizar exclusivamente las librerías nativas de Flutter/Dart; no añadir dependencias externas de terceros a menos que se solicite expresamente.

---

## ⛔ Qué NO Tocar
- **No modificar `test/`** a menos que se pida explícitamente.
- **No agregar dependencias** al `pubspec.yaml` sin avisar y consultar previamente.
- **No modificar las carpetas nativas `android/` ni `ios/`**.

---

## 💻 Comandos Principales
- **Instalar dependencias:** `flutter pub get`
- **Ejecutar la app:** `flutter run`
- **Análisis estático:** `flutter analyze`
- **Correr pruebas:** `flutter test`
