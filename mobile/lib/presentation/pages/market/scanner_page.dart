import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/market/market_bloc.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              context
                  .read<MarketBloc>()
                  .add(ProductScanRequested(barcode.rawValue!));
              Navigator.pop(context); // Go back or to confirmation
              break;
            }
          }
        },
      ),
    );
  }
}
