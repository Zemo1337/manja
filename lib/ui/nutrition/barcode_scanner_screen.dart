import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA, BarcodeFormat.upcE],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final code = normalizeBarcode(barcode.rawValue ?? '');
      if (code != null) {
        _done = true;
        Navigator.pop(context, code);
        return;
      }
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l.scannerTitle),
        actions: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, state, _) => state.error != null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: l.scannerTorch,
                    icon: const Icon(Icons.flashlight_on_outlined),
                    onPressed: () => _controller.toggleTorch(),
                  ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => _ScannerError(error: error, onType: _type),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, state, _) => state.error != null
                ? const SizedBox.shrink()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            width: 280,
                            height: 160,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
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
          ),
        ],
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error, required this.onType});

  final MobileScannerException error;
  final VoidCallback onType;

  @override
  Widget build(BuildContext context) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;
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
