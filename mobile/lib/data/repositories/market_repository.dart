import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/config/env.dart';
import '../../domain/models/establishment.dart';
import '../../domain/models/product.dart';

class MarketRepository {
  final ApiClient _apiClient;
  final Dio _openFoodFactsDio;

  MarketRepository({required ApiClient apiClient, Dio? openFoodFactsDio})
      : _apiClient = apiClient,
        _openFoodFactsDio = openFoodFactsDio ??
            Dio(BaseOptions(baseUrl: Env.openFoodFactsApiUrl));

  Future<Product?> getProduct(String barcode) async {
    try {
      final response = await _apiClient.dio.post(
        '/market/products/sync-open-food-facts',
        data: {'ean': barcode},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(_unwrapData(response.data));
      }
    } catch (e) {
      final existing = await _findLocalProductByBarcode(barcode);
      if (existing != null) return existing;
    }

    try {
      final response = await _openFoodFactsDio.get('/product/$barcode.json');
      final data = response.data;
      if (response.statusCode == 200 &&
          data is Map<String, dynamic> &&
          data['product'] is Map<String, dynamic>) {
        final product = data['product'] as Map<String, dynamic>;
        return Product(
          barcode: barcode,
          name: product['product_name']?.toString().trim().isNotEmpty == true
              ? product['product_name'].toString()
              : 'Product $barcode',
          brand: product['brands']?.toString(),
          imageUrl: product['image_front_url']?.toString() ??
              product['image_url']?.toString(),
          category: product['categories']?.toString(),
        );
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  Future<bool> registerProduct(Product product) async {
    try {
      final response = await _apiClient.dio.post('/market/products', data: {
        'ean': product.barcode,
        'name': product.name,
        'brand': product.brand,
        'photo_url': product.imageUrl,
        'category': product.category,
      });
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<Product?> saveProduct(Product product) async {
    try {
      final response = await _apiClient.dio.post('/market/products', data: {
        'ean': product.barcode.isEmpty ? null : product.barcode,
        'name': product.name,
        'brand': product.brand,
        'photo_url': product.imageUrl,
        'category': product.category,
      });
      if (response.statusCode == 201) {
        return Product.fromJson(_unwrapData(response.data));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Product>> listProducts() async {
    try {
      final response = await _apiClient.dio.get('/market/products');
      final data = response.data is Map<String, dynamic>
          ? response.data['data']
          : response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Establishment>> listEstablishments() async {
    try {
      final response = await _apiClient.dio.get('/market/establishments');
      final data = response.data is Map<String, dynamic>
          ? response.data['data']
          : response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(Establishment.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<EstablishmentLocation?> createEstablishment({
    required String name,
    required String city,
    String? state,
    String? latitude,
    String? longitude,
  }) async {
    try {
      final response =
          await _apiClient.dio.post('/market/establishments', data: {
        'name': name,
        'location_label': 'Principal',
        'city': city,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
      });
      if (response.statusCode == 201) {
        final establishment =
            Establishment.fromJson(_unwrapData(response.data));
        return establishment.locations.isNotEmpty
            ? establishment.locations.first
            : null;
      }
    } catch (_) {}
    return null;
  }

  Future<Product?> _findLocalProductByBarcode(String barcode) async {
    final products = await listProducts();
    for (final product in products) {
      if (product.barcode == barcode) return product;
    }
    return null;
  }

  Map<String, dynamic> _unwrapData(dynamic body) {
    if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    return body as Map<String, dynamic>;
  }
}
