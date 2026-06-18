import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postForm('/auth/login', {
        'username': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['detail'] ?? 'Invalid credentials';
      }
    } catch (e) {
      _errorMessage = 'Network connection failed. Please try again.';
      debugPrint('Login Error: \$e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password, String fullName, String country) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'full_name': fullName,
        'country': country,
      });

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return await login(email, password);
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['detail'] ?? 'Registration failed';
      }
    } catch (e) {
      _errorMessage = 'Network connection failed. Please try again.';
      debugPrint('Registration Error: \$e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
