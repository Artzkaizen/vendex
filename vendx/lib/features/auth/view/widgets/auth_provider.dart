import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendx/features/auth/model/user_model.dart';
import 'package:vendx/utlis/constants/env.dart';

class AuthResponse {
  final bool success;
  final String message;

  AuthResponse({required this.success, required this.message});
}

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  // Constructor
  AuthProvider() {
    _loadUserData();
  }

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  Future<void> load() => _loadUserData();
  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if we have saved user data in SharedPreferences
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      debugPrint("Loading: $_token");
      final userData = jsonDecode(userJson);
      _user = User.fromJson(userData['user']);
      _token = userData['token'];
      // debugPrint("DOne: $_token");
      notifyListeners();
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = {
      'user': _user?.toJson(),
      'token': _token,
    };
    await prefs.setString('user', jsonEncode(userData));
  }

  // Login method
  Future<AuthResponse> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    debugPrint("Loading: $_isLoading");

    await Future.delayed(Duration(seconds: 2));

    try {
      final url = Uri.parse('${Env.apiBaseUrl}/api/auth/local');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'identifier': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _token = responseData['jwt'];
        _user = User.fromJson(responseData['user']);

        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return AuthResponse(
          success: true,
          message: 'Login successful',
        );
      } else {
        final errorData = json.decode(response.body);
        _isLoading = false;
        notifyListeners();
        return AuthResponse(
          success: false,
          message: 'Failed to login: ${errorData['error']['message']}',
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResponse(
        success: false,
        message: 'Failed to login: $e',
      );
    }
  }

  // Register method
  Future<bool> register(String email, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('${Env.apiBaseUrl}/api/auth/local/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _user = User.fromJson(responseData['user']);
      _token = responseData['jwt'];

      await _saveUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }
}
