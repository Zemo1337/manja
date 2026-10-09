import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  StreamSubscription<List<Tag>>? _subscription;
  List<Tag>? _tags;
  Map<int, int> _counts = const {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = AppScope.of(context).db;
    _subscription ??= db.watchTags().listen((tags) async {
      final byRecipe = await db.tagsByRecipe();
      final counts = <int, int>{};
      for (final ids in byRecipe.values) {
        for (final id in ids) {
          counts[id] = (counts[id] ?? 0) + 1;
        }
      }
      if (mounted) {
        setState(() {
          _tags = tags;
          _counts = counts;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<String?> _askName({required String title, String initial = '', required String action}) =>
      showTagNameDialog(context, title: title, initial: initial, action: action);

  Future<void> _add() async {
    final name = await _askName(title: 'New tag', action: 'Add');
    if (name != null && mounted) await AppScope.of(context).db.addTag(name);
  }

  Future<void> _rename(Tag tag) async {
    final name = await _askName(title: 'Rename tag', initial: tag.name, action: 'Rename');
    if (name != null && mounted) await AppScope.of(context).db.renameTag(tag.id, name);
  }

  Future<void> _delete(Tag tag) async {
    final count = _counts[tag.id] ?? 0;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${tag.name}"?'),
        content: Text(
          count == 0
              ? 'No recipe uses this tag.'
              : 'It is removed from $count ${count == 1 ? 'recipe' : 'recipes'}. The recipes themselves stay.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true && mounted) await AppScope.of(context).db.deleteTag(tag.id);
  }

  Future<void> _reorder(int from, int to) async {
    final tags = [..._tags!];
    final moved = tags.removeAt(from);
    tags.insert(to, moved);
    setState(() => _tags = tags);
    await AppScope.of(context).db.reorderTags([for (final t in tags) t.id]);
  }

  @override
  Widget build(BuildContext context) {
    final tags = _tags;
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('New tag'),
      ),
      body: tags == null
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              padding: const EdgeInsets.only(bottom: 88),
              header: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Tags group your recipes. Pick one above the wheel to spin only those. Drag to change the order.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              onReorderItem: _reorder,
              children: [
                for (final t in tags)
                  ListTile(
                    key: ValueKey(t.id),
                    leading: const Icon(Icons.label_outline),
                    title: Text(t.name),
                    subtitle: Text('${_counts[t.id] ?? 0} ${(_counts[t.id] ?? 0) == 1 ? 'recipe' : 'recipes'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(tooltip: 'Rename', icon: const Icon(Icons.edit_outlined), onPressed: () => _rename(t)),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _delete(t),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

Future<String?> showTagNameDialog(
  BuildContext context, {
  String title = 'New tag',
  String initial = '',
  String action = 'Add',
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) => _TagNameDialog(title: title, initial: initial, action: action),
  );
  final trimmed = name?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

class _TagNameDialog extends StatefulWidget {
  const _TagNameDialog({required this.title, required this.initial, required this.action});

  final String title;
  final String initial;
  final String action;

  @override
  State<_TagNameDialog> createState() => _TagNameDialogState();
}

class _TagNameDialogState extends State<_TagNameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _controller,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(hintText: 'Quick weekday'),
      onSubmitted: (v) => Navigator.pop(context, v),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: Text(widget.action)),
    ],
  );
}
