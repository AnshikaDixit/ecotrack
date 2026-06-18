import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/footprint_summary.dart';
import '../models/insight.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  FootprintSummary? _summary;
  List<Insight> _insights = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPeriod = 'week';

  FootprintSummary? get summary => _summary;
  List<Insight> get insights => _insights;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedPeriod => _selectedPeriod;

  void setPeriod(String period) {
    if (_selectedPeriod != period) {
      _selectedPeriod = period;
      fetchData();
    }
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final summaryRes = await _apiService.fetchFootprintSummary(_selectedPeriod);
      final insightsRes = await _apiService.fetchInsights();

      if (summaryRes.statusCode == 200 && insightsRes.statusCode == 200) {
        _summary = FootprintSummary.fromJson(json.decode(summaryRes.body));
        
        final insightsList = json.decode(insightsRes.body) as List;
        _insights = insightsList.map((i) => Insight.fromJson(i)).toList();
      } else {
        _errorMessage = 'Failed to load dashboard data. Status Code: ${summaryRes.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
