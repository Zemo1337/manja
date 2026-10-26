import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';
import '../../l10n/l10n.dart';

final apiSignupUri = Uri.parse('https://api.data.gov/signup/');

Future<void> openApiSignup(BuildContext context) async {
  final opened = await launchUrl(apiSignupUri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.apiKeyOpenInBrowser('$apiSignupUri'))));
  }
}

Future<void> handleNutritionError(BuildContext context, NutritionSourceException error) async {
  final repo = AppScope.of(context).nutrition;
  final l = context.l10n;
  if (error.source != FoodSource.usda) {
    final message = switch (error.kind) {
      NutritionErrorKind.unreachable => l.nutritionOffUnreachable,
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
    NutritionErrorKind.rateLimited => l.apiKeyRateLimited,
    NutritionErrorKind.unauthorized => l.apiKeyRejected,
    NutritionErrorKind.unreachable => l.nutritionUsdaUnreachable,
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
      final l = dialogContext.l10n;
      return AlertDialog(
        icon: const Icon(Icons.local_cafe_outlined),
        title: Text(l.apiKeyDemoLimitTitle),
        content: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(text: '${l.apiKeyDemoLimitIntro}\n\n'),
                TextSpan(text: l.apiKeyDemoLimitSignupBefore),
                TextSpan(
                  text: 'api.data.gov/signup',
                  style: link,
                  recognizer: TapGestureRecognizer()..onTap = () => openApiSignup(dialogContext),
                ),
                TextSpan(text: '${l.apiKeyDemoLimitSignupAfter}\n\n'),
                TextSpan(text: '${l.apiKeyDemoLimitEnterKey}\n\n'),
                TextSpan(
                  text: l.apiKeyDemoLimitWarning,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.apiKeyNotNow)),
          TextButton(onPressed: () => openApiSignup(dialogContext), child: Text(l.apiKeyGetKey)),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await showApiKeyDialog(context);
            },
            child: Text(l.apiKeyEnterMine),
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
      SnackBar(content: Text(origin == ApiKeyOrigin.user ? context.l10n.apiKeySaved : context.l10n.apiKeyRemoved)),
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
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.apiKeyDialogTitle),
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
            decoration: InputDecoration(labelText: l.apiKeyLabel, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          Text(l.apiKeyStoredLocally, style: Theme.of(context).textTheme.bodySmall),
          TextButton.icon(
            onPressed: () => openApiSignup(context),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(l.apiKeyGetFreeKey),
          ),
        ],
      ),
      actions: [
        if (widget.current != null)
          TextButton(onPressed: () => Navigator.pop(context, ''), child: Text(l.apiKeyRemove)),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.nutritionCancel)),
        FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: Text(l.nutritionSave)),
      ],
    );
  }
}
