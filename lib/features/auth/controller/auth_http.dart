import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vendx/features/auth/view/widgets/auth_provider.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _client;
  final AuthProvider _authProvider;

  AuthHttpClient(this._client, BuildContext context)
      : _authProvider = Provider.of<AuthProvider>(context, listen: false);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final authToken = _authProvider.token;
      if (authToken == null || authToken.isEmpty) {
        throw Exception("Authorization token is missing.");
      }

      // Add Authorization header
      request.headers['Authorization'] = 'Bearer $authToken';

      // Add Content-Type header
      request.headers['Content-Type'] = 'application/json';

      debugPrint('Request Headers: ${request.headers}');

      // Send the request
      return _client.send(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void close() {
    _client.close();
  }
}
