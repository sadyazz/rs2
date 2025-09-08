import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/movie_provider.dart';
import '../models/dashboard_stats.dart';
import '../models/ready_to_release_movie.dart';
import '../screens/movie_details_screen.dart';
import '../models/movie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ReadyToReleaseMovie> readyToReleaseMovies = [];
  bool isLoadingReadyToRelease = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadReadyToReleaseMovies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardStats();
      context.read<DashboardProvider>().loadTodayScreenings();
    });
  }

  Future<void> _loadReadyToReleaseMovies() async {
    setState(() {
      isLoadingReadyToRelease = true;
    });

    try {
      final movies = await context.read<MovieProvider>().getReadyToReleaseMovies();
      
      setState(() {
        readyToReleaseMovies = movies;
        isLoadingReadyToRelease = false;
      });
    } catch (e) {
      print('DEBUG: Error loading ready to release movies: $e');
      setState(() {
        isLoadingReadyToRelease = false;
      });
    }
  }

  Future<void> _refreshDashboard() async {
    await Future.wait([
      context.read<DashboardProvider>().loadDashboardStats(),
      context.read<DashboardProvider>().loadTodayScreenings(),
      _loadReadyToReleaseMovies(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.dashboard, _buildDashboardContent());
  }

  Widget _buildDashboardContent() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        if (dashboardProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final stats = dashboardProvider.stats;
        if (stats == null) {
          return Center(
            child: Text(l10n.noDataAvailable),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(stats),
                const SizedBox(height: 32),
                _buildTodayScreeningsSection(),
                const SizedBox(height: 32),
                _buildReadyToReleaseSection(),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    final l10n = AppLocalizations.of(context)!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.0,
      children: [
        _buildStatCard(
          icon: Icons.movie,
          title: l10n.totalMovies,
          value: stats.totalMovies?.toString() ?? '0',
          subtitle: l10n.inCatalog,
          color: Colors.orange,
          gradient: [Colors.orange.shade400, Colors.orange.shade600],
          userCountByRole: null,
        ),
        _buildStatCard(
          icon: Icons.schedule,
          title: l10n.activeShows,
          value: stats.activeShows?.toString() ?? '0',
          subtitle: l10n.today,
          color: Colors.green,
          gradient: [Colors.green.shade400, Colors.green.shade600],
          userCountByRole: null,
        ),
        _buildStatCard(
          icon: Icons.people,
          title: l10n.totalUsers,
          value: stats.totalUsers?.toString() ?? '0',
          subtitle: l10n.registered,
          color: Colors.blue,
          gradient: [Colors.blue.shade400, Colors.blue.shade600],
          userCountByRole: stats.userCountByRole,
        ),
        _buildStatCard(
          icon: Icons.movie_creation_outlined,
          title: l10n.totalShows,
          value: stats.totalShows?.toString() ?? '0',
          subtitle: l10n.allTime,
          color: Colors.purple,
          gradient: [Colors.purple.shade400, Colors.purple.shade600],
          userCountByRole: null,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
    Map<String, int>? userCountByRole,
  }) {
    bool isUserCard = userCountByRole != null && userCountByRole.isNotEmpty;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (isUserCard) ...[
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: userCountByRole.entries.take(3).map((entry) {
                    return Column(
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ] else ...[
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTodayScreeningsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final todayScreenings = dashboardProvider.todayScreenings;
        if (todayScreenings == null || todayScreenings.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.todayScreenings,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayScreenings.length,
              itemBuilder: (context, index) {
                final screening = todayScreenings[index];
                return _buildActivityItem(
                  icon: Icons.movie_outlined,
                  title: screening.movieTitle ?? l10n.unknownMovie,
                  subtitle: '${screening.startTime?.hour.toString().padLeft(2, '0')}:${screening.startTime?.minute.toString().padLeft(2, '0')} - ${screening.hallName ?? l10n.unknownHall}',
                  color: Colors.purple.shade200,
                  badge: '${screening.availableSeats ?? 0} seats',
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToMovieDetails(ReadyToReleaseMovie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(
          movie: Movie(
            id: movie.id,
            title: movie.title,
            releaseDate: movie.releaseDate,
            isDeleted: false,
            isComingSoon: true,
          ),
        ),
      ),
    ).then((_) {
      _loadReadyToReleaseMovies();
    });
  }

  Widget _buildReadyToReleaseSection() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        if (isLoadingReadyToRelease) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (readyToReleaseMovies.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.readyToRelease,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: readyToReleaseMovies.length,
              itemBuilder: (context, index) {
                final movie = readyToReleaseMovies[index];
                return InkWell(
                  onTap: () => _navigateToMovieDetails(movie),
                  borderRadius: BorderRadius.circular(12),
                  child: _buildReadyToReleaseItem(movie),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReadyToReleaseItem(ReadyToReleaseMovie movie) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final releaseDate = DateTime(movie.releaseDate.year, movie.releaseDate.month, movie.releaseDate.day);
    final daysUntilRelease = releaseDate.difference(todayDate).inDays;
    
    final isReleasingToday = daysUntilRelease == 0;
    final color = isReleasingToday ? Colors.red : Colors.grey;
    final badge = isReleasingToday ? l10n.releasesToday : l10n.releasesInDays(daysUntilRelease);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color,
                width: isReleasingToday ? 2 : 1,
              ),
            ),
            child: Icon(
              Icons.movie_outlined,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.releaseDate.year}-${movie.releaseDate.month.toString().padLeft(2, '0')}-${movie.releaseDate.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String badge,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
