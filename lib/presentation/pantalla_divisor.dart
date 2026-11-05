import 'package:flutter/material.dart';
import 'divisor_controller.dart';

/// Pantalla única de la aplicación para dividir la cuenta de un restaurante.
///
/// **Por qué existe:** Presenta la interfaz visual interactiva que permite al usuario
/// ingresar monto, personas, propina y modo de redondeo, desplegando el resultado o errores.
/// **Qué recibe:** Recibe por constructor una instancia de [DivisorController] (DIP).
/// **Estado local:** Utiliza [setState] de acuerdo a los requerimientos del proyecto.
class PantallaDivisor extends StatefulWidget {
  final DivisorController controller;

  const PantallaDivisor({
    super.key,
    required this.controller,
  });

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final TextEditingController _controladorMonto = TextEditingController();
  final TextEditingController _controladorPersonas = TextEditingController();
  final TextEditingController _controladorPropina = TextEditingController();

  String _estrategiaSeleccionada = 'exacto';
  EstadoDivision _estado = const EstadoDivision.inicial();

  @override
  void dispose() {
    _controladorMonto.dispose();
    _controladorPersonas.dispose();
    _controladorPropina.dispose();
    super.dispose();
  }

  void _calcular() {
    setState(() {
      _estado = widget.controller.procesar(
        textoMonto: _controladorMonto.text,
        textoPersonas: _controladorPersonas.text,
        textoPropina: _controladorPropina.text,
        claveEstrategia: _estrategiaSeleccionada,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Divisor de Cuenta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Monto Total
            TextField(
              key: const Key('campoMonto'),
              controller: _controladorMonto,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Monto total de la cuenta',
                hintText: 'Ej. 100.00',
                prefixIcon: const Icon(Icons.attach_money),
                errorText: _estado.errorMonto,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Número de Personas
            TextField(
              key: const Key('campoPersonas'),
              controller: _controladorPersonas,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de personas',
                hintText: 'Ej. 4',
                prefixIcon: const Icon(Icons.group),
                errorText: _estado.errorPersonas,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Porcentaje de Propina
            TextField(
              key: const Key('campoPropina'),
              controller: _controladorPropina,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Porcentaje de propina (%)',
                hintText: 'Ej. 10 (vacío = 0%)',
                prefixIcon: const Icon(Icons.volunteer_activism),
                errorText: _estado.errorPropina,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Selector de Modo de Redondeo
            const Text(
              'Modo de redondeo:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'exacto',
                  label: Text('Exacto'),
                  icon: Icon(Icons.straighten),
                ),
                ButtonSegment<String>(
                  value: 'haciaArriba',
                  label: Text('Hacia arriba'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_estrategiaSeleccionada},
              onSelectionChanged: (conjunto) {
                setState(() {
                  _estrategiaSeleccionada = conjunto.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Botón Calcular
            FilledButton.icon(
              key: const Key('botonCalcular'),
              onPressed: _calcular,
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Calcular',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Área de Resultado (solo si tieneResultado es true)
            if (_estado.tieneResultado && _estado.resultadoPorPersona != null)
              Card(
                key: const Key('tarjetaResultado'),
                elevation: 3,
                color: colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Cuánto paga cada persona',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _estado.resultadoPorPersona!,
                        key: const Key('textoResultado'),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
