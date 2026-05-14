import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/market/market_bloc.dart';
import '../../bloc/sync/sync_bloc.dart';
import 'product_details_page.dart';
import 'quote_form_page.dart';
import 'scanner_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MarketBloc>().add(MarketBootstrapRequested());
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  void _lookupBarcode(String barcode) {
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) return;
    context.read<MarketBloc>().add(ProductScanRequested(cleanBarcode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarketBloc, MarketState>(
      listener: (context, state) {
        if (state is MarketProductFound) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: state.product)),
          );
        }
        if (state is MarketProductNotFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produto ${state.barcode} nao encontrado')),
          );
        }
        if (state is MarketSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto cadastrado')),
          );
        }
        if (state is MarketError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Mercado')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _barcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Codigo de barras',
                suffixIcon: IconButton(
                  tooltip: 'Buscar',
                  onPressed: () => _lookupBarcode(_barcodeController.text),
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: _lookupBarcode,
            ),
            const SizedBox(height: 12),
            BlocBuilder<MarketBloc, MarketState>(
              builder: (context, state) {
                return FilledButton.icon(
                  onPressed: state is MarketLoading
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ScannerPage()),
                          ),
                  icon: state is MarketLoading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.qr_code_scanner),
                  label: Text(state is MarketLoading
                      ? 'Buscando produto...'
                      : 'Escanear produto'),
                );
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<MarketBloc>().add(MarketBootstrapRequested()),
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar produtos e mercados'),
            ),
            const SizedBox(height: 24),
            BlocBuilder<MarketBloc, MarketState>(
              builder: (context, state) {
                if (state is! MarketReady || state.products.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Produtos cadastrados',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...state.products.take(20).map(
                          (product) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(product.name),
                            subtitle: Text(product.brand ?? product.barcode),
                            trailing: IconButton(
                              tooltip: 'Lancar cotacao',
                              icon: const Icon(Icons.add_a_photo_outlined),
                              onPressed: product.id == null
                                  ? null
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              QuoteFormPage(product: product),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            BlocConsumer<SyncBloc, SyncState>(
              listener: (context, state) {
                if (state is SyncFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('Fila offline'),
                  subtitle: Text(
                    state is SyncInProgress
                        ? 'Sincronizando cotacoes pendentes'
                        : 'Cotacoes sem internet ficam salvas localmente.',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
