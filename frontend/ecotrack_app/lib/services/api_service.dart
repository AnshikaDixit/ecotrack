import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://ecotrack-backend-fzgr.onrender.com';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
  }

  Future<http.Response> postForm(String endpoint, Map<String, String> body) async {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body,
    );
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> fetchFootprintSummary(String period) async {
    return await get('/footprint/summary?period=$period');
  }

  Future<http.Response> fetchInsights() async {
    return await get('/insights');
  }

  Future<http.Response> logActivity(Map<String, dynamic> data) async {
    return await post('/activities', data);
  }

  Future<http.Response> getGoals() async {
    return await get('/goals');
  }

  Future<http.Response> createGoal(Map<String, dynamic> data) async {
    return await post('/goals', data);
  }
}


