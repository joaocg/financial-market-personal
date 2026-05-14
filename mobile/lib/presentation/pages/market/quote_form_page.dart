import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/repositories/market_repository.dart';
import '../../../domain/models/establishment.dart';
import '../../../domain/models/price_quote.dart';
import '../../../domain/models/product.dart';
import '../../bloc/sync/sync_bloc.dart';

class QuoteFormPage extends StatefulWidget {
  final Product product;

  const QuoteFormPage({super.key, required this.product});

  @override
  State<QuoteFormPage> createState() => _QuoteFormPageState();
}

class _QuoteFormPageState extends State<QuoteFormPage> {
  final _priceController = TextEditingController();
  final _marketNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  CameraController? _cameraController;
  List<EstablishmentLocation> _locations = const [];
  EstablishmentLocation? _selectedLocation;
  bool _isCameraInitialized = false;
  bool _isSubmitting = false;
  bool _isLoadingLocations = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final establishments =
        await context.read<MarketRepository>().listEstablishments();
    final locations = establishments
        .expand((establishment) => establishment.locations)
        .toList();
    if (!mounted) return;
    setState(() {
      _locations = locations;
      _selectedLocation = locations.isNotEmpty ? locations.first : null;
      _isLoadingLocations = false;
    });
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final controller = CameraController(cameras.first, ResolutionPreset.medium);
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _cameraController = controller;
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _marketNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<Position?> _currentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> _submit() async {
    final controller = _cameraController;
    final productId = widget.product.id;
    final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (controller == null ||
        !_isCameraInitialized ||
        productId == null ||
        productId.isEmpty ||
        _selectedLocation == null ||
        price == null ||
        price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Informe produto, mercado e preco valido')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final position = await _currentPosition();
    if (position == null) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Permita o acesso a localizacao para lancar a cotacao')),
        );
      }
      return;
    }

    final image = await controller.takePicture();
    final quote = PriceQuote(
      productId: productId,
      establishmentLocationId: _selectedLocation!.id,
      productBarcode: widget.product.barcode,
      price: price,
      latitude: position.latitude,
      longitude: position.longitude,
      photoPath: image.path,
      timestamp: DateTime.now(),
    );

    if (mounted) {
      context.read<SyncBloc>().add(AddQuoteRequested(quote));
      Navigator.pop(context);
    }
  }

  Future<void> _createMarket() async {
    final position = await _currentPosition();
    if (position == null || !mounted) return;

    final location = await showDialog<EstablishmentLocation>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Novo mercado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _marketNameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final created =
                    await context.read<MarketRepository>().createEstablishment(
                          name: _marketNameController.text.trim(),
                          city: _cityController.text.trim(),
                          state: _stateController.text.trim(),
                          latitude: position.latitude.toString(),
                          longitude: position.longitude.toString(),
                        );
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, created);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (location != null && mounted) {
      setState(() {
        _locations = [..._locations, location];
        _selectedLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova cotacao')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(widget.product.name),
              subtitle: Text(widget.product.brand ?? widget.product.barcode),
            ),
            if (_isLoadingLocations)
              const LinearProgressIndicator()
            else ...[
              DropdownButtonFormField<EstablishmentLocation>(
                initialValue: _selectedLocation,
                decoration: const InputDecoration(labelText: 'Mercado'),
                items: _locations
                    .map((location) => DropdownMenuItem(
                          value: location,
                          child: Text(location.displayName),
                        ))
                    .toList(),
                onChanged: (location) =>
                    setState(() => _selectedLocation = location),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _createMarket,
                icon: const Icon(Icons.store_outlined),
                label: const Text('Cadastrar mercado atual'),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preco'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            if (_isCameraInitialized)
              SizedBox(height: 300, child: CameraPreview(_cameraController!))
            else
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isSubmitting ? 'Salvando...' : 'Salvar cotacao'),
            ),
          ],
        ),
      ),
    );
  }
}
