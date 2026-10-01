import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickSplitView extends StatefulWidget {
  final String currencySymbol;

  const QuickSplitView({
    super.key,
    required this.currencySymbol,
  });

  @override
  State<QuickSplitView> createState() => _QuickSplitViewState();
}

class _QuickSplitViewState extends State<QuickSplitView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customTipController = TextEditingController();
  final TextEditingController _taxPercentController = TextEditingController(text: '15');

  int _numPeople = 2;
  double _tipPercentage = 10.0;
  bool _isCustomTip = false;
  bool _includeTax = false;
  bool _taxAlreadyIncluded = false;
  bool _roundUp = false;

  final List<double> _presetTips = [0, 10, 12, 15, 20];
  final List<int> _quickPeople = [2, 3, 4, 5, 6, 8];

  @override
  void dispose() {
    _amountController.dispose();
    _customTipController.dispose();
    _taxPercentController.dispose();
    super.dispose();
  }

  double get _billAmount {
    final text = _amountController.text.replaceAll(',', '.').trim();
    return double.tryParse(text) ?? 0.0;
  }

  double get _taxPercent {
    if (!_includeTax) return 0.0;
    final text = _taxPercentController.text.replaceAll(',', '.').trim();
    return double.tryParse(text) ?? 0.0;
  }

  double get _effectiveTipPercent {
    if (_isCustomTip) {
      final text = _customTipController.text.replaceAll(',', '.').trim();
      return double.tryParse(text) ?? 0.0;
    }
    return _tipPercentage;
  }

  // Calculations
  double get _subtotal {
    final amount = _billAmount;
    if (_includeTax && _taxAlreadyIncluded) {
      // Amount entered already has tax included
      return amount / (1 + (_taxPercent / 100));
    }
    return amount;
  }

  double get _taxAmount {
    if (!_includeTax) return 0.0;
    if (_taxAlreadyIncluded) {
      return _billAmount - _subtotal;
    }
    return _billAmount * (_taxPercent / 100);
  }

  double get _tipAmount {
    // Tip calculated based on subtotal or base amount
    final base = _taxAlreadyIncluded ? _subtotal : _billAmount;
    return base * (_effectiveTipPercent / 100);
  }

  double get _totalAmount {
    if (_taxAlreadyIncluded) {
      return _billAmount + _tipAmount;
    }
    return _billAmount + _taxAmount + _tipAmount;
  }

  double get _amountPerPerson {
    if (_numPeople <= 0) return 0.0;
    final perPerson = _totalAmount / _numPeople;
    if (_roundUp) {
      return perPerson.ceilToDouble();
    }
    return perPerson;
  }

  double get _effectiveTotal {
    if (_roundUp) {
      return _amountPerPerson * _numPeople;
    }
    return _totalAmount;
  }

  void _resetAll() {
    setState(() {
      _amountController.clear();
      _customTipController.clear();
      _numPeople = 2;
      _tipPercentage = 10.0;
      _isCustomTip = false;
      _includeTax = false;
      _taxAlreadyIncluded = false;
      _roundUp = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _copySummary() {
    final cur = widget.currencySymbol;
    final tipStr = _effectiveTipPercent.toStringAsFixed(_effectiveTipPercent.truncateToDouble() == _effectiveTipPercent ? 0 : 1);
    final sb = StringBuffer();
    sb.writeln('🧾 *DIVISIÓN RÁPIDA DE CUENTA*');
    sb.writeln('━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('💰 Subtotal: $cur${_subtotal.toStringAsFixed(2)}');
    if (_includeTax) {
      sb.writeln('🏛️ Impuesto (${_taxPercent.toStringAsFixed(0)}%): $cur${_taxAmount.toStringAsFixed(2)}');
    }
    if (_tipAmount > 0) {
      sb.writeln('⭐ Propina ($tipStr%): $cur${_tipAmount.toStringAsFixed(2)}');
    }
    sb.writeln('💳 Total: $cur${_effectiveTotal.toStringAsFixed(2)}');
    sb.writeln('👥 Personas: $_numPeople');
    sb.writeln('━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('👉 *CADA PERSONA PAGA: $cur${_amountPerPerson.toStringAsFixed(2)}*');
    if (_roundUp) {
      sb.writeln('*(Monto redondeado al entero superior)*');
    }

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Resumen copiado al portapapeles!'),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cur = widget.currencySymbol;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Card Hero
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total por persona',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_alt, size: 16, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              '$_numPeople ${_numPeople == 1 ? "persona" : "personas"}',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$cur${_amountPerPerson.toStringAsFixed(2)}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat(
                        context,
                        'Subtotal',
                        '$cur${_subtotal.toStringAsFixed(2)}',
                      ),
                      _buildSummaryStat(
                        context,
                        'Propina',
                        '$cur${_tipAmount.toStringAsFixed(2)}',
                      ),
                      if (_includeTax)
                        _buildSummaryStat(
                          context,
                          'IVA',
                          '$cur${_taxAmount.toStringAsFixed(2)}',
                        ),
                      _buildSummaryStat(
                        context,
                        'Total General',
                        '$cur${_effectiveTotal.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bill Amount Input Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Monto de la Cuenta',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          cur,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Number of People Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.group, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            '¿Entre cuántos dividen?',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_numPeople',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: _numPeople > 1
                            ? () => setState(() => _numPeople--)
                            : null,
                        icon: const Icon(Icons.remove),
                        tooltip: 'Restar persona',
                      ),
                      Expanded(
                        child: Slider(
                          value: _numPeople.toDouble().clamp(1.0, 30.0),
                          min: 1.0,
                          max: 30.0,
                          divisions: 29,
                          label: '$_numPeople',
                          onChanged: (val) {
                            setState(() {
                              _numPeople = val.round();
                            });
                          },
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: _numPeople < 50
                            ? () => setState(() => _numPeople++)
                            : null,
                        icon: const Icon(Icons.add),
                        tooltip: 'Agregar persona',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _quickPeople.map((count) {
                      final isSelected = _numPeople == count;
                      return ChoiceChip(
                        label: Text('$count personas'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _numPeople = count);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Tip Selection Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.volunteer_activism, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Propina (Tip)',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '$cur${_tipAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._presetTips.map((tip) {
                        final isSelected = !_isCustomTip && _tipPercentage == tip;
                        return ChoiceChip(
                          label: Text('${tip.toInt()}%'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _isCustomTip = false;
                              _tipPercentage = tip;
                            });
                          },
                        );
                      }),
                      ChoiceChip(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 14),
                            SizedBox(width: 4),
                            Text('Otro %'),
                          ],
                        ),
                        selected: _isCustomTip,
                        onSelected: (selected) {
                          setState(() {
                            _isCustomTip = true;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_isCustomTip) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customTipController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Porcentaje personalizado',
                              suffixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Taxes & Rounding Options Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Impuestos y Redondeo',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Calcular Impuesto (IVA / Tax)'),
                    subtitle: Text(_includeTax
                        ? 'Tasa: ${_taxPercent.toStringAsFixed(0)}%'
                        : 'Desactivado'),
                    value: _includeTax,
                    onChanged: (val) {
                      setState(() {
                        _includeTax = val;
                      });
                    },
                  ),
                  if (_includeTax) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _taxPercentController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: '% Impuesto (Ej. 15% IVA Ecuador)',
                                suffixText: '%',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text('El monto ingresado ya incluye el impuesto'),
                      value: _taxAlreadyIncluded,
                      onChanged: (val) {
                        setState(() {
                          _taxAlreadyIncluded = val ?? false;
                        });
                      },
                    ),
                  ],
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Redondear hacia arriba'),
                    subtitle: const Text('Evita centavos molestos al pagar en efectivo'),
                    value: _roundUp,
                    onChanged: (val) {
                      setState(() {
                        _roundUp = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons: Share & Reset
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _billAmount > 0 ? _copySummary : null,
                  icon: const Icon(Icons.share),
                  label: const Text('Copiar Resumen'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: _resetAll,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Limpiar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 15 : 13,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
