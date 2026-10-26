import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../domain/units.dart';
import '../../l10n/l10n.dart';
import '../app_theme.dart';
import 'nutrient_labels.dart';

enum NutritionBasis { portion, per100g, custom }

String formatNutrient(Nutrient n, double value) {
  if (n == Nutrient.energy || n == Nutrient.sodium) return value.round().toString();
  return value < 10 ? value.toStringAsFixed(1).replaceFirst('.', decimalSeparator) : value.round().toString();
}

String formatDetailedNutrient(double value) => value >= 10
    ? value.round().toString()
    : (value >= 1 ? value.toStringAsFixed(1) : value.toStringAsFixed(2)).replaceFirst('.', decimalSeparator);

String? dailyReferencePercent(Nutrient n, double value) {
  final reference = n.dailyReference;
  if (reference == null) return null;
  final percent = value / reference * 100;
  return percent > 0 && percent < 1 ? '<1%' : '${percent.round()}%';
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
    final l = context.l10n;
    final r = widget.result;
    final counted = r.lines.where((l) => l.counted).length;
    if (counted == 0) {
      return Text(
        l.nutritionNoLinks,
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
          segments: [
            ButtonSegment(value: NutritionBasis.portion, label: Text(l.nutritionBasisPortion)),
            const ButtonSegment(value: NutritionBasis.per100g, label: Text('100 g')),
            ButtonSegment(value: NutritionBasis.custom, label: Text(l.nutritionBasisCustom)),
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
              decoration: InputDecoration(
                labelText: l.nutritionAmount,
                suffixText: 'g',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (values != null) _NutrientTable(values: values, partial: r.partial),
        if (values != null && Nutrient.vitaminsAndMinerals.any(values.has))
          VitaminsAndMinerals(values: values, partial: r.partial),
        const SizedBox(height: 8),
        Text(
          [
            r.finishedWeightG != null
                ? l.nutritionDishWeighed(_grams(r.totalWeightG))
                : l.nutritionDishSum(_grams(r.totalWeightG)),
            l.nutritionPortionsOfAbout(r.portions, _grams(r.portionWeightG)),
          ].join(' · '),
          style: theme.textTheme.bodySmall,
        ),
        if (r.partial.isNotEmpty) Text(l.nutritionLowerBound, style: theme.textTheme.bodySmall),
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
    final l = context.l10n;
    final rows = <(String, String, bool, bool, bool)>[
      for (final n in Nutrient.basic)
        if (values[n] case final v?)
          (
            n.labelIn(l),
            '${formatNutrient(n, v)} ${n.unit}',
            n == Nutrient.energy,
            n == Nutrient.saturatedFat || n == Nutrient.sugars,
            partial.contains(n),
          ),
      if (values.saltG case final salt?)
        (l.nutritionSalt, '${formatNutrient(Nutrient.fat, salt)} g', false, false, partial.contains(Nutrient.sodium)),
    ];
    final colors = HighlightColors.of(context);
    final highlight = colors.background;
    final onHighlight = colors.foreground;
    return Table(
      columnWidths: const {0: FlexColumnWidth(), 1: IntrinsicColumnWidth()},
      children: [
        for (final (label, value, bold, indented, isPartial) in rows)
          TableRow(
            decoration: bold
                ? BoxDecoration(color: highlight, borderRadius: BorderRadius.circular(8))
                : BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
                  ),
            children: [
              Padding(
                padding: EdgeInsets.only(left: indented ? 24 : 8, top: 6, bottom: 6),
                child: Text(
                  label,
                  style: bold ? theme.textTheme.titleSmall?.copyWith(color: onHighlight) : theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
                child: Text(
                  '$value${isPartial ? ' *' : ''}',
                  textAlign: TextAlign.end,
                  style: bold ? theme.textTheme.titleSmall?.copyWith(color: onHighlight) : theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class VitaminsAndMinerals extends StatelessWidget {
  const VitaminsAndMinerals({super.key, required this.values, this.partial = const {}});

  final Nutrients values;
  final Set<Nutrient> partial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final l = context.l10n;
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(l.nutritionVitaminsMinerals, style: theme.textTheme.titleSmall),
        subtitle: Text(l.nutritionDailyReferenceHint, style: muted),
        children: [
          for (final n in Nutrient.vitaminsAndMinerals)
            if (values[n] case final v?)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(n.labelIn(l), style: theme.textTheme.bodyMedium)),
                    Text(
                      '${formatDetailedNutrient(v)} ${n.unit}${partial.contains(n) ? ' *' : ''}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(
                      width: 52,
                      child: Text(dailyReferencePercent(n, v) ?? '', textAlign: TextAlign.end, style: muted),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _MissingCard extends StatelessWidget {
  const _MissingCard({required this.missing});

  final List<LineNutrition> missing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.nutritionNotCounted, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            for (final m in missing)
              Text(
                m.issue == LineIssue.noFood
                    ? l.nutritionMissingNoFood(m.line.name)
                    : l.nutritionMissingNoWeight(m.line.name, m.line.unit.symbolIn(l)),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
