import '../../core/api/api_client.dart';
import '../../core/auth/token_storage.dart';
import '../../domain/models/user.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository(
      {required ApiClient apiClient, required TokenStorage tokenStorage})
      : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final body = response.data;
        final data =
            body is Map<String, dynamic> && body['data'] is Map<String, dynamic>
                ? body['data'] as Map<String, dynamic>
                : body as Map<String, dynamic>;

        final accessToken = data['access_token']?.toString();
        if (accessToken == null || accessToken.isEmpty) {
          return null;
        }

        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: data['refresh_token']?.toString() ?? '',
        );
        if (data['user'] is Map<String, dynamic>) {
          return User.fromJson(data['user'] as Map<String, dynamic>);
        }
        return User(
          id: data['user_id']?.toString() ?? email,
          name: data['name']?.toString() ?? email.split('@').first,
          email: email,
          familyId: data['family_id']?.toString() ?? '',
          role: data['role']?.toString() ?? 'member',
        );
      }
      return null;
    } catch (e) {
      throw const AuthException(
        'Nao foi possivel autenticar. Verifique a conexao e a URL da API.',
      );
    }
  }

  Future<void> logout() async {
    await _tokenStorage.deleteTokens();
  }
}
