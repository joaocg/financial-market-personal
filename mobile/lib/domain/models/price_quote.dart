import 'package:equatable/equatable.dart';

enum SyncStatus { pending, syncing, synced, failed }

class PriceQuote extends Equatable {
  final int? localId;
  final String productId;
  final String establishmentLocationId;
  final String productBarcode;
  final double price;
  final double latitude;
  final double longitude;
  final String photoPath;
  final DateTime timestamp;
  final SyncStatus syncStatus;
  final String? errorMessage;

  const PriceQuote({
    this.localId,
    required this.productId,
    required this.establishmentLocationId,
    required this.productBarcode,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.photoPath,
    required this.timestamp,
    this.syncStatus = SyncStatus.pending,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'product_id': productId,
      'establishment_location_id': establishmentLocationId,
      'product_barcode': productBarcode,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'photo_path': photoPath,
      'timestamp': timestamp.toIso8601String(),
      'sync_status': syncStatus.name,
      'error_message': errorMessage,
    };
  }

  factory PriceQuote.fromMap(Map<String, dynamic> map) {
    return PriceQuote(
      localId: map['local_id'],
      productId: map['product_id'],
      establishmentLocationId: map['establishment_location_id'],
      productBarcode: map['product_barcode'],
      price: map['price'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photoPath: map['photo_path'],
      timestamp: DateTime.parse(map['timestamp']),
      syncStatus: SyncStatus.values.byName(map['sync_status']),
      errorMessage: map['error_message'],
    );
  }

  @override
  List<Object?> get props => [
        localId,
        productId,
        establishmentLocationId,
        productBarcode,
        price,
        latitude,
        longitude,
        photoPath,
        timestamp,
        syncStatus,
        errorMessage,
      ];
}
