import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';

final apiSignupUri = Uri.parse('https://api.data.gov/signup/');

Future<void> openApiSignup(BuildContext context) async {
  final opened = await launchUrl(apiSignupUri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open $apiSignupUri in your browser')));
  }
}

Future<void> handleNutritionError(BuildContext context, NutritionSourceException error) async {
  final repo = AppScope.of(context).nutrition;
  if (error.source != FoodSource.usda) {
    final message = switch (error.kind) {
      NutritionErrorKind.unreachable => 'Open Food Facts could not be reached. Check your internet connection.',
      _ => error.message,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    return;
  }
  if (error.kind == NutritionErrorKind.rateLimited && repo.usingDemoKey) {
    await showDemoLimitDialog(context);
    return;
  }
  final message = switch (error.kind) {
    NutritionErrorKind.rateLimited => 'You reached the hourly USDA limit for your key. Please try again later.',
    NutritionErrorKind.unauthorized => 'USDA did not accept the API key. Check it in Ingredients > USDA online lookup.',
    NutritionErrorKind.unreachable => 'USDA could not be reached. Check your internet connection.',
    NutritionErrorKind.other => error.message,
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> showDemoLimitDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      final link = TextStyle(color: theme.colorScheme.primary, decoration: TextDecoration.underline);
      return AlertDialog(
        icon: const Icon(Icons.local_cafe_outlined),
        title: const Text('Out of free lookups'),
        content: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Oh, hey there buddy, we see that you used up all the built-in USDA requests.\n\n'),
                const TextSpan(text: 'If you need more, you can sign up for your own free API key at '),
                TextSpan(
                  text: 'api.data.gov/signup',
                  style: link,
                  recognizer: TapGestureRecognizer()..onTap = () => openApiSignup(dialogContext),
                ),
                const TextSpan(text: '. Once you register, you will receive your very own API key by email.\n\n'),
                const TextSpan(text: 'You can then enter this key in the app to get more lookups.\n\n'),
                TextSpan(
                  text: 'Do not forget: do not share your key publicly.',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Not now')),
          TextButton(onPressed: () => openApiSignup(dialogContext), child: const Text('Get a key')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await showApiKeyDialog(context);
            },
            child: const Text('Enter my key'),
          ),
        ],
      );
    },
  );
}

Future<ApiKeyOrigin?> showApiKeyDialog(BuildContext context) async {
  final repo = AppScope.of(context).nutrition;
  final current = await repo.userApiKey();
  if (!context.mounted) return null;
  final result = await showDialog<String?>(
    context: context,
    builder: (_) => _ApiKeyDialog(current: current),
  );
  if (result == null) return null;
  final origin = await repo.setUserApiKey(result);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(origin == ApiKeyOrigin.user ? 'Your API key is saved' : 'Your API key was removed')),
    );
  }
  return origin;
}

class _ApiKeyDialog extends StatefulWidget {
  const _ApiKeyDialog({required this.current});

  final String? current;

  @override
  State<_ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<_ApiKeyDialog> {
  late final _controller = TextEditingController(text: widget.current ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your USDA API key'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(labelText: 'API key', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          Text(
            'The key is stored only on this device. Do not share it publicly.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton.icon(
            onPressed: () => openApiSignup(context),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Get a free key'),
          ),
        ],
      ),
      actions: [
        if (widget.current != null)
          TextButton(onPressed: () => Navigator.pop(context, ''), child: const Text('Remove key')),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: const Text('Save')),
      ],
    );
  }
}
