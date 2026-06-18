import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/api_service.dart';

class GoalsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Goal> _goals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchGoals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getGoals();
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _goals = data.map((g) => Goal.fromJson(g)).toList();
      } else {
        _errorMessage = 'Failed to load goals';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createGoal(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createGoal(data);
      if (response.statusCode == 201) {
        await fetchGoals();
        return true;
      } else {
        final err = json.decode(response.body);
        _errorMessage = err['detail'] ?? 'Failed to create goal';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
