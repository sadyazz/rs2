import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';
import '../models/movie_revenue.dart';
import '../models/top_customer.dart';
import 'auth_provider.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;
  
  int? _userCount;
  double? _totalIncome;
  List<MovieRevenue>? _top5Movies;
  List<MovieRevenue>? _revenueByMovie;
  List<TopCustomer>? _top5Customers;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get userCount => _userCount;
  double? get totalIncome => _totalIncome;
  List<MovieRevenue>? get top5Movies => _top5Movies;
  List<MovieRevenue>? get revenueByMovie => _revenueByMovie;
  List<TopCustomer>? get top5Customers => _top5Customers;

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

  Future<void> loadUserCount() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/user-count";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userCount = data['userCount'];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user count: $e');
    }
  }

  Future<void> loadTotalIncome() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/total-income";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _totalIncome = (data['totalIncome'] ?? 0.0).toDouble();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading total income: $e');
    }
  }

  Future<void> loadTop5WatchedMovies() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/top-5-watched-movies";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _top5Movies = data.map((json) => MovieRevenue.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading top 5 watched movies: $e');
    }
  }

  Future<void> loadRevenueByMovie() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/revenue-by-movie";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _revenueByMovie = data.map((json) => MovieRevenue.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading revenue by movie: $e');
    }
  }

  Future<void> loadTop5Customers() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/api/Dashboard/top-5-customers";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _top5Customers = data.map((json) => TopCustomer.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading top 5 customers: $e');
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

  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboardStats(),
      loadUserCount(),
      loadTotalIncome(),
      loadTop5WatchedMovies(),
      loadRevenueByMovie(),
      loadTop5Customers(),
    ]);
  }
} 