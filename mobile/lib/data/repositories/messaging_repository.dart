import '../../core/api/api_client.dart';
import '../../domain/models/query_result.dart';

class MessagingRepository {
  final ApiClient _apiClient;

  MessagingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<QueryResult>> getRecentQueries() async {
    try {
      final response = await _apiClient.dio.get('/messaging/queries');
      if (response.statusCode == 200) {
        final List<dynamic> queriesJson = response.data;
        return queriesJson.map((json) => QueryResult.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
