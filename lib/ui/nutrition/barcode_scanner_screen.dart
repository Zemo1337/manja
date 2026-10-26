import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:nutrition_off/nutrition_off.dart';

import '../../l10n/l10n.dart';

bool get canScanBarcodes =>
    !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

Future<String?> scanOrEnterBarcode(BuildContext context) => canScanBarcodes
    ? Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()))
    : enterBarcode(context);

Future<String?> enterBarcode(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _BarcodeDialog());

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _done = false;
  Exception? _error;

  void _onScan(Code code) {
    if (_done || !code.isValid) return;
    final barcode = normalizeBarcode(code.text ?? '');
    if (barcode == null) return;
    _done = true;
    Navigator.pop(context, barcode);
  }

  Future<void> _type() async {
    final code = await enterBarcode(context);
    if (code != null && mounted && !_done) {
      _done = true;
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final error = _error;
    return Scaffold(
      appBar: AppBar(title: Text(l.scannerTitle)),
      body: error != null
          ? _ScannerError(denied: error.toString().contains('AccessDenied'), onType: _type)
          : Stack(
              fit: StackFit.expand,
              children: [
                ReaderWidget(
                  onScan: _onScan,
                  onControllerCreated: (_, error) {
                    if (error != null && mounted) setState(() => _error = error);
                  },
                  codeFormat: Format.ean13 | Format.ean8 | Format.upca | Format.upce,
                  tryHarder: true,
                  tryInverted: true,
                  showToggleCamera: false,
                  scanDelay: const Duration(milliseconds: 300),
                  scanDelaySuccess: Duration.zero,
                  cropPercent: 0.7,
                  actionButtonsAlignment: Alignment.topRight,
                  actionButtonsBackgroundColor: Colors.black54,
                  actionButtonsBackgroundBorderRadius: BorderRadius.circular(24),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.scannerHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 4)]),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: _type,
                          icon: const Icon(Icons.keyboard_outlined),
                          label: Text(l.scannerTypeNumber),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.denied, required this.onType});

  final bool denied;
  final VoidCallback onType;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                denied ? l.scannerPermissionDenied : l.scannerCameraFailed,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onType, child: Text(l.scannerTypeNumber)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarcodeDialog extends StatefulWidget {
  const _BarcodeDialog();

  @override
  State<_BarcodeDialog> createState() => _BarcodeDialogState();
}

class _BarcodeDialogState extends State<_BarcodeDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final code = normalizeBarcode(_controller.text);
    if (code == null) {
      setState(() => _error = context.l10n.scannerInvalidBarcode);
      return;
    }
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.scannerDialogTitle),
    content: TextField(
      controller: _controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: '3850104051029', errorText: _error),
      onChanged: (_) {
        if (_error != null) setState(() => _error = null);
      },
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.nutritionCancel)),
      FilledButton(onPressed: _submit, child: Text(context.l10n.scannerLookUp)),
    ],
  );
}
