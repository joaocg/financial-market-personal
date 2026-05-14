import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/product.dart';
import '../../bloc/market/market_bloc.dart';
import 'quote_form_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: BlocConsumer<MarketBloc, MarketState>(
        listener: (context, state) {
          if (state is MarketProductFound && state.product.id != product.id) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: state.product),
              ),
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
        builder: (context, state) {
          final loading = state is MarketLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null)
                  Center(
                    child: Image.network(
                      product.imageUrl!,
                      height: 200,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 96),
                    ),
                  ),
                const SizedBox(height: 20),
                Text('Codigo de barras: ${product.barcode}',
                    style: const TextStyle(fontSize: 16)),
                Text('Marca: ${product.brand ?? 'Desconhecida'}',
                    style: const TextStyle(fontSize: 16)),
                Text('Categoria: ${product.category ?? 'Desconhecida'}',
                    style: const TextStyle(fontSize: 16)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: loading
                        ? null
                        : () => context
                            .read<MarketBloc>()
                            .add(ProductRegistrationRequested(product)),
                    icon: loading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label:
                        Text(loading ? 'Cadastrando...' : 'Cadastrar produto'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: product.id == null
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => QuoteFormPage(product: product),
                              ),
                            ),
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(product.id == null
                        ? 'Cadastre antes de cotar'
                        : 'Lancar cotacao'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
