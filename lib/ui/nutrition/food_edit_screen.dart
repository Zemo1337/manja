import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../app_scope.dart';
import '../../domain/units.dart';

const _portionUnits = [
  CookingUnit.piece,
  CookingUnit.slice,
  CookingUnit.clove,
  CookingUnit.can,
  CookingUnit.pinch,
  CookingUnit.tsp,
  CookingUnit.tbsp,
  CookingUnit.cup,
  CookingUnit.metricCup,
  CookingUnit.ml,
  CookingUnit.l,
];

const _fields = [
  (Nutrient.energy, 'Energy', 'kcal'),
  (Nutrient.fat, 'Fat', 'g'),
  (Nutrient.saturatedFat, '  of which saturates', 'g'),
  (Nutrient.carbohydrate, 'Carbohydrate', 'g'),
  (Nutrient.sugars, '  of which sugars', 'g'),
  (Nutrient.fiber, 'Fiber', 'g'),
  (Nutrient.protein, 'Protein', 'g'),
];

class FoodEditScreen extends StatefulWidget {
  const FoodEditScreen({super.key, this.existing, this.initialName = ''});

  final Food? existing;
  final String initialName;

  @override
  State<FoodEditScreen> createState() => _FoodEditScreenState();
}

class _PortionRow {
  _PortionRow({String amount = '1', this.unit = CookingUnit.piece, String grams = ''})
      : amount = TextEditingController(text: amount),
        grams = TextEditingController(text: grams);

  final TextEditingController amount;
  final TextEditingController grams;
  CookingUnit unit;

  void dispose() {
    amount.dispose();
    grams.dispose();
  }
}

class _FoodEditScreenState extends State<FoodEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? widget.initialName);
  late final _values = {
    for (final (n, _, _) in _fields)
      n: TextEditingController(text: _format(widget.existing?.per100g[n])),
  };
  late final _salt = TextEditingController(text: _format(widget.existing?.per100g.saltG));
  late final _portions = [
    for (final p in widget.existing?.portions ?? const <FoodPortion>[])
      if (p.unit != null && _portionUnits.contains(p.unit))
        _PortionRow(amount: formatAmount(p.amount), unit: p.unit!, grams: formatAmount(p.grams)),
  ];
  bool _saving = false;

  static String _format(double? v) => v == null ? '' : formatAmount(double.parse(v.toStringAsFixed(2)));

  static double? _parse(String text) => double.tryParse(text.trim().replaceAll(',', '.'));

  @override
  void dispose() {
    _name.dispose();
    _salt.dispose();
    for (final c in _values.values) {
      c.dispose();
    }
    for (final p in _portions) {
      p.dispose();
    }
    super.dispose();
  }

  String? _optionalNumber(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = _parse(v);
    return n == null || n < 0 ? 'Number' : null;
  }

  String? _requiredPositive(String? v) {
    final n = _parse(v ?? '');
    return n == null || n <= 0 ? 'Required' : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final salt = _parse(_salt.text);
    final values = <Nutrient, double>{
      for (final e in _values.entries) e.key: ?_parse(e.value.text),
      if (salt != null) Nutrient.sodium: salt * 400,
    };
    final food = await AppScope.of(context).nutrition.saveUserFood(
      sourceId: widget.existing?.source == FoodSource.user ? widget.existing!.sourceId : null,
      name: _name.text.trim(),
      per100g: Nutrients(values),
      portions: [
        for (final p in _portions)
          FoodPortion(
            label: '${p.amount.text.trim()} ${p.unit.symbol}',
            grams: _parse(p.grams.text)!,
            unit: p.unit,
            amount: _parse(p.amount.text)!,
          ),
      ],
    );
    if (mounted) Navigator.pop(context, food);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New ingredient' : 'Edit ingredient'),
        actions: [TextButton(onPressed: _saving ? null : _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            Text('Nutrition per 100 g', style: theme.textTheme.titleLarge),
            Text('Copy the values from the package label. Leave unknown values empty.', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            for (final (n, label, unit) in [..._fields, (Nutrient.sodium, 'Salt', 'g')])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  key: ValueKey('nutrient-${n.name}'),
                  controller: n == Nutrient.sodium ? _salt : _values[n],
                  decoration: InputDecoration(
                    labelText: label.trim(),
                    prefixText: label.startsWith(' ') ? '   ' : null,
                    suffixText: unit,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: _optionalNumber,
                ),
              ),
            const SizedBox(height: 16),
            Text('Portions', style: theme.textTheme.titleLarge),
            Text(
              'How much one unit weighs, so recipes can use cups, spoons or pieces.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (final (index, p) in _portions.indexed)
              Padding(
                key: ObjectKey(p),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 64,
                      child: TextFormField(
                        controller: p.amount,
                        decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _requiredPositive,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: DropdownButtonFormField<CookingUnit>(
                        initialValue: p.unit,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder()),
                        items: [
                          for (final u in _portionUnits) DropdownMenuItem(value: u, child: Text(u.label)),
                        ],
                        onChanged: (u) => setState(() => p.unit = u ?? p.unit),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(8, 16, 8, 0), child: Text('=')),
                    SizedBox(
                      width: 88,
                      child: TextFormField(
                        controller: p.grams,
                        decoration: const InputDecoration(
                          labelText: 'Weight',
                          suffixText: 'g',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _requiredPositive,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _portions.removeAt(index).dispose()),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _portions.add(_PortionRow())),
                icon: const Icon(Icons.add),
                label: const Text('Add portion'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
