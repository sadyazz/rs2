import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/hall_provider.dart';
import '../models/movie.dart';
import '../models/hall.dart';
import '../models/search_result.dart';
import '../widgets/date_range_selector.dart';
import '../widgets/ticket_sales_chart.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/attendance_chart.dart';
import '../layouts/master_screen.dart';
import '../utilities/pdf_exporter.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  late MovieProvider _movieProvider;
  late HallProvider _hallProvider;
  SearchResult<Movie>? _moviesResult;
  SearchResult<Hall>? _hallsResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    _hallProvider = context.read<HallProvider>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      final dashboardProvider = context.read<DashboardProvider>();
      

      final now = DateTime(2025, DateTime.now().month, DateTime.now().day);
      dashboardProvider.setDateRange(now.subtract(const Duration(days: 7)), now, DateRangeType.weekly);
    });
  }

  Future<void> _loadData() async {
    try {
      final moviesResult = await _movieProvider.get();
      final hallsResult = await _hallProvider.get();

      setState(() {
        _moviesResult = moviesResult;
        _hallsResult = hallsResult;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MasterScreen(
      l10n.reports,
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: DateRangeSelector(
                      onDateRangeChanged: (startDate, endDate, type) {
                        final dashboardProvider = context.read<DashboardProvider>();
                        dashboardProvider.setDateRange(startDate, endDate, type);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFiltersCard(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),


            _buildKeyMetricsSection(context),
            const SizedBox(height: 32),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: _buildTicketSalesSection(context),
                ),
                const SizedBox(width: 24),

                Expanded(
                  child: _buildRevenueSection(context),
                ),
              ],
            ),
            const SizedBox(height: 32),


            _buildAttendanceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.filters,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    decoration: InputDecoration(
                      labelText: l10n.movie,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    value: null,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.allMovies),
                      ),
                      if (_moviesResult?.items != null)
                        ...(_moviesResult?.items ?? []).map((movie) => DropdownMenuItem(
                              value: movie.id,
                              child: Text(movie.title ?? ''),
                            )).toList(),
                    ],
                    onChanged: (value) {
                      final dashboardProvider = context.read<DashboardProvider>();
                      dashboardProvider.setSelectedMovie(value);
                      dashboardProvider.refreshReports();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    decoration: InputDecoration(
                      labelText: l10n.hall,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    value: null,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.allHalls),
                      ),
                      if (_hallsResult?.items != null)
                        ...(_hallsResult?.items ?? []).map((hall) => DropdownMenuItem(
                              value: hall.id,
                              child: Text(hall.name ?? ''),
                            )).toList(),
                    ],
                    onChanged: (value) {
                      final dashboardProvider = context.read<DashboardProvider>();
                      dashboardProvider.setSelectedHall(value);
                      dashboardProvider.refreshReports();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final dashboardProvider = context.watch<DashboardProvider>();

    int totalTickets = 0;
    double totalRevenue = 0;
    double averageOccupancy = 0;

    if (dashboardProvider.ticketSales != null) {
      for (var sale in dashboardProvider.ticketSales!) {
        totalTickets += sale.ticketCount;
        totalRevenue += sale.totalRevenue;
      }
    }

    if (dashboardProvider.screeningAttendance != null && dashboardProvider.screeningAttendance!.isNotEmpty) {
      double totalOccupancy = 0;
      for (var attendance in dashboardProvider.screeningAttendance!) {
        totalOccupancy += attendance.occupancyRate;
      }
      averageOccupancy = totalOccupancy / dashboardProvider.screeningAttendance!.length;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.keyMetrics,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _downloadReport(context),
                  icon: const Icon(Icons.download),
                  label: Text(l10n.downloadReport),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildMetricCard(
                  context,
                  title: l10n.totalTicketsSold,
                  value: totalTickets.toString(),
                  icon: Icons.confirmation_number,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  title: l10n.totalRevenue,
                  value: '\$${totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
                const SizedBox(width: 16),
                _buildMetricCard(
                  context,
                  title: l10n.averageOccupancy,
                  value: '${averageOccupancy.toStringAsFixed(1)}%',
                  icon: Icons.people,
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketSalesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dashboardProvider = context.watch<DashboardProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ticketSales,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            if (dashboardProvider.ticketSales != null)
              TicketSalesChart(
                ticketSales: dashboardProvider.ticketSales!,
                dateRangeType: dashboardProvider.dateRangeType,
              )
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(l10n.noDataAvailable),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dashboardProvider = context.watch<DashboardProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.revenue,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            if (dashboardProvider.revenueData != null)
              RevenueChart(
                revenueData: dashboardProvider.revenueData!,
                dateRangeType: dashboardProvider.dateRangeType,
              )
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(l10n.noDataAvailable),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dashboardProvider = context.watch<DashboardProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.screeningAttendance,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            if (dashboardProvider.screeningAttendance != null)
              AttendanceChart(attendanceData: dashboardProvider.screeningAttendance!)
            else
              AspectRatio(
                aspectRatio: 21 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(l10n.noDataAvailable),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final dashboardProvider = context.read<DashboardProvider>();

    // Get selected movie and hall names
    String? selectedMovieName;
    String? selectedHallName;

    if (dashboardProvider.selectedMovieId != null && _moviesResult?.items != null) {
      selectedMovieName = _moviesResult?.items
          ?.firstWhere((m) => m.id == dashboardProvider.selectedMovieId)
          .title;
    }

    if (dashboardProvider.selectedHallId != null && _hallsResult?.items != null) {
      selectedHallName = _hallsResult?.items
          ?.firstWhere((h) => h.id == dashboardProvider.selectedHallId)
          .name;
    }

    final result = await PdfExporter.exportToPDF(
      context,
      dashboardProvider.ticketSales ?? [],
      dashboardProvider.revenueData ?? [],
      dashboardProvider.screeningAttendance ?? [],
      dateRangeType: dashboardProvider.dateRangeType,
      selectedMovie: selectedMovieName,
      selectedHall: selectedHallName,
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == 'success'
                ? l10n.pdfExportedSuccessfully
                : l10n.failedToExportPdf,
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


}
