import 'package:flutter/material.dart';
import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/estrategia_redondeo.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

/// Punto de entrada de la aplicación y ÚNICO punto de composición e instanciación
/// de dependencias concretas según la Constitución del proyecto.
void main() {
  // Instanciación de componentes de dominio y datos (DIP)
  final calcularDivision = CalcularDivision();
  final validarEntrada = ValidarEntrada();
  final formateador = FormateadorMoneda();

  // Inyección de estrategias polimórficas (OCP y LSP)
  final estrategias = <String, EstrategiaRedondeo>{
    'exacto': RedondeoExacto(),
    'haciaArriba': RedondeoHaciaArriba(),
  };

  // Creación del controlador inyectando sus dependencias
  final controller = DivisorController(
    calcularDivision: calcularDivision,
    validarEntrada: validarEntrada,
    formateador: formateador,
    estrategias: estrategias,
  );

  runApp(DivisorCuentaApp(controller: controller));
}

/// Widget raíz de la aplicación.
class DivisorCuentaApp extends StatelessWidget {
  final DivisorController controller;

  const DivisorCuentaApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de Cuenta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          brightness: Brightness.light,
        ),
      ),
      home: PantallaDivisor(controller: controller),
    );
  }
}
