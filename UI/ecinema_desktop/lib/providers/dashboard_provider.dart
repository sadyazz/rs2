import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';
import '../models/movie_revenue.dart';
import '../models/top_customer.dart';
import '../models/screening.dart';
import '../models/ticket_sales.dart';
import '../models/screening_attendance.dart';
import '../models/revenue.dart';
import '../widgets/date_range_selector.dart';
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
  List<Screening>? _todayScreenings;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get userCount => _userCount;
  double? get totalIncome => _totalIncome;
  List<MovieRevenue>? get top5Movies => _top5Movies;
  List<MovieRevenue>? get revenueByMovie => _revenueByMovie;
  List<TopCustomer>? get top5Customers => _top5Customers;
  List<Screening>? get todayScreenings => _todayScreenings;

  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/Dashboard/stats";
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
      final url = "$baseUrl/Dashboard/user-count";
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
      final url = "$baseUrl/Dashboard/total-income";
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
      final url = "$baseUrl/Dashboard/top-5-watched-movies";
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
      final url = "$baseUrl/Dashboard/revenue-by-movie";
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
      final url = "$baseUrl/Dashboard/top-5-customers";
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

  Future<void> loadTodayScreenings() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/Dashboard/today-screenings";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _todayScreenings = data.map((json) => Screening.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading today\'s screenings: $e');
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

  DateTime? _startDate;
  DateTime? _endDate;
  DateRangeType _dateRangeType = DateRangeType.monthly;
  int? _selectedMovieId;
  int? _selectedHallId;
  List<TicketSales>? _ticketSales;
  List<ScreeningAttendance>? _screeningAttendance;
  List<Revenue>? _revenueData;
  List<Map<String, dynamic>>? _movies;
  List<Map<String, dynamic>>? _halls;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateRangeType get dateRangeType => _dateRangeType;
  int? get selectedMovieId => _selectedMovieId;
  int? get selectedHallId => _selectedHallId;
  List<TicketSales>? get ticketSales => _ticketSales;
  List<ScreeningAttendance>? get screeningAttendance => _screeningAttendance;
  List<Revenue>? get revenueData => _revenueData;
  List<Map<String, dynamic>>? get movies => _movies;
  List<Map<String, dynamic>>? get halls => _halls;

  void setDateRange(DateTime start, DateTime end, DateRangeType type) {
    _startDate = start;
    _endDate = end;
    _dateRangeType = type;
    refreshReports();
  }

  void setSelectedMovie(int? movieId) {
    _selectedMovieId = movieId;
    refreshReports();
  }

  void setSelectedHall(int? hallId) {
    _selectedHallId = hallId;
    refreshReports();
  }

  Future<void> loadTicketSales() async {
    if (_startDate == null || _endDate == null) return;

    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      var url = "$baseUrl/Dashboard/ticket-sales?startDate=${_startDate?.toIso8601String()}&endDate=${_endDate?.toIso8601String()}";
      
      if (_selectedMovieId != null) {
        url += "&movieId=$_selectedMovieId";
      }
      if (_selectedHallId != null) {
        url += "&hallId=$_selectedHallId";
      }
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _ticketSales = data.map((json) => TicketSales.fromJson(json)).toList();

        notifyListeners();
      }
    } catch (e) {
      print('Error loading ticket sales: $e');
    }
  }

  Future<void> loadScreeningAttendance() async {
    if (_startDate == null || _endDate == null) return;

    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      var url = "$baseUrl/Dashboard/screening-attendance?startDate=${_startDate?.toIso8601String()}&endDate=${_endDate?.toIso8601String()}";
      
      if (_selectedMovieId != null) {
        url += "&movieId=$_selectedMovieId";
      }
      if (_selectedHallId != null) {
        url += "&hallId=$_selectedHallId";
      }
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _screeningAttendance = data.map((json) => ScreeningAttendance.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading screening attendance: $e');
    }
  }

  Future<void> loadRevenue() async {
    if (_startDate == null || _endDate == null) return;

    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      var url = "$baseUrl/Dashboard/revenue?startDate=${_startDate?.toIso8601String()}&endDate=${_endDate?.toIso8601String()}";
      
      if (_selectedMovieId != null) {
        url += "&movieId=$_selectedMovieId";
      }
      if (_selectedHallId != null) {
        url += "&hallId=$_selectedHallId";
      }

      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _revenueData = data.map((json) => Revenue.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading revenue: $e');
    }
  }

  Future<void> refreshReports() async {
    await Future.wait([
      loadTicketSales(),
      loadScreeningAttendance(),
      loadRevenue(),
    ]);
  }

  Future<void> loadMovies() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/Movie";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final result = responseData['result'];
        if (result != null) {
          final data = result as List;
          _movies = data.map((json) => json as Map<String, dynamic>).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading movies: $e');
    }
  }

  Future<void> loadHalls() async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190");
      final url = "$baseUrl/Hall";
      final uri = Uri.parse(url);
      final headers = _createHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final result = responseData['result'];
        if (result != null) {
          final data = result as List;
          _halls = data.map((json) => json as Map<String, dynamic>).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading halls: $e');
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboardStats(),
      loadUserCount(),
      loadTotalIncome(),
      loadTop5WatchedMovies(),
      loadRevenueByMovie(),
      loadTop5Customers(),
      loadTodayScreenings(),
      loadMovies(),
      loadHalls(),
      refreshReports(),
    ]);
  }
} 