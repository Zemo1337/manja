import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../app_scope.dart';
import '../../domain/units.dart';
import '../../l10n/l10n.dart';
import '../nutrition/food_picker_sheet.dart';

List<(String, String)> quickIngredients(AppLocalizations l) => [
  (l.converterFlour, 'usda:168894'),
  (l.converterSugar, 'usda:746784'),
  (l.converterPowderedSugar, 'usda:169656'),
  (l.converterButter, 'usda:173410'),
  (l.converterWater, 'usda:173647'),
  (l.converterMilk, 'usda:171265'),
  (l.converterOliveOil, 'usda:171413'),
  (l.converterRice, 'usda:168877'),
  (l.converterHoney, 'usda:169640'),
  (l.converterSalt, 'usda:173468'),
  (l.converterOats, 'usda:173904'),
  (l.converterCocoa, 'usda:169593'),
];

String formatQuantity(double v) {
  if (v == 0) return '0';
  final digits = v.abs() >= 100 ? 0 : (v.abs() >= 10 ? 1 : 2);
  final text = v.abs() < 1 ? v.toStringAsPrecision(3) : v.toStringAsFixed(digits);
  final trimmed = text.contains('.') ? text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '') : text;
  return trimmed.replaceFirst('.', decimalSeparator);
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _left = TextEditingController(text: '1');
  final _right = TextEditingController();
  CookingUnit _leftUnit = CookingUnit.cup;
  CookingUnit _rightUnit = CookingUnit.g;
  bool _editingRight = false;
  Food? _food;
  Map<String, Food> _quick = const {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_quick.isEmpty) _loadQuick();
  }

  Future<void> _loadQuick() async {
    final keys = [for (final q in quickIngredients(context.l10n)) q.$2];
    final quick = await AppScope.of(context).nutrition.foodsByKey(keys);
    if (!mounted) return;
    setState(() {
      _quick = quick;
      _food ??= quick['usda:168894'];
    });
    _recalculate();
  }

  @override
  void dispose() {
    _left.dispose();
    _right.dispose();
    super.dispose();
  }

  double? _parse(String text) => double.tryParse(text.trim().replaceAll(',', '.'));

  double? _convert(double amount, CookingUnit from, CookingUnit to) => convertAmount(amount, from, to, food: _food);

  void _recalculate() {
    final source = _editingRight ? _right : _left;
    final target = _editingRight ? _left : _right;
    final amount = _parse(source.text);
    final result = amount == null
        ? null
        : _editingRight
        ? _convert(amount, _rightUnit, _leftUnit)
        : _convert(amount, _leftUnit, _rightUnit);
    final text = result == null ? '' : formatQuantity(result);
    if (target.text != text) target.text = text;
    setState(() {});
  }

  void _swap() {
    setState(() {
      final unit = _leftUnit;
      _leftUnit = _rightUnit;
      _rightUnit = unit;
      _editingRight = !_editingRight;
      final text = _right.text;
      _right.text = _left.text;
      _left.text = text;
    });
  }

  Future<void> _pickFood() async {
    final food = await showFoodPicker(context);
    if (food == null || !mounted) return;
    setState(() => _food = food);
    _recalculate();
  }

  String? get _problem {
    final amount = _parse((_editingRight ? _right : _left).text);
    if (amount == null) return null;
    final needsFood = _leftUnit.kind != _rightUnit.kind || _leftUnit.kind == UnitKind.count;
    if (_leftUnit == _rightUnit || !needsFood) return null;
    final l = context.l10n;
    if (_food == null) return l.converterPickIngredient;
    if (_convert(1, _leftUnit, _rightUnit) == null) {
      final missing = gramsFor(_food!, 1, _leftUnit) == null ? _leftUnit : _rightUnit;
      return l.converterNoWeight(missing.symbolIn(l), _food!.name);
    }
    return null;
  }

  Widget _amountRow(TextEditingController controller, CookingUnit unit, ValueChanged<CookingUnit> onUnit, bool right) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: ValueKey(right ? 'right-amount' : 'left-amount'),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (_) {
              _editingRight = right;
              _recalculate();
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<CookingUnit>(
            key: ValueKey(right ? 'right-unit' : 'left-unit'),
            initialValue: unit,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              for (final u in CookingUnit.values)
                DropdownMenuItem(
                  value: u,
                  child: Text(u.labelIn(context.l10n), overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (u) {
              if (u == null) return;
              onUnit(u);
              _recalculate();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final problem = _problem;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.converterTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          KeyedSubtree(
            key: ValueKey('left-$_leftUnit'),
            child: _amountRow(_left, _leftUnit, (u) => _leftUnit = u, false),
          ),
          Center(
            child: IconButton(
              tooltip: l.converterSwap,
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                _swap();
                _recalculate();
              },
            ),
          ),
          KeyedSubtree(
            key: ValueKey('right-$_rightUnit'),
            child: _amountRow(_right, _rightUnit, (u) => _rightUnit = u, true),
          ),
          if (problem != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(problem, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
            ),
          const SizedBox(height: 24),
          Text(l.converterIngredient, style: theme.textTheme.titleMedium),
          Text(l.converterIngredientHint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final (label, key) in quickIngredients(l))
                if (_quick[key] case final food?)
                  ChoiceChip(
                    label: Text(label),
                    selected: _food?.key == food.key,
                    onSelected: (_) {
                      setState(() => _food = food);
                      _recalculate();
                    },
                  ),
              ActionChip(
                avatar: const Icon(Icons.search, size: 18),
                label: Text(_food == null || _quick.containsKey(_food!.key) ? l.converterOther : _food!.name),
                onPressed: _pickFood,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_food != null) _FoodTable(food: _food!) else const _UnitTable(),
        ],
      ),
    );
  }
}

