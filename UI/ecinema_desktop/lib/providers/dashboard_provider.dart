import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';
import 'auth_provider.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/stats";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _stats = DashboardStats.fromJson(data);
      } else {
        _error = 'Failed to load dashboard statistics';
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, String> _createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
  }

  void refresh() {
    loadDashboardStats();
  }
} 