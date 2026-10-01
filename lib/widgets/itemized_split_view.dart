import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/person.dart';
import '../models/bill_item.dart';

class ItemizedSplitView extends StatefulWidget {
  final String currencySymbol;

  const ItemizedSplitView({
    super.key,
    required this.currencySymbol,
  });

  @override
  State<ItemizedSplitView> createState() => _ItemizedSplitViewState();
}

class _ItemizedSplitViewState extends State<ItemizedSplitView> {
  final List<Person> _people = [
    Person(id: '1', name: 'Juan', color: Person.getColorForIndex(0)),
    Person(id: '2', name: 'María', color: Person.getColorForIndex(1)),
    Person(id: '3', name: 'Carlos', color: Person.getColorForIndex(2)),
  ];

  final List<BillItem> _items = [];

  double _tipPercentage = 10.0;
  double _taxPercentage = 15.0; // IVA Ecuador 15%
  bool _applyTax = false;
  String? _payerPersonId;

  int _nextPersonId = 4;
  int _nextItemId = 1;

  @override
  void initState() {
    super.initState();
    _payerPersonId = _people.isNotEmpty ? _people.first.id : null;
    // Add 2 initial sample items to make the interface immediately intuitive and helpful
    _items.add(
      BillItem(
        id: '${_nextItemId++}',
        name: 'Pizza Familiar',
        price: 15.0,
        quantity: 1,
        assignedPersonIds: {'1', '2', '3'},
      ),
    );
    _items.add(
      BillItem(
        id: '${_nextItemId++}',
        name: 'Bebidas',
        price: 3.5,
        quantity: 2,
        assignedPersonIds: {'1', '2'},
      ),
    );
  }

  // --- Calculations ---
  double get _itemsSubtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get _taxTotal {
    if (!_applyTax) return 0.0;
    return _itemsSubtotal * (_taxPercentage / 100);
  }

  double get _tipTotal {
    return _itemsSubtotal * (_tipPercentage / 100);
  }

  double get _grandTotal {
    return _itemsSubtotal + _taxTotal + _tipTotal;
  }

  double _subtotalForPerson(String personId) {
    double total = 0.0;
    for (final item in _items) {
      total += item.shareForPerson(personId);
    }
    return total;
  }

  double _taxForPerson(String personId) {
    if (!_applyTax || _itemsSubtotal == 0) return 0.0;
    final sub = _subtotalForPerson(personId);
    return sub * (_taxPercentage / 100);
  }

  double _tipForPerson(String personId) {
    if (_itemsSubtotal == 0) return 0.0;
    final sub = _subtotalForPerson(personId);
    return sub * (_tipPercentage / 100);
  }

  double _totalForPerson(String personId) {
    return _subtotalForPerson(personId) +
        _taxForPerson(personId) +
        _tipForPerson(personId);
  }