class _FoodTable extends StatelessWidget {
  const _FoodTable({required this.food});

  final Food food;

  static const _volumes = [
    (1.0, CookingUnit.tsp),
    (1.0, CookingUnit.tbsp),
    (1.0, CookingUnit.dl),
    (1.0, CookingUnit.cup),
    (100.0, CookingUnit.ml),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = <(String, String)>[
      for (final (amount, unit) in _volumes)
        if (gramsFor(food, amount, unit) case final g?)
          ('${formatQuantity(amount)} ${unit.labelIn(l)}', '${formatQuantity(g)} g'),
      if (convertAmount(100, CookingUnit.g, CookingUnit.cup, food: food) case final cups?)
        ('100 g', '${formatQuantity(cups)} ${CookingUnit.cup.labelIn(l)}'),
      for (final p in food.portions)
        if (p.unit == null || p.unit!.kind == UnitKind.count) (p.label, '${formatQuantity(p.grams)} g'),
    ];
    return _Table(title: food.name, rows: rows, empty: l.converterNoVolumeWeights);
  }
}

class _UnitTable extends StatelessWidget {
  const _UnitTable();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String one(CookingUnit unit) => '1 ${unit.labelIn(l)}';
    return _Table(
      title: l.converterCommonEquivalents,
      rows: [
        (one(CookingUnit.tsp), '${formatQuantity(4.93)} ml'),
        (one(CookingUnit.tbsp), '${l.converterTeaspoons(3)} · ${formatQuantity(14.8)} ml'),
        (one(CookingUnit.cup), '${l.converterTablespoons(16)} · 237 ml'),
        (one(CookingUnit.dl), '100 ml · ${formatQuantity(0.42)} ${CookingUnit.cup.symbolIn(l, 0.42)}'),
        (one(CookingUnit.flOz), '${formatQuantity(29.6)} ml'),
        (one(CookingUnit.oz), '${formatQuantity(28.3)} g'),
        (one(CookingUnit.lb), '454 g'),
      ],
      empty: '',
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.title, required this.rows, required this.empty});

  final String title;
  final List<(String, String)> rows;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            if (rows.isEmpty) Text(empty, style: theme.textTheme.bodySmall),
            for (final (left, right) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(left)),
                    Text(right, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
