import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_import/recipe_import.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/recipe_importer.dart';
import 'recipe_edit_screen.dart';

const _readPageScript = '''
JSON.stringify({
  title: document.title,
  blocks: Array.from(document.querySelectorAll('script[type="application/ld+json"]')).map(s => s.textContent)
})''';

final _challengeTitles = RegExp(
  r'just a moment|attention required|verify|checking your browser|captcha',
  caseSensitive: false,
);

enum _Phase { idle, loading, challenge, photo }

class ImportRecipeScreen extends StatefulWidget {
  const ImportRecipeScreen({super.key, this.importer, this.useWebView, this.initialUrl});

  final RecipeImporter? importer;
  final bool? useWebView;
  final String? initialUrl;

  @override
  State<ImportRecipeScreen> createState() => _ImportRecipeScreenState();
}

class _ImportRecipeScreenState extends State<ImportRecipeScreen> {
  late final _url = TextEditingController(text: widget.initialUrl ?? '');
  late final RecipeImporter _importer = widget.importer ?? RecipeImporter();
  _Phase _phase = _Phase.idle;
  String? _error;
  WebViewController? _web;
  Timer? _poll;
  DateTime? _startedAt;
  Uri? _target;

  bool get _useWebView => widget.useWebView ?? WebViewPlatform.instance != null;

  @override
  void dispose() {
    _poll?.cancel();
    _url.dispose();
    super.dispose();
  }

  Uri? _parseUrl() {
    var text = _url.text.trim();
    if (text.isEmpty) return null;
    if (!text.startsWith(RegExp(r'https?://'))) text = 'https://$text';
    final uri = Uri.tryParse(text);
    return uri == null || uri.host.isEmpty ? null : uri;
  }

  void _fail(String message) {
    _poll?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _Phase.idle;
      _error = message;
      _web = null;
    });
  }

  Future<void> _start() async {
    final url = _parseUrl();
    if (url == null) {
      setState(() => _error = 'Enter a link to a recipe page, for example https://www.coolinarika.com/recept/…');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _phase = _Phase.loading;
      _error = null;
      _target = url;
    });
    if (!_useWebView) {
      try {
        await _finish(await _importer.fromUrl(url));
      } on RecipeImportException catch (e) {
        _fail(e.message);
      }
      return;
    }
    final web = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    setState(() => _web = web);
    _startedAt = DateTime.now();
    await web.loadRequest(url);
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 1500), (_) => _check(web, url));
  }

  Future<void> _check(WebViewController web, Uri url) async {
    if (!mounted || _web != web || _phase == _Phase.photo) return;
    final Map<String, dynamic> page;
    try {
      var raw = await web.runJavaScriptReturningResult(_readPageScript);
      if (raw is String) raw = jsonDecode(raw);
      if (raw is String) raw = jsonDecode(raw);
      page = raw as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final blocks = [for (final b in page['blocks'] as List? ?? const []) '$b'];
    final recipe = recipeFromJsonLd(blocks, pageUrl: url);
    if (recipe != null) {
      _poll?.cancel();
      await _finish(recipe);
      return;
    }
    final challenge = _challengeTitles.hasMatch('${page['title']}');
    if (challenge && _phase != _Phase.challenge && mounted) setState(() => _phase = _Phase.challenge);
    final waited = DateTime.now().difference(_startedAt!);
    if (waited > Duration(seconds: challenge ? 120 : 30)) {
      _fail(
        challenge
            ? 'The site kept checking the browser. Try again later, or copy the recipe by hand.'
            : 'No recipe data found on this page. The site may not publish its recipes in a readable format.',
      );
    }
  }

  Future<void> _finish(ImportedRecipe recipe) async {
    if (!mounted) return;
    setState(() => _phase = _Phase.photo);
    String? photo;
    if (recipe.imageUrl != null) photo = await _importer.downloadImage(recipe.imageUrl!, await getTemporaryDirectory());
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeEditScreen(template: RecipeTemplate.fromImported(recipe, photoPath: photo)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _phase != _Phase.idle;
    return Scaffold(
      appBar: AppBar(title: const Text('Import recipe')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _url,
              enabled: !busy,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Link to the recipe',
                hintText: 'https://…',
                border: const OutlineInputBorder(),
                errorText: _error,
                errorMaxLines: 3,
                suffixIcon: IconButton(
                  tooltip: 'Paste',
                  icon: const Icon(Icons.content_paste),
                  onPressed: busy
                      ? null
                      : () async {
                          final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim();
                          if (text != null) _url.text = text;
                        },
                ),
              ),
              onSubmitted: (_) => busy ? null : _start(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: busy ? null : _start,
              icon: const Icon(Icons.download),
              label: const Text('Import'),
            ),
          ),
          if (busy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (_phase != _Phase.challenge)
                    const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  if (_phase == _Phase.challenge) Icon(Icons.verified_user_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(switch (_phase) {
                      _Phase.loading => 'Reading the recipe from ${_target?.host ?? 'the page'}…',
                      _Phase.challenge => 'The site wants to check that you are a person. Complete the check below.',
                      _Phase.photo => 'Downloading the photo…',
                      _Phase.idle => '',
                    }),
                  ),
                ],
              ),
            ),
          if (_web != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outlineVariant)),
                    child: WebViewWidget(controller: _web!),
                  ),
                ),
              ),
            )
          else if (!busy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Works with most recipe sites. You can check and change everything before saving.',
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