  // --- Person Management ---
  void _showAddPersonDialog({Person? editingPerson}) {
    final textController =
        TextEditingController(text: editingPerson?.name ?? '');
    Color selectedColor = editingPerson?.color ??
        Person.getColorForIndex(_people.length);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text(editingPerson == null
                  ? 'Agregar Amigo'
                  : 'Editar Nombre'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ej. Sofía',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Color identificador:'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Person.palette.map((color) {
                        final isChosen = color == selectedColor;
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setDialogState(() {
                              selectedColor = color;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 16,
                            child: isChosen
                                ? const Icon(Icons.check,
                                    size: 18, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = textController.text.trim();
                    if (name.isEmpty) return;

                    setState(() {
                      if (editingPerson != null) {
                        editingPerson.name = name;
                        editingPerson.color = selectedColor;
                      } else {
                        final newPerson = Person(
                          id: '${_nextPersonId++}',
                          name: name,
                          color: selectedColor,
                        );
                        _people.add(newPerson);
                        _payerPersonId ??= newPerson.id;
                      }
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: Text(editingPerson == null ? 'Agregar' : 'Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removePerson(Person person) {
    setState(() {
      _people.removeWhere((p) => p.id == person.id);
      for (final item in _items) {
        item.assignedPersonIds.remove(person.id);
      }
      if (_payerPersonId == person.id) {
        _payerPersonId = _people.isNotEmpty ? _people.first.id : null;
      }
    });
  }

  // --- Item Management ---
  void _showItemDialog({BillItem? editingItem}) {
    if (_people.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos una persona primero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final nameController =
        TextEditingController(text: editingItem?.name ?? '');
    final priceController = TextEditingController(
      text: editingItem != null ? editingItem.price.toStringAsFixed(2) : '',
    );
    int quantity = editingItem?.quantity ?? 1;
    final Set<String> assignedIds = editingItem != null
        ? Set.from(editingItem.assignedPersonIds)
        : _people.map((p) => p.id).toSet();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text(editingItem == null ? 'Nuevo Ítem' : 'Editar Ítem'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del plato/bebida',
                        hintText: 'Ej. Hamburguesa doble',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Precio Unitario',
                              prefixText: '${widget.currencySymbol} ',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filledTonal(
                                iconSize: 18,
                                visualDensity: VisualDensity.compact,
                                onPressed: quantity > 1
                                    ? () => setDialogState(() => quantity--)
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  'x$quantity',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              IconButton.filledTonal(
                                iconSize: 18,
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    setDialogState(() => quantity++),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '¿Quiénes lo comparten?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              if (assignedIds.length == _people.length) {
                                assignedIds.clear();
                              } else {
                                assignedIds.addAll(_people.map((p) => p.id));
                              }
                            });
                          },
                          child: Text(
                            assignedIds.length == _people.length
                                ? 'Desmarcar'
                                : 'Todos',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _people.map((p) {
                        final isAssigned = assignedIds.contains(p.id);
                        return FilterChip(
                          avatar: CircleAvatar(
                            backgroundColor: p.color,
                            child: Text(
                              p.name.isNotEmpty
                                  ? p.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                          label: Text(p.name),
                          selected: isAssigned,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                assignedIds.add(p.id);
                              } else {
                                assignedIds.remove(p.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (assignedIds.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                          '⚠️ Debes seleccionar al menos una persona',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(
                            priceController.text.replaceAll(',', '.').trim()) ??
                        0.0;
                    if (name.isEmpty || price <= 0 || assignedIds.isEmpty) {
                      return;
                    }

                    setState(() {
                      if (editingItem != null) {
                        editingItem.name = name;
                        editingItem.price = price;
                        editingItem.quantity = quantity;
                        editingItem.assignedPersonIds = assignedIds;
                      } else {
                        _items.add(
                          BillItem(
                            id: '${_nextItemId++}',
                            name: name,
                            price: price,
                            quantity: quantity,
                            assignedPersonIds: assignedIds,
                          ),
                        );
                      }
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: Text(editingItem == null ? 'Agregar' : 'Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeItem(BillItem item) {
    setState(() {
      _items.removeWhere((i) => i.id == item.id);
    });
  }

  // --- Copy Summary for WhatsApp ---
  void _copyDetailedSummary() {
    final cur = widget.currencySymbol;
    final sb = StringBuffer();
    sb.writeln('🧾 *DESGLOSE DE CUENTA DETALLADA*');
    sb.writeln('━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('💰 Subtotal de consumos: $cur${_itemsSubtotal.toStringAsFixed(2)}');
    if (_applyTax) {
      sb.writeln('🏛️ IVA (${_taxPercentage.toStringAsFixed(0)}%): $cur${_taxTotal.toStringAsFixed(2)}');
    }
    if (_tipTotal > 0) {
      sb.writeln('⭐ Propina (${_tipPercentage.toStringAsFixed(0)}%): $cur${_tipTotal.toStringAsFixed(2)}');
    }
    sb.writeln('💳 *TOTAL GENERAL: $cur${_grandTotal.toStringAsFixed(2)}*');

    final payer = _people.where((p) => p.id == _payerPersonId).firstOrNull;
    if (payer != null) {
      sb.writeln('💳 *Pagado por: ${payer.name}* (transferirle a él/ella)');
    }

    sb.writeln('━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('👥 *CUÁNTO DEBE PAGAR CADA UNO:*');

    for (final person in _people) {
      final totalP = _totalForPerson(person.id);
      sb.writeln('');
      sb.writeln('👤 *${person.name}* ➔ $cur${totalP.toStringAsFixed(2)}');

      // List individual item parts
      final userItems =
          _items.where((i) => i.assignedPersonIds.contains(person.id)).toList();
      for (final item in userItems) {
        final share = item.shareForPerson(person.id);
        final fractionStr = item.assignedPersonIds.length > 1
            ? ' (1/${item.assignedPersonIds.length})'
            : '';
        sb.writeln('   • ${item.quantity > 1 ? "${item.quantity}x " : ""}${item.name}$fractionStr: $cur${share.toStringAsFixed(2)}');
      }

      if (_tipTotal > 0 || _applyTax) {
        final tipShare = _tipForPerson(person.id);
        final taxShare = _taxForPerson(person.id);
        final extras = <String>[];
        if (_applyTax) extras.add('IVA: $cur${taxShare.toStringAsFixed(2)}');
        if (_tipTotal > 0) extras.add('Propina: $cur${tipShare.toStringAsFixed(2)}');
        sb.writeln('   • + ${extras.join(" | ")}');
      }

      if (payer != null && payer.id != person.id && totalP > 0) {
        sb.writeln('   👉 Transferir $cur${totalP.toStringAsFixed(2)} a ${payer.name}');
      }
    }

    sb.writeln('━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln('Generado con Divisor de Cuenta 🚀');

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Desglose completo copiado al portapapeles!'),
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
          // Header Card with Total
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de la Mesa',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_items.length} ${_items.length == 1 ? "ítem" : "ítems"}',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$cur${_grandTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                          'Consumos', '$cur${_itemsSubtotal.toStringAsFixed(2)}'),
                      if (_applyTax)
                        _buildSummaryItem(
                            'IVA (${_taxPercentage.toInt()}%)',
                            '$cur${_taxTotal.toStringAsFixed(2)}'),
                      _buildSummaryItem(
                          'Propina (${_tipPercentage.toInt()}%)',
                          '$cur${_tipTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Section 1: People / Friends
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
                            'Amigos en la mesa (${_people.length})',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _showAddPersonDialog(),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_people.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No hay personas agregadas. Toca "+ Agregar" para empezar.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _people.map((p) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: p.color,
                            child: Text(
                              p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(p.name),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removePerson(p),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Section 2: Items List
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
                          Icon(Icons.fastfood, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Platos y Bebidas',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () => _showItemDialog(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Nuevo Ítem'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            const Text(
                              'Aún no hay ítems agregados.\nRegistra lo que se pidió en la mesa.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (ctx, index) {
                        final item = _items[index];
                        final assigned = _people
                            .where((p) => item.assignedPersonIds.contains(p.id))
                            .toList();

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              if (item.quantity > 1) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'x${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (assigned.isEmpty)
                                const Text(
                                  '⚠️ Sin asignar a nadie',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              else
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: assigned.map((p) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: p.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: p.color.withValues(alpha: 0.5)),
                                      ),
                                      child: Text(
                                        p.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: p.color,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$cur${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Editar',
                                onPressed: () =>
                                    _showItemDialog(editingItem: item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: Colors.redAccent),
                                tooltip: 'Eliminar',
                                onPressed: () => _removeItem(item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Section 3: Tax & Tip Settings
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
                        'Propina e Impuesto de la Mesa',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Se repartirán proporcionalmente según el consumo de cada persona.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  // Tip Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Propina del servicio:'),
                      Text(
                        '${_tipPercentage.toInt()}% ($cur${_tipTotal.toStringAsFixed(2)})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [0, 5, 10, 12, 15, 20].map((tip) {
                      final isSelected = _tipPercentage == tip.toDouble();
                      return ChoiceChip(
                        label: Text('$tip%'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _tipPercentage = tip.toDouble());
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(height: 24),
                  // Tax Toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Agregar IVA / Impuesto'),
                    subtitle: Text(_applyTax
                        ? 'Tasa: ${_taxPercentage.toStringAsFixed(0)}% ($cur${_taxTotal.toStringAsFixed(2)})'
                        : 'Desactivado'),
                    value: _applyTax,
                    onChanged: (val) {
                      setState(() {
                        _applyTax = val;
                      });
                    },
                  ),
                  if (_applyTax) ...[
                    Wrap(
                      spacing: 8,
                      children: [8, 12, 15, 16, 18].map((t) {
                        final isSelected = _taxPercentage == t.toDouble();
                        return ChoiceChip(
                          label: Text('$t%'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _taxPercentage = t.toDouble());
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Section 4: Who Paid? (Settlement)
          if (_people.isNotEmpty) ...[
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payment, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '¿Quién pagó la cuenta completa?',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona quién puso la tarjeta o efectivo para que los demás le transfieran.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _payerPersonId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _people.map((p) {
                        return DropdownMenuItem<String>(
                          value: p.id,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: p.color,
                                radius: 10,
                                child: Text(
                                  p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(p.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _payerPersonId = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Section 5: Individual Breakdown Cards
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pie_chart, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Total a pagar por amigo',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_people.isEmpty)
                    const Center(child: Text('No hay personas'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _people.length,
                      itemBuilder: (ctx, index) {
                        final person = _people[index];
                        final sub = _subtotalForPerson(person.id);
                        final tip = _tipForPerson(person.id);
                        final tax = _taxForPerson(person.id);
                        final total = _totalForPerson(person.id);
                        final isPayer = person.id == _payerPersonId;

                        final consumedItems = _items
                            .where((i) =>
                                i.assignedPersonIds.contains(person.id))
                            .toList();

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isPayer
                                  ? colorScheme.primary
                                  : Colors.grey.shade300,
                              width: isPayer ? 2 : 1,
                            ),
                          ),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: person.color,
                              child: Text(
                                person.name.isNotEmpty
                                    ? person.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  person.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                if (isPayer) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Pagó la cuenta',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Text(
                              '$cur${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorScheme.primary,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const Text('Detalle de consumos:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    const SizedBox(height: 4),
                                    if (consumedItems.isEmpty)
                                      const Text(
                                        'Ningún ítem asignado',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      )
                                    else
                                      ...consumedItems.map((item) {
                                        final fraction =
                                            item.assignedPersonIds.length > 1
                                                ? ' (1/${item.assignedPersonIds.length})'
                                                : '';
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item.quantity > 1 ? "${item.quantity}x " : ""}${item.name}$fraction',
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                              Text(
                                                '$cur${item.shareForPerson(person.id).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Subtotal platos:',
                                            style: TextStyle(fontSize: 12)),
                                        Text('$cur${sub.toStringAsFixed(2)}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    if (_applyTax)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Parte de IVA:',
                                              style: TextStyle(fontSize: 12)),
                                          Text('$cur${tax.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    if (_tipTotal > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Parte de Propina:',
                                              style: TextStyle(fontSize: 12)),
                                          Text('$cur${tip.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    if (_payerPersonId != null &&
                                        !isPayer &&
                                        total > 0) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_forward,
                                                size: 14, color: Colors.green),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                'Transferir $cur${total.toStringAsFixed(2)} a ${_people.firstWhere((p) => p.id == _payerPersonId).name}',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Share Button
          FilledButton.icon(
            onPressed: (_items.isNotEmpty && _people.isNotEmpty)
                ? _copyDetailedSummary
                : null,
            icon: const Icon(Icons.share),
            label: const Text('Copiar Desglose para WhatsApp'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
