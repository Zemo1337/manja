import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/text_fold.dart';

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _two(int n) => n.toString().padLeft(2, '0');

String _day(DateTime d) => '${_two(d.day)}.${_two(d.month)}.${d.year}';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _search = TextEditingController();
  DateTimeRange? _range;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _filtered => _search.text.trim().isNotEmpty || _range != null;

  List<MealLogEntry> _filter(List<MealLogEntry> entries) {
    final query = foldText(_search.text.trim());
    final range = _range;
    return [
      for (final e in entries)
        if ((query.isEmpty || foldText(e.recipe.name).contains(query)) &&
            (range == null ||
                (!e.log.eatenAt.isBefore(range.start) &&
                    e.log.eatenAt.isBefore(range.end.add(const Duration(days: 1))))))
          e,
    ];
  }

  Future<void> _pickRange(List<MealLogEntry> entries) async {
    final now = DateTime.now();
    final first = entries.isEmpty ? now : entries.last.log.eatenAt;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(first.year, first.month, first.day),
      lastDate: DateTime(now.year, now.month, now.day),
      initialDateRange: _range,
      helpText: 'Show meals from',
      saveText: 'Show',
    );
    if (range != null) setState(() => _range = range);
  }

  void _delete(MealLogEntry entry) {
    final db = AppScope.of(context).db;
    db.deleteMealLog(entry.log.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${entry.recipe.name} removed from the history'),
          action: SnackBarAction(label: 'Undo', onPressed: () => db.logMeal(entry.recipe.id, entry.log.eatenAt)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final db = AppScope.of(context).db;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: StreamBuilder<List<MealLogEntry>>(
        stream: db.watchMealLog(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final all = snapshot.data!;
          if (all.isEmpty) return const Center(child: Text('Nothing cooked yet. Spin the wheel!'));
          final entries = _filter(all);
          final range = _range;
          final rows = <Widget>[];
          String? month;
          for (final e in entries) {
            final d = e.log.eatenAt;
            final label = '${_months[d.month - 1]} ${d.year}';
            if (label != month) {
              month = label;
              final count = entries.where((x) => x.log.eatenAt.year == d.year && x.log.eatenAt.month == d.month).length;
              rows.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    '$label · $count ${count == 1 ? 'meal' : 'meals'}',
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              );
            }
            rows.add(
              Dismissible(
                key: ValueKey(e.log.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: theme.colorScheme.errorContainer,
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) => _delete(e),
                child: ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: Text(e.recipe.name),
                  subtitle: Text('${_day(d)}  ${_two(d.hour)}:${_two(d.minute)}'),
                ),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search dishes',
                          isDense: true,
                          border: const OutlineInputBorder(),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close),
                                  onPressed: () => setState(_search.clear),
                                ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      tooltip: 'Pick dates',
                      onPressed: () => _pickRange(all),
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                ),
              ),
              if (range != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      avatar: const Icon(Icons.date_range, size: 18),
                      label: Text(
                        range.start == range.end ? _day(range.start) : '${_day(range.start)} – ${_day(range.end)}',
                      ),
                      onPressed: () => _pickRange(all),
                      onDeleted: () => setState(() => _range = null),
                    ),
                  ),
                ),
              if (_filtered)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entries.isEmpty
                          ? 'No meals match'
                          : '${entries.length} ${entries.length == 1 ? 'meal' : 'meals'}'
                                '${entries.length > 1 ? ', last on ${_day(entries.first.log.eatenAt)}' : ' on ${_day(entries.first.log.eatenAt)}'}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              Expanded(
                child: ListView(padding: const EdgeInsets.only(bottom: 24), children: rows),
              ),
            ],
          );
        },
      ),
    );
  }
}
