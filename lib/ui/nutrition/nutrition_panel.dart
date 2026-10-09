import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../app_theme.dart';

enum NutritionBasis { portion, per100g, custom }

String formatNutrient(Nutrient n, double value) {
  if (n == Nutrient.energy || n == Nutrient.sodium) return value.round().toString();
  return value < 10 ? value.toStringAsFixed(1) : value.round().toString();
}

String _grams(double g) => '${g.round()} g';

class NutritionPanel extends StatefulWidget {
  const NutritionPanel({super.key, required this.result});

  final RecipeNutrition result;

  @override
  State<NutritionPanel> createState() => _NutritionPanelState();
}

class _NutritionPanelState extends State<NutritionPanel> {
  NutritionBasis _basis = NutritionBasis.portion;
  final _custom = TextEditingController(text: '250');

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  double? get _customGrams {
    final v = double.tryParse(_custom.text.trim().replaceAll(',', '.'));
    return v == null || v <= 0 ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = widget.result;
    final counted = r.lines.where((l) => l.counted).length;
    if (counted == 0) {
      return Text(
        'Link ingredients to foods in the recipe editor to see nutrition values.',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      );
    }
    final values = switch (_basis) {
      NutritionBasis.portion => r.perPortion,
      NutritionBasis.per100g => r.per100g,
      NutritionBasis.custom => _customGrams == null ? null : r.perWeight(_customGrams!),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<NutritionBasis>(
          segments: const [
            ButtonSegment(value: NutritionBasis.portion, label: Text('Portion')),
            ButtonSegment(value: NutritionBasis.per100g, label: Text('100 g')),
            ButtonSegment(value: NutritionBasis.custom, label: Text('Custom')),
          ],
          selected: {_basis},
          showSelectedIcon: false,
          onSelectionChanged: (s) => setState(() => _basis = s.single),
        ),
        if (_basis == NutritionBasis.custom) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: 160,
            child: TextField(
              controller: _custom,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount', suffixText: 'g', border: OutlineInputBorder()),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (values != null) _NutrientTable(values: values, partial: r.partial),
        const SizedBox(height: 8),
        Text(
          [
            'Dish ${_grams(r.totalWeightG)} ${r.finishedWeightG != null ? '(weighed)' : '(sum of ingredients)'}',
            '${r.portions} ${r.portions == 1 ? 'portion' : 'portions'} of about ${_grams(r.portionWeightG)}',
          ].join(' · '),
          style: theme.textTheme.bodySmall,
        ),
        if (r.partial.isNotEmpty)
          Text(
            '* Some linked foods have no data for this value, so it is a lower bound.',
            style: theme.textTheme.bodySmall,
          ),
        if (!r.complete) ...[const SizedBox(height: 8), _MissingCard(missing: r.missing)],
      ],
    );
  }
}

class _NutrientTable extends StatelessWidget {
  const _NutrientTable({required this.values, required this.partial});

  final Nutrients values;
  final Set<Nutrient> partial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, String, bool)>[
      for (final n in Nutrient.values)
        if (values[n] case final v?) (n.label, '${formatNutrient(n, v)} ${n.unit}', n == Nutrient.energy),
      if (values.saltG case final salt?) ('Salt', '${formatNutrient(Nutrient.fat, salt)} g', false),
    ];
    final colors = HighlightColors.of(context);
    final highlight = colors.background;
    final onHighlight = colors.foreground;
    return Table(
      columnWidths: const {0: FlexColumnWidth(), 1: IntrinsicColumnWidth()},
      children: [
        for (final (label, value, bold) in rows)
          TableRow(
            decoration: bold
                ? BoxDecoration(color: highlight, borderRadius: BorderRadius.circular(8))
                : BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
                  ),
            children: [
              Padding(
                padding: EdgeInsets.only(left: _indented(label) ? 24 : 8, top: 6, bottom: 6),
                child: Text(
                  label,
                  style: bold ? theme.textTheme.titleSmall?.copyWith(color: onHighlight) : theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
                child: Text(
                  '$value${_isPartial(label) ? ' *' : ''}',
                  textAlign: TextAlign.end,
                  style: bold ? theme.textTheme.titleSmall?.copyWith(color: onHighlight) : theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
      ],
    );
  }

  bool _indented(String label) => label == Nutrient.saturatedFat.label || label == Nutrient.sugars.label;

  bool _isPartial(String label) =>
      partial.any((n) => n.label == label) || (label == 'Salt' && partial.contains(Nutrient.sodium));
}

class _MissingCard extends StatelessWidget {
  const _MissingCard({required this.missing});

  final List<LineNutrition> missing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Not counted', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            for (final m in missing)
              Text(
                '${m.line.name}: ${m.issue == LineIssue.noFood ? 'no food linked' : 'no gram weight for "${m.line.unit.symbol}"'}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
