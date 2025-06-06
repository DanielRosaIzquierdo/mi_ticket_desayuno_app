import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) {
            context.pop(code); // <- Aquí volvemos con el resultado
          }
        },
      ),
    );
  }
}
