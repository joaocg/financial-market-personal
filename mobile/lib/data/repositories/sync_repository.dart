import '../../core/api/api_client.dart';
import '../../domain/models/price_quote.dart';
import '../datasources/local_quote_data_source.dart';

class SyncRepository {
  final ApiClient _apiClient;
  final LocalQuoteDataSource _localDataSource;

  SyncRepository(
      {required ApiClient apiClient,
      required LocalQuoteDataSource localDataSource})
      : _apiClient = apiClient,
        _localDataSource = localDataSource;

  Future<void> syncQuotes() async {
    final pendingQuotes = await _localDataSource.getPendingQuotes();
    for (final quote in pendingQuotes) {
      await _syncQuote(quote);
    }
  }

  Future<void> _syncQuote(PriceQuote quote) async {
    if (quote.localId == null) return;

    try {
      await _localDataSource.updateSyncStatus(
          quote.localId!, SyncStatus.syncing);

      if (quote.productId.isEmpty || quote.establishmentLocationId.isEmpty) {
        await _localDataSource.updateSyncStatus(
          quote.localId!,
          SyncStatus.failed,
          errorMessage: 'Produto ou mercado nao informado',
        );
        return;
      }

      final response =
          await _apiClient.dio.post('/market/price-entries', data: {
        'product_id': quote.productId,
        'establishment_location_id': quote.establishmentLocationId,
        'price': quote.price,
        'measured_at': quote.timestamp.toIso8601String(),
        'source_channel': 'mobile',
        'image_path': quote.photoPath,
        'validation_status': 'doubtful',
      });

      if (response.statusCode == 201) {
        await _localDataSource.updateSyncStatus(
            quote.localId!, SyncStatus.synced);
      } else {
        await _localDataSource.updateSyncStatus(
            quote.localId!, SyncStatus.failed,
            errorMessage: 'Server returned ${response.statusCode}');
      }
    } catch (e) {
      await _localDataSource.updateSyncStatus(quote.localId!, SyncStatus.failed,
          errorMessage: e.toString());
    }
  }
}
