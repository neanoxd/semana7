import 'package:flutter/material.dart';
import 'widgets/quick_split_view.dart';
import 'widgets/itemized_split_view.dart';

void main() {
  runApp(const DivisorCuentaApp());
}

class DivisorCuentaApp extends StatefulWidget {
  const DivisorCuentaApp({super.key});

  @override
  State<DivisorCuentaApp> createState() => _DivisorCuentaAppState();
}

class _DivisorCuentaAppState extends State<DivisorCuentaApp> {
  ThemeMode _themeMode = ThemeMode.system;
  String _currencySymbol = '\$';

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        // From system, determine based on current brightness
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _themeMode =
            brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      }
    });
  }

  void _changeCurrency(String symbol) {
    setState(() {
      _currencySymbol = symbol;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF00796B); // Teal / Emerald theme

    return MaterialApp(
      title: 'Divisor de Cuenta',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 1.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 1.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: HomeScreen(
        currencySymbol: _currencySymbol,
        onCurrencyChanged: _changeCurrency,
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String currencySymbol;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.currencySymbol,
    required this.onCurrencyChanged,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _currencies = [
    {'symbol': '\$', 'name': 'Dólar (USD / Ecuador)'},
    {'symbol': '€', 'name': 'Euro (EUR)'},
    {'symbol': '£', 'name': 'Libra Esterlina (GBP)'},
    {'symbol': 'S/', 'name': 'Sol Peruano (PEN)'},
    {'symbol': 'MXN \$', 'name': 'Peso Mexicano (MXN)'},
    {'symbol': 'COP \$', 'name': 'Peso Colombiano (COP)'},
    {'symbol': 'ARS \$', 'name': 'Peso Argentino (ARS)'},
    {'symbol': 'CLP \$', 'name': 'Peso Chileno (CLP)'},
  ];

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seleccionar Moneda',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _currencies.length,
                  itemBuilder: (c, idx) {
                    final cur = _currencies[idx];
                    final isSelected = widget.currencySymbol == cur['symbol'];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        foregroundColor: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        child: Text(
                          cur['symbol']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(cur['name']!),
                      trailing: isSelected
                          ? Icon(Icons.check,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        widget.onCurrencyChanged(cur['symbol']!);
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF00796B)),
              SizedBox(width: 8),
              Text('Divisor de Cuenta'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¿Cómo funciona la aplicación?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '⚡ División Rápida:\n'
                  'Ideal cuando todos van a pagar exactamente lo mismo. '
                  'Ingresa el total, selecciona el número de personas, la propina deseada y si aplica IVA (ej. 15% en Ecuador). '
                  'Calcula al instante cuánto debe pagar cada uno.',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 12),
                Text(
                  '📋 Por Ítems / Amigos:\n'
                  'Ideal para comidas donde cada uno pide cosas distintas. '
                  'Agrega a los comensales, registra los platos y marca quiénes los compartieron. '
                  'La propina y los impuestos se reparten de manera matemáticamente justa según el consumo individual.',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 12),
                Text(
                  '📲 Compartir en WhatsApp:\n'
                  'Copia un resumen claro y formateado para enviarlo al grupo de amigos o chat con un solo clic.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calculate_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Divisor de Cuenta',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar Moneda (${widget.currencySymbol})',
            onPressed: _showCurrencyPicker,
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.currencySymbol,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          IconButton(
            tooltip: isDark ? 'Modo Claro' : 'Modo Oscuro',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'Información y Ayuda',
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          QuickSplitView(currencySymbol: widget.currencySymbol),
          ItemizedSplitView(currencySymbol: widget.currencySymbol),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flash_on_outlined),
            selectedIcon: Icon(Icons.flash_on),
            label: 'División Rápida',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Por Ítems / Amigos',
          ),
        ],
      ),
    );
  }
}
