import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _date(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}  ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final db = AppScope.of(context).db;
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: StreamBuilder<List<MealLogEntry>>(
        stream: db.watchMealLog(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snapshot.data!;
          if (entries.isEmpty) return const Center(child: Text('Nothing cooked yet. Spin the wheel!'));
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final entry = entries[i];
              return Dismissible(
                key: ValueKey(entry.log.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) => db.deleteMealLog(entry.log.id),
                child: ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: Text(entry.recipe.name),
                  subtitle: Text(_date(entry.log.eatenAt)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
