import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/units.dart';

class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key, this.existing});

  final RecipeFull? existing;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _IngredientRow {
  _IngredientRow({String name = '', String amount = '', this.unit = CookingUnit.g})
      : name = TextEditingController(text: name),
        amount = TextEditingController(text: amount);

  final TextEditingController name;
  final TextEditingController amount;
  CookingUnit unit;

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _portions;
  late final TextEditingController _prep;
  late final TextEditingController _cook;
  late final TextEditingController _info;
  late final List<_IngredientRow> _ingredients;
  late final List<TextEditingController> _steps;
  bool _saving = false;

  bool get _isNew => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final r = widget.existing?.recipe;
    _name = TextEditingController(text: r?.name ?? '');
    _portions = TextEditingController(text: '${r?.portions ?? 2}');
    _prep = TextEditingController(text: r?.prepMinutes?.toString() ?? '');
    _cook = TextEditingController(text: r?.cookMinutes?.toString() ?? '');
    _info = TextEditingController(text: r?.cookingInfo ?? '');
    _ingredients = [
      for (final i in widget.existing?.ingredients ?? const <RecipeIngredient>[])
        _IngredientRow(name: i.name, amount: formatAmount(i.amount), unit: CookingUnit.fromName(i.unit)),
    ];
    if (_ingredients.isEmpty) _ingredients.add(_IngredientRow());
    _steps = [for (final s in widget.existing?.steps ?? const <RecipeStep>[]) TextEditingController(text: s.body)];
    if (_steps.isEmpty) _steps.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final c in [_name, _portions, _prep, _cook, _info, ..._steps]) {
      c.dispose();
    }
    for (final row in _ingredients) {
      row.dispose();
    }
    super.dispose();
  }

  double? _parseAmount(String text) => double.tryParse(text.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final draft = RecipeDraft(
      id: widget.existing?.recipe.id,
      name: _name.text.trim(),
      portions: int.parse(_portions.text.trim()),
      prepMinutes: int.tryParse(_prep.text.trim()),
      cookMinutes: int.tryParse(_cook.text.trim()),
      cookingInfo: _info.text.trim(),
      isFavorite: widget.existing?.recipe.isFavorite ?? false,
      ingredients: [
        for (final row in _ingredients)
          if (row.name.text.trim().isNotEmpty)
            IngredientDraft(name: row.name.text.trim(), amount: _parseAmount(row.amount.text) ?? 0, unit: row.unit.name),
      ],
      steps: [for (final s in _steps) if (s.text.trim().isNotEmpty) s.text.trim()],
    );
    await AppScope.of(context).db.saveRecipe(draft);
    if (mounted) Navigator.pop(context);
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _optionalMinutes(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final n = int.tryParse(v.trim());
    return n == null || n < 0 ? 'Whole minutes' : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New recipe' : 'Edit recipe'),
        actions: [
          TextButton(onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
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
              validator: _required,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _portions,
                    decoration: const InputDecoration(labelText: 'Portions', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => (int.tryParse(v?.trim() ?? '') ?? 0) < 1 ? 'At least 1' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _prep,
                    decoration: const InputDecoration(labelText: 'Prep (min)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: _optionalMinutes,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _cook,
                    decoration: const InputDecoration(labelText: 'Cook (min)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: _optionalMinutes,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Ingredients', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final (index, row) in _ingredients.indexed)
              Padding(
                key: ObjectKey(row),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 72,
                      child: TextFormField(
                        controller: row.amount,
                        decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) => row.name.text.trim().isNotEmpty && _parseAmount(v ?? '') == null ? '?' : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 104,
                      child: DropdownButtonFormField<CookingUnit>(
                        initialValue: row.unit,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder()),
                        items: [
                          for (final u in CookingUnit.values)
                            DropdownMenuItem(value: u, child: Text(u.symbol, overflow: TextOverflow.ellipsis)),
                        ],
                        onChanged: (u) => setState(() => row.unit = u ?? row.unit),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextFormField(
                        controller: row.name,
                        decoration: const InputDecoration(labelText: 'Ingredient', border: OutlineInputBorder()),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _ingredients.removeAt(index).dispose()),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _ingredients.add(_IngredientRow())),
                icon: const Icon(Icons.add),
                label: const Text('Add ingredient'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _info,
              decoration: const InputDecoration(
                labelText: 'Cooking info',
                hintText: 'Oven temperature, pan size, tips…',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Text('Preparation steps', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final (index, step) in _steps.indexed)
              Padding(
                key: ObjectKey(step),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 8),
                      child: CircleAvatar(radius: 14, child: Text('${index + 1}')),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: step,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        minLines: 1,
                        maxLines: 6,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _steps.removeAt(index).dispose()),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _steps.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Add step'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
